/*
 PreActionButtonStyle.swift
 UserInterface

 Created by Takuto Nakamura on 2024/09/01.
 Copyright 2024 Takuto Nakamura (Kyome22)

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

import SwiftUI

struct PreActionButtonStyle: PrimitiveButtonStyle {
    var preAction: () async -> Void

    init(preAction: @escaping () async -> Void) {
        self.preAction = preAction
    }

    func makeBody(configuration: Configuration) -> some View {
        Button(role: configuration.role) {
            Task {
                await preAction()
                configuration.trigger()
            }
        } label: {
            configuration.label
        }
    }
}

extension PrimitiveButtonStyle where Self == PreActionButtonStyle {
    static func preAction(perform action: @escaping () async -> Void) -> PreActionButtonStyle {
        PreActionButtonStyle(preAction: action)
    }
}
