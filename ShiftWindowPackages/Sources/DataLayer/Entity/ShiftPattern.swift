/*
 ShiftPattern.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import SpiceKey
import SwiftUI

public struct ShiftPattern: Codable, Identifiable, Sendable {
    enum CodingKeys: String, CodingKey {
        case shiftType
        case spiceKeyData
    }

    public let shiftType: ShiftType
    public var spiceKeyData: SpiceKeyData?

    public var id: ShiftType { shiftType }

    public var keyEquivalent: KeyEquivalent? {
        spiceKeyData?.key?.keyEquivalent
    }

    public var eventModifiers: EventModifiers? {
        spiceKeyData?.modifierFlags?.eventModifiers
    }

    public var keyCombination: KeyCombination? {
        spiceKeyData?.keyCombination
    }

    public init(shiftType: ShiftType) {
        self.shiftType = shiftType
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shiftType = try container.decode(ShiftType.self, forKey: .shiftType)
        spiceKeyData = try container.decodeIfPresent(SpiceKeyData.self, forKey: .spiceKeyData)
    }

    public func encode(to encoder: any Encoder) throws {
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
