//
//  AppKit+Extensions.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2022/06/27.
//

import AppKit

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
}

extension NSScreen {
    var displayID: CGDirectDisplayID {
        let key = NSDeviceDescriptionKey("NSScreenNumber")
        return self.deviceDescription[key] as! CGDirectDisplayID
    }
}
