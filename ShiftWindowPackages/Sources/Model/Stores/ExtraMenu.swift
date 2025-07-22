/*
 ExtraMenu.swift
 Model

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

import Foundation
import DataSource
import Observation

@MainActor @Observable public final class ExtraMenu {
    private let appStateClient: AppStateClient
    private let executeClient: ExecuteClient
    private let nsAppClient: NSAppClient
    private let logService: LogService
    private let shiftService: ShiftService
    private let shortcutService: ShortcutService
    private let updateService: UpdateService

    @ObservationIgnored private var task: Task<Void, Never>?

    public var shiftPatterns: [ShiftPattern]
    public var hideIcons: Bool
    public var canChecksForUpdates: Bool

    public init(
        _ appDependencies: AppDependencies,
        shiftPatterns: [ShiftPattern] = [],
        hideIcons: Bool = false,
        canChecksForUpdates: Bool = false
    ) {
        self.appStateClient = appDependencies.appStateClient
        self.executeClient = appDependencies.executeClient
        self.nsAppClient = appDependencies.nsAppClient
        self.logService = .init(appDependencies)
        self.shiftService = .init(appDependencies)
        self.shortcutService = .init(appDependencies)
        self.updateService = .init(appDependencies)
        self.shiftPatterns = shiftPatterns
        self.hideIcons = (try? executeClient.checkIconsVisible()) ?? hideIcons
        self.canChecksForUpdates = canChecksForUpdates
    }

    public func send(_ action: Action) async {
        switch action {
        case .task(let screenName):
            logService.notice(.screenView(name: screenName))
            task = Task { [weak self, appStateClient, updateService] in
                await withTaskGroup(of: Void.self) { group in
                    group.addTask { @MainActor @Sendable in
                        let values = appStateClient.withLock(\.shiftPatternsSubject.values)
                        for await value in values {
                            self?.updateShiftPatterns(value)
                        }
                    }
                    group.addTask { @MainActor @Sendable in
                        let values = updateService.canChecksForUpdates
                        for await value in values {
                            self?.updateCanChecksForUpdates(value)
                        }
                    }
                }
            }

        case .shiftPatternButtonTapped(let shiftType):
            await Task { @MainActor [shiftService] in
                await shiftService.shiftWindow(shiftType: shiftType)
            }.value

        case .hideDesktopIconsButtonTapped(let isOn):
            do {
                try executeClient.toggleIconsVisible(isOn)
                hideIcons = isOn
            } catch {
                logService.critical(.failedExecuteScript(error))
            }

        case .checkForUpdatesButtonTapped:
            updateService.checkForUpdates()

        case .settingsButtonTapped:
            nsAppClient.activate(true)

        case .aboutButtonTapped:
            nsAppClient.activate(true)
            nsAppClient.orderFrontStandardAboutPanel(nil)

        case .quitButtonTapped:
            nsAppClient.terminate(nil)
        }
    }

    private func updateShiftPatterns(_ shiftPatterns: [ShiftPattern]) {
        self.shiftPatterns = shiftPatterns
    }

    private func updateCanChecksForUpdates(_ canChecksForUpdates: Bool) {
        self.canChecksForUpdates = canChecksForUpdates
    }

    public enum Action {
        case task(String)
        case shiftPatternButtonTapped(ShiftType)
        case hideDesktopIconsButtonTapped(Bool)
        case checkForUpdatesButtonTapped
        case settingsButtonTapped
        case aboutButtonTapped
        case quitButtonTapped
    }
}
