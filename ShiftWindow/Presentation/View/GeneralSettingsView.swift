/*
  GeneralSettingsView.swift
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

struct GeneralSettingsView<GVM: GeneralSettingsViewModel>: View {
    @StateObject private var viewModel: GVM

    init(viewModel: GVM) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if macOS13OrLater {
                HStack(alignment: .center, spacing: 8) {
                    Text("launchAtLogin:")
                    Toggle(isOn: $viewModel.launchAtLogin) {
                        Text("enable")
                    }
                }
            } else {
                Text("launchAtLogin:")
                Text("registerloginItems")
                    .frame(width: 300, alignment: .leading)
                    .padding(.horizontal, 8)
                Button {
                    viewModel.openLoginItems()
                } label: {
                    Text("openSystemPreferences")
                        .frame(width: 250)
                }
                .frame(maxWidth: .infinity, alignment: .center)
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
                    .frame(width: 250)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .fixedSize()
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["en_US", "ja_JP"], id: \.self) { id in
            GeneralSettingsView(viewModel: PreviewMock.GeneralSettingsViewModelMock())
                .environment(\.locale, .init(identifier: id))
        }
    }
}
