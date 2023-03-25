//
//  ResourceDatePicker.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-03-22.
//

import SwiftUI

struct ResourceDatePicker: View {
    
    @Binding var date: Date
    
    var body: some View {
        DatePicker(
            "Pick a date",
            selection: $date,
            in: Calendar.current.date(byAdding: .year, value: -1, to: Date())!...,
            displayedComponents: [.date]
        )
        .frame(minHeight: 300)
        .datePickerStyle(.graphical)
        .accentColor(Color.primary)
        .background(Color.background)
        .environment(\.locale, Locale(identifier: "en_GB"))
        .environment(\.calendar, Calendar(identifier: .iso8601))
    }
}

struct ResourceDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        ResourceDatePicker(date: .constant(Date.now))
    }
}
