//
//  RMEpisode.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/03.
//

import Foundation

// MARK: - RMLocation
struct RMLocation: Codable {
    let id: Int
    let name, type, dimension: String
    let residents: [String]
    let url: String
    let created: String
}
