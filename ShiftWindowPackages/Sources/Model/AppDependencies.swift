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

import Infrastructure
import SwiftUI

public final class AppDependencies: Sendable {
    public let appStateClient: AppStateClient
    public let cgDirectDisplayClient: CGDirectDisplayClient
    public let executeClient: ExecuteClient
    public let hiServicesClient: HIServicesClient
    public let loggingSystemClient: LoggingSystemClient
    public let nsAppClient: NSAppClient
    public let nsScreenClient: NSScreenClient
    public let nsWorkspaceClient: NSWorkspaceClient
    public let smAppServiceClient: SMAppServiceClient
    public let spiceKeyClient: SpiceKeyClient
    public let spuUpdaterClient: SPUUpdaterClient
    public let userDefaultsClient: UserDefaultsClient
    public let windowSceneMessengerClient: WindowSceneMessengerClient

    public nonisolated init(
        appStateClient: AppStateClient = .liveValue,
        cgDirectDisplayClient: CGDirectDisplayClient = .liveValue,
        executeClient: ExecuteClient = .liveValue,
        hiServicesClient: HIServicesClient = .liveValue,
        loggingSystemClient: LoggingSystemClient = .liveValue,
        nsAppClient: NSAppClient = .liveValue,
        nsScreenClient: NSScreenClient = .liveValue,
        nsWorkspaceClient: NSWorkspaceClient = .liveValue,
        smAppServiceClient: SMAppServiceClient = .liveValue,
        spiceKeyClient: SpiceKeyClient = .liveValue,
        spuUpdaterClient: SPUUpdaterClient = .liveValue,
        userDefaultsClient: UserDefaultsClient = .liveValue,
        windowSceneMessengerClient: WindowSceneMessengerClient = .liveValue
    ) {
        self.appStateClient = appStateClient
        self.cgDirectDisplayClient = cgDirectDisplayClient
        self.executeClient = executeClient
        self.hiServicesClient = hiServicesClient
        self.loggingSystemClient = loggingSystemClient
        self.nsAppClient = nsAppClient
        self.nsScreenClient = nsScreenClient
        self.nsWorkspaceClient = nsWorkspaceClient
        self.smAppServiceClient = smAppServiceClient
        self.spiceKeyClient = spiceKeyClient
        self.spuUpdaterClient = spuUpdaterClient
        self.userDefaultsClient = userDefaultsClient
        self.windowSceneMessengerClient = windowSceneMessengerClient
    }
}

struct AppDependenciesKey: EnvironmentKey {
    static let defaultValue = AppDependencies()
}

public extension EnvironmentValues {
    var appDependencies: AppDependencies {
        get { self[AppDependenciesKey.self] }
        set { self[AppDependenciesKey.self] = newValue }
    }
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
