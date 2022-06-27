//
//  GeneralSettingsView.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2022/06/27.
//

import SwiftUI

struct GeneralSettingsView: View {
    @StateObject var viewModel = GeneralSettingsViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("launchAtLogin:")
                Toggle(isOn: $viewModel.launchAtLogin) {
                    Text("enable")
                }
                .onChange(of: viewModel.launchAtLogin) { newValue in
                    viewModel.toggleLaunchAtLogin(newValue)
                }
            }
            Divider()
            Text("permission:")
            Text("explain1")
                .frame(width: 300, alignment: .leading)
                .padding(.horizontal, 8)
            Text("explain2")
                .frame(width: 300, alignment: .leading)
                .padding(.horizontal, 8)
            Button {
                viewModel.openSystemPreferences()
            } label: {
                Text("openSystemPreferences")
            }
            .fixedSize()
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 8)
        }
        .fixedSize()
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
