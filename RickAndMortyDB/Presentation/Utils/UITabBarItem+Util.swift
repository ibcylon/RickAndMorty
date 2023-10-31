//
//  UITabBarItem+Util.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/31.
//

import UIKit

extension UITabBarItem {
  static func makeTabItem(_ feature: RMTabBarController.Feature) -> UITabBarItem {
    UITabBarItem(
      title: feature.rawValue,
      image: UIImage(systemName: feature.image),
      selectedImage: UIImage(systemName: feature.image + ".fill"))
  }
}
