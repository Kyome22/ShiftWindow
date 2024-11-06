/*
 ShortcutSettingsViewModel.swift
 Domain

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

import DataLayer
import Foundation
import Observation
import SpiceKey

@MainActor @Observable public final class ShortcutSettingsViewModel {
    private let userDefaultsRepository: UserDefaultsRepository
    private let logService: LogService
    private let shortcutService: ShortcutService

    @ObservationIgnored private var task: Task<Void, Never>?

    public var patterns: [ShiftPattern]
    public var showShortcutPanel: Bool {
        didSet { userDefaultsRepository.showShortcutPanel = showShortcutPanel }
    }

    public init(
        _ userDefaultsRepository: UserDefaultsRepository,
        _ logService: LogService,
        _ shortcutService: ShortcutService
    ) {
        self.userDefaultsRepository = userDefaultsRepository
        self.logService = logService
        self.shortcutService = shortcutService
        patterns = userDefaultsRepository.patterns
        showShortcutPanel = userDefaultsRepository.showShortcutPanel
        task = Task {
            for await patterns in await shortcutService.patternsStream() {
                self.patterns = patterns
            }
        }
    }

    deinit {
        task?.cancel()
    }

    public func onAppear(screenName: String) {
        logService.notice(.screenView(name: screenName))
    }

    public func updateShortcut(id: String?, keyCombo: KeyCombination) {
        guard let id else { return }
        Task {
            await shortcutService.updateShortcut(id: id, keyCombo: keyCombo)
        }
    }

    public func removeShortcut(id: String?) {
        guard let id else { return }
        Task {
            await shortcutService.removeShortcut(id: id)
        }
    }
}
