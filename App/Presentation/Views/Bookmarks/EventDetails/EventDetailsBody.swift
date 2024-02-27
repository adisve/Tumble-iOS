//
//  EventDetailsBodyView.swift
//  Tumble
//
//  Created by Adis Veletanlic on 2023-02-01.
//

import SwiftUI

struct EventDetailsBody: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            DetailsBuilder(title: NSLocalizedString("Course", comment: ""), image: "text.book.closed") {
                Text(event.course?.englishName ?? "")
                    .apply(style: TextStyles.onSurfaceTitle)
            }
            DetailsBuilder(title: NSLocalizedString("Teachers", comment: ""), image: "person.2") {
                if !event.teachers.isEmpty {
                    if !event.teachers.first!.firstName.isEmpty && !event.teachers.first!.lastName.isEmpty {
                        ForEach(event.teachers, id: \.self) { teacher in
                            Text("\(teacher.firstName) \(teacher.lastName)")
                                .apply(style: TextStyles.onSurfaceTitle)
                        }
                    } else {
                        Text(NSLocalizedString("No teachers listed at this time", comment: ""))
                            .apply(style: TextStyles.onSurfaceTitle)
                    }
                } else {
                    Text(NSLocalizedString("No teachers listed at this time", comment: ""))
                        .apply(style: TextStyles.onSurfaceTitle)
                }
            }
            DetailsBuilder(title: NSLocalizedString("Date", comment: ""), image: "calendar") {
                Text("\(event.from.formatDate() ?? "")")
                    .apply(style: TextStyles.onSurfaceTitle)
            }
            DetailsBuilder(title: NSLocalizedString("Time", comment: ""), image: "clock") {
                Text("\(event.from.convertToHoursAndMinutesISOString() ?? "") - \(event.to.convertToHoursAndMinutesISOString() ?? "")")
                    .apply(style: TextStyles.onSurfaceTitle)
            }
            DetailsBuilder(title: NSLocalizedString("Locations", comment: ""), image: "mappin.and.ellipse") {
                if event.locations.count > 0 {
                    ForEach(event.locations, id: \.self) { location in
                        Text(location.locationId.capitalized)
                            .apply(style: TextStyles.onSurfaceTitle)
                    }
                } else {
                    Text(NSLocalizedString("No locations listed at this time", comment: ""))
                        .apply(style: TextStyles.onSurfaceTitle)
                }
            }
            
            Spacer()
        }
    }
}
