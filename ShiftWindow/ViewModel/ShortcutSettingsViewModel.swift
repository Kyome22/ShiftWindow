//
//  ShortcutSettingsViewModel.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2022/07/15.
//

import Foundation

final class ShortcutSettingsViewModel: ObservableObject {
    @Published var showShortcutPanel: Bool {
        didSet {
            DataManager.shared.showShortcutPanel = showShortcutPanel
        }
    }

    init() {
        showShortcutPanel = DataManager.shared.showShortcutPanel
    }
}
