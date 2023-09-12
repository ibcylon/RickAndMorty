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
  private let navigationObserver: AnyObserver<Void>
  init(service: RMServiceType, observer: AnyObserver<Void>) {
    self.service = service
    self.navigationObserver = observer
  }
  
  struct Input {
    let trigger: Driver<Void>
    let morePagetrigger: Driver<Void>
    let itemSelected: Driver<IndexPath>
  }

  struct Output {
    let characterList: Driver<[CharacterSection]>
    let hasNextPage: Driver<Bool>
    let toItemDetail: Driver<RMCharacter>
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

    let itemSelected = input.itemSelected.withLatestFrom(list) { $1[$0.section].items[$0.item] }
      .do(onNext: { [weak self] _ in
        self?.navigationObserver.onNext(())
      })

    return Output(
      characterList: list,
      hasNextPage: hasNextPage.asDriver(onErrorDriveWith: .empty()),
      toItemDetail: itemSelected
    )
  }
}
