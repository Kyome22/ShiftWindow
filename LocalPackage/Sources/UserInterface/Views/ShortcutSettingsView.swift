/*
 ShortcutSettingsView.swift
 UserInterface

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

import DataSource
import Model
import SpiceKey
import SwiftUI

struct ShortcutSettingsView: View {
    @StateObject var store: ShortcutSettings

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(store.shiftPatterns) { shiftPattern in
                LabeledContent {
                    HStack {
                        Spacer()
                        SpiceKeyField(keyCombination: Binding<KeyCombination?>(
                            get: { shiftPattern.keyCombination },
                            asyncSet: { await store.send(.onUpdateShortcut(shiftPattern, $0)) }
                        ))
                        .frame(width: 100)
                    }
                } label: {
                    Label {
                        Text(shiftPattern.label)
                    } icon: {
                        Image(shiftPattern.imageResource)
                    }
                }
                if shiftPattern.shiftType.needsDivider {
                    Divider()
                }
            }
            Divider()
            LabeledContent {
                Toggle(isOn: Binding<Bool>(
                    get: { store.showShortcutPanel },
                    asyncSet: { await store.send(.showShortcutPanelToggleSwitched($0)) }
                )) {
                    Text("enable", bundle: .module)
                }
            } label: {
                Text("showShortcutPanel", bundle: .module)
            }
        }
        .fixedSize()
        .task {
            await store.send(.task(String(describing: Self.self)))
        }
        .onDisappear {
            Task {
                await store.send(.onDisappear)
            }
        }
    }
}

extension ShortcutSettings: ObservableObject {}

#Preview {
    ShortcutSettingsView(store: .init(.testDependencies()))
}
