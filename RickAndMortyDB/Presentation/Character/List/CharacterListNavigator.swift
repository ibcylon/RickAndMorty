//
//  CharacterListNavigator.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/12.
//

import UIKit

import RxSwift

protocol CharacterListNavigatorType {
  func presentItem()
  func toList()
}

final class CharacterListNavigator: CharacterListNavigatorType {
  private let navigationController: UINavigationController
  private let characterService: RMServiceType

  init(navigationController: UINavigationController, 
       service: RMServiceType) {
    self.navigationController = navigationController
    self.characterService = service
  }

  func presentItem() {
    let navigator = CharacterDetailNavigator(navigationController: self.navigationController)
    let viewModel = CharacterDetailViewModel(navigator: navigator)
    let viewController = CharacterDetailVIewController()
    viewController.viewModel = viewModel

    self.navigationController.pushViewController(viewController, animated: true)
  }

  func toList() {
    let navigationSubject = PublishSubject<Void>()
    let viewModel = CharacterSearchViewModel(
      navigator: self,
      characterService: self.characterService,
      navigationTrigger: navigationSubject.asDriver(onErrorDriveWith: .empty())
    )
    let listViewModel = CharacterListViewModel(
      service: self.characterService,
      observer: navigationSubject.asObserver()
    )
    let viewController = CharacterSearchViewController()
    viewController.viewModel = viewModel
    viewController.listViewModel = listViewModel
    self.navigationController.pushViewController(viewController, animated: true)
  }
}
