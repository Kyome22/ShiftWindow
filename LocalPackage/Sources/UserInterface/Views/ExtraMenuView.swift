/*
 ExtraMenuView.swift
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

import DataSource
import Model
import SpiceKey
import SwiftUI

struct ExtraMenuView: View {
    @State var store: ExtraMenu

    var body: some View {
        VStack {
            ForEach(store.shiftPatterns) { shiftPattern in
                Button {
                    Task {
                        await store.send(.shiftPatternButtonTapped(shiftPattern.shiftType))
                    }
                } label: {
                    Label {
                        Text(shiftPattern.label)
                    } icon: {
                        Image(shiftPattern.imageResource)
                    }
                    .labelStyle(.titleAndIcon)
                }
                .keyboardShortcutIfPossible(shiftPattern.keyEquivalent, modifiers: shiftPattern.eventModifiers)
                if shiftPattern.shiftType.needsDivider {
                    Divider()
                }
            }
            Divider()
            Toggle(isOn: Binding<Bool>(
                get: { store.hideIcons },
                set: { newValue in
                    Task { await store.send(.hideDesktopIconsButtonTapped(newValue)) }
                }
            )) {
                Text("hideDesktopIcons", bundle: .module)
            }
            Divider()
            SettingsLink {
                Text("settings", bundle: .module)
            }
            .preActionButtonStyle {
                Task {
                    await store.send(.settingsButtonTapped)
                }
            }
            Divider()
            Button {
                Task {
                    await store.send(.checkForUpdatesButtonTapped)
                }
            } label: {
                Text("checkForUpdates", bundle: .module)
            }
            .disabled(!store.canChecksForUpdates)
            Button {
                Task {
                    await store.send(.aboutButtonTapped)
                }
            } label: {
                Text("aboutApp", bundle: .module)
            }
            Button {
                Task {
                    await store.send(.quitButtonTapped)
                }
            } label: {
                Text("quitApp", bundle: .module)
            }
        }
        .task {
            await store.send(.task(String(describing: Self.self)))
        }
    }
}

#Preview {
    ExtraMenuView(store: .init(.testDependencies()))
}
