//
//  ShortcutSettingsView.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2022/06/27.
//

import SwiftUI
import SpiceKey

struct ShortcutSettingsView: View {
    @EnvironmentObject private var appDelegate: AppDelegate

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(appDelegate.patterns, id: \.type.id) { pattern in
                HStack(alignment: .center, spacing: 8) {
                    Image(pattern.imageTitle)
                    wrapText(pattern.titleKey)
                    SKTextField(id: pattern.type.id,
                                initialKeyCombination: pattern.keyCombination)
                    .onRegistered { id, keyCombination in
                        guard let id = id else { return }
                        appDelegate.updateShortcut(id: id, keyCombo: keyCombination)
                    }
                    .onDeleted { id in
                        guard let id = id else { return }
                        appDelegate.removeShortcut(id: id)
                    }
                }
                if pattern.type == .rightHalf || pattern.type == .rightThird {
                    Divider()
                }
            }
        }
        .frame(width: 240)
        .fixedSize()
    }

    private func wrapText(_ key: LocalizedStringKey) -> some View {
        return Text("widthAnchor")
            .hidden()
            .overlay(alignment: .leading) {
                Text(key)
            }
            .fixedSize()
    }
}

struct ShortcutSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutSettingsView()
    }
}
