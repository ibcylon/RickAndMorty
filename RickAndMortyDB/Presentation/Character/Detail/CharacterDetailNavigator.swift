//
//  CharacterDetailNavigator.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/12.
//

import UIKit

protocol CharacterDetailNavigatorType {
  func popToList()
}

final class CharacterDetailNavigator: CharacterDetailNavigatorType {
  private let navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func popToList() {
    self.navigationController.popViewController(animated: true)
  }
}
