/*
  MenuBarModel.swift
  ShiftWindow

  Created by Takuto Nakamura on 2023/01/24.
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
import Combine

protocol MenuBarModel: AnyObject {
    var updateMenuItemsPublisher: AnyPublisher<[ShiftPattern], Never> { get }
    var resetIconsVisiblePublisher: AnyPublisher<Void, Never> { get }

    func shiftWindow(shiftType: ShiftType)
    func toggleIconsVisible(flag: Bool)
    func resetIconsVisible()
    func openPreferences()
    func openAbout()
    func terminateApp()
}

final class MenuBarModelImpl<SM: ShiftModel,
                             SCM: ShortcutModel,
                             WM: WindowModel>: NSObject, MenuBarModel {
    private let updateMenuItemsSubject = CurrentValueSubject<[ShiftPattern], Never>([])
    var updateMenuItemsPublisher: AnyPublisher<[ShiftPattern], Never> {
        return updateMenuItemsSubject.eraseToAnyPublisher()
    }
    private let resetIconsVisibleSubject = PassthroughSubject<Void, Never>()
    var resetIconsVisiblePublisher: AnyPublisher<Void, Never> {
        return resetIconsVisibleSubject.eraseToAnyPublisher()
    }

    private let shiftModel: SM
    private let windowModel: WM
    private var cancellables = Set<AnyCancellable>()

    init(
        _ shiftModel: SM,
        _ shortcutModel: SCM,
        _ windowModel: WM
    ) {
        self.shiftModel = shiftModel
        self.windowModel = windowModel
        super.init()
        shortcutModel.patternsPublisher
            .sink { [weak self] patterns in
                self?.updateMenuItemsSubject.send(patterns)
            }
            .store(in: &cancellables)
    }

    func shiftWindow(shiftType: ShiftType) {
        shiftModel.shiftWindow(shiftType: shiftType)
    }

    func toggleIconsVisible(flag: Bool) {
        let args = flag
        ? "defaults write com.apple.finder CreateDesktop -bool FALSE; killall Finder"
        : "defaults delete com.apple.finder CreateDesktop; killall Finder"
        let shell = Process()
        shell.launchPath = "/bin/sh"
        shell.arguments = ["-c", args]
        shell.launch()
        shell.waitUntilExit()
    }

    func resetIconsVisible() {
        resetIconsVisibleSubject.send(())
    }

    func openPreferences() {
        windowModel.openPreferences()
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
    final class MenuBarModelMock: MenuBarModel {
        var updateMenuItemsPublisher: AnyPublisher<[ShiftPattern], Never> {
            Just(ShiftPattern.defaults).eraseToAnyPublisher()
        }
        var resetIconsVisiblePublisher: AnyPublisher<Void, Never> {
            Just(()).eraseToAnyPublisher()
        }

        func shiftWindow(shiftType: ShiftType) {}
        func toggleIconsVisible(flag: Bool) {}
        func resetIconsVisible() {}
        func openPreferences() {}
        func openAbout() {}
        func terminateApp() {}
    }
}
