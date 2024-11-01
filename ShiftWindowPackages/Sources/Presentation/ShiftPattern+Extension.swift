/*
 ShiftPattern+Extension.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import DataLayer
import SwiftUI

extension ShiftPattern {
    var label: String {
        shiftType.label
    }

    var imageResource: ImageResource {
        shiftType.imageResource
    }

    var description: String {
        let str = spiceKeyData?.keyCombination?.string ?? "nil"
        return "type: \(label), spiceKeyData: \(str)"
    }
}
