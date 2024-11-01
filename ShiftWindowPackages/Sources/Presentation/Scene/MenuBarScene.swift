/*
 MenuBarScene.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import Domain
import SwiftUI

public struct MenuBarScene: Scene {
    @Environment(\.appDependency) private var appDependency

    public init() {}

    public var body: some Scene {
        MenuBarExtra {
            MenuView(
                executeClient: appDependency.executeClient,
                nsAppClient: appDependency.nsAppClient,
                logService: appDependency.logService,
                shiftService: appDependency.shiftService,
                shortcutService: appDependency.shortcutService
            )
            .environment(\.displayScale, 2.0)
        } label: {
            Image(.statusIcon)
                .environment(\.displayScale, 2.0)
        }
    }
}
