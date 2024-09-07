/*
 SettingsView.swift
 ShiftWindow

 Created by Takuto Nakamura on 2022/06/27.
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

import SwiftUI

struct SettingsView<SVM: SettingsViewModel>: View {
    @State var viewModel: SVM
    @Environment(\.settingsTab) private var settingsTab

    var body: some View {
        TabView(selection: settingsTab) {
            GeneralSettingsView(viewModel: viewModel.generalSettingsViewModel)
                .tabItem {
                    Label("general", systemImage: "gear")
                }
                .tag(SettingsTabType.general)
            ShortcutSettingsView(viewModel: viewModel.shortcutSettingsViewModel)
                .tabItem {
                    Label("shortcut", systemImage: "command")
                }
                .tag(SettingsTabType.shortcuts)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .accessibilityIdentifier("Preferences")
    }
}

#Preview {
    ForEach(["en_US", "ja_JP"], id: \.self) { id in
        SettingsView(viewModel: PreviewMock.SettingsViewModelMock())
            .environment(\.settingsTab, .constant(.general))
            .environment(\.locale, .init(identifier: id))
    }
}
