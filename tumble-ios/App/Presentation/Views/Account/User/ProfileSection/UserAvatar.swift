//
//  UserAvatar.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-02-13.
//

import SwiftUI

struct UserAvatar: View {
    
    let name: String
    
    var body: some View {
        Text(name.abbreviate())
            .font(.system(size: 40, weight: .semibold))
            .foregroundColor(.onPrimary)
            .padding()
            .background(Circle().fill(Color("PrimaryColor")))
    }
}

