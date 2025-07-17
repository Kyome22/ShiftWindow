/*
 UserDefaultsRepository.swift
 Infrastructure

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

public struct UserDefaultsRepository: Sendable {
    private var userDefaultsClient: UserDefaultsClient

    public var patterns: [ShiftPattern] {
        get {
            guard let data = userDefaultsClient.data(.patterns) else { return [] }
            return (try? JSONDecoder().decode([ShiftPattern].self, from: data)) ?? []
        }
        nonmutating set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaultsClient.setData(data, .patterns)
        }
    }

    public var showShortcutPanel: Bool {
        get { userDefaultsClient.bool(.showShortcutPanel) }
        nonmutating set { userDefaultsClient.setBool(newValue, .showShortcutPanel) }
    }

    public init(_ userDefaultsClient: UserDefaultsClient) {
        self.userDefaultsClient = userDefaultsClient

        #if DEBUG
        if ProcessInfo.needsResetUserDefaults {
            userDefaultsClient.removePersistentDomain(Bundle.main.bundleIdentifier!)
        }
        #endif

        if patterns.isEmpty {
            patterns = ShiftPattern.defaults
        }

        #if DEBUG
        showAllData()
        #endif
    }

    private func showAllData() {
        guard let dict = userDefaultsClient.persistentDomain(Bundle.main.bundleIdentifier!) else {
            return
        }
        for (key, value) in dict.sorted(by: { $0.0 < $1.0 }) {
            Swift.print("\(key) => \(value)")
        }
    }
}
