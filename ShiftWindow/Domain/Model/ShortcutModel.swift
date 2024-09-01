/*
 ShortcutModel.swift
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

import AsyncAlgorithms
@preconcurrency import Combine
import SpiceKey

protocol ShortcutModel: AnyObject, Sendable {
    var showPanelChannel: AsyncChannel<String> { get }
    var fadeOutPanelChannel: AsyncChannel<Void> { get }

    init(_ userDefaultsRepository: UserDefaultsRepository,
         _ shiftModel: ShiftModel)

    func patternsStream() -> AsyncStream<[ShiftPattern]>
    func initializeShortcuts()
    func updateShortcut(id: String, keyCombo: KeyCombination)
    func removeShortcut(id: String)
}

final class ShortcutModelImpl: ShortcutModel {
    let showPanelChannel = AsyncChannel<String>()
    let fadeOutPanelChannel = AsyncChannel<Void>()
    private let patternsSubject: CurrentValueSubject<[ShiftPattern], Never>
    private let userDefaultsRepository: any UserDefaultsRepository
    private let shiftModel: any ShiftModel

    init(
        _ userDefaultsRepository: UserDefaultsRepository,
        _ shiftModel: ShiftModel
    ) {
        self.userDefaultsRepository = userDefaultsRepository
        self.shiftModel = shiftModel
        self.patternsSubject = .init(userDefaultsRepository.patterns)
    }

    func patternsStream() -> AsyncStream<[ShiftPattern]> {
        AsyncStream { continuation in
            let cancellable = patternsSubject.sink { value in
                continuation.yield(value)
            }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }

    func initializeShortcuts() {
        patternsSubject.value.forEach { pattern in
            guard let keyCombo = pattern.spiceKeyData?.keyCombination else { return }
            let spiceKey = SpiceKey(keyCombo) { [weak self] in
                guard let self else { return }
                await self.showPanelChannel.send(keyCombo.string)
                await MainActor.run {
                    self.shiftModel.shiftWindow(shiftType: pattern.shiftType)
                }
            } keyUpHandler: { [weak self] in
                guard let self else { return }
                await self.fadeOutPanelChannel.send(())
            }
            spiceKey.register()
            pattern.spiceKeyData?.spiceKey = spiceKey
        }
    }

    private func getIndex(id: String) -> Int? {
        patternsSubject.value.firstIndex(where: { $0.shiftType.id == id })
    }

    func updateShortcut(id: String, keyCombo: KeyCombination) {
        guard let index = getIndex(id: id) else { return }
        let pattern = patternsSubject.value[index]
        let spiceKey = SpiceKey(keyCombo) { [weak self] in
            guard let self else { return }
            Task {
                await self.showPanelChannel.send(keyCombo.string)
                await MainActor.run {
                    self.shiftModel.shiftWindow(shiftType: pattern.shiftType)
                }
            }
        } keyUpHandler: { [weak self] in
            guard let self else { return }
            Task {
                await self.fadeOutPanelChannel.send(())
            }
        }
        spiceKey.register()
        let spiceKeyData = SpiceKeyData(id, keyCombo.key, keyCombo.modifierFlags, spiceKey)
        patternsSubject.value[index].spiceKeyData = spiceKeyData
        userDefaultsRepository.patterns = patternsSubject.value
    }

    func removeShortcut(id: String) {
        guard let index = getIndex(id: id) else { return }
        patternsSubject.value[index].spiceKeyData?.spiceKey?.unregister()
        patternsSubject.value[index].spiceKeyData = nil
        userDefaultsRepository.patterns = patternsSubject.value
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class ShortcutModelMock: ShortcutModel {
        let showPanelChannel = AsyncChannel<String>()
        let fadeOutPanelChannel = AsyncChannel<Void>()

        init(_ userDefaultsRepository: UserDefaultsRepository,
             _ shiftModel: ShiftModel) {}
        init() {}

        func patternsStream() -> AsyncStream<[ShiftPattern]> { AsyncStream(unfolding: { nil }) }
        func initializeShortcuts() {}
        func updateShortcut(id: String, keyCombo: KeyCombination) {}
        func removeShortcut(id: String) {}
    }
}
