//
//  CharacterSectionModel.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/09.
//

import Foundation

import RxDataSources

struct CharacterSection {
  var header: String
  var items: [Item]

}

extension CharacterSection: SectionModelType {
  typealias Item = RMCharacter

  init(original: CharacterSection, items: [RMCharacter]) {
    self = original
    self.items = items
  }
}
