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
        VStack(alignment: .leading, spacing: 8) {
            ForEach(viewModel.patterns, id: \.shiftType.id) { pattern in
                HStack(alignment: .center, spacing: 8) {
                    Image(pattern.imageResource)
                    wrapText(maxKey: "widthAnchor", key: pattern.titleKey)
                    SKTextField(id: pattern.shiftType.id,
                                initialKeyCombination: pattern.keyCombination)
                    .onRegistered { id, keyCombination in
                        if let id {
                            viewModel.updateShortcut(id: id, keyCombo: keyCombination)
                        }
                    }
                    .onDeleted { id in
                        if let id {
                            viewModel.removeShortcut(id: id)
                        }
                    }
                }
                if pattern.shiftType == .rightHalf || pattern.shiftType == .rightThird {
                    Divider()
                }
            }
            Divider()
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("showShortcutPanel:")
                Toggle(isOn: $viewModel.showShortcutPanel) {
                    Text("enable")
                }
            }
        }
        .frame(width: 240)
        .fixedSize()
    }
}

#Preview {
    ForEach(["en_US", "ja_JP"], id: \.self) { id in
        ShortcutSettingsView(viewModel: PreviewMock.ShortcutSettingsViewModelMock())
            .environment(\.locale, .init(identifier: id))
    }
}
