//
//  MenuBar.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2023/01/24.
//
//  Copyright 2023 Takuto Nakamura (Kyome22)
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
import Combine

final class MenuBar<MM: MenuBarModel>: NSObject, NSMenuDelegate {
    private let statusItem = NSStatusItem.default
    private let menu = NSMenu()
    private let toggleItem = NSMenuItem()
    private let menuBarModel: MM

    init(menuBarModel: MM) {
        self.menuBarModel = menuBarModel
        super.init()

        menu.delegate = self
        menuBarModel.patterns.forEach { pattern in
            let item = ShiftMenuItem(pattern: pattern,
                                     action: #selector(shiftWindow(_:)),
                                     target: self)
            menu.addItem(item)
            switch pattern.shiftType {
            case .rightHalf, .rightThird, .maximize:
                menu.addSeparator()
            default:
                break
            }
        }
        toggleItem.setValues(title: "hideDesktopIcons".localized,
                             action: #selector(toggleIconsVisible(_:)),
                             target: self)
        menu.addItem(toggleItem)
        menu.addSeparator()
        menu.addItem(title: "preferences".localized,
                     action: #selector(openPreferences(_:)),
                     target: self)
        menu.addSeparator()
        menu.addItem(title: "aboutApp".localized,
                     action: #selector(openAbout(_:)),
                     target: self)
        menu.addItem(title: "terminateApp".localized,
                     action: #selector(terminateApp(_:)),
                     target: self)

        statusItem.button?.image = NSImage(named: "StatusIcon")
        statusItem.menu = menu

        menuBarModel.updateMenuItemsHandler = { [weak self] in
            self?.updateMenuItems()
        }
        menuBarModel.currentToggleStateHandler = { [weak self] in
            return self?.toggleItem.state.isOn ?? false
        }
    }

    @objc func shiftWindow(_ sender: ShiftMenuItem) {
        menuBarModel.shiftWindow(shiftType: sender.pattern.shiftType)
    }

    @objc func toggleIconsVisible(_ sender: NSMenuItem) {
        let flag = !sender.state.isOn
        menuBarModel.toggleIconsVisible(flag: flag)
        sender.state = flag.state
    }

    @objc func openPreferences(_ sender: Any?) {
        menuBarModel.openPreferences()
    }

    @objc func openAbout(_ sender: Any?) {
        menuBarModel.openAbout()
    }

    @objc func terminateApp(_ sender: Any?) {
        menuBarModel.terminateApp()
    }

    func updateMenuItems() {
        let items = menu.items.compactMap { $0 as? ShiftMenuItem }
        for (pattern, item) in zip(menuBarModel.patterns, items) {
            item.update(pattern)
        }
    }
}
