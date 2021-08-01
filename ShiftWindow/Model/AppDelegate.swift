//
//  AppDelegate.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/07/26.
//

import Cocoa
import SpiceKey

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var preferencesWC: NSWindowController?
    private var menuManager: MenuManager!
    private var shiftManager: ShiftManager!
    private(set) var patterns = [ShiftPattern]()
    
    class var shared: AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
    
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
    }
    
    @IBAction func openPreferences(_ sender: Any?) {
        if self.preferencesWC == nil {
            let sb = NSStoryboard(name: "PreferencesTab", bundle: nil)
            let wc = (sb.instantiateInitialController() as! NSWindowController)
            wc.window?.delegate = self
            wc.window?.isMovableByWindowBackground = true
            self.preferencesWC = wc
        }
        NSApp.activate(ignoringOtherApps: true)
        self.preferencesWC?.showWindow(nil)
    }
    
    @IBAction func openAbout(_ sender: Any?) {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(nil)
    }
    
    @IBAction func shiftWindow(_ sender: ShiftMenuItem) {
        self.shiftManager.shiftWindow(type: sender.pattern.type)
    }
    
    // MARK: Keyboard Shortcuts
    private func initShortcuts() {
        self.patterns.forEach { pattern in
            guard let keyCombo = pattern.spiceKeyData?.keyCombination else { return }
            let spiceKey = SpiceKey(keyCombo, keyDownHandler: { [weak self] in
                self?.shiftManager.shiftWindow(type: pattern.type)
            })
            spiceKey.register()
            pattern.spiceKeyData?.spiceKey = spiceKey
        }
    }
    
    func updateShortcut(id: String, key: Key, flags: ModifierFlags) {
        if let pattern = self.patterns.first(where: { $0.type.id == id }) {
            let keyCombo = KeyCombination(key, flags)
            let spiceKey = SpiceKey(keyCombo, keyDownHandler: { [weak self] in
                self?.shiftManager.shiftWindow(type: pattern.type)
            })
            spiceKey.register()
            pattern.spiceKeyData = SpiceKeyData(id, key, flags, spiceKey)
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
        if window === self.preferencesWC?.window {
            self.preferencesWC = nil
        }
    }
    
}
