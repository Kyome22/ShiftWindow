//
//  AppDelegate.swift
//  ShiftWindowLauncher
//
//  Created by Takuto Nakamura on 2021/08/01.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainAppId = "com.kyome.ShiftWindow"
        let isRunning = NSWorkspace.shared.runningApplications.contains { app in
            app.bundleIdentifier == mainAppId
        }
        if isRunning {
            NSApp.terminate(nil)
        } else {
            if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: mainAppId) {
                let config = NSWorkspace.OpenConfiguration()
                NSWorkspace.shared.openApplication(at: url, configuration: config) { _, _ in
                    NSApp.terminate(nil)
                }
            }
        }
    }

}

