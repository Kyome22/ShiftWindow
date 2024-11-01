/*
 MenuViewModel.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
*/

import DataLayer
import Foundation
import Observation

@MainActor @Observable public final class MenuViewModel {
    private let executeClient: ExecuteClient
    private let nsAppClient: NSAppClient
    private let logService: LogService
    private let shiftService: ShiftService

    @ObservationIgnored private var task: Task<Void, Never>?

    public var patterns = [ShiftPattern]()
    public var hideIcons: Bool {
        didSet { toggleIconsVisible(hideIcons) }
    }

    public init(
        _ executeClient: ExecuteClient,
        _ nsAppClient: NSAppClient,
        _ logService: LogService,
        _ shiftService: ShiftService,
        _ shortcutService: ShortcutService
    ) {
        self.executeClient = executeClient
        self.nsAppClient = nsAppClient
        self.logService = logService
        self.shiftService = shiftService
        hideIcons = (try? executeClient.checkIconsVisible()) ?? false
        task = Task {
            for await patterns in await shortcutService.patternsStream() {
                self.patterns = patterns
            }
        }
    }

    deinit {
        task?.cancel()
    }

    public func shiftWindow(shiftType: ShiftType) {
        Task {
            await shiftService.shiftWindow(shiftType: shiftType)
        }
    }

    public func activateApp() {
        nsAppClient.activate(true)
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
