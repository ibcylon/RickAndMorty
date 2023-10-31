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
  func getSingleItem(id: String) -> Observable<RMCharacter>
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

  func getSingleItem(id: String) -> Observable<RMCharacter> {
    let endPoint = target.url.appending(path: id)
    let request = RequestWithURL(url: endPoint).request()
    return performItem(request)
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

  private func performItem<T: Codable>(_ request: URLRequest) -> Observable<T> {
    return .create { [weak self] observer in
      self?.client.perform(request) { result in
        switch result {
        case .success(let response):
          do {
            let item = try RMMapper<T>.map(data: response.0, response: response.1)
            observer.onNext(item)
          } catch {
            observer.onError(error)
          }
        case .failure(let failure):
          observer.onError(failure)
        }
      }
      return Disposables.create {
        observer.onCompleted()
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
  static func map(data: Data, response: HTTPURLResponse) throws -> T {
//    if response.statusCode == 204 {
//      return
//    }

    if response.statusCode == 200 {
      do {
        let json = try JSONDecoder().decode(T.self, from: data)
        return json
      } catch {
        throw InvalidHTTPResponseError()
      }
    }

    if response.statusCode == 401 {
      print("401 Unauthroized")
      throw InvalidHTTPResponseError()
    }

    if response.statusCode == 403 {
      print("403 forbidden")
      throw InvalidHTTPResponseError()
    }

    RMLogger.dataLogger.error("\(response.statusCode)")
    RMLogger.dataLogger.error("\(response.description)")
    throw InvalidHTTPResponseError()
  }
}
