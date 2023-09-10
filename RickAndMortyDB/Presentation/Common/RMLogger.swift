//
//  RMLogger.swift
//  RickAndMortyDB
//
//  Created by Kanghos on 2023/09/12.
//

import Foundation
import OSLog

extension Logger {
  private static var subsystem = Bundle.main.bundleIdentifier!
  static var data = Logger(subsystem: subsystem, category: "Data")
  static var ui = Logger(subsystem: subsystem, category: "UI")
  static var domain = Logger(subsystem: subsystem, category: "Domain")
}

struct RMLogger {
  static var dataLogger = Logger.data
  static var ui = Logger.ui
  static var domain = Logger.domain
}
