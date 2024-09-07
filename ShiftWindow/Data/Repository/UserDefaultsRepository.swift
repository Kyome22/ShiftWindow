/*
 UserDefaultsRepository.swift
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

fileprivate let RESET_USER_DEFAULTS = false

protocol UserDefaultsRepository: AnyObject, Sendable {
    var showShortcutPanel: Bool { get set }
    var patterns: [ShiftPattern] { get set }
}

final class UserDefaultsRepositoryImpl: UserDefaultsRepository {
    private let userDefaults: UserDefaults

    var showShortcutPanel: Bool {
        get { userDefaults.bool(forKey: "showShortcutPanel") }
        set { userDefaults.set(newValue, forKey: "showShortcutPanel") }
    }

    var patterns: [ShiftPattern] {
        get {
            guard let data = userDefaults.data(forKey: "patterns") else { return [] }
            return (try? JSONDecoder().decode([ShiftPattern].self, from: data)) ?? []
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaults.set(data, forKey: "patterns")
        }
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
#if DEBUG
        if RESET_USER_DEFAULTS {
            self.userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        }
#endif
        if self.patterns.isEmpty {
            self.patterns = ShiftPattern.defaults
        }
#if DEBUG
        showAllData()
#endif
    }

    private func showAllData() {
        if let dict = userDefaults.persistentDomain(forName: Bundle.main.bundleIdentifier!) {
            for (key, value) in dict.sorted(by: { $0.0 < $1.0 }) {
                Swift.print("\(key) => \(value)")
            }
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class UserDefaultsRepositoryMock: UserDefaultsRepository {
        var showShortcutPanel: Bool {
            get { false }
            set {}
        }
        var patterns: [ShiftPattern] {
            get { ShiftPattern.defaults }
            set {}
        }
    }
}

extension UserDefaults: @unchecked Sendable {}
