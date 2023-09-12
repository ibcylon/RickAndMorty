//
//  CharacterDetailVIewController.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/12.
//

import UIKit

final class CharacterDetailVIewController: UIViewController {
  
  var viewModel: CharacterDetailViewModel!

  init() {
    super.init(nibName: nil, bundle: nil)
    setUpViews()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  private func setUpViews() {
    self.view.backgroundColor = .white
  }

  func bind() {

  }
}
