/*
 ShortcutSettingsView.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
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
