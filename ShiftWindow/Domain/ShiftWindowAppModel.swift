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
import Combine
import SpiceKey

protocol ShiftWindowAppModel: ObservableObject {
    associatedtype UR: UserDefaultsRepository
    associatedtype LR: LaunchAtLoginRepository
    associatedtype SCM: ShortcutModel

    var settingsTab: SettingsTabType { get set }
    var userDefaultsRepository: UR { get }
    var launchAtLoginRepository: LR { get }
    var shortcutModel: SCM { get }
}

final class ShiftWindowAppModelImpl: NSObject, ShiftWindowAppModel {
    typealias UR = UserDefaultsRepositoryImpl
    typealias LR = LaunchAtLoginRepositoryImpl
    typealias SCM = ShortcutModelImpl
    typealias SCMConcrete = SCM<UR, ShiftModelImpl>
    typealias WMConcrete = WindowModelImpl<UR, SCMConcrete>
    typealias MMConcrete = MenuBarModelImpl<ShiftModelImpl, SCMConcrete, WMConcrete>

    @Published var settingsTab: SettingsTabType = .general

    let userDefaultsRepository: UR
    let launchAtLoginRepository: LR
    private let shiftModel: ShiftModelImpl
    let shortcutModel: SCMConcrete
    private let windowModel: WMConcrete
    private let menuBarModel: MMConcrete
    private var menuBar: MenuBar<MMConcrete>?
    private var cancellables = Set<AnyCancellable>()

    override init() {
        userDefaultsRepository = UR()
        launchAtLoginRepository = LR()
        shiftModel = ShiftModelImpl()
        shortcutModel = SCM(userDefaultsRepository, shiftModel)
        windowModel = WindowModelImpl(userDefaultsRepository, shortcutModel)
        menuBarModel = MenuBarModelImpl(shiftModel, shortcutModel, windowModel)
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
        shortcutModel.initializeShortcuts()
        checkPermissionAllowed()
    }

    private func applicationWillTerminate() {
        menuBarModel.resetIconsVisible()
    }

    @discardableResult
    private func checkPermissionAllowed() -> Bool {
        let key = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
        let options: NSDictionary = [key: true]
        return AXIsProcessTrustedWithOptions(options)
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class ShiftWindowAppModelMock: ShiftWindowAppModel {
        typealias UR = UserDefaultsRepositoryMock
        typealias LR = LaunchAtLoginRepositoryMock
        typealias SM = ShortcutModelMock

        var settingsTab: SettingsTabType = .general
        let userDefaultsRepository = UR()
        let launchAtLoginRepository = LR()
        let shortcutModel = SM()
    }
}
