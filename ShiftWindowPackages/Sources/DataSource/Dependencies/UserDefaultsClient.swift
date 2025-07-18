/*
 UserDefaultsClient.swift
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

public struct UserDefaultsClient: DependencyClient {
    var bool: @Sendable (String) -> Bool
    var setBool: @Sendable (Bool, String) -> Void
    var data: @Sendable (String) -> Data?
    var setData: @Sendable (Data?, String) -> Void
    var removePersistentDomain: @Sendable (String) -> Void
    var persistentDomain: @Sendable (String) -> [String : Any]?

    public static let liveValue = Self(
        bool: { UserDefaults.standard.bool(forKey: $0) },
        setBool: { UserDefaults.standard.set($0, forKey: $1) },
        data: { UserDefaults.standard.data(forKey: $0) },
        setData: { UserDefaults.standard.set($0, forKey: $1) },
        removePersistentDomain: { UserDefaults.standard.removePersistentDomain(forName: $0) },
        persistentDomain: { UserDefaults.standard.persistentDomain(forName: $0) }
    )

    public static let testValue = Self(
        bool: { _ in false },
        setBool: { _, _ in },
        data: { _ in nil },
        setData: { _, _ in },
        removePersistentDomain: { _ in },
        persistentDomain: { _ in nil }
    )
}

extension UserDefaults: @retroactive @unchecked Sendable {}
