/*
 MenuViewModel.swift
 ShiftWindow

 Created by Takuto Nakamura on 2023/10/24.
 Copyright 2023 Takuto Nakamura (Kyome22)

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
import SwiftUI
import Combine

protocol MenuViewModel: ObservableObject {
    var patterns: [ShiftPattern] { get set }
    var hideIcons: Bool { get set }

    init(_ shiftModel: ShiftModel,
         _ shortcutModel: ShortcutModel,
         _ windowModel: WindowModel)

    func shiftWindow(shiftType: ShiftType)
    func openSettings()
    func openAbout()
    func terminateApp()
}

final class MenuViewModelImpl<SM: ShiftModel,
                              SCM: ShortcutModel,
                              WM: WindowModel>: MenuViewModel {
    @Published var patterns = [ShiftPattern]()
    @Published var hideIcons: Bool = false

    private let shiftModel: SM
    private let windowModel: WM
    private var cancellables = Set<AnyCancellable>()

    init(
        _ shiftModel: ShiftModel,
        _ shortcutModel: ShortcutModel,
        _ windowModel: WindowModel
    ) {
        self.shiftModel = shiftModel as! SM
        self.windowModel = windowModel as! WM
        shortcutModel.patternsPublisher
            .sink { [weak self] patterns in
                self?.patterns = patterns
            }
            .store(in: &cancellables)

        _hideIcons.projectedValue
            .dropFirst()
            .sink { [weak self] value in
                self?.toggleIconsVisible(value)
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)
            .sink { [weak self] _ in
                if let self, hideIcons {
                    toggleIconsVisible(false)
                }
            }
            .store(in: &cancellables)
    }

    func shiftWindow(shiftType: ShiftType) {
        shiftModel.shiftWindow(shiftType: shiftType)
    }

    private func toggleIconsVisible(_ hideIcons: Bool) {
        let args: String = hideIcons ? .createDesktopFalse : .createDesktopTrue
        let shell = Process()
        shell.launchPath = "/bin/sh"
        shell.arguments = ["-c", args]
        shell.launch()
        shell.waitUntilExit()
    }

    func openSettings() {
        windowModel.openSettings()
    }

    func openAbout() {
        windowModel.openAbout()
    }

    func terminateApp() {
        NSApp.terminate(nil)
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class MenuViewModelMock: MenuViewModel {
        @Published var patterns = [ShiftPattern]()
        @Published var hideIcons: Bool = false

        init(_ shiftModel: ShiftModel,
             _ shortcutModel: ShortcutModel,
             _ windowModel: WindowModel) {}
        init() {}

        func shiftWindow(shiftType: ShiftType) {}
        func toggleIconsVisible() {}
        func resetIconsVisible() {}
        func openSettings() {}
        func openAbout() {}
        func terminateApp() {}
    }
}
