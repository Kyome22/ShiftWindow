//
//  GeneralPaneVC.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/08/01.
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
