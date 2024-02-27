//
//  RoomContainerCar.swift
//  Tumble
//
//  Created by Adis Veletanlic on 3/23/23.
//

import SwiftUI

struct TimeslotCard: View {
    let onBook: () -> Void
    let locationId: String
    @Binding var bookingButtonState: BookingButtonState
    
    var body: some View {
        HStack {
            Text(locationId)
                .apply(style: TextStyles.onSurfaceTitleSemibold)
            Spacer()
            Button(action: {
                if bookingButtonState != .booked {
                    onBook()
                }
            }, label: {
                switch bookingButtonState {
                case .loading:
                    CustomProgressIndicator(color: .onPrimary)
                        .padding()
                case .booked:
                    Text(NSLocalizedString("Booked", comment: ""))
                        .apply(style: TextStyles.onPrimaryTitleSemibold)
                        .padding(7.5)
                case .available:
                    Text(NSLocalizedString("Book", comment: ""))
                        .apply(style: TextStyles.onPrimaryTitleSemibold)
                        .padding(7.5)
                }
            })
            .disabled(bookingButtonState == .booked)
            .buttonStyle(BookButtonStyle())
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 70)
        .background(Color.surface)
        .cornerRadius(10)
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
}
