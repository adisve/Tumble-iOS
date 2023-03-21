//
//  DrawerRow.swift
//  tumble-ios
//
//  Created by Adis Veletanlic on 11/17/22.
//

import SwiftUI

struct SidebarMenuButton: View {
    let sideBarTabType: SidebarTabType
    let title: String
    let image: String
    
    @ObservedObject var parentViewModel: SidebarViewModel
    @Binding var selectedSideBarTab: SidebarTabType
    var animation: Namespace.ID
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedSideBarTab = sideBarTabType
                parentViewModel.sidebarSheetType = sideBarTabType
                parentViewModel.presentSidebarSheet = true
            }
        }, label: {
            HStack (spacing: 10) {
                Image(systemName: image)
                    .font(.system(size: 20))
                    .frame(width: 32)
                Text(title)
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
            }
            .foregroundColor(selectedSideBarTab.rawValue == title ? .onPrimary : .onSurface)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .frame(maxWidth: getRect().width - 170, alignment: .leading)
            .background(
                ZStack {
                    if selectedSideBarTab.rawValue == title {
                        Color.primary.opacity(selectedSideBarTab.rawValue == title ? 1 : 0)
                            .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 10))
                            .matchedGeometryEffect(id: "SIDEBARTAB", in: animation)
                    }
                }
            )
        })
    }
}
