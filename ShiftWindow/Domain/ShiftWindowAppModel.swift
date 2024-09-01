/*
 ShiftWindowAppModel.swift
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
@preconcurrency import ApplicationServices
import Combine
import SpiceKey

@MainActor protocol ShiftWindowAppModel: ObservableObject {
    associatedtype UR: UserDefaultsRepository
    associatedtype SM: ShiftModel
    associatedtype ScM: ShortcutModel
    associatedtype WM: WindowModel
    associatedtype MVM: MenuViewModel
    associatedtype GVM: GeneralSettingsViewModel
    associatedtype SVM: ShortcutSettingsViewModel

    var settingsTab: SettingsTabType { get set }
    var userDefaultsRepository: UR { get }
    var shiftModel: SM { get }
    var shortcutModel: ScM { get }
    var windowModel: WM { get }
}

final class ShiftWindowAppModelImpl: ShiftWindowAppModel {
    typealias UR = UserDefaultsRepositoryImpl
    typealias SM = ShiftModelImpl
    typealias ScM = ShortcutModelImpl
    typealias WM = WindowModelImpl
    typealias EM = ExecuteModelImpl
    typealias MVM = MenuViewModelImpl<ExecuteModelImpl>
    typealias GVM = GeneralSettingsViewModelImpl<LaunchAtLoginRepositoryImpl>
    typealias SVM = ShortcutSettingsViewModelImpl

    @Published var settingsTab: SettingsTabType = .general

    let userDefaultsRepository: UR
    let shiftModel: SM
    let shortcutModel: ScM
    let windowModel: WM
    private var cancellables = Set<AnyCancellable>()

    init() {
        userDefaultsRepository = UR()
        shiftModel = SM()
        shortcutModel = ScM(userDefaultsRepository, shiftModel)
        windowModel = WM(userDefaultsRepository, shortcutModel)

        NotificationCenter.default
            .publisher(for: NSApplication.didFinishLaunchingNotification)
            .sink { [weak self] _ in
                self?.shortcutModel.initializeShortcuts()
                self?.checkPermissionAllowed()
            }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: NSApplication.willTerminateNotification)
            .sink { _ in
                if EM.checkIconsVisible() {
                    EM.toggleIconsVisible(false)
                }
            }
            .store(in: &cancellables)
    }

    @discardableResult
    private  func checkPermissionAllowed() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class ShiftWindowAppModelMock: ShiftWindowAppModel {
        typealias UR = UserDefaultsRepositoryMock
        typealias SM = ShiftModelMock
        typealias ScM = ShortcutModelMock
        typealias WM = WindowModelMock
        typealias MVM = MenuViewModelMock
        typealias GVM = GeneralSettingsViewModelMock
        typealias SVM = ShortcutSettingsViewModelMock

        @Published var settingsTab: SettingsTabType = .general

        let userDefaultsRepository = UR()
        let shiftModel = SM()
        let shortcutModel = ScM()
        let windowModel = WM()
    }
}
