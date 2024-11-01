/*
 SettingsView.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
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
