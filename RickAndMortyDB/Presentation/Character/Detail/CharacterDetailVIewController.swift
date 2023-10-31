//
//  CharacterDetailVIewController.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/12.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class CharacterDetailVIewController: UIViewController {
  
  var viewModel: CharacterDetailViewModel
  var disposeBag = DisposeBag()
  private lazy var characterDetailView = RMCharacterDetailView()
  init(viewModel: CharacterDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    RMLogger.dataLogger.debug("fasfkljasldfj \(self)")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setUpViews()
    bind()
  }

  private func setUpViews() {
    self.navigationItem.largeTitleDisplayMode = .never
    self.view.backgroundColor = .white
    self.view.addSubview(characterDetailView)

    characterDetailView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  func bind() {
    let backButton = UIBarButtonItem(
      image: UIImage(systemName: "chevron.left"),
      style: .plain,
      target: nil,
      action: nil)
    self.navigationItem.leftBarButtonItem = backButton

    let backbuttonTrigger = backButton.rx.tap
      .asDriver()
    let trigger = self.rx.viewWillAppear.map { _ in }
      .asDriver(onErrorDriveWith: .empty())

    let input = CharacterDetailViewModel.Input(
      trigger: trigger,
      backButtonTrigger: backbuttonTrigger
    )
    let output = viewModel.transform(input: input)

    output.character
      .drive(onNext: { [weak self] item in
        self?.navigationItem.title = item.name
        self?.characterDetailView.bind(item: item)
      })
      .disposed(by: disposeBag)

    output.toList
      .drive()
      .disposed(by: disposeBag)
  }
}
