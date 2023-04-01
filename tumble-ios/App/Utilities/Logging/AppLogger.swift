//
//  AppLogger.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-02-03.
//

import Foundation
import Logging

/// Basic logger singleton shared globally
struct AppLogger {
    static let shared = Logger(label: "app.studios.tumble")
}
