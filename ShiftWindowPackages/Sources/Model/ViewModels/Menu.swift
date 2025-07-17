/*
 Menu.swift
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
import Infrastructure
import Observation

@MainActor @Observable public final class Menu {
    private let appStateClient: AppStateClient
    private let executeClient: ExecuteClient
    private let nsAppClient: NSAppClient
    private let logService: LogService
    private let shiftService: ShiftService
    private let shortcutService: ShortcutService
    private let updateService: UpdateService

    @ObservationIgnored private var task: Task<Void, Never>?

    public var patterns = [ShiftPattern]()
    public var hideIcons: Bool
    public var canChecksForUpdates = false

    public init(_ appDependencies: AppDependencies) {
        self.appStateClient = appDependencies.appStateClient
        self.executeClient = appDependencies.executeClient
        self.nsAppClient = appDependencies.nsAppClient
        self.logService = .init(appDependencies)
        self.shiftService = .init(appDependencies)
        self.shortcutService = .init(appDependencies)
        self.updateService = .init(appDependencies)
        hideIcons = (try? executeClient.checkIconsVisible()) ?? false
        task = Task { [weak self, appStateClient, updateService] in
            await withTaskGroup(of: Void.self) { group in
                group.addTask { @MainActor @Sendable in
                    let values = appStateClient.withLock(\.shiftPatternsSubject.values)
                    for await value in values {
                        self?.updatePatterns(value)
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
    }

    private func updatePatterns(_ patterns: [ShiftPattern]) {
        self.patterns = patterns
    }

    private func updateCanChecksForUpdates(_ canChecksForUpdates: Bool) {
        self.canChecksForUpdates = canChecksForUpdates
    }

    public func shiftWindow(shiftType: ShiftType) async {
        await Task { @MainActor [shiftService] in
            await shiftService.shiftWindow(shiftType: shiftType)
        }.value
    }

    public func activateApp() {
        nsAppClient.activate(true)
    }

    public func checkForUpdates() {
        updateService.checkForUpdates()
    }

    public func openAbout() {
        nsAppClient.activate(true)
        nsAppClient.orderFrontStandardAboutPanel(nil)
    }

    public func terminateApp() {
        nsAppClient.terminate(nil)
    }

    public func toggleIconsVisible(_ value: Bool) {
        do {
            try executeClient.toggleIconsVisible(value)
            hideIcons = value
        } catch {
            logService.critical(.failedExecuteScript(error))
        }
    }
}
