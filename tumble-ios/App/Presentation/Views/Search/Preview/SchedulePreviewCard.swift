//
//  SchedulePreviewCardView.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2022-12-02.
//

import SwiftUI

struct SchedulePreviewCard: View {
    let previewColor: Color
    let event: Response.Event
    let isLast: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7.5)
                .fill(event.isSpecial ? .red : previewColor)
                
            Rectangle()
                .fill(Color.surface)
                .offset(x: 7.5)
                .cornerRadius(5, corners: [.topRight, .bottomRight])
            VStack (alignment: .leading, spacing: 0) {
                PreviewCardBanner(color: event.isSpecial ? .red : previewColor, timeSpan: "\(event.from.convertISOToHoursAndMinutes() ?? "") - \(event.to.convertISOToHoursAndMinutes() ?? "")", isSpecial: event.isSpecial)
                    
                BookmarkCardInformation(title: event.title, courseName: event.course.englishName.trimmingCharacters(in: .whitespaces), location: event.locations.first?.id ?? "Unknown")
                Spacer()
            }
            
        }
        .frame(height: 140)
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .padding(.bottom, isLast ? 40 : 10)
        
    }
}