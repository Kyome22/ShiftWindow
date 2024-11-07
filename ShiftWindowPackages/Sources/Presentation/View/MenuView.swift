/*
 MenuView.swift
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
import SpiceKey
import SwiftUI

struct MenuView: View {
    @State private var viewModel: MenuViewModel

    init(
        executeClient: ExecuteClient,
        nsAppClient: NSAppClient,
        logService: LogService,
        shiftService: ShiftService,
        shortcutService: ShortcutService,
        updateService: UpdateService
    ) {
        viewModel = .init(executeClient, nsAppClient, logService, shiftService, shortcutService, updateService)
    }

    var body: some View {
        VStack {
            ForEach(viewModel.patterns) { pattern in
                Button {
                    viewModel.shiftWindow(shiftType: pattern.shiftType)
                } label: {
                    Label {
                        Text(pattern.label)
                    } icon: {
                        Image(pattern.imageResource)
                    }
                    .labelStyle(.titleAndIcon)
                }
                .keyboardShortcutIfPossible(pattern.keyEquivalent, modifiers: pattern.eventModifiers)
                if pattern.shiftType.needsDivider {
                    Divider()
                }
            }
            Divider()
            Toggle(isOn: $viewModel.hideIcons) {
                Text("hideDesktopIcons", bundle: .module)
            }
            Divider()
            SettingsLink {
                Text("settings", bundle: .module)
            }
            .preActionButtonStyle {
                viewModel.activateApp()
            }
            Divider()
            Button {
                viewModel.checkForUpdates()
            } label: {
                Text("checkForUpdates", bundle: .module)
            }
            Button {
                viewModel.openAbout()
            } label: {
                Text("aboutApp", bundle: .module)
            }
            Button {
                viewModel.terminateApp()
            } label: {
                Text("terminateApp", bundle: .module)
            }
        }
    }
}

#Preview {
    let shiftService = ShiftService(.testValue, .testValue, .testValue, .testValue, .testValue)
    MenuView(
        executeClient: .testValue,
        nsAppClient: .testValue,
        logService: .init(.testValue),
        shiftService: shiftService,
        shortcutService: .init(.init(.testValue, reset: false), shiftService),
        updateService: .init(.testValue)
    )
}
