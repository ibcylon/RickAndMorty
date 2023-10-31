//
//  Coordinator.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/29.
//

import UIKit

protocol Coordinator: AnyObject {
  var navigationController: UINavigationController { get set }
  var childCoordinators: [Coordinator] { get set }
  
  func start()
}
