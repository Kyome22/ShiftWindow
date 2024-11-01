/*
 SMAppServiceClient.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import ServiceManagement

public struct SMAppServiceClient: DependencyClient {
    var status: @Sendable () -> SMAppService.Status
    var register: @Sendable () throws -> Void
    var unregister: @Sendable () throws -> Void

    public static let liveValue = Self(
        status: { SMAppService.mainApp.status },
        register: { try SMAppService.mainApp.register() },
        unregister: { try SMAppService.mainApp.unregister() }
    )

    public static let testValue = Self(
        status: { .notFound },
        register: {},
        unregister: {}
    )
}
