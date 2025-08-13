/*
 ShortcutService.swift
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
import SpiceKey

struct ShortcutService {
    private let appStateClient: AppStateClient
    private let spiceKeyClient: SpiceKeyClient
    private let windowSceneMessengerClient: WindowSceneMessengerClient
    private let userDefaultsRepository: UserDefaultsRepository

    init(_ appDependencies: AppDependencies) {
        self.appStateClient = appDependencies.appStateClient
        self.spiceKeyClient = appDependencies.spiceKeyClient
        self.windowSceneMessengerClient = appDependencies.windowSceneMessengerClient
        userDefaultsRepository = .init(appDependencies.userDefaultsClient)
    }

    func initializeShortcuts() {
        let shiftPatterns = userDefaultsRepository.shiftPatterns
        appStateClient.withLock {
            $0.shiftPatternsSubject.send(shiftPatterns)
        }
        shiftPatterns.forEach { shiftPattern in
            guard let keyCombo = shiftPattern.spiceKeyData?.keyCombination else { return }
            let spiceKey = SpiceKey(keyCombo) { [appStateClient, userDefaultsRepository, windowSceneMessengerClient] in
                if userDefaultsRepository.showShortcutPanel {
                    windowSceneMessengerClient.request(.open, .shortcutPanel, [.keyEquivalent: keyCombo.string])
                }
                appStateClient.withLock {
                    $0.shiftTypeSubject.send(shiftPattern.shiftType)
                }
            } keyUpHandler: { [windowSceneMessengerClient] in
                windowSceneMessengerClient.request(.close, .shortcutPanel, [:])
            }
            spiceKeyClient.register(spiceKey)
            shiftPattern.spiceKeyData?.spiceKey = spiceKey
        }
    }

    func getIndex(id: String) -> Int? {
        appStateClient.withLock(\.shiftPatternsSubject.value).firstIndex(where: { $0.shiftType.id == id })
    }

    func updateShortcut(id: String, keyCombo: KeyCombination) {
        guard let index = getIndex(id: id) else { return }
        let shiftPattern = appStateClient.withLock { $0.shiftPatternsSubject.value[index] }
        let spiceKey = SpiceKey(keyCombo) { [appStateClient, userDefaultsRepository, windowSceneMessengerClient] in
            if userDefaultsRepository.showShortcutPanel {
                windowSceneMessengerClient.request(.open, .shortcutPanel, [.keyEquivalent: keyCombo.string])
            }
            appStateClient.withLock {
                $0.shiftTypeSubject.send(shiftPattern.shiftType)
            }
        } keyUpHandler: { [windowSceneMessengerClient] in
            windowSceneMessengerClient.request(.close, .shortcutPanel, [:])
        }
        spiceKeyClient.register(spiceKey)
        appStateClient.withLock {
            $0.shiftPatternsSubject.value[index].spiceKeyData = SpiceKeyData(id, keyCombo.key, keyCombo.modifierFlags, spiceKey)
        }
        userDefaultsRepository.shiftPatterns = appStateClient.withLock(\.shiftPatternsSubject.value)
    }

    func removeShortcut(id: String) {
        guard let index = getIndex(id: id) else { return }
        let shiftPattern = appStateClient.withLock { $0.shiftPatternsSubject.value[index] }
        if let spiceKey = shiftPattern.spiceKeyData?.spiceKey {
            spiceKeyClient.unregister(spiceKey)
        }
        appStateClient.withLock {
            $0.shiftPatternsSubject.value[index].spiceKeyData = nil
        }
        userDefaultsRepository.shiftPatterns = appStateClient.withLock(\.shiftPatternsSubject.value)
    }
}
