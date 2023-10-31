//
//  CharacterSearchViewModel.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/12.
//

import Foundation

import RxCocoa

protocol CharacterSearchDelegate: AnyObject {
  func logout()
  func presentItem(item: RMCharacter)
}

final class CharacterSearchViewModel: ViewModelType {
  private let characterService: RMServiceType
  private let navigationTrigger: Driver<RMCharacter>

  var delegate: CharacterSearchDelegate?

  init(characterService: RMServiceType,
       navigationTrigger: Driver<RMCharacter>
  ) {
    self.characterService = characterService
    self.navigationTrigger = navigationTrigger
  }

  struct Input {
    let toItemTrigger: Driver<Void>
    let logout: Driver<Void>
  }

  struct Output {
    let toItem: Driver<Void>
    let logout: Driver<Void>
  }

  func transform(input: Input) -> Output {
    let toItem = self.navigationTrigger
      .do(onNext: { [weak self] item in
        self?.delegate?.presentItem(item: item)
      }).map { _ in }

    let logout = input.logout
      .do(onNext:  { [weak self] in
        self?.delegate?.logout()
      })

    return Output(
      toItem: toItem,
      logout: logout
    )
  }
}
