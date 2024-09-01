/*
 MenuViewModel.swift
 ShiftWindow

 Created by Takuto Nakamura on 2023/10/24.
 Copyright 2023 Takuto Nakamura (Kyome22)

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

import AppKit
import SwiftUI

@MainActor protocol MenuViewModel: ObservableObject {
    var patterns: [ShiftPattern] { get set }
    var hideIcons: Bool { get set }

    init(_ shiftModel: ShiftModel,
         _ shortcutModel: ShortcutModel,
         _ windowModel: WindowModel)

    func shiftWindow(shiftType: ShiftType)
    func activateApp()
    func openAbout()
    func terminateApp()
}

final class MenuViewModelImpl<EM: ExecuteModel>: MenuViewModel {
    @Published var patterns = [ShiftPattern]()
    @Published var hideIcons: Bool {
        didSet {
            EM.toggleIconsVisible(hideIcons)
        }
    }

    private let shiftModel: ShiftModel
    private let windowModel: WindowModel
    private var task: Task<Void, Never>?

    init(
        _ shiftModel: ShiftModel,
        _ shortcutModel: ShortcutModel,
        _ windowModel: WindowModel
    ) {
        self.shiftModel = shiftModel
        self.windowModel = windowModel
        self.hideIcons = EM.checkIconsVisible()

        task = Task {
            for await patterns in shortcutModel.patternsStream() {
                self.patterns = patterns
            }
        }
    }

    deinit {
        task?.cancel()
    }

    func shiftWindow(shiftType: ShiftType) {
        shiftModel.shiftWindow(shiftType: shiftType)
    }

    func activateApp() {
        NSApp.activate(ignoringOtherApps: true)
    }

    func openAbout() {
        windowModel.openAbout()
    }

    func terminateApp() {
        NSApp.terminate(nil)
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class MenuViewModelMock: MenuViewModel {
        @Published var patterns = [ShiftPattern]()
        @Published var hideIcons: Bool = false

        init(_ shiftModel: ShiftModel,
             _ shortcutModel: ShortcutModel,
             _ windowModel: WindowModel) {}
        init() {}

        func shiftWindow(shiftType: ShiftType) {}
        func activateApp() {}
        func openAbout() {}
        func terminateApp() {}
    }
}
