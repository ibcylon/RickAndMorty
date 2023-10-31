//
//  RMCharacterDetailView.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/12.
//

import UIKit

import SnapKit

final class RMCharacterDetailView: UIView {
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    return label
  }()

  init() {
    super.init(frame: .zero)

    makeUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func makeUI() {
    self.addSubViews(imageView, nameLabel)

    imageView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
      $0.height.equalTo(self.snp.height).dividedBy(2)
    }
    nameLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(10)
      $0.leading.trailing.equalTo(imageView)
      $0.bottom.equalTo(self.safeAreaLayoutGuide)
    }
  }

  func bind(item: RMCharacter) {
    self.nameLabel.text = item.status.rawValue
    self.imageView.setImage(url: item.image)
  }
}
