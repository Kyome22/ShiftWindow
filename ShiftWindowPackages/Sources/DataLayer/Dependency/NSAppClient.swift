/*
 NSAppClient.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import AppKit

public struct NSAppClient: DependencyClient {
    public var mainMenu: @MainActor @Sendable () -> NSMenu?
    public var activate: @MainActor @Sendable (Bool) -> Void
    public var terminate: @MainActor @Sendable (Any?) -> Void
    public var orderFrontStandardAboutPanel: @MainActor @Sendable (Any?) -> Void

    public static let liveValue = Self(
        mainMenu: { NSApp.mainMenu },
        activate: { NSApp.activate(ignoringOtherApps: $0) },
        terminate: { NSApp.terminate($0) },
        orderFrontStandardAboutPanel: { NSApp.orderFrontStandardAboutPanel($0) }
    )

    public static let testValue = Self(
        mainMenu: { nil },
        activate: { _ in },
        terminate: { _ in },
        orderFrontStandardAboutPanel: { _ in }
    )
}
