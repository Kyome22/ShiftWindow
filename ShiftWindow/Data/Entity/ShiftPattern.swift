/*
  ShiftPattern.swift
  ShiftWindow

  Created by Takuto Nakamura on 2021/07/31.
  Copyright 2021 Takuto Nakamura (Kyome22)

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/

import AppKit
import SwiftUI
import SpiceKey

struct ShiftPattern: Codable {
    enum CodingKeys: String, CodingKey {
        case shiftType
        case spiceKeyData
    }
    
    let shiftType: ShiftType
    var spiceKeyData: SpiceKeyData?

    var titleKey: LocalizedStringKey {
        return shiftType.titleKey
    }
    var title: String {
        return shiftType.id.localized
    }
    var imageTitle: String {
        return shiftType.imageTitle
    }
    var image: NSImage {
        return shiftType.image
    }
    var keyString: String? {
        return spiceKeyData?.key?.string
    }    
    var modifierMask: NSEvent.ModifierFlags? {
        return spiceKeyData?.modifierFlags?.flags
    }
    var keyCombination: KeyCombination? {
        return spiceKeyData?.keyCombination
    }
    var description: String {
        let str = spiceKeyData?.keyCombination?.string ?? "nil"
        return "type: \(titleKey), spiceKeyData: \(str)"
    }
    
    init(shiftType: ShiftType) {
        self.shiftType = shiftType
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shiftType = try container.decode(ShiftType.self, forKey: .shiftType)
        spiceKeyData = try container.decodeIfPresent(SpiceKeyData.self, forKey: .spiceKeyData)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shiftType, forKey: .shiftType)
        try container.encodeIfPresent(spiceKeyData, forKey: .spiceKeyData)
    }

    static let `defaults`: [ShiftPattern] = [
        ShiftPattern(shiftType: .topHalf),
        ShiftPattern(shiftType: .bottomHalf),
        ShiftPattern(shiftType: .leftHalf),
        ShiftPattern(shiftType: .rightHalf),
        ShiftPattern(shiftType: .leftThird),
        ShiftPattern(shiftType: .leftTwoThirds),
        ShiftPattern(shiftType: .middleThird),
        ShiftPattern(shiftType: .rightTwoThirds),
        ShiftPattern(shiftType: .rightThird),
        ShiftPattern(shiftType: .maximize)
    ]
}
