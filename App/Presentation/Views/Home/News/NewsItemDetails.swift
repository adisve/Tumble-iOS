//
//  NewsItemDetails.swift
//  Tumble
//
//  Created by Adis Veletanlic on 2023-04-05.
//

import SwiftUI

struct NewsItemDetails: View {
    let newsItem: Response.NotificationContent
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text(newsItem.title)
                    .apply(style: TextStyles.onBackgroundHeaderLargeSemibold)
                    .padding(.bottom, 20)
                Text(newsItem.timestamp.formatDate() ?? "")
                    .apply(style: TextStyles.onBackgroundHeaderSemibold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading) {
                Divider()
                    .opacity(0.8)
                    .padding(.vertical, 15)
                Text(newsItem.body)
                    .apply(style: TextStyles.onBackgroundBody)
            }
            .padding(.trailing, 10)
            Spacer()
        }
        .padding([.horizontal, .top], 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.background)
        .navigationTitle(NSLocalizedString("Details", comment: ""))
    }
}
