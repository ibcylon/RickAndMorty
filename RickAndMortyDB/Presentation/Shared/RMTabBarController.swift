//
//  RMTabBarController.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/03.
//

import UIKit

final class RMTabBarController: UITabBarController {
  deinit {
    RMLogger.dataLogger.debug("[deinit] \(self)")
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
}
