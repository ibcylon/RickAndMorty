//
//  CharacterListViewModel.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/07.
//

import Foundation

import RxSwift
import RxCocoa

final class CharacterListViewModel: ViewModelType {
  private let service: RMServiceType

  init(service: RMServiceType) {
    self.service = service
  }
  
  struct Input {
    let trigger: Driver<Void>
    let morePagetrigger: Driver<Void>
  }

  struct Output {
    let characterList: Driver<[CharacterSection]>
    let hasNextPage: Driver<Bool>
  }

  func transform(input: Input) -> Output {
    let nextPageSubject = BehaviorSubject<String?>(value: nil)
    let listSubject = BehaviorSubject<[RMCharacter]>(value: [])

    let fetch = input.trigger
      .flatMapLatest({ [unowned self] _ in
        return service.getAllItems()
          .catch({ error in
            print(error.localizedDescription)
            return .just(RMInfoModel<RMCharacter>.empty)
          })
            .do(onNext: { nextPageSubject.onNext($0.info.next) } )
            .asDriver(onErrorJustReturn: RMInfoModel<RMCharacter>.empty)
      }).asSharedSequence()

    let hasNextPage = nextPageSubject.map { $0 != nil }

    let pagingTrigger = input.morePagetrigger.withLatestFrom(nextPageSubject.asDriver(onErrorDriveWith: .empty()))
      .compactMap { $0 }
      .compactMap { URL(string: $0) }
      .distinctUntilChanged()
      .flatMapLatest { [unowned self] nextPageURL in
        return service.getNextPage(with: nextPageURL)
          .catch { error in
            print(error.localizedDescription)
            return .just(RMInfoModel<RMCharacter>.empty)
          }.do(onNext: { nextPageSubject.onNext($0.info.next) })
          .asDriver(onErrorJustReturn: RMInfoModel<RMCharacter>.empty)
      }.asSharedSequence()


    let list = Driver.merge(fetch, pagingTrigger)
      .map { $0.results }
      .map { newpage in
        var mutableList = (try? listSubject.value()) ?? []
        mutableList.append(contentsOf: newpage)
        listSubject.onNext(mutableList)
        return mutableList
      }
      .map { [CharacterSection(header: "Character", items: $0)] }
      .asDriver(onErrorJustReturn: [])

    return Output(
      characterList: list,
      hasNextPage: hasNextPage.asDriver(onErrorDriveWith: .empty())
    )
  }
}
