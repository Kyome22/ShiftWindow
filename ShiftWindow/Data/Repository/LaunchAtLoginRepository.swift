/*
 LaunchAtLoginRepository.swift
 ShiftWindow

 Created by Takuto Nakamura on 2023/01/24.
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

import Foundation
import ServiceManagement

protocol LaunchAtLoginRepository: AnyObject {
    var current: Bool { get }

    func switchRegistration(_ newValue: Bool, failureHandler: @escaping () -> Void)
}

final class LaunchAtLoginRepositoryImpl: LaunchAtLoginRepository {
    var current: Bool {
        if #available(macOS 13, *) {
            return SMAppService.mainApp.status == .enabled
        }
        return false
    }

    func switchRegistration(_ newValue: Bool, failureHandler: @escaping () -> Void) {
        guard #available(macOS 13, *) else { return }
        do {
            if newValue {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            logput(error.localizedDescription)
        }
        if current != newValue {
            failureHandler()
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class LaunchAtLoginRepositoryMock: LaunchAtLoginRepository {
        var current: Bool = false
        func switchRegistration(_ newValue: Bool, failureHandler: @escaping () -> Void) {}
    }
}
