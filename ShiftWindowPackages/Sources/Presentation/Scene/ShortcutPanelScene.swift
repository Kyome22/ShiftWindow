/*
 ShortcutPanelScene.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/02.
 
*/

import DataLayer
import Domain
import PanelSceneKit
import SwiftUI

public struct ShortcutPanelScene: Scene {
    @Binding var isPresented: Bool

    public init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
    }

    public var body: some Scene {
        PanelScene(isPresented: $isPresented, type: ShortcutPanel.self) { userInfo in
            let keyEquivalent = (userInfo?[String.keyEquivalent] as? String) ?? ""
            ShortcutView(keyEquivalent: keyEquivalent)
        }
    }
}
