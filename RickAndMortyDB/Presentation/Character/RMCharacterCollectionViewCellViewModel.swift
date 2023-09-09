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
  private let imageURL: URL?

  init(name: String, status: RMCharacterStatus, imageURL: URL?) {
    self.name = name
    self.status = status
    self.imageURL = imageURL
  }

  var statusText: String {
    return status.rawValue
  }

  func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
    guard let imageURL = self.imageURL else {
      completion(.failure(URLError(.badURL)))
      return
    }
    let request = RequestWithURL(url: imageURL).request()
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data, error == nil else {
        completion(.failure(error ?? URLError(.badServerResponse)))
        return
      }
      completion(.success(data))
      return
    }
    task.resume()
  }
}
