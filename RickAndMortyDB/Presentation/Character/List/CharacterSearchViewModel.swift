//
//  CharacterSearchViewModel.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/12.
//

import Foundation

import RxCocoa

final class CharacterSearchViewModel: ViewModelType {
  private let navigator: CharacterListNavigatorType
  private let characterService: RMServiceType
  private let navigationTrigger: Driver<Void>
  
  init(navigator: CharacterListNavigatorType,
       characterService: RMServiceType,
       navigationTrigger: Driver<Void>
  ) {
    self.navigator = navigator
    self.characterService = characterService
    self.navigationTrigger = navigationTrigger
  }

  struct Input {
    let toItemTrigger: Driver<Void>
  }

  struct Output {
    let toItem: Driver<Void>
  }

  func transform(input: Input) -> Output {
    let toItem = self.navigationTrigger
      .do(onNext: { [weak self] _ in
        self?.navigator.presentItem()
      })
    return Output(
      toItem: toItem
    )
  }
}
