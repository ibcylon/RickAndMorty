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
  func toMemoryLeak()
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

  deinit {
    RMLogger.dataLogger.debug("[deinit] searchViewModel")
  }

  struct Input {
    let toItemTrigger: Driver<Void>
    let logout: Driver<Void>
    let back: Driver<Void>
  }

  struct Output {
    let toItem: Driver<Void>
    let logout: Driver<Void>
    let back: Driver<Void>
  }

  func transform(input: Input) -> Output {
    let toItem = self.navigationTrigger
      .do(onNext: { [weak self] item in
        self?.delegate?.presentItem(item: item)
      })
        .map { _ in }

    let logout = input.logout
      .do(onNext:  { [weak self] in
        self?.delegate?.logout()
      })

    let back = input.back
    .do(onNext: { [weak self] in
      self?.delegate?.toMemoryLeak()
    })

    return Output(
      toItem: toItem,
      logout: logout,
      back: back
      )
    }
}
