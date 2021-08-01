//
//  ShortcutsPaneVC.swift
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
import SpiceKey

class ShortcutsPaneVC: NSViewController {
    
    @IBOutlet weak var contentView: NSView!
    var originalSize = CGSize.zero
    private var spiceKeyFields = [SpiceKeyField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.originalSize = self.view.frame.size
        self.spiceKeyFields = self.contentView.subviews
            .sorted(by: { $0.tag < $1.tag })
            .compactMap({ view in
                if let spiceKeyField = view as? SpiceKeyField {
                    spiceKeyField.delegate = self
                    spiceKeyField.id = ShiftType(rawValue: view.tag)?.id
                    return spiceKeyField
                }
                return nil
            })
        let patterns = AppDelegate.shared.patterns
        assert(self.spiceKeyFields.count == patterns.count, "imposible")
        for i in (0 ..< patterns.count) {
            if let keyComboString = patterns[i].keyComboString {
                self.spiceKeyFields[i].setInitialSpiceKey(string: keyComboString)
            }
        }
    }
    
}

extension ShortcutsPaneVC: SpiceKeyFieldDelegate {
    
    func didRegisterSpiceKey(_ field: SpiceKeyField, _ key: Key, _ flags: ModifierFlags) {
        guard let id = field.id else { return }
        AppDelegate.shared.updateShortcut(id: id, key: key, flags: flags)
    }
    
    func didDelete(_ field: SpiceKeyField) {
        guard let id = field.id else { return }
        AppDelegate.shared.removeShortcut(id: id)
    }
    
}
