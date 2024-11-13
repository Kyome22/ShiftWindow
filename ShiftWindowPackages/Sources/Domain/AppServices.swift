/*
 AppServices.swift
 Domain

 Created by Takuto Nakamura on 2024/11/14.
 
*/

import DataLayer
import Observation
import SwiftUI

public final class AppServices: Sendable {
    public let logService: LogService
    public let shiftService: ShiftService
    public let shortcutService: ShortcutService
    public let updateService: UpdateService

    public nonisolated init(appDependencies: AppDependencies) {
        logService = .init(appDependencies.loggingSystemClient)
        shiftService = .init(appDependencies.cgDirectDisplayClient,
                             appDependencies.hiServicesClient,
                             appDependencies.nsAppClient,
                             appDependencies.nsScreenClient,
                             appDependencies.nsWorkspaceClient)
        shortcutService = .init(appDependencies.panelSceneMessengerClient,
                                appDependencies.spiceKeyClient,
                                appDependencies.userDefaultsClient)
        updateService = .init(appDependencies.spuUpdaterClient)
    }
}

struct AppServicesKey: EnvironmentKey {
    static let defaultValue = AppServices(appDependencies: AppDependenciesKey.defaultValue)
}

public extension EnvironmentValues {
    var appServices: AppServices {
        get { self[AppServicesKey.self] }
        set { self[AppServicesKey.self] = newValue }
    }
}
