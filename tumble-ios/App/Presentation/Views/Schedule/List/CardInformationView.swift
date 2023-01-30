//
//  CardInformationView.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-01-26.
//

import SwiftUI

struct CardInformationView: View {
    let title: String
    let courseName: String
    let location: String
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(title)
                .titleCard()
            VStack {
                Text(courseName)
                    .courseNameCard()
                Spacer()
            }
            HStack {
                Spacer()
                Text(location)
                    .locationCard()
                Image(systemName: "location")
                    .font(.title3)
                    .foregroundColor(Color("OnSurface"))
                    .padding(.trailing, 5)
            }
            .padding(.trailing, 10)
            Spacer()
        }
    }
}