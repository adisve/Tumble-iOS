//
//  NewsItemCard.swift
//  Tumble
//
//  Created by Adis Veletanlic on 2023-04-05.
//

import SwiftUI

struct NewsItemCard: View {
    let newsItem: Response.NotificationContent
    
    var body: some View {
        NavigationLink(destination: AnyView(NewsItemDetails(newsItem: newsItem)), label: {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(newsItem.title)
                        .apply(style: TextStyles.onSurfaceTitleSemibold)
                    Spacer()
                    Text(newsItem.timestamp.formatDate() ?? "")
                        .apply(style: TextStyles.onSurfaceBodyOpaque)
                }
                .padding(.bottom, 7.5)
                Text(newsItem.body)
                    .apply(style: TextStyles.onSurfaceBodyMedium)
                    .multilineTextAlignment(.leading)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color.surface)
            .cornerRadius(15)
            .padding(.vertical, 7.5)
        })
    }
}
