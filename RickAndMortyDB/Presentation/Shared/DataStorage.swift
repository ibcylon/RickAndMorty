//
//  DataStorage.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/31.
//

import Foundation

@propertyWrapper
struct DataStorage<T: Codable> {
  private let key: String
  private let defaultValue: T

  init(key: String, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }

  var wrappedValue: T {
    get {
      guard let data = UserDefaults.standard.object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(T.self, from: data)
      else {
        return defaultValue
      }

      return value
    }

    set {
      let data = try? JSONEncoder().encode(newValue)
      UserDefaults.standard.set(data, forKey: key)
    }
  }
}
