/*
 GeneralSettingsView.swift
 UserInterface

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

import DataSource
import Model
import SwiftUI

struct GeneralSettingsView: View {
    @StateObject var store: GeneralSettings

    var body: some View {
        Form {
            LabeledContent {
                Toggle(isOn: Binding<Bool>(
                    get: { store.launchAtLogin },
                    asyncSet: { await store.send(.launchAtLoginToggleSwitched($0)) }
                )) {
                    Text("AutomaticallyLaunchAtLogin", bundle: .module)
                }
            } label: {
                Text("launch", bundle: .module)
            }
            LabeledContent {
                Toggle(isOn: Binding<Bool>(
                    get: { store.checkForUpdates },
                    asyncSet: { await store.send(.checkForUpdatesToggleSwitched($0)) }
                )) {
                    Text("AutomaticallyCheckForUpdates", bundle: .module)
                }
            } label: {
                Text("update", bundle: .module)
            }
            Divider()
            LabeledContent {
                Text("permissionExplain", bundle: .module)
                    .frame(width: 300, alignment: .leading)
            } label: {
                Text("permission", bundle: .module)
            }
            Button {
                Task {
                    await store.send(.openSystemSettingsButtonTapped)
                }
            } label: {
                Text("openSystemSettings", bundle: .module)
                    .frame(maxWidth: .infinity)
            }
        }
        .fixedSize()
        .task {
            await store.send(.task(String(describing: Self.self)))
        }
    }
}

extension GeneralSettings: ObservableObject {}

#Preview {
    GeneralSettingsView(store: .init(.testDependencies()))
}
