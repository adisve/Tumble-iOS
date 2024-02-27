//
//  VerboseEventButtonLabel.swift
//  Tumble
//
//  Created by Adis Veletanlic on 2023-03-20.
//

import SwiftUI

struct VerboseEventButtonLabel: View {
    let event: Event
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(event.title)
                        .apply(style: TextStyles.cardTitle)
                    Text(event.course?.englishName ?? "")
                        .apply(style: TextStyles.cardBodyDimmed)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                HStack {
                    Image(systemName: "person.2")
                        .font(.system(size: 15))
                        .foregroundColor(.onSurface.opacity(0.7))
                    if let teacher = event.teachers.first {
                        if !teacher.firstName.isEmpty && !teacher.lastName.isEmpty {
                            Text("\(teacher.firstName) \(teacher.lastName)")
                                .apply(style: TextStyles.cardBodyDimmed)
                        } else {
                            Text(NSLocalizedString("No teachers listed", comment: ""))
                                .apply(style: TextStyles.cardBodyDimmed)
                        }
                    } else {
                        Text(NSLocalizedString("No teachers listed", comment: ""))
                            .apply(style: TextStyles.cardBodyDimmed)
                    }
                }
                HStack {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 15))
                            .foregroundColor(.onSurface)
                        Text(event.locations.first?.locationId.capitalized ?? NSLocalizedString("Unknown", comment: ""))
                            .apply(style: TextStyles.cardBody)
                    }
                    Spacer()
                    if let timeFrom = event.from.convertToHoursAndMinutesISOString(),
                       let timeTo = event.to.convertToHoursAndMinutesISOString()
                    {
                        HStack {
                            Circle()
                                .foregroundColor(event.isSpecial ? Color.red : event.course?.color.toColor())
                                .frame(width: 7, height: 7)
                            HStack {
                                Text("\(timeFrom)")
                                    .apply(style: TextStyles.cardBody)
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.onSurface)
                                Text("\(timeTo)")
                                    .apply(style: TextStyles.cardBody)
                            }
                        }
                    }
                }
            }
            .padding()
            .frame(height: 160, alignment: .leading)
            .frame(maxWidth: .infinity)
            .background(event.isSpecial ? Color.red.opacity(0.2) : Color.surface)
            .background(Color.surface)
            .cornerRadius(15)
        }
    }
}
