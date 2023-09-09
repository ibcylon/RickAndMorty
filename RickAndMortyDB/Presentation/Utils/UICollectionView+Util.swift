//
//  UICollectionView+Util.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/09.
//

import UIKit

import RxSwift
import RxCocoa

public protocol Reusable: AnyObject {
  static var reuseIdentifier: String { get }
}

public extension Reusable {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

extension UICollectionViewCell: Reusable {}

public extension UICollectionView {

  func register<T: UICollectionViewCell>(cellType: T.Type) {

    self.register(cellType, forCellWithReuseIdentifier: T.reuseIdentifier)
  }

  func register<T: UICollectionReusableView>(type: T.Type) {
    self.register(type,
                  forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                  withReuseIdentifier: T.reuseIdentifier)
  }

  func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
    guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Failed to dequeue reusable cell")
    }
    return cell
  }

  func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
    guard let view = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Failed to dequeue reusable supplementary view")
    }
    return view
  }
}

extension UICollectionReusableView: Reusable {}

