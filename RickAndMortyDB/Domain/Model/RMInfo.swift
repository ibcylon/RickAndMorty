//
//  RMInfo.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/07.
//

import Foundation

// MARK: - RMLocation
struct RMInfoModel<T: Codable>: Codable {
  let info: Info
  let results: [T]

  static var empty: RMInfoModel {
    return RMInfoModel(info: Info.empty, results: [])
  }
}

struct Info: Codable {
  let count: Int
  let pages: Int
  let next: String?
  let prev: String?

  static let empty: Info = {
  Info(count: 0, pages: 0, next: nil, prev: nil )
  }()
}
