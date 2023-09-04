//
//  Request.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/04.
//

import Foundation

protocol Request {
  func request() -> URLRequest
}

struct RequestWithURL: Request {
  private let url: URL

  init(url: URL) {
    self.url = url
  }

  func request() -> URLRequest {
    return URLRequest(url: url)
  }
}

struct POSTRequest: Request {
  private let base: Request

  init(base: Request) {
    self.base = base
  }

  func request() -> URLRequest {
    var request = base.request()
    request.httpMethod = "POST"
    return request
  }
}

struct BearerRequest: Request {
  private let base: Request
  private let token: String

  init(base: Request, token: String) {
    self.base = base
    self.token = token
  }

  func request() -> URLRequest {
    var request = base.request()
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    return request
  }
}

struct RequestWithBody: Request {
  private let base: Request
  private let data: Data

  init(base: Request, data: Data) {
    self.base = base
    self.data = data
  }

  func request() -> URLRequest {
    var request = base.request()
    request.httpBody = data

    return request
  }
}

struct RequestWithQuery: Request {
  private let base: Request
  private let query: [URLQueryItem]

  init(base: Request, query: [URLQueryItem]) {
    self.base = base
    self.query = query
  }

  func request() -> URLRequest {
    var request = base.request()

    request.url?.append(queryItems: query)
    return request
  }
}

struct RequestWithPath: Request {
  private let base : Request
  private let path: [String]

  init(base: Request, path: [String]) {
    self.base = base
    self.path = path
  }

  func request() -> URLRequest {
    var request = base.request()
    path.forEach { item in
      request.url?.append(path: item)
    }
    return request
  }
}
