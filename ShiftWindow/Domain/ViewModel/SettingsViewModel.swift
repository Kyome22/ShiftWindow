/*
 SettingsViewModel.swift
 ShiftWindow

 Created by Takuto Nakamura on 2024/09/07.
 Copyright 2024 Takuto Nakamura (Kyome22)

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

import Observation
import SwiftUI

@MainActor protocol SettingsViewModel {
    associatedtype GSVM: GeneralSettingsViewModel
    associatedtype SSVM: ShortcutSettingsViewModel

    var generalSettingsViewModel: GSVM { get }
    var shortcutSettingsViewModel: SSVM { get }

    init(_ userDefaultsRepository: UserDefaultsRepository,
         _ shortcutModel: ShortcutModel)
}

final class SettingsViewModelImpl<GSVM: GeneralSettingsViewModel,
                                  SSVM: ShortcutSettingsViewModel>: SettingsViewModel {
    typealias GSVM = GSVM
    typealias SSVM = SSVM

    private let userDefaultsRepository: UserDefaultsRepository
    private let shortcutModel: ShortcutModel

    var generalSettingsViewModel: GSVM { .init() }
    var shortcutSettingsViewModel: SSVM { .init(userDefaultsRepository, shortcutModel) }

    init(
        _ userDefaultsRepository: UserDefaultsRepository,
        _ shortcutModel: ShortcutModel
    ) {
        self.userDefaultsRepository = userDefaultsRepository
        self.shortcutModel = shortcutModel
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class SettingsViewModelMock: SettingsViewModel {
        typealias GSVM = GeneralSettingsViewModelMock
        typealias SSVM = ShortcutSettingsViewModelMock

        let generalSettingsViewModel = GSVM()
        let shortcutSettingsViewModel = SSVM()

        init(_ userDefaultsRepository: UserDefaultsRepository,
             _ shortcutModel: ShortcutModel) {}
        init() {}
    }
}
