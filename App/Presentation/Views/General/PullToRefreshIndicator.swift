//
//  PullToRefreshIndicator.swift
//  Tumble
//
//  Created by Adis Veletanlic on 4/1/23.
//

import SwiftUI

struct PullToRefreshIndicator: View {
    var body: some View {
        HStack {
            Text(NSLocalizedString("Pull to refresh", comment: ""))
                .apply(style: TextStyles.primaryBodySemibold)
            Image(systemName: "arrow.down")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct PullToRefreshIndicator_Previews: PreviewProvider {
    static var previews: some View {
        PullToRefreshIndicator()
    }
}
