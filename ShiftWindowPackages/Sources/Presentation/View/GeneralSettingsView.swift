/*
 GeneralSettingsView.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
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
