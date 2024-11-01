/*
 UserDefaultsRepository.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import Foundation

public struct UserDefaultsRepository: Sendable {
    private let userDefaultsClient: UserDefaultsClient

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

    public init(_ userDefaultsClient: UserDefaultsClient, reset: Bool) {
        self.userDefaultsClient = userDefaultsClient

        #if DEBUG
        if reset {
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
