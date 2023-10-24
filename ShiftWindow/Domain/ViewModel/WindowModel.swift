/*
  WindowModel.swift
  ShiftWindow

  Created by Takuto Nakamura on 2023/01/28.
  Copyright 2021 Takuto Nakamura (Kyome22)

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
import Combine

protocol WindowModel: AnyObject {
    func openSettings()
    func openAbout()
}

final class WindowModelImpl<UR: UserDefaultsRepository,
                            SCM: ShortcutModel>: NSObject, WindowModel, NSWindowDelegate {
    private let userDefaultsRepository: UR
    private let shortcutModel: SCM
    private var shortcutPanel: ShortcutPanel?
    private var cancellables = Set<AnyCancellable>()

    private var settingsWindow: NSWindow? {
        return NSApp.windows.first(where: { window in
            window.frameAutosaveName == "com_apple_SwiftUI_Settings_window"
        })
    }

    init(_ userDefaultsRepository: UR, _ shortcutModel: SCM) {
        self.userDefaultsRepository = userDefaultsRepository
        self.shortcutModel = shortcutModel
        super.init()

        shortcutModel.showPanelPublisher
            .sink { [weak self] keyEquivalent in
                self?.showShortcutPanel(keyEquivalent: keyEquivalent)
            }
            .store(in: &cancellables)
        shortcutModel.fadeOutPanelPublisher
            .sink { [weak self] in
                self?.shortcutPanel?.fadeOut()
            }
            .store(in: &cancellables)
    }

    func openSettings() {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        guard let window = settingsWindow else { return }
        if window.canBecomeMain {
            window.center()
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    func openAbout() {
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

    // MARK: NSWindowDelegate
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        if window === shortcutPanel {
            shortcutPanel = nil
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class WindowModelMock: WindowModel {
        func openSettings() {}
        func openAbout() {}
    }
}
