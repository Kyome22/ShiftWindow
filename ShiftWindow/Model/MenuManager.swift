//
//  MenuManager.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/07/31.
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
