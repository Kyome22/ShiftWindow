/*
 AppDependency.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
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
