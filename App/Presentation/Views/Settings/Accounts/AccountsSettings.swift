//
//  AccountsSettings.swift
//  App
//
//  Created by Adis Veletanlic on 6/13/24.
//

import SwiftUI

struct AccountsSettings: View {
    @Binding var currentUser: String?
    @Binding var accountList: [String]
    let changeUser: (String) -> Void
    
    var body: some View {
        if !accountList.isEmpty {
            SettingsList {
                SettingsListGroup {
                    if !accountList.isEmpty {
                        ForEach(accountList, id: \.self) { user in
                            SettingsRadioButton(
                                title: user,
                                isSelected: Binding<Bool>(
                                    get: { user == currentUser },
                                    set: { selected in
                                        if selected {
                                            currentUser = user
                                            changeUser(user)
                                        }
                                    }
                                )
                            )
                            if user != accountList.last {
                                Divider()
                            }
                        }
                    } else {
                        
                    }
                }
            }
        } else {
            Info(title: NSLocalizedString("No accounts yet", comment: ""), image: "person.slash")
        }
    }
}
