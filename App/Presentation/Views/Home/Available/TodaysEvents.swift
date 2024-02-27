//
//  TodaysEvents.swift
//  Tumble
//
//  Created by Adis Veletanlic on 2023-04-04.
//

import SwiftUI

struct TodaysEvents: View {
    @Binding var eventsForToday: [WeekEventCardModel]
    @Binding var swipedCards: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(NSLocalizedString("Today's events", comment: ""))
                .apply(style: TextStyles.onBackgroundTitleSemibold)
            VStack {
                if !eventsForToday.isEmpty {
                    TodaysEventsCarousel(
                        swipedCards: $swipedCards,
                        weekEventCards: $eventsForToday
                    )
                } else {
                    Text(NSLocalizedString("No events for today", comment: ""))
                        .apply(style: TextStyles.onBackgroundTitleSemibold)
                }
            }
            .frame(minHeight: 100, alignment: .top)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
