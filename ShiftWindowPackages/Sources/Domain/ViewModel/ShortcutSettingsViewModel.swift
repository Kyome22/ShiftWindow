/*
 ShortcutSettingsViewModel.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
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
