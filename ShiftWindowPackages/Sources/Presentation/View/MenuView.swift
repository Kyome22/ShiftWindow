/*
 MenuView.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import DataLayer
import Domain
import SpiceKey
import SwiftUI

struct MenuView: View {
    @State private var viewModel: MenuViewModel

    init(
        executeClient: ExecuteClient,
        nsAppClient: NSAppClient,
        logService: LogService,
        shiftService: ShiftService,
        shortcutService: ShortcutService
    ) {
        viewModel = .init(executeClient, nsAppClient, logService, shiftService, shortcutService)
    }

    var body: some View {
        VStack {
            ForEach(viewModel.patterns) { pattern in
                Button {
                    viewModel.shiftWindow(shiftType: pattern.shiftType)
                } label: {
                    Label {
                        Text(pattern.label)
                    } icon: {
                        Image(pattern.imageResource)
                    }
                    .labelStyle(.titleAndIcon)
                }
                .keyboardShortcutIfPossible(pattern.keyEquivalent, modifiers: pattern.eventModifiers)
                if pattern.shiftType.needsDivider {
                    Divider()
                }
            }
            Divider()
            Toggle(isOn: $viewModel.hideIcons) {
                Text("hideDesktopIcons", bundle: .module)
            }
            Divider()
            SettingsLink {
                Text("settings", bundle: .module)
            }
            .preActionButtonStyle {
                viewModel.activateApp()
            }
            Divider()
            Button {
                viewModel.openAbout()
            } label: {
                Text("aboutApp", bundle: .module)
            }
            Button {
                viewModel.terminateApp()
            } label: {
                Text("terminateApp", bundle: .module)
            }
        }
    }
}

#Preview {
    let shiftService = ShiftService(.testValue, .testValue, .testValue, .testValue)
    MenuView(
        executeClient: .testValue,
        nsAppClient: .testValue,
        logService: .init(.testValue),
        shiftService: shiftService,
        shortcutService: .init(.init(.testValue, reset: false), shiftService)
    )
}
