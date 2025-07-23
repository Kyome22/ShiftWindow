/*
 ShortcutSettings.swift
 Model

 Created by Takuto Nakamura on 2024/11/01.
 Copyright 2022 Takuto Nakamura (Kyome22)

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

import Foundation
import DataSource
import Observation
import SpiceKey

@MainActor @Observable public final class ShortcutSettings {
    private let appStateClient: AppStateClient
    private let userDefaultsRepository: UserDefaultsRepository
    private let logService: LogService
    private let shortcutService: ShortcutService

    @ObservationIgnored private var task: Task<Void, Never>?

    public var shiftPatterns: [ShiftPattern]
    public var showShortcutPanel: Bool

    public init(
        _ appDependencies: AppDependencies,
        shiftPatterns: [ShiftPattern]? = nil,
        showShortcutPanel: Bool? = nil
    ) {
        self.appStateClient = appDependencies.appStateClient
        self.userDefaultsRepository = .init(appDependencies.userDefaultsClient)
        self.logService = .init(appDependencies)
        self.shortcutService = .init(appDependencies)
        self.shiftPatterns = shiftPatterns ?? userDefaultsRepository.shiftPatterns
        self.showShortcutPanel = showShortcutPanel ?? userDefaultsRepository.showShortcutPanel
    }

    public func send(_ action: Action) {
        switch action {
        case let .onAppear(screenName):
            logService.notice(.screenView(name: screenName))
            task = Task { [weak self, appStateClient] in
                let values = appStateClient.withLock(\.shiftPatternsSubject.values)
                for await value in values {
                    self?.shiftPatterns = value
                }
            }

        case .onDisappear:
            task?.cancel()

        case let .onUpdateShortcut(shiftPattern, keyCombination):
            let id = shiftPattern.shiftType.id
            if let keyCombination {
                shortcutService.updateShortcut(id: id, keyCombo: keyCombination)
            } else {
                shortcutService.removeShortcut(id: id)
            }

        case let .showShortcutPanelToggleSwitched(isOn):
            showShortcutPanel = isOn
            userDefaultsRepository.showShortcutPanel = isOn
        }
    }

    public enum Action {
        case onAppear(String)
        case onDisappear
        case onUpdateShortcut(ShiftPattern, KeyCombination?)
        case showShortcutPanelToggleSwitched(Bool)
    }
}
