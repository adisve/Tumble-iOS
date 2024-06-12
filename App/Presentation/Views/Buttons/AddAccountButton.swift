//
//  AddAccountButton.swift
//  App
//
//  Created by Adis Veletanlic on 6/12/24.
//

import SwiftUI

struct AddAccountButton: View {
    
    var body: some View {
        NavigationLink(destination: AccountLogin(), label: {
            Image(systemName: "person.badge.plus")
        })
    }
}
