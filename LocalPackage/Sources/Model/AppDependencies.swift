/*
 AppDependencies.swift
 Model

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

import DataSource
import SwiftUI

public struct AppDependencies: Sendable {
    public var appStateClient = AppStateClient.liveValue
    public var cgDirectDisplayClient = CGDirectDisplayClient.liveValue
    public var executeClient = ExecuteClient.liveValue
    public var hiServicesClient = HIServicesClient.liveValue
    public var loggingSystemClient = LoggingSystemClient.liveValue
    public var nsAppClient = NSAppClient.liveValue
    public var nsScreenClient = NSScreenClient.liveValue
    public var nsWorkspaceClient = NSWorkspaceClient.liveValue
    public var smAppServiceClient = SMAppServiceClient.liveValue
    public var spiceKeyClient = SpiceKeyClient.liveValue
    public var spuUpdaterClient = SPUUpdaterClient.liveValue
    public var userDefaultsClient = UserDefaultsClient.liveValue
    public var windowSceneMessengerClient = WindowSceneMessengerClient.liveValue

    static let shared = AppDependencies()
}

extension EnvironmentValues {
    @Entry public var appDependencies = AppDependencies.shared
}

extension AppDependencies {
    public static func testDependencies(
        appStateClient: AppStateClient = .testValue,
        cgDirectDisplayClient: CGDirectDisplayClient = .testValue,
        executeClient: ExecuteClient = .testValue,
        hiServicesClient: HIServicesClient = .testValue,
        loggingSystemClient: LoggingSystemClient = .testValue,
        nsAppClient: NSAppClient = .testValue,
        nsScreenClient: NSScreenClient = .testValue,
        nsWorkspaceClient: NSWorkspaceClient = .testValue,
        smAppServiceClient: SMAppServiceClient = .testValue,
        spiceKeyClient: SpiceKeyClient = .testValue,
        spuUpdaterClient: SPUUpdaterClient = .testValue,
        userDefaultsClient: UserDefaultsClient = .testValue,
        windowSceneMessengerClient: WindowSceneMessengerClient = .testValue
    ) -> AppDependencies {
        AppDependencies(
            appStateClient: appStateClient,
            cgDirectDisplayClient: cgDirectDisplayClient,
            executeClient: executeClient,
            hiServicesClient: hiServicesClient,
            loggingSystemClient: loggingSystemClient,
            nsAppClient: nsAppClient,
            nsScreenClient: nsScreenClient,
            nsWorkspaceClient: nsWorkspaceClient,
            smAppServiceClient: smAppServiceClient,
            spiceKeyClient: spiceKeyClient,
            spuUpdaterClient: spuUpdaterClient,
            userDefaultsClient: userDefaultsClient,
            windowSceneMessengerClient: windowSceneMessengerClient
        )
    }
}
