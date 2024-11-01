/*
 ShortcutService.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import Combine
import DataLayer
import Foundation
import PanelSceneKit
import SpiceKey

public actor ShortcutService {
    private let patternsSubject: CurrentValueSubject<[ShiftPattern], Never>
    private let userDefaultsRepository: UserDefaultsRepository
    private let shiftService: ShiftService

    public init(
        _ userDefaultsRepository: UserDefaultsRepository,
        _ shiftService: ShiftService
    ) {
        self.userDefaultsRepository = userDefaultsRepository
        self.shiftService = shiftService
        patternsSubject = .init(userDefaultsRepository.patterns)
    }

    public func patternsStream() -> AsyncStream<[ShiftPattern]> {
        AsyncStream { continuation in
            let cancellable = patternsSubject.sink { value in
                continuation.yield(value)
            }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }

    public func initializeShortcuts() {
        patternsSubject.value.forEach { pattern in
            guard let keyCombo = pattern.spiceKeyData?.keyCombination else { return }
            let spiceKey = SpiceKey(keyCombo) { @MainActor [weak self] in
                guard let self else { return }
                if userDefaultsRepository.showShortcutPanel {
                    PanelSceneMessenger.request(
                        panelAction: .open,
                        with: .shortcutPanel,
                        userInfo: [String.keyEquivalent: keyCombo.string]
                    )
                }
                await shiftService.shiftWindow(shiftType: pattern.shiftType)
            } keyUpHandler: {
                PanelSceneMessenger.request(panelAction: .close, with: .shortcutPanel)
            }
            spiceKey.register()
            pattern.spiceKeyData?.spiceKey = spiceKey
        }
    }

    func getIndex(id: String) -> Int? {
        patternsSubject.value.firstIndex(where: { $0.shiftType.id == id })
    }

    public func updateShortcut(id: String, keyCombo: KeyCombination) {
        guard let index = getIndex(id: id) else { return }
        let pattern = patternsSubject.value[index]
        let spiceKey = SpiceKey(keyCombo) { @MainActor [weak self] in
            guard let self else { return }
            if userDefaultsRepository.showShortcutPanel {
                PanelSceneMessenger.request(
                    panelAction: .open,
                    with: .shortcutPanel,
                    userInfo: [String.keyEquivalent: keyCombo.string]
                )
            }
            await shiftService.shiftWindow(shiftType: pattern.shiftType)
        } keyUpHandler: {
            PanelSceneMessenger.request(panelAction: .close, with: .shortcutPanel)
        }
        spiceKey.register()
        let spiceKeyData = SpiceKeyData(id, keyCombo.key, keyCombo.modifierFlags, spiceKey)
        patternsSubject.value[index].spiceKeyData = spiceKeyData
        userDefaultsRepository.patterns = patternsSubject.value
    }

    public func removeShortcut(id: String) {
        guard let index = getIndex(id: id) else { return }
        patternsSubject.value[index].spiceKeyData?.spiceKey?.unregister()
        patternsSubject.value[index].spiceKeyData = nil
        userDefaultsRepository.patterns = patternsSubject.value
    }
}

extension AnyCancellable: @retroactive @unchecked Sendable {}
