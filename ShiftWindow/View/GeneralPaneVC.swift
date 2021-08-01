//
//  GeneralPaneVC.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/08/01.
//
//  Copyright 2021 Takuto Nakamura (Kyome22)
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Cocoa
import ServiceManagement

class GeneralPaneVC: NSViewController {

    @IBOutlet weak var launchAtLoginCheckBox: NSButton!
    var originalSize = CGSize.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.originalSize = self.view.frame.size
        self.launchAtLoginCheckBox.state = DataManager.shared.launchAtLogin.state
    }
    
    @IBAction func toggleLaunchAtLogin(_ sender: NSButton) {
        let launcherAppID = "com.kyome.ShiftWindowLauncher"
        let flag = sender.state.isOn
        if SMLoginItemSetEnabled(launcherAppID as CFString, flag) {
            DataManager.shared.launchAtLogin = flag
        } else {
            sender.state = DataManager.shared.launchAtLogin.state
        }
    }
    
    @IBAction func pushOpenSystemPreferences(_ sender: Any) {
        let path = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
        NSWorkspace.shared.open(URL(string: path)!)
    }
    
}
