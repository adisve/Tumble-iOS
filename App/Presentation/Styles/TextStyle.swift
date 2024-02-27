//
//  TextStyle.swift
//  App
//
//  Created by Adis Veletanlic on 2024-02-27.
//

import Foundation
import SwiftUI

struct TextStyle {
    let font: Font
    let color: Color
    let lineSpacing: CGFloat?
    let multilineTextAlignment: TextAlignment?
    let padding: EdgeInsets?
    let opacity: CGFloat?

    init(
        font: Font,
        color: Color = .primary,
        lineSpacing: CGFloat? = nil,
        multilineTextAlignment: TextAlignment? = nil,
        padding: EdgeInsets? = nil,
        opacity: CGFloat? = nil
    ) {
        self.font = font
        self.color = color
        self.lineSpacing = lineSpacing
        self.multilineTextAlignment = multilineTextAlignment
        self.padding = padding
        self.opacity = opacity
    }
}


extension Text {
    func apply(style: TextStyle) -> some View {
        self
            .font(style.font)
            .foregroundColor(style.color)
            .lineSpacing(style.lineSpacing ?? 0)
            .multilineTextAlignment(style.multilineTextAlignment ?? .leading)
            .padding(style.padding ?? EdgeInsets())
            .opacity(style.opacity ?? 1.0)
    }
}

extension LabelStyleConfiguration.Title {
    func apply(style: TextStyle) -> some View {
        self
            .font(style.font)
            .foregroundColor(style.color)
            .lineSpacing(style.lineSpacing ?? 0)
            .multilineTextAlignment(style.multilineTextAlignment ?? .leading)
            .padding(style.padding ?? EdgeInsets())
            .opacity(style.opacity ?? 1.0)
    }
}

extension TextField {
    func apply(style: TextStyle) -> some View {
        self
            .font(style.font)
            .foregroundColor(style.color)
            .lineSpacing(style.lineSpacing ?? 0)
            .multilineTextAlignment(style.multilineTextAlignment ?? .leading)
            .padding(style.padding ?? EdgeInsets())
            .opacity(style.opacity ?? 1.0)
    }
}
