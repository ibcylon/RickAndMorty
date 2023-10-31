//
//  AppData.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/10/31.
//

import Foundation

struct AppData {
  private enum Key: String {
    case need_onboarding
    case need_login
    case email
    case nickname
  }

  @DataStorage(key: Key.need_onboarding.rawValue, defaultValue: true)
  static var needOnBoarding: Bool

  @DataStorage(key: Key.need_login.rawValue, defaultValue: true)
  static var needLogin: Bool

  @DataStorage(key: Key.email.rawValue, defaultValue: nil)
  static var email: String?

  @DataStorage(key: Key.nickname.rawValue, defaultValue: nil)
  static var nickname: String?
}
