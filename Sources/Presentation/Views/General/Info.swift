//
//  InfoView.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 11/28/22.
//

import SwiftUI

struct Info: View {
    let title: String
    let image: String?
    var body: some View {
        VStack(alignment: .center) {
            if image != nil {
                Image(systemName: image!)
                    .font(.system(size: 24))
                    .foregroundColor(.onSurface)
                    .padding(.bottom, 15)
            }
            Text(title)
                .info()
                .multilineTextAlignment(.center)
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .center
        )
        .background(Color.background)
    }
}
