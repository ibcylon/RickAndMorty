//
//  CharacterSearchViewController.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/03.
//

import UIKit

import SnapKit
import RxSwift

final class CharacterSearchViewController: UIViewController {
  private let characterListView: CharacterListView

  var viewModel: CharacterSearchViewModel!
  var listViewModel: CharacterListViewModel!
  private var disposeBag = DisposeBag()
  init() {
    self.characterListView = CharacterListView()
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()

    setUpViews()
    bind()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  private func setUpViews() {
    self.view.backgroundColor = .white

    self.view.addSubview(characterListView)
    characterListView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }

    self.title = "Characters"
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }

  func bind() {
    self.characterListView.viewModel = self.listViewModel
    self.characterListView.bind()
    
    let input = CharacterSearchViewModel.Input(toItemTrigger: self.rx.viewWillAppear.map { _ in }.asDriver(onErrorDriveWith: .empty()))
    let output = viewModel.transform(input: input)
    output.toItem
      .drive()
      .disposed(by: disposeBag)
  }
}
