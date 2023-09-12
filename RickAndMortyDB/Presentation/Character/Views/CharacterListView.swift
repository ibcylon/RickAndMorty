//
//  CharacterListView.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/07.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

class CharacterListView: UIView {

  var viewModel: CharacterListViewModel!
  private var disposeBag = DisposeBag()
  private let progressView: UIActivityIndicatorView = {
    let progressView = UIActivityIndicatorView(style: .large)
    progressView.hidesWhenStopped = true
    return progressView
  }()

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
    layout.footerReferenceSize = .init(width: UIScreen.main.bounds.width, height: 100)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isHidden = true
    collectionView.alpha = 0
    collectionView.register(cellType: RMCharacterCollectionViewCell.self)
    collectionView.register(type: RMFooterLoadingCollectionReusableView.self)

    return collectionView
  }()

  init() {
    super.init(frame: .zero)
    setupView()
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

  func bind() {
    let triggerSubject = PublishSubject<Void>()
    let hasNextPageRelay = BehaviorRelay<Bool>(value: true)
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<CharacterSection> { section, collectionView, indexPath, item in
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RMCharacterCollectionViewCell.self)
      cell.configure(
        with: RMCharacterCollectionViewCellViewModel(
          name: item.name,
          status: item.status,
          imageURL: URL(string: item.image)
        )
      )
      return cell
    } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
      let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, cellType: RMFooterLoadingCollectionReusableView.self)
      guard kind == UICollectionView.elementKindSectionFooter, hasNextPageRelay.value == true else {
        footer.stopAnimationg()
        return footer
      }
      footer.startAnimating()
      return footer
    }
    let pagingTrigger = collectionView.rx.didScroll
      .map { self.collectionView.needMorePage }
      .filter { $0 }
      .map { _ in }
      .asDriver(onErrorDriveWith: .empty())
    

    let input = CharacterListViewModel.Input(
      trigger: triggerSubject.asDriver(onErrorDriveWith: .empty()),
      morePagetrigger: pagingTrigger,
      itemSelected: collectionView.rx.itemSelected.asDriver()
    )
    let output = viewModel.transform(input: input)

    output.characterList
    .do(onNext: { [weak self] _ in
      UIView.animate(withDuration: 0.4) {
        self?.collectionView.isHidden = false
        self?.collectionView.alpha = 1
      }
      self?.progressView.stopAnimating()
    })
      .drive(collectionView.rx.items(dataSource: dataSource))
    .disposed(by: disposeBag)

      output.hasNextPage
      .drive(hasNextPageRelay)
      .disposed(by: disposeBag)

    output.toItemDetail
      .drive()
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

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y
    let totalContentHeight = scrollView.contentSize.height
    let totalScrollViewFixedHeight = scrollView.frame.size.height

    if offset >= (totalContentHeight - totalScrollViewFixedHeight) {
      print("need fetching data")
    }
  }
}

