/*
 AppDelegate.swift
 Domain

 Created by Takuto Nakamura on 2024/11/01.
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
import DataLayer

public final class AppDelegate: NSObject, NSApplicationDelegate {
    public let appDependencies = AppDependencies()
    public let appServices: AppServices

    public override init() {
        appServices = .init(appDependencies: appDependencies)
        super.init()
    }

    public func applicationDidFinishLaunching(_ notification: Notification) {
        Task {
            await appServices.logService.bootstrap()
            appServices.logService.notice(.launchApp)
            await appServices.shortcutService.initializeShortcuts()
        }
        Task {
            for await shiftType in await appServices.shortcutService.shiftTypeStream() {
                await appServices.shiftService.shiftWindow(shiftType: shiftType)
            }
        }
        let unmanagedKey = appDependencies.hiServicesClient.trustedCheckOptionPrompt()
        let options = [unmanagedKey.takeRetainedValue(): true] as CFDictionary
        _ = appDependencies.hiServicesClient.isProcessTrusted(options)
    }

    public func applicationWillTerminate(_ notification: Notification) {
        let executeClient = appDependencies.executeClient
        Task.detached(priority: .background) {
            if try executeClient.checkIconsVisible() {
                try executeClient.toggleIconsVisible(false)
            }
        }
    }
}
