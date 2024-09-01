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

@MainActor protocol WindowModel: AnyObject, Sendable {
    init(_ userDefaultsRepository: UserDefaultsRepository,
         _ shortcutModel: ShortcutModel)

    func openAbout()
}

final class WindowModelImpl: NSObject, WindowModel, NSWindowDelegate {
    private let userDefaultsRepository: UserDefaultsRepository
    private let shortcutModel: ShortcutModel
    private var shortcutPanel: ShortcutPanel?
    private var task: Task<Void, Never>?

    nonisolated init(
        _ userDefaultsRepository: UserDefaultsRepository,
        _ shortcutModel: ShortcutModel
    ) {
        self.userDefaultsRepository = userDefaultsRepository
        self.shortcutModel = shortcutModel
        super.init()

        task = Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { @MainActor in
                    for await keyEquivalent in shortcutModel.showPanelChannel {
                        self.showShortcutPanel(keyEquivalent: keyEquivalent)
                    }
                }
                group.addTask { @MainActor in
                    for await _ in shortcutModel.fadeOutPanelChannel {
                        self.shortcutPanel?.fadeOut()
                    }
                }
            }
        }
    }

    deinit {
        task?.cancel()
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
        init(_ userDefaultsRepository: UserDefaultsRepository, 
             _ shortcutModel: ShortcutModel) {}
        init() {}

        func openAbout() {}
    }
}
