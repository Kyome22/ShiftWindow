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

import DataLayer
import Domain
import SwiftUI

public struct SettingsView: View {
    @State private var settingsTabType: SettingsTabType = .general
    @Environment(\.appDependency) private var appDependency

    public init() {}

    public var body: some View {
        TabView(selection: $settingsTabType) {
            GeneralSettingsView(
                nsWorkspaceClient: appDependency.nsWorkspaceClient,
                checkForUpdatesRepository: appDependency.checkForUpdatesRepository,
                launchAtLoginRepository: appDependency.launchAtLoginRepository,
                logService: appDependency.logService
            )
            .tabItem {
                Label {
                    Text("general", bundle: .module)
                } icon: {
                    Image(systemName: "gear")
                }
            }
            .tag(SettingsTabType.general)
            ShortcutSettingsView(
                userDefaultsRepository: appDependency.userDefaultsRepository,
                logService: appDependency.logService,
                shortcutService: appDependency.shortcutService
            )
            .tabItem {
                Label {
                    Text("shortcut", bundle: .module)
                } icon: {
                    Image(systemName: "command")
                }
            }
            .tag(SettingsTabType.shortcuts)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .accessibilityIdentifier("settings")
    }
}

#Preview {
    SettingsView()
}
