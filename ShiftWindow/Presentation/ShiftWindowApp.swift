//
//  ShiftWindowApp.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2022/06/27.
//
//  Copyright 2022 Takuto Nakamura (Kyome22)
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import SwiftUI

@main
struct ShiftWindowApp: App {
    typealias GVMConcrete = GeneralSettingsViewModelImpl<LaunchAtLoginRepositoryImpl>
    typealias SMConcrete = ShortcutModelImpl<UserDefaultsRepositoryImpl>
    typealias SVMConcrete = ShortcutSettingsViewModelImpl<UserDefaultsRepositoryImpl, SMConcrete>

    @StateObject private var appModel = ShiftWindowAppModelImpl()

    var body: some Scene {
        Settings {
            SettingsView<ShiftWindowAppModelImpl, GVMConcrete, SVMConcrete>()
                .environmentObject(appModel)
        }
    }
}