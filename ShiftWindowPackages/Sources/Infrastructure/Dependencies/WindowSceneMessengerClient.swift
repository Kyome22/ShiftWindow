/*
 WindowSceneMessengerClient.swift
 Infrastructure

 Created by Takuto Nakamura on 2025/01/07.
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

import WindowSceneKit

public struct WindowSceneMessengerClient: DependencyClient {
    public var request: @Sendable (WindowAction, String, [String: any Sendable]) -> Void

    public static let liveValue = Self(
        request: { WindowSceneMessenger.request(windowAction: $0, windowKey: $1, supplements: $2) }
    )

    public static let testValue = Self(
        request: { _, _, _ in }
    )
}
