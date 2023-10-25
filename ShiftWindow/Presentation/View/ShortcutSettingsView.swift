/*
 ShortcutSettingsView.swift
 ShiftWindow

 Created by Takuto Nakamura on 2022/06/27.
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

import SwiftUI
import SpiceKey

struct ShortcutSettingsView<SVM: ShortcutSettingsViewModel>: View {
    @StateObject var viewModel: SVM

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.patterns, id: \.shiftType.id) { pattern in
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
                        Text(pattern.titleKey)
                    } icon: {
                        Image(pattern.imageResource)
                    }
                }
                if pattern.shiftType == .rightHalf || pattern.shiftType == .rightThird {
                    Divider()
                }
            }
            Divider()
            LabeledContent("showShortcutPanel:") {
                Toggle(isOn: $viewModel.showShortcutPanel) {
                    Text("enable")
                }
            }
        }
        .fixedSize()
    }
}

#Preview {
    ForEach(["en_US", "ja_JP"], id: \.self) { id in
        ShortcutSettingsView(viewModel: PreviewMock.ShortcutSettingsViewModelMock())
            .environment(\.locale, .init(identifier: id))
    }
}
