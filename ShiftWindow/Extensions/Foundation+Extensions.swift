//
//  Foundation+Extensions.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2022/06/27.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }

    var bundleString: String? {
        return Bundle.main.object(forInfoDictionaryKey: self) as? String
    }
}

extension Array {
    subscript (safe index: Index) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}
