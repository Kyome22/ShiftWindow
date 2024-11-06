/*
 ShortcutSettingsView.swift
 Presentation

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

import DataLayer
import Domain
import SpiceKey
import SwiftUI

struct ShortcutSettingsView: View {
    @State private var viewModel: ShortcutSettingsViewModel

    init(
        userDefaultsRepository: UserDefaultsRepository,
        logService: LogService,
        shortcutService: ShortcutService
    ) {
        viewModel = .init(userDefaultsRepository, logService, shortcutService)
    }

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.patterns) { pattern in
                LabeledContent {
                    HStack {
                        Spacer()
                        SKTextField(
                            id: pattern.shiftType.id,
                            initialKeyCombination: pattern.keyCombination
                        )
                        .onRegistered { id, keyCombination in
                            viewModel.updateShortcut(id: id, keyCombo: keyCombination)
                        }
                        .onDeleted { id in
                            viewModel.removeShortcut(id: id)
                        }
                        .frame(width: 100)
                    }
                } label: {
                    Label {
                        Text(pattern.label)
                    } icon: {
                        Image(pattern.imageResource)
                    }
                }
                if pattern.shiftType.needsDivider {
                    Divider()
                }
            }
            Divider()
            LabeledContent {
                Toggle(isOn: $viewModel.showShortcutPanel) {
                    Text("enable", bundle: .module)
                }
            } label: {
                Text("showShortcutPanel", bundle: .module)
            }
        }
        .fixedSize()
        .onAppear {
            viewModel.onAppear(screenName: String(describing: Self.self))
        }
    }
}

#Preview {
    let userDefaultsRepository = UserDefaultsRepository(.testValue, reset: false)
    let shiftService = ShiftService(.testValue, .testValue, .testValue, .testValue)
    ShortcutSettingsView(
        userDefaultsRepository: userDefaultsRepository,
        logService: .init(.testValue),
        shortcutService: .init(userDefaultsRepository, shiftService)
    )
}
