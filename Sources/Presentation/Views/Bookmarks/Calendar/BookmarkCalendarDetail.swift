//
//  BookmarkCalendarDetail.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-03-18.
//

import SwiftUI

struct BookmarkCalendarDetail: View {
    
    let onTapDetail: (Event) -> Void
    let event: Event
    
    var body: some View {
        Button(action: {
            HapticsController.triggerHapticLight()
            onTapDetail(event)
        }, label: {
            if let course = event.course {
                CompactEventButtonLabel(event: event, color: event.isSpecial ? .red : course.color.toColor())
            }
        })
        .buttonStyle(CompactButtonStyle(backgroundColor: event.isSpecial ? .red.opacity(0.15) : event.course?.color.toColor().opacity(0.15) ?? .white))
        .padding(.horizontal, 15)
    }
}
