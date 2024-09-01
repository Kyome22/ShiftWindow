/*
 ShortcutSettingsViewModel.swift
 ShiftWindow

 Created by Takuto Nakamura on 2022/07/15.
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
import SpiceKey

@MainActor protocol ShortcutSettingsViewModel: ObservableObject {
    var patterns: [ShiftPattern] { get set }
    var showShortcutPanel: Bool { get set }

    init(_ userDefaultsRepository: UserDefaultsRepository,
         _ shortcutModel: ShortcutModel)

    func updateShortcut(id: String?, keyCombo: KeyCombination)
    func removeShortcut(id: String?)
}

final class ShortcutSettingsViewModelImpl: ShortcutSettingsViewModel {
    @Published var patterns: [ShiftPattern]
    @Published var showShortcutPanel: Bool {
        didSet { userDefaultsRepository.showShortcutPanel = showShortcutPanel }
    }

    private let userDefaultsRepository: UserDefaultsRepository
    private let shortcutModel: ShortcutModel
    private var task: Task<Void, Never>?

    init(
        _ userDefaultsRepository: UserDefaultsRepository,
        _ shortcutModel: ShortcutModel
    ) {
        self.userDefaultsRepository = userDefaultsRepository
        self.shortcutModel = shortcutModel
        patterns =  userDefaultsRepository.patterns
        showShortcutPanel = userDefaultsRepository.showShortcutPanel

        task = Task {
            for await patterns in shortcutModel.patternsStream() {
                self.patterns = patterns
            }
        }
    }

    func updateShortcut(id: String?, keyCombo: KeyCombination) {
        guard let id else { return }
        shortcutModel.updateShortcut(id: id, keyCombo: keyCombo)
    }

    func removeShortcut(id: String?) {
        guard let id else { return }
        shortcutModel.removeShortcut(id: id)
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class ShortcutSettingsViewModelMock: ShortcutSettingsViewModel {
        @Published var patterns: [ShiftPattern] = ShiftPattern.defaults
        @Published var showShortcutPanel: Bool = true

        init(_ userDefaultsRepository: UserDefaultsRepository,
             _ shortcutModel: ShortcutModel) {}
        init() {}

        func updateShortcut(id: String?, keyCombo: KeyCombination) {}
        func removeShortcut(id: String?) {}
    }
}
