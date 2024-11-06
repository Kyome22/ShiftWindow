/*
 AppDependency.swift
 Domain

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
import Observation
import SwiftUI

public final class AppDependency: Sendable {
    public let executeClient: ExecuteClient
    public let hiServicesClient: HIServicesClient
    public let nsAppClient: NSAppClient
    public let nsWorkspaceClient: NSWorkspaceClient
    public let userDefaultsRepository: UserDefaultsRepository
    public let launchAtLoginRepository: LaunchAtLoginRepository
    public let logService: LogService
    public let shiftService: ShiftService
    public let shortcutService: ShortcutService

    public nonisolated init(
        executeClient: ExecuteClient = .liveValue,
        hiServicesClient: HIServicesClient = .liveValue,
        loggingSystemClient: LoggingSystemClient = .liveValue,
        nsAppClient: NSAppClient = .liveValue,
        nsScreenClient: NSScreenClient = .liveValue,
        nsWorkspaceClient: NSWorkspaceClient = .liveValue,
        smAppServiceClient: SMAppServiceClient = .liveValue,
        userDefaultsClient: UserDefaultsClient = .liveValue,
        needsResetUserDefaults: Bool = false
    ) {
        self.executeClient = executeClient
        self.hiServicesClient = hiServicesClient
        self.nsAppClient = nsAppClient
        self.nsWorkspaceClient = nsWorkspaceClient
        userDefaultsRepository = .init(userDefaultsClient, reset: needsResetUserDefaults)
        launchAtLoginRepository = .init(smAppServiceClient)
        logService = .init(loggingSystemClient)
        shiftService = .init(hiServicesClient, nsAppClient, nsScreenClient, nsWorkspaceClient)
        shortcutService = .init(userDefaultsRepository, shiftService)
    }
}

struct AppDependencyKey: EnvironmentKey {
    static let defaultValue = AppDependency(
        executeClient: .testValue,
        hiServicesClient: .testValue,
        loggingSystemClient: .testValue,
        nsAppClient: .testValue,
        nsScreenClient: .testValue,
        nsWorkspaceClient: .testValue,
        smAppServiceClient: .testValue,
        userDefaultsClient: .testValue
    )
}

public extension EnvironmentValues {
    var appDependency: AppDependency {
        get { self[AppDependencyKey.self] }
        set { self[AppDependencyKey.self] = newValue }
    }
}
