//
//  SkipButtonView.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-01-28.
//

import SwiftUI

typealias OnClickSkip = () -> Void

struct SkipButton: View {
    let onClickSkip: OnClickSkip
    var body: some View {
        Button(action: onClickSkip) {
                Image(systemName: "arrow.uturn.right")
                .font(.system(size: 22))
                .foregroundColor(.onPrimary)
                .padding(15)
                .background(Color.primary)
                .clipShape(Circle())
            }
    }
}