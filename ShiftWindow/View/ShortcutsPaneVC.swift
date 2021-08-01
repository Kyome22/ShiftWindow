//
//  ShortcutsPaneVC.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/08/01.
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
