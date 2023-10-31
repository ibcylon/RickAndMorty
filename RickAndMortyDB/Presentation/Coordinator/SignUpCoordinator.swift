//
//  SignUpCoordinator.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/31.
//

import UIKit

protocol SignUpCoordinatorDelegate: AnyObject {
  func toTabBar(coordinator: SignUpCoordinator)
}

final class SignUpCoordinator: Coordinator {
  var navigationController: UINavigationController

  var childCoordinators: [Coordinator]

  var delegate: SignUpCoordinatorDelegate?

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }

  func start() {
    initialViewController(email: AppData.email, nickname: AppData.nickname)
  }

  // MARK: Private
  private func initialViewController(email: String?, nickname: String?) {
    guard let _ = email else {
      emailInput()
      return
    }
    guard let _ = nickname  else {
      nicknameInput()
      return
    }
    self.delegate?.toTabBar(coordinator: self)
  }
  
  func emailInput() {
    let viewController = EmailInputViewController()
    viewController.delegate = self
    self.navigationController.viewControllers = [viewController]
  }

  func nicknameInput() {
    let viewController = NicknameInputViewController()
    viewController.delegate = self
    self.navigationController.pushViewController(viewController, animated: true)
  }
}

extension SignUpCoordinator: EmailInputViewControllerDelegate {
  func emailInputViewNextButtonTap(email: String) {
    AppData.email = email
    nicknameInput()
  }
}

extension SignUpCoordinator: NicknameInputViewControllerDelegate {
  func nicknameInputViewNextButtonTap(nickname: String) {
    AppData.nickname = nickname
    self.delegate?.toTabBar(coordinator: self)
  }
}
