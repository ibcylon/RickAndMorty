//
//  OnBoardingViewController.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/29.
//

import UIKit

protocol OnBoardingViewControllerDelegate: AnyObject {
  func rightBarButtonTap()
}

final class OnBoardingViewController: UIViewController {

  var delegate: OnBoardingViewControllerDelegate?

  override func viewDidLoad() {
    print(#function)
    super.viewDidLoad()

    let rightBarButton = UIBarButtonItem(title: "탭바로", style: .plain, target: self, action: #selector(rightBarButtonTap))
    self.navigationItem.rightBarButtonItem = rightBarButton
    self.view.backgroundColor = .orange
    self.title = "onboaring"
  }

  @objc
  func rightBarButtonTap(_ sender: UIBarButtonItem) {
    delegate?.rightBarButtonTap()
  }
}
