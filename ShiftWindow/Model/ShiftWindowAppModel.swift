//
//  ShiftWindowAppModel.swift
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
import SpiceKey

protocol ShiftWindowAppModel: ObservableObject {
    associatedtype UR: UserDefaultsRepository
    associatedtype LR: LaunchAtLoginRepository
    associatedtype SM: ShortcutManager

    var settingsTab: SettingsTabType { get set }
    var userDefaultsRepository: UR { get }
    var launchAtLoginRepository: LR { get }
    var shortcutManager: SM { get }
}

final class ShiftWindowAppModelImpl: NSObject, ShiftWindowAppModel {
    typealias UR = UserDefaultsRepositoryImpl
    typealias LR = LaunchAtLoginRepositoryImpl
    typealias SM = ShortcutManagerImpl

    @Published var settingsTab: SettingsTabType = .general

    let userDefaultsRepository: UR
    let launchAtLoginRepository: LR
    let shortcutManager: SM<UR>
    private let menuBarModel: MenuBarModelImpl<UR>
    private let shiftManager: ShiftManagerImpl

    private var menuBar: MenuBar<MenuBarModelImpl<UR>>?
    private var shortcutPanel: ShortcutPanel?
    private var cancellables = Set<AnyCancellable>()

    private var settingsWindow: NSWindow? {
        return NSApp.windows.first(where: { window in
            window.frameAutosaveName == "com_apple_SwiftUI_Settings_window"
        })
    }

    override init() {
        userDefaultsRepository = UR()
        launchAtLoginRepository = LR()
        shortcutManager = SM(userDefaultsRepository)
        menuBarModel = MenuBarModelImpl(userDefaultsRepository)
        shiftManager = ShiftManagerImpl()
        super.init()

        NotificationCenter.default.publisher(for: NSApplication.didFinishLaunchingNotification)
            .sink { [weak self] _ in
                self?.applicationDidFinishLaunching()
            }
            .store(in: &cancellables)
        NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)
            .sink { [weak self] _ in
                self?.applicationWillTerminate()
            }
            .store(in: &cancellables)
    }

    private func applicationDidFinishLaunching() {
        menuBar = MenuBar(menuBarModel: menuBarModel)
        shortcutManager.shiftWindowPublisher
            .sink { [weak self] (shiftType, keyEquivalent) in
                self?.showShortcutPanel(keyEquivalent: keyEquivalent)
                self?.shiftManager.shiftWindow(shiftType: shiftType)
            }
            .store(in: &cancellables)
        shortcutManager.fadeOutPanelSubjectPublisher
            .sink { [weak self] in
                self?.shortcutPanel?.fadeOut()
            }
            .store(in: &cancellables)
        shortcutManager.updatePatternsPublisher
            .sink { [weak self] in
                self?.menuBarModel.updateMenuItemsHandler?()
            }
            .store(in: &cancellables)

        menuBarModel.shiftWindowPublisher
            .sink { [weak self] shiftType in
                self?.shiftManager.shiftWindow(shiftType: shiftType)
            }
            .store(in: &cancellables)
        menuBarModel.toggleIconsVisiblePublisher
            .sink { [weak self] flag in
                self?.toggleIconsVisible(flag: flag)
            }
            .store(in: &cancellables)
        menuBarModel.openWindowPublisher
            .sink { [weak self] windowType in
                switch windowType {
                case .preferences:
                    self?.openPreferences()
                case .about:
                    self?.openAbout()
                }
            }
            .store(in: &cancellables)

        shortcutManager.initializeShortcuts()
        checkPermissionAllowed()
    }

    private func applicationWillTerminate() {
        if menuBarModel.currentToggleStateHandler?() == true {
            toggleIconsVisible(flag: false)
        }
    }

    @discardableResult
    private func checkPermissionAllowed() -> Bool {
        let key = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
        let options: NSDictionary = [key: true]
        return AXIsProcessTrustedWithOptions(options)
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

    private func openPreferences() {
        if #available(macOS 13, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
        guard let window = settingsWindow else { return }
        if window.canBecomeMain {
            window.center()
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    private func openAbout() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(nil)
    }

    private func showShortcutPanel(keyEquivalent: String) {
        if userDefaultsRepository.showShortcutPanel {
            guard shortcutPanel == nil else { return }
            shortcutPanel = ShortcutPanel(keyEquivalent: keyEquivalent)
            shortcutPanel?.delegate = self
            shortcutPanel?.orderFrontRegardless()
        }
    }
}

extension ShiftWindowAppModelImpl: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        if window === shortcutPanel {
            shortcutPanel = nil
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class ShiftWindowAppModelMock: ShiftWindowAppModel {
        typealias UR = UserDefaultsRepositoryMock
        typealias LR = LaunchAtLoginRepositoryMock
        typealias SM = ShortcutManagerMock

        var settingsTab: SettingsTabType = .general
        var userDefaultsRepository = UR()
        var launchAtLoginRepository = LR()
        var shortcutManager = SM()
    }
}
