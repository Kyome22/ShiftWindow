/*
 GeneralSettingsViewModel.swift
 ShiftWindow

 Created by Takuto Nakamura on 2022/06/27.
 Copyright 2023 Takuto Nakamura (Kyome22)

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

import AppKit
import Observation

protocol GeneralSettingsViewModel: Observable {
    var launchAtLogin: Bool { get set }

    init()

    func openSystemPreferences()
}

@Observable final class GeneralSettingsViewModelImpl<LR: LaunchAtLoginRepository>: GeneralSettingsViewModel {
    var launchAtLogin: Bool {
        didSet { launchAtLoginSwitched() }
    }
    private let launchAtLoginRepository: LR

    init() {
        self.launchAtLoginRepository = LR()
        launchAtLogin = launchAtLoginRepository.currentStatus
    }

    func openSystemPreferences() {
        let path = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        NSWorkspace.shared.open(URL(string: path)!)
    }

    private func launchAtLoginSwitched() {
        switch launchAtLoginRepository.switchStatus(launchAtLogin) {
        case .success:
            break
        case let .failure(.switchFailed(value)):
            launchAtLogin = value
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    @Observable final class GeneralSettingsViewModelMock: GeneralSettingsViewModel {
        var launchAtLogin: Bool = false

        init() {}

        func openSystemPreferences() {}
    }
}
