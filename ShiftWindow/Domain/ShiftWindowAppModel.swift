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
import Observation
import SpiceKey

protocol ShiftWindowAppModel: AnyObject, Observable {
    associatedtype UR: UserDefaultsRepository
    associatedtype SM: ShiftModel
    associatedtype ScM: ShortcutModel
    associatedtype WM: WindowModel
    associatedtype SVM: SettingsViewModel
    associatedtype MVM: MenuViewModel
    associatedtype GSVM: GeneralSettingsViewModel
    associatedtype SSVM: ShortcutSettingsViewModel

    var settingsTab: SettingsTabType { get set }
    var userDefaultsRepository: UR { get }
    var shiftModel: SM { get }
    var shortcutModel: ScM { get }
    var windowModel: WM { get }

    init()

    func didFinishLaunching()
    func willTerminate()
}


@Observable final class ShiftWindowAppModelImpl: ShiftWindowAppModel {
    typealias UR = UserDefaultsRepositoryImpl
    typealias SM = ShiftModelImpl
    typealias ScM = ShortcutModelImpl
    typealias WM = WindowModelImpl
    typealias EM = ExecuteModelImpl
    typealias SVM = SettingsViewModelImpl<GSVM, SSVM>
    typealias MVM = MenuViewModelImpl<EM>
    typealias GSVM = GeneralSettingsViewModelImpl<LaunchAtLoginRepositoryImpl>
    typealias SSVM = ShortcutSettingsViewModelImpl

    var settingsTab: SettingsTabType = .general

    let userDefaultsRepository: UR
    let shiftModel: SM
    let shortcutModel: ScM
    let windowModel: WM

    init() {
        userDefaultsRepository = UR()
        shiftModel = SM()
        shortcutModel = ScM(userDefaultsRepository, shiftModel)
        windowModel = WM(userDefaultsRepository, shortcutModel)
    }

    func didFinishLaunching() {
        shortcutModel.initializeShortcuts()

        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
    }

    func willTerminate() {
        if EM.checkIconsVisible() {
            EM.toggleIconsVisible(false)
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    @Observable final class ShiftWindowAppModelMock: ShiftWindowAppModel {
        typealias UR = UserDefaultsRepositoryMock
        typealias SM = ShiftModelMock
        typealias ScM = ShortcutModelMock
        typealias WM = WindowModelMock
        typealias SVM = SettingsViewModelMock
        typealias MVM = MenuViewModelMock
        typealias GSVM = GeneralSettingsViewModelMock
        typealias SSVM = ShortcutSettingsViewModelMock

        var settingsTab: SettingsTabType = .general
        let userDefaultsRepository = UR()
        let shiftModel = SM()
        let shortcutModel = ScM()
        let windowModel = WM()

        func didFinishLaunching() {}
        func willTerminate() {}
    }
}
