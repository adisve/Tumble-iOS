//
//  UIImageViewExtension.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-02-14.
//

import Foundation
import UIKit

extension UIImage {

    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }

    func getSizeIn(_ type: DataUnits) -> Double {

        guard let data = self.pngData() else {
            return .zero
        }

        var size: Double = 0.0

        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }

        return size
    }
}