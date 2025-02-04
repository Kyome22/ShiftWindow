/*
 GeneralSettingsViewModel.swift
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

@MainActor @Observable public final class GeneralSettingsViewModel {
    private let nsWorkspaceClient: NSWorkspaceClient
    private let checkForUpdatesRepository: CheckForUpdatesRepository
    private let launchAtLoginRepository: LaunchAtLoginRepository
    private let logService: LogService

    public var launchAtLogin: Bool
    public var checkForUpdates: Bool

    public init(
        _ nsWorkspaceClient: NSWorkspaceClient,
        _ spuUpdaterClient: SPUUpdaterClient,
        _ smAppServiceClient: SMAppServiceClient,
        _ logService: LogService
    ) {
        self.nsWorkspaceClient = nsWorkspaceClient
        self.checkForUpdatesRepository = .init(spuUpdaterClient)
        self.launchAtLoginRepository = .init(smAppServiceClient)
        self.logService = logService
        launchAtLogin = launchAtLoginRepository.isEnabled
        checkForUpdates = checkForUpdatesRepository.isEnabled
    }

    public func onAppear(screenName: String) {
        logService.notice(.screenView(name: screenName))
    }

    public func openSystemSettings() {
        let path = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        _ = nsWorkspaceClient.open(URL(string: path)!)
    }

    public func toggleLaunchAtLogin(_ isOn: Bool) {
        switch launchAtLoginRepository.switchStatus(isOn) {
        case .success:
            launchAtLogin = isOn
        case let .failure(.switchFailed(value)):
            launchAtLogin = value
        }
    }

    public func toggleCheckForUpdates(_ isOn: Bool) {
        checkForUpdates = isOn
        checkForUpdatesRepository.switchStatus(isOn)
    }
}
