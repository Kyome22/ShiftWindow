/*
 SettingsWindowScene.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import SwiftUI

public struct SettingsWindowScene: Scene {
    public init () {}

    public var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}
