//
//  CharacterListView.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/07.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class CharacterListView: UIView {

  private let viewModel: CharacterListViewModel
  private var disposeBag = DisposeBag()
  private let progressView: UIActivityIndicatorView = {
    let progressView = UIActivityIndicatorView(style: .large)
    progressView.hidesWhenStopped = true
    return progressView
  }()

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isHidden = true
    collectionView.alpha = 0
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

    return collectionView
  }()

  init(viewModel: CharacterListViewModel) {
    self.viewModel = viewModel
   super.init(frame: .zero)
    setupView()
    bind()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView() {
    addSubViews(collectionView, progressView)

    progressView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(100)
    }

    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    setUpCollectionView()
  }

  private func setUpCollectionView() {
    collectionView.delegate = self
  }

  private func bind() {
    let triggerSubject = PublishSubject<Void>()
    let triggerDriver = triggerSubject.asDriver(onErrorDriveWith: .empty())
      .do(onNext:  { [weak self] in
        self?.progressView.startAnimating()
      })
    let input = CharacterListViewModel.Input(trigger: triggerDriver )

    let output = viewModel.transform(input: input)

    output.characterList
      .do(onNext: { [weak self] _ in
        UIView.animate(withDuration: 0.4) {
          self?.collectionView.isHidden = false
          self?.collectionView.alpha = 1
        }
        self?.progressView.stopAnimating()
      })
      .drive(collectionView.rx.items(cellIdentifier: "Cell", cellType: UICollectionViewCell.self)) { index, item, cell in
        cell.largeContentTitle = item.name
        cell.backgroundColor = .blue
      }
      .disposed(by: disposeBag)
    triggerSubject.onNext(())
  }
}

extension CharacterListView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (UIScreen.main.bounds.width - 30) / 2
    let height = width * 1.5

    return CGSize(
      width: width,
      height: height
    )
  }
}
