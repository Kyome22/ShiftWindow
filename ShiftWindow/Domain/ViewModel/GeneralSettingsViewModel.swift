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

protocol GeneralSettingsViewModel: ObservableObject {
    var launchAtLogin: Bool { get set }

    init(_ launchAtLoginRepository: LaunchAtLoginRepository)

    func openSystemPreferences()
}

final class GeneralSettingsViewModelImpl<LR: LaunchAtLoginRepository>: GeneralSettingsViewModel {
    @Published var launchAtLogin: Bool {
        didSet {
            launchAtLoginRepository.switchRegistration(launchAtLogin) { [weak self] in
                self?.launchAtLogin = oldValue
            }
        }
    }
    private let launchAtLoginRepository: LR

    init(_ launchAtLoginRepository: LaunchAtLoginRepository) {
        self.launchAtLoginRepository = launchAtLoginRepository as! LR
        launchAtLogin = launchAtLoginRepository.current
    }

    func openSystemPreferences() {
        let path = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        NSWorkspace.shared.open(URL(string: path)!)
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class GeneralSettingsViewModelMock: GeneralSettingsViewModel {
        @Published var launchAtLogin: Bool = false

        init(_ launchAtLoginRepository: LaunchAtLoginRepository) {}
        init() {}

        func openSystemPreferences() {}
    }
}
