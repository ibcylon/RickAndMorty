//
//  UIImageView+Util.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/12.
//

import UIKit

extension UIImageView {
  func setImage(url: String) {
    setImage(url: URL(string: url)!)
  }

  func setImage(url: URL?) {
    guard let url = url else {
      RMLogger.dataLogger.error("잘못된 URL입니다.")
      self.image = nil
      return
    }
    RMImageLoader.shared.loadImageData(url) { result in
      switch result {
      case .success(let data):
        DispatchQueue.main.async {
          self.image = UIImage(data: data)
        }
      case .failure(let failure):
        RMLogger.dataLogger.error("\(failure.localizedDescription)")
        DispatchQueue.main.async {
          self.image = nil
        }
      }
    }
  }
}
