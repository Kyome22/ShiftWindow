//
//  ShiftPattern.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/07/31.
//

import Cocoa
import SpiceKey

class ShiftPattern: NSObject, NSCoding {
    
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
    var title: String { return self.type.title }
    var image: NSImage { return self.type.image }
    var keyString: String? {
        return self.spiceKeyData?.key?.string
    }    
    var modifierMask: NSEvent.ModifierFlags? {
        return self.spiceKeyData?.modifierFlags?.flags
    }
    var keyComboString: String? {
        return self.spiceKeyData?.keyCombination?.string
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
        return "type: \(self.title), spiceKeyData: \(str)"
    }
    
}
