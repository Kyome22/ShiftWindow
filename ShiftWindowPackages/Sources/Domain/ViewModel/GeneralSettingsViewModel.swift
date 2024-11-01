/*
 GeneralSettingsViewModel.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import DataLayer
import Foundation
import Observation

@MainActor @Observable public final class GeneralSettingsViewModel {
    private let nsWorkspaceClient: NSWorkspaceClient
    private let launchAtLoginRepository: LaunchAtLoginRepository
    private let logService: LogService

    public var launchAtLoginIsEnabled: Bool {
        didSet { launchAtLoginSwitched(launchAtLoginIsEnabled) }
    }

    public init(
        _ nsWorkspaceClient: NSWorkspaceClient,
        _ launchAtLoginRepository: LaunchAtLoginRepository,
        _ logService: LogService
    ) {
        self.nsWorkspaceClient = nsWorkspaceClient
        self.launchAtLoginRepository = launchAtLoginRepository
        self.logService = logService
        launchAtLoginIsEnabled = launchAtLoginRepository.isEnabled
    }

    public func onAppear(screenName: String) {
        logService.notice(.screenView(name: screenName))
    }

    public func openSystemSettings() {
        let path = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        _ = nsWorkspaceClient.open(URL(string: path)!)
    }

    func launchAtLoginSwitched(_ isEnabled: Bool) {
        switch launchAtLoginRepository.switchStatus(isEnabled) {
        case .success:
            break
        case let .failure(.switchFailed(value)):
            launchAtLoginIsEnabled = value
        }
    }
}
