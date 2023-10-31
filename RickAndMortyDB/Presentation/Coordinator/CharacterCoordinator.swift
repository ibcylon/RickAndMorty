//
//  CharacterCoordinator.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/31.
//

import UIKit

import RxSwift

protocol CharacterCoordinatorDelegate: AnyObject {
  func logout()
}

final class CharacterCoordinator: Coordinator {
  var navigationController: UINavigationController

  var childCoordinators: [Coordinator]

  var delegate: CharacterCoordinatorDelegate?

  private let service: RMCharacterService

  init(navigationController: UINavigationController, service: RMCharacterService) {
    self.navigationController = navigationController
    self.service = service
    self.childCoordinators = []
  }

  func start() {
    toSearch()
  }

  // MARK: Private
  private func toSearch() {
    let itemSelectedSubject = PublishSubject<RMCharacter>()

    let viewModel = CharacterSearchViewModel(
      characterService: self.service,
      navigationTrigger: itemSelectedSubject.asDriverOnErrorJustComplete()
    )
    viewModel.delegate = self

    let listViewModel = CharacterListViewModel(
      service: self.service,
      observer: itemSelectedSubject.asObserver()
    )

    let viewController = CharacterSearchViewController()
    viewController.viewModel = viewModel
    viewController.listViewModel = listViewModel
    self.navigationController.pushViewController(viewController, animated: true)
  }

  private func toCharacterInfo(item: RMCharacter) {
    let viewModel = CharacterDetailViewModel(service: self.service,
                                             model: item)
    viewModel.delegate = self
    let viewController = CharacterDetailVIewController(viewModel: viewModel)

    self.navigationController.pushViewController(viewController, animated: true)
  }
}

extension CharacterCoordinator: CharacterSearchDelegate {
  func presentItem(item: RMCharacter) {
    self.toCharacterInfo(item: item)
  }

  func logout() {
    self.navigationController.viewControllers = []
    self.delegate?.logout()
  }
}

extension CharacterCoordinator: CharacterDetailDelegate {
  func toList() {
    self.navigationController.popViewController(animated: true)
  }
}
