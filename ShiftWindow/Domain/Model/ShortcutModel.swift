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
    var shiftWindowPublisher: AnyPublisher<(ShiftType, String), Never> { get }
    var fadeOutPanelSubjectPublisher: AnyPublisher<Void, Never> { get }
    var updatePatternsPublisher: AnyPublisher<Void, Never> { get }

    func initializeShortcuts()
    func updateShortcut(id: String, keyCombo: KeyCombination)
    func removeShortcut(id: String)
}

final class ShortcutModelImpl<UR: UserDefaultsRepository>: ShortcutModel {
    private let userDefaultsRepository: UR

    private let shiftWindowSubject = PassthroughSubject<(ShiftType, String), Never>()
    var shiftWindowPublisher: AnyPublisher<(ShiftType, String), Never> {
        return shiftWindowSubject.eraseToAnyPublisher()
    }
    private let fadeOutPanelSubject = PassthroughSubject<Void, Never>()
    var fadeOutPanelSubjectPublisher: AnyPublisher<Void, Never> {
        return fadeOutPanelSubject.eraseToAnyPublisher()
    }
    private let updatePatternsSubject = PassthroughSubject<Void, Never>()
    var updatePatternsPublisher: AnyPublisher<Void, Never> {
        return updatePatternsSubject.eraseToAnyPublisher()
    }

    init(_ userDefaultsRepository: UR) {
        self.userDefaultsRepository = userDefaultsRepository
    }

    func initializeShortcuts() {
        userDefaultsRepository.patterns.forEach { pattern in
            guard let keyCombo = pattern.spiceKeyData?.keyCombination else { return }
            let spiceKey = SpiceKey(keyCombo) { [weak self] in
                self?.shiftWindowSubject.send((pattern.shiftType, keyCombo.string))
            } keyUpHandler: { [weak self] in
                self?.fadeOutPanelSubject.send(())
            }
            spiceKey.register()
            pattern.spiceKeyData?.spiceKey = spiceKey
        }
    }

    func updateShortcut(id: String, keyCombo: KeyCombination) {
        let patterns = userDefaultsRepository.patterns
        guard let pattern = patterns.first(where: { $0.shiftType.id == id }) else { return }
        let spiceKey = SpiceKey(keyCombo) { [weak self] in
            self?.shiftWindowSubject.send((pattern.shiftType, keyCombo.string))
        } keyUpHandler: { [weak self] in
            self?.fadeOutPanelSubject.send(())
        }
        spiceKey.register()
        pattern.spiceKeyData = SpiceKeyData(id, keyCombo.key, keyCombo.modifierFlags, spiceKey)
        userDefaultsRepository.patterns = patterns
        updatePatternsSubject.send(())
    }

    func removeShortcut(id: String) {
        let patterns = userDefaultsRepository.patterns
        guard let pattern = patterns.first(where: { $0.shiftType.id == id }) else { return }
        pattern.spiceKeyData?.spiceKey?.unregister()
        pattern.spiceKeyData = nil
        userDefaultsRepository.patterns = patterns
        updatePatternsSubject.send(())
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class ShortcutModelMock: ShortcutModel {
        var shiftWindowPublisher: AnyPublisher<(ShiftType, String), Never> {
            Just((ShiftType.maximize, "")).eraseToAnyPublisher()
        }
        var fadeOutPanelSubjectPublisher: AnyPublisher<Void, Never> {
            Just(()).eraseToAnyPublisher()
        }
        var updatePatternsPublisher: AnyPublisher<Void, Never> {
            Just(()).eraseToAnyPublisher()
        }

        func initializeShortcuts() {}
        func updateShortcut(id: String, keyCombo: KeyCombination) {}
        func removeShortcut(id: String) {}
    }
}
