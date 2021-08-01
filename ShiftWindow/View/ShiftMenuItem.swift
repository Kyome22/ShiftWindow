//
//  ShiftMenuItem.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/07/31.
//

import Cocoa

class ShiftMenuItem: NSMenuItem {
    
    let pattern: ShiftPattern

    init(pattern: ShiftPattern, action: Selector) {
        self.pattern = pattern
        super.init(title: pattern.title, action: action, keyEquivalent: "")
        self.image = pattern.image
        if let keyString = pattern.keyString,
           let modifierMask = pattern.modifierMask {
            self.keyEquivalent = keyString
            self.keyEquivalentModifierMask = modifierMask
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
