/*
 AppDelegate.swift
 Model

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
import Infrastructure

public final class AppDelegate: NSObject, NSApplicationDelegate {
    public let appDependencies = AppDependenciesKey.defaultValue

    public func applicationDidFinishLaunching(_ notification: Notification) {
        let userDefaultsRepository = UserDefaultsRepository(appDependencies.userDefaultsClient)
        appDependencies.appStateClient.withLock {
            $0.shiftPatternsSubject.send(userDefaultsRepository.shiftPatterns)
        }

        let logService = LogService(appDependencies)
        logService.bootstrap()
        logService.notice(.launchApp)

        let shortcutService = ShortcutService(appDependencies)
        shortcutService.initializeShortcuts()

        let shiftService = ShiftService(appDependencies)
        Task {
            let values = appDependencies.appStateClient.withLock(\.shiftTypeSubject.values)
            for await value in values {
                await shiftService.shiftWindow(shiftType: value)
            }
        }

        let unmanagedKey = appDependencies.hiServicesClient.trustedCheckOptionPrompt()
        let options = [unmanagedKey.takeRetainedValue(): true] as CFDictionary
        _ = appDependencies.hiServicesClient.isProcessTrusted(options)
    }

    public func applicationWillTerminate(_ notification: Notification) {
        if (try? appDependencies.executeClient.checkIconsVisible()) == true {
            try? appDependencies.executeClient.toggleIconsVisible(false)
        }
    }
}
