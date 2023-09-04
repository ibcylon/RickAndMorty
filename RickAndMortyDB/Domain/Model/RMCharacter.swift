//
//  RMCharacter.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/03.
//

import Foundation

// MARK: - RMCharacter
struct RMCharacter: Codable {
  let id: Int
  let name, species, type: String
  let status: RMCharacterStatus
  let gender: RMGender
  let origin: RMSingleLocation
  let location: RMSingleLocation
  let image: String
  let episode: [String]
  let url: String
  let created: String
}

// MARK: - Location
struct RMSingleLocation: Codable {
  let name: String
  let url: String
}

