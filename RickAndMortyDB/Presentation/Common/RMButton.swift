//
//  RMButton.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/31.
//

import UIKit

final class RMButton: UIButton {
  init(title: String) {
    super.init(frame: .zero)
    self.setTitle(title, for: .normal)
    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var status: Bool = false {
    didSet {
      if oldValue {
        self.backgroundColor = .orange
        self.isEnabled = true
      } else {
        self.backgroundColor = .lightGray
        self.isEnabled = false
      }
    }
  }

  func makeUI() {
    self.status = false
    self.layer.cornerRadius = 8
    self.layer.masksToBounds = true
  }
}
