/*
 Composable.swift
 Model

 Created by Takuto Nakamura on 2025/08/13.
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

import Observation

@MainActor
public protocol Composable: AnyObject {
    associatedtype Action: Sendable

    var action: (Action) async -> Void { get }

    func reduce(_ action: Action) async
}

public extension Composable {
    func reduce(_ action: Action) async {}

    func send(_ action: Action) async {
        await self.action(action)
        await reduce(action)
    }
}
