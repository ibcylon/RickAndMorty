//
//  CharacterSearchViewController.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/03.
//

import UIKit

import SnapKit

final class CharacterSearchViewController: UIViewController {
  private let characterListView: CharacterListView
  init() {
    self.characterListView = CharacterListView(
      viewModel: CharacterListViewModel(
        service: RMCharacterService(client: URLSession.shared)
      )
    )
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = .white

    self.view.addSubview(characterListView)
    characterListView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
    }
}
