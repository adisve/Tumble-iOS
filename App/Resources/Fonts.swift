//
//  Fonts.swift
//  App
//
//  Created by Adis Veletanlic on 2024-02-27.
//

import Foundation
import SwiftUI

struct Fonts {
    
    // Base sizes
    private static let baseCaptionSize: CGFloat = 10
    private static let baseBodySize: CGFloat = 14
    private static let baseTitleSize: CGFloat = 18
    private static let baseHeaderSize: CGFloat = 20

    // Weights
    private static let weightRegular = Font.Weight.regular
    private static let weightMedium = Font.Weight.medium
    private static let weightSemibold = Font.Weight.semibold
    
    // Fonts
    static let caption = Font.system(size: baseCaptionSize, weight: weightRegular)
    static let captionMedium = Font.system(size: baseCaptionSize, weight: weightMedium)
    static let captionSemiBold = Font.system(size: baseCaptionSize, weight: weightSemibold)
    
    static let captionMediumMedium = Font.system(size: baseCaptionSize + 2, weight: weightMedium)
    static let captionMediumSemiBold = Font.system(size: baseCaptionSize + 2, weight: weightSemibold)
    
    static let title = Font.system(size: baseTitleSize, weight: weightRegular)
    static let titleMedium = Font.system(size: baseTitleSize, weight: weightMedium)
    static let titleSemiBold = Font.system(size: baseTitleSize, weight: weightSemibold)

    static let body = Font.system(size: baseBodySize, weight: weightRegular)
    static let bodyMedium = Font.system(size: baseBodySize, weight: weightMedium)
    static let bodySemiBold = Font.system(size: baseBodySize, weight: weightSemibold)
    
    static let headerSmall = Font.system(size: baseHeaderSize, weight: weightRegular)
    static let headerSmallMedium = Font.system(size: baseHeaderSize, weight: weightMedium)
    static let headerSmallSemiBold = Font.system(size: baseHeaderSize, weight: weightSemibold)
    static let headerMedium = Font.system(size: baseHeaderSize + 7, weight: weightRegular)
    static let headerMediumMedium = Font.system(size: baseHeaderSize + 7, weight: weightMedium)
    static let headerMediumSemiBold = Font.system(size: baseHeaderSize + 7, weight: weightSemibold)
    static let headerLarge = Font.system(size: baseHeaderSize + 14, weight: weightRegular)
    static let headerLargeMedium = Font.system(size: baseHeaderSize + 14, weight: weightMedium)
    static let headerLargeSemiBold = Font.system(size: baseHeaderSize + 14, weight: weightSemibold)
}
