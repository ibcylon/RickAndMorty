//
//  RMImageLoader.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/10.
//

import Foundation

final class RMImageLoader {
  static let shared = RMImageLoader()

  private var imageDataCache = NSCache<NSString, NSData>()
  private init() {}
  private var fileManager: FileManager {
    FileManager.default
  }
  private var cachePath: URL {
    URL.cachesDirectory
  }

  func loadImageData(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
    let key = url.absoluteString as NSString

    // 1. From Memory
    if let memoryData = self.imageDataCache.object(forKey: key) {
      RMLogger.dataLogger.notice("Read from memory cache")
      completion(.success(memoryData as Data))
      return
    }
    // 2. From Disk
    // Then, save to Memory
    if let diskData = fetchFromDisk(url) {
      self.imageDataCache.setObject(diskData as NSData, forKey: key)
      RMLogger.dataLogger.notice("Read from disk cache")
      completion(.success(diskData))
      return
    }

    // 3. From Network
    // Then, save to Memory and Disk
    let client: HTTPClient = URLSession.shared
    downloadImage(client: client, url: url) { [weak self] result in
      switch result {
      case .success(let data):
        let imageData = data as NSData
        self?.imageDataCache.setObject(imageData, forKey: key)
        self?.cacheDisk(key: url, data: data)
        completion(.success(data))
      case .failure(let failure):
        completion(.failure(failure))
      }
    }
  }

  private func downloadImage(client: HTTPClient = URLSession.shared, url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
    let request = RequestWithURL(url: url).request()

    client.perform(request) { result in
      switch result {
      case .success(let success):

        completion(.success(success.0))
      case .failure(let failure):
        completion(.failure(failure))
      }
    }
  }

  private func fetchFromDisk(_ url: URL) -> Data? {
    let imageName = url.lastPathComponent
    let endPoint = cachePath.appending(path: imageName, directoryHint: .notDirectory)

    guard fileManager.fileExists(atPath: endPoint.path()),
          let imageData = try? Data(contentsOf: endPoint)
    else {
      return nil
    }
    return imageData
  }

  private func cacheDisk(key: URL, data: Data) {
    let imageName = key.lastPathComponent
    let endPoint = cachePath.appending(path: imageName, directoryHint: .notDirectory)

    fileManager.createFile(atPath: endPoint.path(), contents: data)
  }
}
