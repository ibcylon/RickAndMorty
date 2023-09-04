//
//  APIComponent.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/04.
//

import Foundation

enum Constant {
  static let baseURLString: String = "https://rickandmortyapi.com/api"
  
}
enum EndPoint: String {
  case character
  case location
  case episode
}

struct APIComponent {
  private let endPoint: EndPoint

  init(endPoint: EndPoint) {
    self.endPoint = endPoint
  }

  private var urlString: String {
    Constant.baseURLString + "/" + endPoint.rawValue
  }

  var url: URL {
    URL(string: urlString)!
  }
}
