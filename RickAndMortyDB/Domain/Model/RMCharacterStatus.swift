//
//  RMCharacterStatus.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/04.
//

import Foundation

enum RMCharacterStatus: String, Codable {
  case alive = "Alive"
  case dead = "Dead"
  case unknown = "unknown"
}
