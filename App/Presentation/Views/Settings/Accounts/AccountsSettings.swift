//
//  AccountsSettings.swift
//  App
//
//  Created by Adis Veletanlic on 6/13/24.
//

import SwiftUI
import SwipeActions

struct AccountsSettings: View {
    @Binding var currentUser: String?
    @Binding var accountDict: [String:Int]
    let changeUser: (String) -> Void
    let onDeleteAccount: (String) -> Void
    
    var body: some View {
        if !accountDict.isEmpty {
            SettingsList {
                SettingsListGroup {
                    ForEach(accountDict.sorted(by: { $0.key > $1.key }), id: \.key) { key, value in
                        SettingsRadioButton(
                            title: key,
                            isSelected: Binding<Bool>(
                                get: { key == currentUser },
                                set: { selected in
                                    if selected {
                                        currentUser = key
                                        changeUser(key)
                                    }
                                }
                            )
                        )
                        if key != accountDict.keys.sorted(by: >).last {
                            Divider()
                        }
                    }
                }
            }
        } else {
            Info(title: NSLocalizedString("No accounts yet", comment: ""), image: "person.slash")
        }
    }
}

