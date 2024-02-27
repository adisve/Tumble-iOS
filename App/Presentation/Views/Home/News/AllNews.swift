//
//  AllNews.swift
//  Tumble
//
//  Created by Adis Veletanlic on 2023-04-05.
//

import SwiftUI

struct AllNews: View {
    let news: Response.NewsItems?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(NSLocalizedString("Other news", comment: ""))
                    .apply(style: TextStyles.onBackgroundTitleSemibold)
                Spacer()
            }
            if let news = news {
                VStack(alignment: .leading) {
                    if news.count >= 4 {
                        if news[4...].isEmpty {
                            Text(NSLocalizedString("No other news", comment: ""))
                                .apply(style: TextStyles.onBackgroundTitle)
                                .padding(.top, 7.5)
                        } else {
                            ForEach(news[4...], id: \.self) { newsItem in
                                NewsItemCard(newsItem: newsItem)
                            }
                        }
                    } else {
                        Text(NSLocalizedString("No other news", comment: ""))
                            .apply(style: TextStyles.onBackgroundTitle)
                            .padding(.top, 7.5)
                    }
                }
            }
        }
        .padding(.top, 30)
    }
}
