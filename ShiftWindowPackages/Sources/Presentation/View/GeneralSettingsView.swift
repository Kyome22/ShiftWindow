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
        launchAtLoginRepository: LaunchAtLoginRepository,
        logService: LogService
    ) {
        viewModel = .init(nsWorkspaceClient, launchAtLoginRepository, logService)
    }

    var body: some View {
        VStack(alignment: .leading) {
            LabeledContent {
                Toggle(isOn: $viewModel.launchAtLoginIsEnabled) {
                    Text("enable", bundle: .module)
                }
            } label: {
                Text("launchAtLogin", bundle: .module)
            }
            Divider()
            Form {
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
        launchAtLoginRepository: .init(.testValue),
        logService: .init(.testValue)
    )
}
