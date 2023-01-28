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
    var shiftWindowPublisher: AnyPublisher<ShiftType, Never> { get }
    var toggleIconsVisiblePublisher: AnyPublisher<Bool, Never> { get }
    var openWindowPublisher: AnyPublisher<WindowType, Never> { get }
    var patterns: [ShiftPattern] { get }
    var updateMenuItemsHandler: (() -> Void)? { get set }
    var currentToggleStateHandler: (() -> Bool)? { get set }

    func shiftWindow(shiftType: ShiftType)
    func toggleIconsVisible(flag: Bool)
    func openPreferences()
    func openAbout()
    func terminateApp()
}

final class MenuBarModelImpl<UR: UserDefaultsRepository>: NSObject, MenuBarModel {
    private let userDefaultsRepository: UR

    private let shiftWindowSubject = PassthroughSubject<ShiftType, Never>()
    var shiftWindowPublisher: AnyPublisher<ShiftType, Never> {
        return shiftWindowSubject.eraseToAnyPublisher()
    }
    private let toggleIconsVisibleSubject = PassthroughSubject<Bool, Never>()
    var toggleIconsVisiblePublisher: AnyPublisher<Bool, Never> {
        return toggleIconsVisibleSubject.eraseToAnyPublisher()
    }
    private let openWindowSubject = PassthroughSubject<WindowType, Never>()
    var openWindowPublisher: AnyPublisher<WindowType, Never> {
        return openWindowSubject.eraseToAnyPublisher()
    }

    var patterns: [ShiftPattern] {
        return userDefaultsRepository.patterns
    }
    var updateMenuItemsHandler: (() -> Void)?
    var currentToggleStateHandler: (() -> Bool)?

    init(_ userDefaultsRepository: UR) {
        self.userDefaultsRepository = userDefaultsRepository
        super.init()
    }

    func shiftWindow(shiftType: ShiftType) {
        shiftWindowSubject.send(shiftType)
    }

    func toggleIconsVisible(flag: Bool) {
        toggleIconsVisibleSubject.send(flag)
    }

    func openPreferences() {
        openWindowSubject.send(.preferences)
    }

    func openAbout() {
        openWindowSubject.send(.about)
    }

    func terminateApp() {
        NSApp.terminate(nil)
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class MenuBarModelMock: MenuBarModel {
        var shiftWindowPublisher: AnyPublisher<ShiftType, Never> {
            Just(ShiftType.maximize).eraseToAnyPublisher()
        }
        var toggleIconsVisiblePublisher: AnyPublisher<Bool, Never> {
            Just(true).eraseToAnyPublisher()
        }
        var openWindowPublisher: AnyPublisher<WindowType, Never> {
            Just(.preferences).eraseToAnyPublisher()
        }
        let patterns: [ShiftPattern] = ShiftPattern.defaults
        var updateMenuItemsHandler: (() -> Void)?
        var currentToggleStateHandler: (() -> Bool)?

        func shiftWindow(shiftType: ShiftType) {}
        func toggleIconsVisible(flag: Bool) {}
        func openPreferences() {}
        func openAbout() {}
        func terminateApp() {}
    }
}
