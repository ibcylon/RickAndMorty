//
//  OnBoardingCoordinator.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/29.
//

import UIKit

protocol OnBoardingCoordinatorDelegate: AnyObject {
  func dismiss(coordinator: OnBoardingCoordinator)
}

final class OnBoardingCoordinator: Coordinator {
  var navigationController: UINavigationController

  var childCoordinators: [Coordinator]

  var delegate: OnBoardingCoordinatorDelegate?

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }

  func start() {
    let viewController = OnBoardingViewController()
    viewController.delegate = self
    self.navigationController.viewControllers = [viewController]
  }
}

extension OnBoardingCoordinator: OnBoardingViewControllerDelegate {
  func rightBarButtonTap() {
    delegate?.dismiss(coordinator: self)
  }
}
