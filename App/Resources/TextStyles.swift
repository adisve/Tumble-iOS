//
//  TextStyles.swift
//  App
//
//  Created by Adis Veletanlic on 2024-02-27.
//

import Foundation
import SwiftUI

struct TextStyles {
    
    static let body = TextStyle(font: Fonts.body)
    
    static let onBackgroundBody = TextStyle(
        font: Fonts.body,
        color: .onBackground
    )
    
    static let mediumBodyGray = TextStyle(
        font: Fonts.bodyMedium,
        color: .gray
    )
    
    static let onBackgroundBodyMedium = TextStyle(
        font: Fonts.bodyMedium,
        color: .onBackground
    )
    
    static let onBackgroundTitleMedium = TextStyle(
        font: Fonts.titleMedium,
        color: .onBackground
    )
    
    static let onSurfaceBody = TextStyle(
        font: Fonts.body,
        color: .onSurface
    )
    
    static let username = TextStyle(
        font: Fonts.body,
        color: .onBackground
    )
    
    static let schoolName = TextStyle(
        font: Fonts.bodySemiBold,
        color: .onBackground,
        padding: EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
    )
    
    static let onSurfaceBodySemibold = TextStyle(
        font: Fonts.body,
        color: .onSurface
    )
    
    static let onSurfaceTitleSemibold = TextStyle(
        font: Fonts.titleSemiBold,
        color: .onSurface
    )
    
    static let onSurfaceTitleMedium = TextStyle(
        font: Fonts.titleMedium,
        color: .onSurface
    )
    
    static let onBackgroundHeaderSemibold = TextStyle(
        font: Fonts.headerSmallSemiBold,
        color: .onBackground
    )
    
    static let onBackgroundHeaderLargeSemibold = TextStyle(
        font: Fonts.headerLargeSemiBold,
        color: .onBackground
    )
    
    static let onBackgroundTitleSemibold = TextStyle(
        font: Fonts.titleSemiBold,
        color: .onBackground
    )
    
    static let onBackgroundTitle = TextStyle(
        font: Fonts.title,
        color: .onBackground
    )
    
    static let onSurfaceBodyMedium = TextStyle(
        font: Fonts.bodyMedium,
        color: .onBackground
    )
    
    
    static let primaryTitleSemibold = TextStyle(
        font: Fonts.titleSemiBold,
        color: .primary
    )
    
    static let onPrimaryTitleSemibold = TextStyle(
        font: Fonts.titleSemiBold,
        color: .onPrimary
    )
    
    static let onSurfaceBodyOpaque = TextStyle(
        font: Fonts.body,
        color: .onSurface,
        opacity: 0.7
    )
    
    static let schoolNamePicker = TextStyle(
        font: Fonts.body,
        color: .onBackground
    )
    
    static let captionDimmed = TextStyle(
        font: Fonts.caption,
        color: .onBackground,
        padding: EdgeInsets(top: 35, leading: 35, bottom: 35, trailing: 35),
        opacity: 0.7
    )
    
    static let searchBarTitle = TextStyle(
        font: Fonts.title,
        padding: EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
    )
    
    static let sheetTitle = TextStyle(
        font: Fonts.titleSemiBold,
        color: Color.onBackground,
        padding: EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0)
    )
    
    static let bodyInstructions = TextStyle(
        font: Fonts.bodyMedium
    )
    
    static let infoHeaderSmall = TextStyle(
        font: Fonts.headerSmallSemiBold,
        color: Color.onBackground,
        padding: EdgeInsets(top: 0, leading: 15, bottom: 25, trailing: 15)
    )
    
    static let infoHeaderMedium = TextStyle(
        font: Fonts.headerMediumSemiBold,
        color: Color.onBackground
    )
    
    static let programmeTitle = TextStyle(
        font: Fonts.titleSemiBold,
        multilineTextAlignment: .leading,
        padding: EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
    )
    
    static let programmeBody = TextStyle(
        font: Fonts.body,
        multilineTextAlignment: .leading
    )
    
    static let searchResultsField = TextStyle(
        font: Fonts.titleSemiBold,
        color: Color.onBackground,
        padding: EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 0)
    )
    
    static let dayHeader = TextStyle(
        font: Fonts.headerSmallSemiBold,
        padding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
    )
    
    static let toastBody = TextStyle(
        font: Fonts.bodySemiBold,
        color: .onPrimary,
        padding: EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
    )
    
    static let toastCaption = TextStyle(
        font: Fonts.caption,
        color: .onPrimary
    )
    
    static let labelBody = TextStyle(
        font: Fonts.body,
        color: .onSurface,
        padding: EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
    )
    
    static let cardBody = TextStyle(
        font: Fonts.bodySemiBold,
        color: .onSurface
    )
    
    static let cardBodyDimmed = TextStyle(
        font: Fonts.bodySemiBold,
        color: .onSurface,
        opacity: 0.7
    )
    
    static let cardTitle = TextStyle(
        font: Fonts.titleMedium,
        color: .onSurface
    )
    
    static let linkDimmed = TextStyle(
        font: Fonts.caption,
        color: .onSurface,
        opacity: 0.7
    )
    
    static let shareSheetTitle = TextStyle(
        font: Fonts.titleSemiBold,
        color: .onSurface,
        padding: EdgeInsets(top: 0, leading: 0, bottom: 7, trailing: 0)
    )
    
    static let settingsNavCurrent = TextStyle(
        font: Fonts.body,
        color: .onSurface,
        padding: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10), 
        opacity: 0.4
    )
    
}
