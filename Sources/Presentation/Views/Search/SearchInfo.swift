//
//  SearchInitialView.swift
//  Tumble
//
//  Created by Adis Veletanlic on 11/20/22.
//

import SwiftUI
import WrappingHStack

struct SearchInfo: View {
    let schools: [School]
    let gridSpacing: CGFloat = 10.0
    @Binding var selectedSchool: School?
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            if selectedSchool == nil {
                Text(NSLocalizedString(
                    "Choose a university to begin your search", comment: ""
                ))
                .info()
                .multilineTextAlignment(.leading)
                .padding(.bottom, 10)
            }
            
            FlowStack(items: schools, viewGenerator: { school in
                SchoolPill(school: school, selectedSchool: $selectedSchool)
            })
            
            if let selectedSchool = selectedSchool {
                if schools.filter({ $0.loginRq }).contains(selectedSchool) {
                    HStack {
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                        Group {
                            Text(NSLocalizedString("Important: ", comment: "")).bold()
                                +
                                Text(NSLocalizedString(
                                    "This university requires you to log in to their institution before you can see some of their schedules",
                                    comment: ""))
                        }.font(.system(size: 14))
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding()
    }
}
