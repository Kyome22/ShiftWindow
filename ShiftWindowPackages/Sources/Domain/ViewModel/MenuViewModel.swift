/*
 MenuViewModel.swift
 Domain

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

import DataLayer
import Foundation
import Observation

@MainActor @Observable public final class MenuViewModel {
    private let executeClient: ExecuteClient
    private let nsAppClient: NSAppClient
    private let logService: LogService
    private let shiftService: ShiftService
    private let updateService: UpdateService

    @ObservationIgnored private var task: Task<Void, Never>?

    public var patterns = [ShiftPattern]()
    public var hideIcons: Bool {
        didSet { toggleIconsVisible(hideIcons) }
    }
    public var canChecksForUpdates = false

    public init(
        _ executeClient: ExecuteClient,
        _ nsAppClient: NSAppClient,
        _ logService: LogService,
        _ shiftService: ShiftService,
        _ shortcutService: ShortcutService,
        _ updateService: UpdateService
    ) {
        self.executeClient = executeClient
        self.nsAppClient = nsAppClient
        self.logService = logService
        self.shiftService = shiftService
        self.updateService = updateService
        hideIcons = (try? executeClient.checkIconsVisible()) ?? false
        task = Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    for await value in await shortcutService.patternsStream() {
                        await MainActor.run {
                            self.patterns = value
                        }
                    }
                }
                group.addTask {
                    for await value in await updateService.canChecksForUpdatesStream() {
                        await MainActor.run {
                            self.canChecksForUpdates = value
                        }
                    }
                }
            }
        }
    }

    deinit {
        task?.cancel()
    }

    public func shiftWindow(shiftType: ShiftType) async {
        await shiftService.shiftWindow(shiftType: shiftType)
    }

    public func activateApp() {
        nsAppClient.activate(true)
    }

    public func checkForUpdates() async {
        await updateService.checkForUpdates()
    }

    public func openAbout() {
        nsAppClient.activate(true)
        nsAppClient.orderFrontStandardAboutPanel(nil)
    }

    public func terminateApp() {
        nsAppClient.terminate(nil)
    }

    func toggleIconsVisible(_ value: Bool) {
        Task.detached(priority: .background) {
            do {
                try self.executeClient.toggleIconsVisible(value)
            } catch {
                self.logService.critical(.failedExecuteScript(error))
            }
        }
    }
}
