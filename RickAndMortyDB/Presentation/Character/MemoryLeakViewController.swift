//
//  MemoryLeakViewController.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/31.
//

import UIKit

import SnapKit

protocol MemoryLeakViewControllerDelegate {
  func memoryLeakViewControllerButtonTap()
}

final class MemoryLeakViewController: UIViewController {

  private lazy var button = RMButton(title: "다음")

  var delegate: MemoryLeakViewControllerDelegate?
  deinit {
    RMLogger.dataLogger.debug("deinit \(self)")
  }
  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.addSubview(button)

    button.snp.makeConstraints {
      $0.width.equalTo(300)
      $0.height.equalTo(60)
      $0.center.equalToSuperview()
    }

    button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
    button.status = true
    self.view.backgroundColor = .white
    button.status = true
  }

  @objc
  private func buttonTap() {
    self.delegate?.memoryLeakViewControllerButtonTap()
  }
}
