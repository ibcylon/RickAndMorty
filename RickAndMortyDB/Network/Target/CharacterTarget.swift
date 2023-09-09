//
//  CharacterTarget.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/04.
//

import Foundation

import RxSwift

protocol RMServiceType {
  func getAllItems() -> Observable<RMInfoModel<RMCharacter>>
  func getNextPage(with nextPageURL: URL) -> Observable<RMInfoModel<RMCharacter>>
}

class RMCharacterService: RMServiceType {
  private let client: HTTPClient
  private let target = APIComponent(endPoint: .character)

  init(client: HTTPClient) {
    self.client = client
  }

  func getAllItems() -> Observable<RMInfoModel<RMCharacter>> {
    let request = RequestWithURL(url: target.url).request()
    return performInfoList(request)
  }

  func getNextPage(with nextPageURL: URL) -> Observable<RMInfoModel<RMCharacter>> {
    let request = RequestWithURL(url: nextPageURL).request()
    return performInfoList(request)
  }

  private func performInfoList(_ request: URLRequest) -> Observable<RMInfoModel<RMCharacter>> {
    return .create { [weak self] observer in
      self?.client.perform(request) { result in
        switch result {
        case .success(let response):
          do {
            let info = try RMInfoMapper<RMCharacter>.map(data: response.0, response: response.1)
            observer.onNext(info)
          } catch let error {
            observer.onError(error)
          }
        case .failure(let error):
          observer.onError(error)
        }
      }
      return Disposables.create {
      }
    }
  }
}

struct RMInfoMapper<T: Codable> {
  static func map(data: Data, response: HTTPURLResponse) throws -> RMInfoModel<T> {
    if response.statusCode == 200 {
      do {
        let json = try JSONDecoder().decode(RMInfoModel<T>.self, from: data)
        return json
      } catch {
        throw InvalidHTTPResponseError()
      }
    } else {
      throw InvalidHTTPResponseError()
    }
  }
}

struct RMMapper<T: Codable> {
  static func map(data: Data, response: HTTPURLResponse) throws -> [T] {
    if response.statusCode == 204 {
      return []
    }

    if response.statusCode == 200 {
      do {
        let json = try JSONDecoder().decode(RMInfoModel<T>.self, from: data)
        return json.results
      } catch {
        throw InvalidHTTPResponseError()
      }
    }

    if response.statusCode == 401 {
      print("401 Unauthroized")
      return []
    }

    if response.statusCode == 403 {
      print("403 forbidden")
      return []
    }

    print(response.statusCode)
    print(response.description)
    return []
  }
}
