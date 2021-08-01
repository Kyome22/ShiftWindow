//
//  DataManager.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/07/31.
//

import Foundation
import ApplicationServices
import SpiceKey

fileprivate let RESET_USER_DEFAULTS = false

class DataManager {
    
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    
    var launchAtLogin: Bool {
        get { return userDefaults.bool(forKey: "launcher") }
        set { userDefaults.set(newValue, forKey: "launcher") }
    }
    
    var patterns: [ShiftPattern] {
        get {
            guard let data = self.userDefaults.data(forKey: "patterns"),
                  let obj = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            else { return [] }
            return obj as! [ShiftPattern]
        }
        set {
            if let data = try? NSKeyedArchiver.archivedData(withRootObject: newValue,
                                                            requiringSecureCoding: false) {
                self.userDefaults.set(data, forKey: "patterns")
            }
        }
    }
    
    private init() {
        #if DEBUG
        if RESET_USER_DEFAULTS {
            self.userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        }
        self.showAllData()
        #endif

        self.userDefaults.register(defaults: ["launcher": false])
        if self.patterns.isEmpty {
            self.patterns = ShiftPattern.defaults
        }
    }
    
    @discardableResult
    func checkPermissionAllowed() -> Bool {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        return AXIsProcessTrustedWithOptions(options)
    }
    
    private func showAllData() {
        if let dict = self.userDefaults.persistentDomain(forName: Bundle.main.bundleIdentifier!) {
            for (key, value) in dict.sorted(by: { $0.0 < $1.0 }) {
                Swift.print("\(key) => \(value)")
            }
        }
    }

}
