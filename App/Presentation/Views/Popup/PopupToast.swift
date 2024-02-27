//
//  PopupToast.swift
//  Tumble
//
//  Created by Adis Veletanlic on 7/15/23.
//

import SwiftUI
import MijickPopupView

struct PopupToast: BottomPopup {
    
    let popup: Popup
    
    func createContent() -> some View {
        HStack {
            VStack (alignment: .leading, spacing: 0) {
                Text(popup.title)
                    .apply(style: TextStyles.toastBody)
                if let message = popup.message {
                    Text(message)
                        .apply(style: TextStyles.toastCaption)
                }
            }
            Spacer()
            Image(systemName: popup.leadingIcon)
                .foregroundColor(.onPrimary)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(Color.primary)
        .cornerRadius(10.0)
        .padding(15)
        .padding(.bottom, 40)
    }
    
    func configurePopup(popup: BottomPopupConfig) -> BottomPopupConfig {
        popup
            .tapOutsideToDismiss(true)
            .backgroundColour(.black.opacity(0))
    }
}
