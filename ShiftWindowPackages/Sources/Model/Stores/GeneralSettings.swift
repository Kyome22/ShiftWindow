/*
 GeneralSettings.swift
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

@MainActor @Observable public final class GeneralSettings {
    private let nsWorkspaceClient: NSWorkspaceClient
    private let checkForUpdatesRepository: CheckForUpdatesRepository
    private let launchAtLoginRepository: LaunchAtLoginRepository
    private let logService: LogService

    public var launchAtLogin: Bool
    public var checkForUpdates: Bool

    public init(_ appDependencies: AppDependencies) {
        self.nsWorkspaceClient = appDependencies.nsWorkspaceClient
        self.checkForUpdatesRepository = .init(appDependencies.spuUpdaterClient)
        self.launchAtLoginRepository = .init(appDependencies.smAppServiceClient)
        self.logService = .init(appDependencies)
        launchAtLogin = launchAtLoginRepository.isEnabled
        checkForUpdates = checkForUpdatesRepository.isEnabled
    }

    public func send(_ action: Action) {
        switch action {
        case .onAppear(let screenName):
            logService.notice(.screenView(name: screenName))

        case .openSystemSettingsButtonTapped:
            let path = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
            _ = nsWorkspaceClient.open(URL(string: path)!)

        case .launchAtLoginToggleSwitched(let isOn):
            switch launchAtLoginRepository.switchStatus(isOn) {
            case .success:
                launchAtLogin = isOn
            case let .failure(.switchFailed(value)):
                launchAtLogin = value
            }

        case .checkForUpdatesToggleSwitched(let isOn):
            checkForUpdates = isOn
            checkForUpdatesRepository.switchStatus(isOn)
        }
    }

    public enum Action {
        case onAppear(String)
        case openSystemSettingsButtonTapped
        case launchAtLoginToggleSwitched(Bool)
        case checkForUpdatesToggleSwitched(Bool)
    }
}
