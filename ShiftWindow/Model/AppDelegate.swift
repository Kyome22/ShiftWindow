//
//  AppDelegate.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/07/26.
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
import SpiceKey

final class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    private var shortcutPanel: ShortcutPanel?
    private var menuManager: MenuManager!
    private var shiftManager: ShiftManager!
    private(set) var patterns = [ShiftPattern]()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.menuManager = MenuManager()
        self.shiftManager = ShiftManager()
        self.patterns = DataManager.shared.patterns
        self.menuManager.updateMenuItems(self.patterns)
        self.initShortcuts()
        DataManager.shared.checkPermissionAllowed()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        DataManager.shared.patterns = self.patterns
        if self.menuManager.isHiddenIcons {
            self.toggleIconsVisible(flag: false)
        }
    }
    
    @objc func openPreferences(_ sender: Any?) {
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        NSApp.windows.forEach { window in
            if window.canBecomeMain {
                window.orderFrontRegardless()
                window.center()
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
    
    @objc func openAbout(_ sender: Any?) {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(nil)
    }
    
    @objc func shiftWindow(_ sender: ShiftMenuItem) {
        self.shiftManager.shiftWindow(type: sender.pattern.type)
    }
    
    @objc func hideDesktopIcons(_ sender: NSMenuItem) {
        let flag = !sender.state.isOn
        self.toggleIconsVisible(flag: flag)
        sender.state = flag.state
    }
    
    private func toggleIconsVisible(flag: Bool) {
        let args = flag
            ? "defaults write com.apple.finder CreateDesktop -bool FALSE; killall Finder"
            : "defaults delete com.apple.finder CreateDesktop; killall Finder"
        let shell = Process()
        shell.launchPath = "/bin/sh"
        shell.arguments = ["-c", args]
        shell.launch()
        shell.waitUntilExit()
    }
    
    private func showShortcutPanel(keyEquivalent: String) {
        if DataManager.shared.showShortcutPanel {
            if shortcutPanel != nil { return }
            shortcutPanel = ShortcutPanel(keyEquivalent: keyEquivalent)
            shortcutPanel?.delegate = self
            shortcutPanel?.orderFrontRegardless()
        }
    }
    
    // MARK: Keyboard Shortcuts
    private func initShortcuts() {
        self.patterns.forEach { pattern in
            guard let keyCombo = pattern.spiceKeyData?.keyCombination else { return }
            let spiceKey = SpiceKey(keyCombo) { [weak self] in
                self?.showShortcutPanel(keyEquivalent: keyCombo.string)
                self?.shiftManager.shiftWindow(type: pattern.type)
            } keyUpHandler: { [weak self] in
                self?.shortcutPanel?.fadeOut()
            }
            spiceKey.register()
            pattern.spiceKeyData?.spiceKey = spiceKey
        }
    }
    
    func updateShortcut(id: String, keyCombo: KeyCombination) {
        if let pattern = self.patterns.first(where: { $0.type.id == id }) {
            let spiceKey = SpiceKey(keyCombo) { [weak self] in
                self?.showShortcutPanel(keyEquivalent: keyCombo.string)
                self?.shiftManager.shiftWindow(type: pattern.type)
            } keyUpHandler: { [weak self] in
                self?.shortcutPanel?.fadeOut()
            }
            spiceKey.register()
            pattern.spiceKeyData = SpiceKeyData(id, keyCombo.key, keyCombo.modifierFlags, spiceKey)
            self.menuManager.updateMenuItems(self.patterns)
            DataManager.shared.patterns = self.patterns
        }
    }
    
    func removeShortcut(id: String) {
        if let pattern = self.patterns.first(where: { $0.type.id == id }) {
            pattern.spiceKeyData?.spiceKey?.unregister()
            pattern.spiceKeyData = nil
            self.menuManager.updateMenuItems(self.patterns)
            DataManager.shared.patterns = self.patterns
        }
    }
}

extension AppDelegate: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        if window === self.shortcutPanel {
            self.shortcutPanel = nil
        }
    }
}
