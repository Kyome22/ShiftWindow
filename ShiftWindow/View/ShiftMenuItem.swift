//
//  ShiftMenuItem.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/07/31.
//
//  Copyright 2021 Takuto Nakamura (Kyome22)
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import AppKit

final class ShiftMenuItem: NSMenuItem {
    var pattern: ShiftPattern

    init(pattern: ShiftPattern, action: Selector, target: AnyObject?) {
        self.pattern = pattern
        super.init(title: pattern.title, action: action, keyEquivalent: "")
        self.target = target
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

    func update(_ pattern: ShiftPattern) {
        self.pattern = pattern
        if let keyString = pattern.keyString,
           let modifierMask = pattern.modifierMask {
            self.keyEquivalent = keyString
            self.keyEquivalentModifierMask = modifierMask
        } else {
            self.keyEquivalent = ""
            self.keyEquivalentModifierMask = []
        }
    }
}
