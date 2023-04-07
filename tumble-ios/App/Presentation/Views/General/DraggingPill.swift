//
//  DraggingPill.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 2023-04-05.
//

import SwiftUI

struct DraggingPill: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.gray)
            .frame(width: 40, height: 4)
            .padding(.top, 10)
    }
}

struct DraggingPill_Previews: PreviewProvider {
    static var previews: some View {
        DraggingPill()
    }
}
