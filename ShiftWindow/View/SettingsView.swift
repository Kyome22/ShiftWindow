//
//  SettingsView.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2022/06/27.
//

import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general
        case shortcut
    }

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("general", systemImage: "gear")
                }
                .tag(Tabs.general)
            ShortcutSettingsView()
                .tabItem {
                    Label("shortcut", systemImage: "command")
                }
                .tag(Tabs.shortcut)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
