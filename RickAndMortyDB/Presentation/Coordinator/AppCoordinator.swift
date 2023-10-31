//
//  AppCoordinator.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/29.
//

import UIKit

class AppCoordinator: Coordinator {
  var navigationController: UINavigationController
  var childCoordinators: [Coordinator]

  private var isOnBoarding: Bool {
    AppData.needOnBoarding
  }
  private var isLogin: Bool {
    AppData.needLogin
  }

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.childCoordinators = []
  }

  func start() {
    RMLogger.dataLogger.debug("needLogin: \(AppData.needLogin)")
    RMLogger.dataLogger.debug("onBoarding: \(AppData.needOnBoarding)")
    RMLogger.dataLogger.debug("\(AppData.email ?? "없음")")
    RMLogger.dataLogger.debug("\(AppData.nickname ?? "없음")")
    if isOnBoarding {
      onBoarding()
    } else if isLogin {
      register()
    } else {
      showTabBar()
    }
  }

  // MARK: Private
  private func onBoarding() {
    let onBoardingCoordinator = OnBoardingCoordinator(navigationController: self.navigationController)
    onBoardingCoordinator.delegate = self

    onBoardingCoordinator.start()
    self.childCoordinators.append(onBoardingCoordinator)
  }

  private func showTabBar() {
    let mainCoordinator = MainCoordinator(navigationController: self.navigationController)
    self.childCoordinators.append(mainCoordinator)
    mainCoordinator.start()
    mainCoordinator.delegate = self
  }
  private func register() {
    let signUpCoordinator = SignUpCoordinator(navigationController: self.navigationController)
    signUpCoordinator.delegate = self

    signUpCoordinator.start()
    self.childCoordinators.append(signUpCoordinator)
  }
}

extension AppCoordinator: OnBoardingCoordinatorDelegate {
  func dismiss(coordinator: OnBoardingCoordinator) {
    self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }

    AppData.needOnBoarding = false

    self.register()
  }
}
extension AppCoordinator: SignUpCoordinatorDelegate {
  func toTabBar(coordinator: SignUpCoordinator) {
    self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }

    AppData.needLogin = false

    self.showTabBar()
  }
}

extension AppCoordinator: MainCoordinatorDelegate {
  func logout(coordinator: MainCoordinator) {
    self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
    AppData.email = nil
    AppData.nickname = nil
    AppData.needLogin = true

    self.start()
  }
}

