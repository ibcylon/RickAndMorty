//
//  HTTPClient.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/04.
//

import Foundation

// https://www.youtube.com/watch?v=Eo3WkbUV-fU&t=796&ab_channel=EssentialDeveloper

// 순수하게 HTTP Request만을 위한 기능
// 디코딩과 분리, 코드만 있는 경우, Auth가 필요한 경우 등
// Composite하게 만들기 위함
// Combine이 아닌 Async await을 쓰는 이유: foundation 프레임워크이기 때문에 변하지 않을 가능성이 높다.
// 어디서 부터 Rx, Combine 또는 Closure | Async를 쓸지는 개발자가 정하는 것 Boundary임

protocol HTTPClient {
  func perform(_ request: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void)
}

protocol TokenProvider {
  func token(completion: @escaping (Result<String, Error>) -> Void)
}

class AuthenticatedHTTPClientDecorator: HTTPClient {
  private let client: HTTPClient
  private let tokenProvider: TokenProvider

  init(client: HTTPClient, tokenProvider: TokenProvider) {
    self.client = client
    self.tokenProvider = tokenProvider
  }

  func perform(_ request: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
    tokenProvider.token { [weak self] result in
      switch result {
      case .success(let token):
        var signedRequest = BearerRequest(
          base:RequestWithURL(url: request.url!),
          token: token).request()
        self?.client.perform(signedRequest) { result in
          completion(result)
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
struct InvalidHTTPResponseError: Error {}

extension URLSession: HTTPClient {

  func perform(_ request: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
    print(request.description)
    let task = dataTask(with: request) { data, response, error in
      guard let data = data, let httpResponse = response as? HTTPURLResponse else {
        completion(.failure(InvalidHTTPResponseError()))
        return
      }
      completion(.success((data, httpResponse)))
      return
    }
    task.resume()
  }
}
