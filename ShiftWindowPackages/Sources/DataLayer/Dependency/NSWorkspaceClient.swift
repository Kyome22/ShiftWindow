/*
 NSWorkspaceClient.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import AppKit

public struct NSWorkspaceClient: DependencyClient {
    public var runningApplications: @Sendable () -> [NSRunningApplication]
    public var open: @Sendable (URL) -> Bool

    public static let liveValue = Self(
        runningApplications: { NSWorkspace.shared.runningApplications },
        open: { NSWorkspace.shared.open($0) }
    )

    public static let testValue = Self(
        runningApplications: { [] },
        open: { _ in false }
    )
}
