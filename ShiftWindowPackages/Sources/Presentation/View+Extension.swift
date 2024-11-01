/*
 SwiftUIView.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import SwiftUI

extension View {
    @ViewBuilder
    func keyboardShortcutIfPossible(_ key: KeyEquivalent?, modifiers: EventModifiers?) -> some View {
        if let key, let modifiers {
            keyboardShortcut(key, modifiers: modifiers)
        } else {
            self
        }
    }
}
