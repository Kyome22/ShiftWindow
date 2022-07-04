//
//  ShiftPattern.swift
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

import Cocoa
import SwiftUI
import SpiceKey

final class ShiftPattern: NSObject, NSCoding {
    static let `defaults`: [ShiftPattern] = [
        ShiftPattern(type: .topHalf),
        ShiftPattern(type: .bottomHalf),
        ShiftPattern(type: .leftHalf),
        ShiftPattern(type: .rightHalf),
        ShiftPattern(type: .leftThird),
        ShiftPattern(type: .leftTwoThirds),
        ShiftPattern(type: .middleThird),
        ShiftPattern(type: .rightTwoThirds),
        ShiftPattern(type: .rightThird),
        ShiftPattern(type: .maximize)
    ]
    
    let type: ShiftType
    var spiceKeyData: SpiceKeyData?
    var titleKey: LocalizedStringKey {
        return self.type.titleKey
    }
    var title: String {
        return self.type.id.localized
    }
    var imageTitle: String {
        return self.type.imageTitle
    }
    var image: NSImage {
        return self.type.image
    }
    var keyString: String? {
        return self.spiceKeyData?.key?.string
    }    
    var modifierMask: NSEvent.ModifierFlags? {
        return self.spiceKeyData?.modifierFlags?.flags
    }
    var keyCombination: KeyCombination? {
        return self.spiceKeyData?.keyCombination
    }
    
    init(type: ShiftType) {
        self.type = type
    }
    
    required init?(coder: NSCoder) {
        self.type = ShiftType(rawValue: coder.decodeInteger(forKey: "type"))!
        self.spiceKeyData = coder.decodeObject(forKey: "spiceKeyData") as? SpiceKeyData
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.type.rawValue, forKey: "type")
        coder.encode(self.spiceKeyData, forKey: "spiceKeyData")
    }
    
    override var description: String {
        let str = self.spiceKeyData?.keyCombination?.string ?? "nil"
        return "type: \(self.titleKey), spiceKeyData: \(str)"
    }
}
