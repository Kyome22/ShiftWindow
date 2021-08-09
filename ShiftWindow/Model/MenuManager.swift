//
//  MenuManager.swift
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

class MenuManager {
    
    private let statusItem = NSStatusItem.default
    private let menu = NSMenu()
    
    init() {
        if let button = self.statusItem.button {
            button.image = NSImage.statusIcon
        }
        self.statusItem.menu = self.menu
    }
    
    func updateMenuItems(_ patterns: [ShiftPattern]) {
        // Reset MenuItems
        self.menu.removeAllItems()
        
        // Add ShiftMenuItems
        patterns.forEach { pattern in
            let item = ShiftMenuItem(
                pattern: pattern,
                action: #selector(AppDelegate.shiftWindow(_:))
            )
            self.menu.addItem(item)
            
            switch pattern.type {
            case .rightHalf, .rightThird, .maximize:
                self.menu.addItem(NSMenuItem.separator())
            default:
                break
            }
        }
        
        // Add Hide Desktop Icons
        let toggleItem = NSMenuItem(
            title: "hideDesktopIcons".localized,
            action: #selector(AppDelegate.hideDesktopIcons(_:))
        )
        self.menu.addItem(toggleItem)
        self.menu.addItem(NSMenuItem.separator())
        
        // Add General Items
        let preferencesItem = NSMenuItem(
            title: "preferences".localized,
            action: #selector(AppDelegate.openPreferences(_:))
        )
        self.menu.addItem(preferencesItem)
        self.menu.addItem(NSMenuItem.separator())
        
        let aboutItem = NSMenuItem(
            title: "aboutApp".localized,
            action: #selector(AppDelegate.openAbout(_:))
        )
        self.menu.addItem(aboutItem)
        
        let terminateItem = NSMenuItem(
            title: "terminateApp".localized,
            action: #selector(NSApp.terminate(_:))
        )
        self.menu.addItem(terminateItem)
    }
 
}
