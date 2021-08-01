//
//  Extensions.swift
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

import Cocoa

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}

extension NSStatusItem {
    static var `default`: NSStatusItem {
        return NSStatusBar.system.statusItem(withLength: Self.variableLength)
    }
}

extension NSMenuItem {
    convenience init(title: String, action: Selector) {
        self.init(title: title, action: action, keyEquivalent: "")
    }
}

extension Bool {
    var state: NSControl.StateValue {
        return self ? .on : .off
    }
}

extension NSControl.StateValue {
    var isOn: Bool {
        return self == .on
    }
}

extension NSImage {
    static let statusIcon = NSImage(imageLiteralResourceName: "StatusIcon")
    
    static let windowTopHalf = NSImage(imageLiteralResourceName: "WindowTopHalf")
    static let windowBottomHalf = NSImage(imageLiteralResourceName: "WindowBottomHalf")
    static let windowLeftHalf = NSImage(imageLiteralResourceName: "WindowLeftHalf")
    static let windowRightHalf = NSImage(imageLiteralResourceName: "WindowRightHalf")
    
    static let windowLeftThird = NSImage(imageLiteralResourceName: "WindowLeftThird")
    static let windowLeftTwoThirds = NSImage(imageLiteralResourceName: "WindowLeftTwoThirds")
    static let windowMiddleThird = NSImage(imageLiteralResourceName: "WindowMiddleThird")
    static let windowRightTwoThirds = NSImage(imageLiteralResourceName: "WindowRightTwoThirds")
    static let windowRightThird = NSImage(imageLiteralResourceName: "WindowRightThird")
    
    static let windowMaximize = NSImage(imageLiteralResourceName: "WindowMaximize")
}

extension CGFloat {
    var half: CGFloat {
        return CGFloat(Double(self / 2.0).rounded())
    }
    
    var third: CGFloat {
        return CGFloat(Double(self / 3.0).rounded())
    }
    
    var twoThirds: CGFloat {
        return 2.0 * CGFloat(Double(self / 3.0).rounded())
    }
}
