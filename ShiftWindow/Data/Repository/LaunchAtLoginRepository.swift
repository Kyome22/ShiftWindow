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

enum LaunchAtLoginError: Error {
    case switchFailed(Bool)
}

protocol LaunchAtLoginRepository: AnyObject {
    var currentStatus: Bool { get }

    init()

    func switchStatus(_ newValue: Bool) -> Result<Void, LaunchAtLoginError>
}

final class LaunchAtLoginRepositoryImpl: LaunchAtLoginRepository {
    var currentStatus: Bool {
        SMAppService.mainApp.status == .enabled
    }

    func switchStatus(_ newValue: Bool) -> Result<Void, LaunchAtLoginError> {
        do {
            if newValue {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            logput(error.localizedDescription)
        }
        let value = currentStatus
        return if value != newValue {
            .failure(.switchFailed(value))
        } else {
            .success(())
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class LaunchAtLoginRepositoryMock: LaunchAtLoginRepository {
        let currentStatus: Bool = false
        func switchStatus(_ newValue: Bool) -> Result<Void, LaunchAtLoginError> {
            .success(())
        }
    }
}
