//
//  RMTabBarController.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/03.
//

import UIKit

final class RMTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()

    makeTabBar()
  }

  func makeTabBar() {
    self.viewControllers = makeTabBarItem()
  }
  enum Feature: String {
    case episode
    case character
    case location

    var image: String {
      switch self {
      case .episode:
        return "play.circle"
      case .character:
        return "person.circle"
      case .location:
        return "map"
      }
    }
  }
  private func makeTabBarItem() -> [UIViewController] {
    let characterController = CharacterSearchViewController()
    let characterNavigation = UINavigationController(rootViewController: characterController)
    characterNavigation.tabBarItem = makeTabItem(.character)


    let episodeNavigation = UINavigationController(rootViewController: UIViewController())
    episodeNavigation.tabBarItem = makeTabItem(.episode)

    let locationController = UIViewController()
    let locationNavigation = UINavigationController(rootViewController: locationController)
    locationNavigation.tabBarItem = makeTabItem(.location)

    return [characterNavigation, episodeNavigation, locationNavigation]
  }

  private func makeTabItem(_ feature: Feature) -> UITabBarItem {
    UITabBarItem(
      title: feature.rawValue,
      image: UIImage(systemName: feature.image),
      selectedImage: UIImage(systemName: feature.image + ".fill"))
  }
}
