/*
 NSScreenClient.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import AppKit

public struct NSScreenClient: DependencyClient {
    public var mainScreen: @Sendable () -> NSScreen?

    public static let liveValue = Self(
        mainScreen: { NSScreen.main }
    )

    public static let testValue = Self(
        mainScreen: { nil }
    )
}
