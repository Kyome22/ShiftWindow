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

import DataLayer
import Domain
import SwiftUI

struct GeneralSettingsView: View {
    @State private var viewModel: GeneralSettingsViewModel

    init(
        nsWorkspaceClient: NSWorkspaceClient,
        spuUpdaterClient: SPUUpdaterClient,
        smAppServiceClient: SMAppServiceClient,
        logService: LogService
    ) {
        viewModel = .init(nsWorkspaceClient, spuUpdaterClient, smAppServiceClient, logService)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Form {
                LabeledContent {
                    Toggle(isOn: Binding<Bool>(
                        get: { viewModel.launchAtLoginIsEnabled },
                        set: { viewModel.launchAtLoginSwitched($0) }
                    )) {
                        Text("AutomaticallyLaunchAtLogin", bundle: .module)
                    }
                } label: {
                    Text("launch", bundle: .module)
                }
                LabeledContent {
                    Toggle(isOn: $viewModel.checkForUpdatesIsEnabled) {
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
                    viewModel.openSystemSettings()
                } label: {
                    Text("openSystemSettings", bundle: .module)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .fixedSize()
        .onAppear {
            viewModel.onAppear(screenName: String(describing: Self.self))
        }
    }
}

#Preview {
    GeneralSettingsView(
        nsWorkspaceClient: .testValue,
        spuUpdaterClient: .testValue,
        smAppServiceClient: .testValue,
        logService: .init(.testValue)
    )
}
