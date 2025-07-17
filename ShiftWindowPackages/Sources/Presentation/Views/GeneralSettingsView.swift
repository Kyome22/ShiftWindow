/*
 GeneralSettingsView.swift
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

struct GeneralSettingsView: View {
    @State private var store: GeneralSettings

    init(_ appDependencies: AppDependencies) {
        store = .init(appDependencies)
    }

    var body: some View {
        Form {
            LabeledContent {
                Toggle(isOn: Binding<Bool>(
                    get: { store.launchAtLogin },
                    set: { store.send(.launchAtLoginToggleSwitched($0)) }
                )) {
                    Text("AutomaticallyLaunchAtLogin", bundle: .module)
                }
            } label: {
                Text("launch", bundle: .module)
            }
            LabeledContent {
                Toggle(isOn: Binding<Bool>(
                    get: { store.checkForUpdates },
                    set: { store.send(.checkForUpdatesToggleSwitched($0)) }
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
                store.send(.openSystemSettingsButtonTapped)
            } label: {
                Text("openSystemSettings", bundle: .module)
                    .frame(maxWidth: .infinity)
            }
        }
        .fixedSize()
        .onAppear {
            store.send(.onAppear(String(describing: Self.self)))
        }
    }
}

#Preview {
    GeneralSettingsView(testDependencies(injection: { _ in }))
}
