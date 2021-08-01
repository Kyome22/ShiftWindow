//
//  Extensions.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/07/31.
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
