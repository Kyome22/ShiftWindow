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

final class MenuViewModelImpl: MenuViewModel {
    @Published var patterns = [ShiftPattern]()
    @Published var hideIcons: Bool = false

    private let shiftModel: ShiftModel
    private let windowModel: WindowModel
    private var cancellables = Set<AnyCancellable>()

    init(
        _ shiftModel: ShiftModel,
        _ shortcutModel: ShortcutModel,
        _ windowModel: WindowModel
    ) {
        self.shiftModel = shiftModel
        self.windowModel = windowModel
        shortcutModel.patternsPublisher
            .sink { [weak self] patterns in
                self?.patterns = patterns
            }
            .store(in: &cancellables)

        hideIcons = checkIconsVisible()
        _hideIcons.projectedValue
            .dropFirst()
            .sink { [weak self] value in
                self?.toggleIconsVisible(value)
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)
            .sink { [weak self] _ in
                self?.toggleIconsVisible(false)
            }
            .store(in: &cancellables)
    }

    func shiftWindow(shiftType: ShiftType) {
        shiftModel.shiftWindow(shiftType: shiftType)
    }

    private func checkIconsVisible() -> Bool {
        let shell = Process()
        let pipe = Pipe()
        shell.launchPath = "/bin/sh"
        shell.arguments = ["-c", .createDesktopRead]
        shell.standardOutput = pipe
        do {
            try shell.run()
            shell.waitUntilExit()
            if shell.terminationStatus == 0,
               let data = try pipe.fileHandleForReading.readToEnd(),
               let str = String(data: data, encoding: .utf8),
               str.trimmingCharacters(in: .newlines) == "0" {
                return true
            }
        } catch {
            logput(error.localizedDescription)
        }
        return false
    }

    private func toggleIconsVisible(_ hideIcons: Bool) {
        // It needs to be other than the main thread in order for reflecting Toggle check mark.
        Task {
            let args: String = hideIcons ? .createDesktopWriteFalse : .createDesktopDelete
            let shell = Process()
            shell.launchPath = "/bin/sh"
            shell.arguments = ["-c", args]
            do {
                try shell.run()
                shell.waitUntilExit()
            } catch {
                logput(error.localizedDescription)
            }
        }
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
        func openSettings() {}
        func openAbout() {}
        func terminateApp() {}
    }
}
