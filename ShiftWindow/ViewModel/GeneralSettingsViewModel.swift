//
//  GeneralSettingsViewModel.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2022/06/27.
//

import AppKit
import ServiceManagement

fileprivate let HELPER_APP_ID = "com.kyome.ShiftWindowLauncher"

final class GeneralSettingsViewModel: ObservableObject {
    private var innerLaunchAtLogin: Bool
    @Published var launchAtLogin: Bool 

    init() {
        let jobDicts = SMCopyAllJobDictionaries(kSMDomainUserLaunchd)
            .takeRetainedValue() as NSArray as! [[String:AnyObject]]
        innerLaunchAtLogin = jobDicts.contains { dict in
            return dict["Label"] as! String == HELPER_APP_ID
        }
        launchAtLogin = innerLaunchAtLogin
    }

    func toggleLaunchAtLogin(_ newValue: Bool) {
        if newValue == innerLaunchAtLogin {
            return
        }
        if SMLoginItemSetEnabled(HELPER_APP_ID as CFString, newValue) {
            innerLaunchAtLogin = newValue
        } else {
            launchAtLogin = innerLaunchAtLogin
        }
    }

    func openSystemPreferences() {
        let path = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        NSWorkspace.shared.open(URL(string: path)!)
    }
}
