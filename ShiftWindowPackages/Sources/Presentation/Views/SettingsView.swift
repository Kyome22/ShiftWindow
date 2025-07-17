/*
 SettingsView.swift
 Presentation

 Created by Takuto Nakamura on 2024/11/01.
 Copyright 2022 Takuto Nakamura (Kyome22)

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

import Infrastructure
import Model
import SwiftUI

public struct SettingsView: View {
    @State private var settingsTab: SettingsTab
    @Environment(\.appDependencies) private var appDependencies

    public init(settingsTab: SettingsTab = .general) {
        self.settingsTab = settingsTab
    }

    public var body: some View {
        TabView(selection: $settingsTab) {
            GeneralSettingsView(appDependencies)
                .tabItem {
                    Label {
                        Text("general", bundle: .module)
                    } icon: {
                        Image(systemName: "gear")
                    }
                }
                .tag(SettingsTab.general)
            ShortcutSettingsView(appDependencies)
                .tabItem {
                    Label {
                        Text("shortcut", bundle: .module)
                    } icon: {
                        Image(systemName: "command")
                    }
                }
                .tag(SettingsTab.shortcuts)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .accessibilityIdentifier("settings")
    }
}

#Preview {
    SettingsView(settingsTab: .general)
        .environment(\.appDependencies, .testDependencies())
}
