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

import Foundation
import Combine
import SpiceKey

protocol ShortcutModel: AnyObject {
    var showPanelPublisher: AnyPublisher<String, Never> { get }
    var fadeOutPanelPublisher: AnyPublisher<Void, Never> { get }
    var patternsPublisher: AnyPublisher<[ShiftPattern], Never> { get }

    init(_ userDefaultsRepository: UserDefaultsRepository,
         _ shiftModel: ShiftModel)

    func initializeShortcuts()
    func updateShortcut(id: String, keyCombo: KeyCombination)
    func removeShortcut(id: String)
}

final class ShortcutModelImpl: ShortcutModel {
    private let showPanelSubject = PassthroughSubject<String, Never>()
    var showPanelPublisher: AnyPublisher<String, Never> {
        return showPanelSubject.eraseToAnyPublisher()
    }
    private let fadeOutPanelSubject = PassthroughSubject<Void, Never>()
    var fadeOutPanelPublisher: AnyPublisher<Void, Never> {
        return fadeOutPanelSubject.eraseToAnyPublisher()
    }
    private let patternsSubject = CurrentValueSubject<[ShiftPattern], Never>([])
    var patternsPublisher: AnyPublisher<[ShiftPattern], Never> {
        return patternsSubject.eraseToAnyPublisher()
    }

    private let userDefaultsRepository: UserDefaultsRepository
    private let shiftModel: ShiftModel

    init(
        _ userDefaultsRepository: UserDefaultsRepository,
        _ shiftModel: ShiftModel
    ) {
        self.userDefaultsRepository = userDefaultsRepository
        self.shiftModel = shiftModel
        self.patternsSubject.value = userDefaultsRepository.patterns
    }

    func initializeShortcuts() {
        patternsSubject.value.forEach { pattern in
            guard let keyCombo = pattern.spiceKeyData?.keyCombination else { return }
            let spiceKey = SpiceKey(keyCombo) { [weak self] in
                self?.showPanelSubject.send(keyCombo.string)
                self?.shiftModel.shiftWindow(shiftType: pattern.shiftType)
            } keyUpHandler: { [weak self] in
                self?.fadeOutPanelSubject.send(())
            }
            spiceKey.register()
            pattern.spiceKeyData?.spiceKey = spiceKey
        }
    }

    private func getIndex(id: String) -> Int? {
        return patternsSubject.value.firstIndex(where: { $0.shiftType.id == id })
    }

    func updateShortcut(id: String, keyCombo: KeyCombination) {
        guard let index = getIndex(id: id) else { return }
        let pattern = patternsSubject.value[index]
        let spiceKey = SpiceKey(keyCombo) { [weak self] in
            self?.showPanelSubject.send(keyCombo.string)
            self?.shiftModel.shiftWindow(shiftType: pattern.shiftType)
        } keyUpHandler: { [weak self] in
            self?.fadeOutPanelSubject.send(())
        }
        spiceKey.register()
        patternsSubject.value[index].spiceKeyData = SpiceKeyData(id,
                                                                 keyCombo.key,
                                                                 keyCombo.modifierFlags,
                                                                 spiceKey)
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
        var showPanelPublisher: AnyPublisher<String, Never> {
            Just("").eraseToAnyPublisher()
        }
        var fadeOutPanelPublisher: AnyPublisher<Void, Never> {
            Just(()).eraseToAnyPublisher()
        }
        var patternsPublisher: AnyPublisher<[ShiftPattern], Never> {
            Just([]).eraseToAnyPublisher()
        }

        init(_ userDefaultsRepository: UserDefaultsRepository,
             _ shiftModel: ShiftModel) {}
        init() {}

        func initializeShortcuts() {}
        func updateShortcut(id: String, keyCombo: KeyCombination) {}
        func removeShortcut(id: String) {}
    }
}
