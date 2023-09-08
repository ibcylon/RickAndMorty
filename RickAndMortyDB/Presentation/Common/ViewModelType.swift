//
//  ViewModelType.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/07.
//

import Foundation

protocol ViewModelType {
  associatedtype Input
  associatedtype Output

  func transform(input: Input) -> Output
}
