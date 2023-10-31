//
//  MainCoordinator.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/29.
//

import UIKit

protocol MainCoordinatorDelegate: AnyObject {
  func logout(coordinator: MainCoordinator)
}

final class MainCoordinator: Coordinator {
  var navigationController: UINavigationController

  var childCoordinators: [Coordinator]
  var tabBar: RMTabBarController? = nil

  var delegate: MainCoordinatorDelegate?

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }

  func start() {
    self.navigationController.viewControllers.removeAll()

    if self.tabBar == nil {
      let rmTabBar = RMTabBarController()
      makeTabBarItem(tabBar: rmTabBar)
      self.tabBar = rmTabBar
    }
    guard let tabBar = self.tabBar else { return }
    self.navigationController.viewControllers = [tabBar]
  }

  private func makeTabBarItem(tabBar: RMTabBarController) {
    var viewControllers: [UIViewController] = []
    let characterService = RMCharacterService(client: URLSession.shared)

    let characterCoordinator = createCharacterCoordinator(service: characterService)

    viewControllers = [characterCoordinator.navigationController]

    tabBar.viewControllers = viewControllers
  }

  private func createCharacterCoordinator(service: RMCharacterService) -> CharacterCoordinator {
    let charaterNavigation = UINavigationController()
    charaterNavigation.tabBarItem = .makeTabItem(.character)
    let characterCoordinator = CharacterCoordinator(
      navigationController: charaterNavigation,
      service: service
    )
    characterCoordinator.delegate = self
    self.childCoordinators.append(characterCoordinator)
    characterCoordinator.start()

    return characterCoordinator
  }
}

extension MainCoordinator: CharacterCoordinatorDelegate {
  func logout() {
    self.delegate?.logout(coordinator: self)
    self.childCoordinators = []
  }
}
