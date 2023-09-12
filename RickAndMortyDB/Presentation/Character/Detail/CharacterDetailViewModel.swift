//
//  CharacterDetailViewModel.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/12.
//

import Foundation

final class CharacterDetailViewModel: ViewModelType {
  private let navigator: CharacterDetailNavigatorType

  init(navigator: CharacterDetailNavigatorType) {
    self.navigator = navigator
  }
  
  struct Input {

  }

  struct Output {

  }
  
  func transform(input: Input) -> Output {
    return Output()
  }
}
