/*
  AppKit+Extensions.swift
  ShiftWindow

  Created by Takuto Nakamura on 2022/06/27.
  Copyright 2022 Takuto Nakamura (Kyome22)

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/

import AppKit

extension NSStatusItem {
    static var `default`: NSStatusItem {
        return NSStatusBar.system.statusItem(withLength: Self.variableLength)
    }
}

extension NSMenu {
    func addItem(title: String, action: Selector, target: AnyObject) {
        self.addItem(NSMenuItem(title: title, action: action, target: target))
    }

    func addSeparator() {
        self.addItem(NSMenuItem.separator())
    }
}

extension NSMenuItem {
    convenience init(title: String, action: Selector, target: AnyObject) {
        self.init(title: title, action: action, keyEquivalent: "")
        self.target = target
    }

    func setValues(title: String, action: Selector, target: AnyObject) {
        self.title = title
        self.action = action
        self.target = target
    }
}

extension NSScreen {
    var displayID: CGDirectDisplayID {
        let key = NSDeviceDescriptionKey("NSScreenNumber")
        return self.deviceDescription[key] as! CGDirectDisplayID
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
