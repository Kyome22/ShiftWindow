/*
 MenuBarScene.swift
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

import Domain
import SwiftUI

public struct MenuBarScene: Scene {
    @Environment(\.appDependency) private var appDependency

    public init() {}

    public var body: some Scene {
        MenuBarExtra {
            MenuView(
                executeClient: appDependency.executeClient,
                nsAppClient: appDependency.nsAppClient,
                logService: appDependency.logService,
                shiftService: appDependency.shiftService,
                shortcutService: appDependency.shortcutService
            )
            .environment(\.displayScale, 2.0)
        } label: {
            Image(.statusIcon)
                .environment(\.displayScale, 2.0)
        }
    }
}