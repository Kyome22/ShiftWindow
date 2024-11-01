/*
 File.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import Foundation

public enum ShiftType: Int, Codable, Identifiable, Sendable, CaseIterable {
    case topHalf
    case bottomHalf
    case leftHalf
    case rightHalf
    case leftThird
    case leftTwoThirds
    case middleThird
    case rightTwoThirds
    case rightThird
    case maximize

    public var id: String { String(describing: self) }
}
