//
//  HomeNextClass.swift
//  Tumble
//
//  Created by Adis Veletanlic on 2023-04-04.
//

import SwiftUI

struct NextClass: View {
    let nextClass: Event?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let nextClass = nextClass {
                    Text(nextClass.from.formatDate() ?? "")
                        .apply(style: TextStyles.mediumBodyGray)
                }
                Spacer()
                Text(NSLocalizedString("Next class", comment: ""))
                    .apply(style: TextStyles.onBackgroundTitleSemibold)
            }
            if let nextClass = nextClass, let course = nextClass.course {
                let color: Color = course.color.toColor()
                CompactEventButtonLabel(event: nextClass, color: color)
                    .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 100, alignment: .center)
                    .cornerRadius(15)
                    .padding(.bottom, 10)
            } else {
                Text(NSLocalizedString("No upcoming class", comment: ""))
                    .apply(style: TextStyles.onBackgroundTitleSemibold)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .padding(.top, 20)
    }
}
