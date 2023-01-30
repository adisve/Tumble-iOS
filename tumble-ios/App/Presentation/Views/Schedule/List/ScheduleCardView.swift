//
//  ScheduleCardview.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 11/18/22.
//

import SwiftUI

struct ScheduleCardView: View {
    @AppStorage(StoreKey.theme.rawValue) private var isDarkMode = false
    @State private var isDisclosed: Bool = false
    @State private var isAnimating: Bool = false
    
    let onTapCard: OnTapCard
    let event: Response.Event
    let isLast: Bool
    let color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7.5)
                .fill(event.isSpecial ? .red : color)
                
            Rectangle()
                .fill(Color("SurfaceColor"))
                .offset(x: 7.5)
                .cornerRadius(5, corners: [.topRight, .bottomRight])
            VStack (alignment: .leading, spacing: 0) {
                CardBannerView(color: event.isSpecial ? .red : color, timeSpan: "\(event.from.ISOtoHours()) - \(event.to.ISOtoHours())", isSpecial: event.isSpecial, courseName: event.course.englishName, isDisclosed: isDisclosed)
                    
                CardInformationView(title: event.title, courseName: event.course.englishName.trimmingCharacters(in: .whitespaces), location: event.locations.first?.id ?? "Unknown")
                Spacer()
            }
            
        }
        .animation(.easeIn.repeatForever(autoreverses: false), value: isAnimating)
        .onTapGesture {
            print("Tapped card")
            onTapCard(event)
        }
        .onLongPressGesture {
            print("long press!")
        }
        .frame(height: 145)
        .padding([.leading, .trailing], 8)
        .padding(.bottom, isLast ? 40 : 10)
        
    }
}
