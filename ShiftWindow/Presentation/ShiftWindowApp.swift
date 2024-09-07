/*
 ShiftWindowApp.swift
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

@main
struct ShiftWindowApp: App {
    typealias SAM = ShiftWindowAppModelImpl
    @State private var appModel = SAM()

    var body: some Scene {
        Settings {
            SettingsView(
                viewModel: SAM.SVM(
                    appModel.userDefaultsRepository,
                    appModel.shortcutModel
                )
            )
            .environment(\.settingsTab, $appModel.settingsTab)
        }
        MenuBarExtra {
            MenuView(
                viewModel: SAM.MVM(
                    appModel.shiftModel,
                    appModel.shortcutModel,
                    appModel.windowModel
                )
            )
            .environment(\.displayScale, 2.0)
            .onAppear {
                appModel.didFinishLaunching()
            }
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)) { _ in
                appModel.willTerminate()
            }
        } label: {
            Image(.statusIcon)
                .environment(\.displayScale, 2.0)
        }
    }
}
