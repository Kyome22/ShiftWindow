/*
 AppDelegate.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.

*/

import AppKit
import DataLayer

public final class AppDelegate: NSObject, NSApplicationDelegate {
    public let appDependency: AppDependency

    public override init() {
        appDependency = .init(
            needsResetUserDefaults: ProcessInfo.needsResetUserDefaults
        )
        super.init()
    }

    public func applicationDidFinishLaunching(_ notification: Notification) {
        Task {
            await appDependency.logService.bootstrap()
            appDependency.logService.notice(.launchApp)
            await appDependency.shortcutService.initializeShortcuts()
        }
        let unmanagedKey = appDependency.hiServicesClient.trustedCheckOptionPrompt()
        let options = [unmanagedKey.takeRetainedValue(): true] as CFDictionary
        _ = appDependency.hiServicesClient.isProcessTrusted(options)
    }

    public func applicationWillTerminate(_ notification: Notification) {
        let executeClient = appDependency.executeClient
        Task.detached(priority: .background) {
            if try executeClient.checkIconsVisible() {
                try executeClient.toggleIconsVisible(false)
            }
        }
    }
}
