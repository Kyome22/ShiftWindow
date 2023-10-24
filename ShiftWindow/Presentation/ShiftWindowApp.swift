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
    typealias UR = UserDefaultsRepositoryImpl
    typealias LR = LaunchAtLoginRepositoryImpl
    typealias SM = ShiftModelImpl
    typealias SCM = ShortcutModelImpl<UR, SM>
    typealias WM = WindowModelImpl<UR, SCM>
    typealias MVM = MenuViewModelImpl<SM, SCM, WM>
    typealias GVM = GeneralSettingsViewModelImpl<LR>
    typealias SVM = ShortcutSettingsViewModelImpl<UR, SCM>

    @StateObject private var appModel = ShiftWindowAppModelImpl()

    var body: some Scene {
        Settings {
            SettingsView<ShiftWindowAppModelImpl, GVM, SVM>()
                .environmentObject(appModel)
        }
        MenuBarExtra {
            MenuView(viewModel: MVM.init(appModel.shiftModel,
                                         appModel.shortcutModel,
                                         appModel.windowModel))
        } label: {
            Image(.statusIcon)
        }
    }
}
