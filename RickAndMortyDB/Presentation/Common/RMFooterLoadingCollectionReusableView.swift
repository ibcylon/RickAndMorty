//
//  RMFooterLoadingCollectionReusableView.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/09.
//

import UIKit

import SnapKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
  private let progressView: UIActivityIndicatorView = {
    let progress = UIActivityIndicatorView(style: .large)
    progress.hidesWhenStopped = true
    return progress
  }()

  override init(frame: CGRect) {
    super.init(frame: .zero)
    setUpViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUpViews() {
    backgroundColor = .white

    self.addSubview(progressView)

    progressView.snp.makeConstraints {
      $0.size.equalTo(100)
      $0.center.equalToSuperview()
    }
  }

  func startAnimating() {
    progressView.startAnimating()
  }

  func stopAnimationg() {
    progressView.stopAnimating()
  }
}
