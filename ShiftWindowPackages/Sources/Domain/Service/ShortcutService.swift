/*
 ShortcutService.swift
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

import Combine
import DataLayer
import Foundation
import SpiceKey

public actor ShortcutService {
    private let patternsSubject: CurrentValueSubject<[ShiftPattern], Never>
    private let shiftTypeSubject = PassthroughSubject<ShiftType, Never>()
    private let spiceKeyClient: SpiceKeyClient
    private let userDefaultsRepository: UserDefaultsRepository
    private let windowSceneMessengerClient: WindowSceneMessengerClient

    public init(
        _ spiceKeyClient: SpiceKeyClient,
        _ userDefaultsClient: UserDefaultsClient,
        _ windowSceneMessengerClient: WindowSceneMessengerClient
    ) {
        self.spiceKeyClient = spiceKeyClient
        userDefaultsRepository = .init(userDefaultsClient)
        self.windowSceneMessengerClient = windowSceneMessengerClient
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

    public func shiftTypeStream() -> AsyncStream<ShiftType> {
        AsyncStream { continuation in
            let cancellable = shiftTypeSubject.sink { value in
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
            let spiceKey = SpiceKey(keyCombo) { [weak self] in
                guard let self else { return }
                if userDefaultsRepository.showShortcutPanel {
                    windowSceneMessengerClient.request(.open, .shortcutPanel, [.keyEquivalent: keyCombo.string])
                }
                shiftTypeSubject.send(pattern.shiftType)
            } keyUpHandler: { [weak self] in
                self?.windowSceneMessengerClient.request(.close, .shortcutPanel, [:])
            }
            spiceKeyClient.register(spiceKey)
            pattern.spiceKeyData?.spiceKey = spiceKey
        }
    }

    func getIndex(id: String) -> Int? {
        patternsSubject.value.firstIndex(where: { $0.shiftType.id == id })
    }

    public func updateShortcut(id: String, keyCombo: KeyCombination) {
        guard let index = getIndex(id: id) else { return }
        let pattern = patternsSubject.value[index]
        let spiceKey = SpiceKey(keyCombo) { [weak self] in
            guard let self else { return }
            if userDefaultsRepository.showShortcutPanel {
                windowSceneMessengerClient.request(.open, .shortcutPanel, [.keyEquivalent: keyCombo.string])
            }
            shiftTypeSubject.send(pattern.shiftType)
        } keyUpHandler: { [weak self] in
            self?.windowSceneMessengerClient.request(.close, .shortcutPanel, [:])
        }
        spiceKeyClient.register(spiceKey)
        let spiceKeyData = SpiceKeyData(id, keyCombo.key, keyCombo.modifierFlags, spiceKey)
        patternsSubject.value[index].spiceKeyData = spiceKeyData
        userDefaultsRepository.patterns = patternsSubject.value
    }

    public func removeShortcut(id: String) {
        guard let index = getIndex(id: id) else { return }
        if let spiceKey = patternsSubject.value[index].spiceKeyData?.spiceKey {
            spiceKeyClient.unregister(spiceKey)
        }
        patternsSubject.value[index].spiceKeyData = nil
        userDefaultsRepository.patterns = patternsSubject.value
    }
}

extension AnyCancellable: @retroactive @unchecked Sendable {}
extension PassthroughSubject<ShiftType, Never>: @retroactive @unchecked Sendable {}
