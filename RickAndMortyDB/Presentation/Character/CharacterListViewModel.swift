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
  }

  struct Output {
    let characterList: Driver<[RMCharacter]>
  }

  func transform(input: Input) -> Output {
    let fetch = input.trigger
      .flatMapLatest({ [unowned self] _ in
        return service.getAllItems()
          .catch({ error in
            print(error.localizedDescription)
            return .just(RMInfoModel<RMCharacter>.empty)
          })
            .asDriver(onErrorJustReturn: RMInfoModel<RMCharacter>.empty)
      }).asSharedSequence()
    let list = fetch.map { $0.results }


    return Output(
      characterList: list
    )
  }
}
