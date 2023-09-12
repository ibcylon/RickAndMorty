//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/09.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel {
  let name: String
  private let status: RMCharacterStatus
  let imageURL: URL?

  init(name: String, status: RMCharacterStatus, imageURL: URL?) {
    self.name = name
    self.status = status
    self.imageURL = imageURL
  }

  var statusText: String {
    return status.rawValue
  }
}
