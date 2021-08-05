//
//  AppDelegate.swift
//  ShiftWindowLauncher
//
//  Created by Takuto Nakamura on 2021/08/01.
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

