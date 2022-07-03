//
//  DataManager.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/07/31.
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

import Foundation
import ApplicationServices
import SpiceKey

fileprivate let RESET_USER_DEFAULTS = false

final class DataManager {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    
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
