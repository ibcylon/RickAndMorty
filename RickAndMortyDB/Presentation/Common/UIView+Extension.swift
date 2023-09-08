//
//  UIView+Extension.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/07.
//

import UIKit

extension UIView {
  func addSubViews(_ views: UIView...) {
    views.forEach { addSubview($0) }
  }
}
