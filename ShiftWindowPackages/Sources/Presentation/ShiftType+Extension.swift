/*
 ShiftType+Extension.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import DataLayer
import SwiftUI

extension ShiftType {
    var label: String {
        let localizationValue: String.LocalizationValue = switch self {
        case .topHalf:        "shiftTopHalf"
        case .bottomHalf:     "shiftBottomHalf"
        case .leftHalf:       "shiftLeftHalf"
        case .rightHalf:      "shiftRighthalf"
        case .leftThird:      "shiftLeftThird"
        case .leftTwoThirds:  "shiftLeftTwoThirds"
        case .middleThird:    "shiftMiddleThird"
        case .rightTwoThirds: "shiftRightThirds"
        case .rightThird:     "shiftRightThird"
        case .maximize:       "shiftMaximize"
        }
        return String(localized: localizationValue, bundle: .module)
    }

    var imageResource: ImageResource {
        switch self {
        case .topHalf:        .windowTopHalf
        case .bottomHalf:     .windowBottomHalf
        case .leftHalf:       .windowLeftHalf
        case .rightHalf:      .windowRightHalf
        case .leftThird:      .windowLeftThird
        case .leftTwoThirds:  .windowLeftTwoThirds
        case .middleThird:    .windowMiddleThird
        case .rightTwoThirds: .windowRightTwoThirds
        case .rightThird:     .windowRightThird
        case .maximize:       .windowMaximize
        }
    }

    var needsDivider: Bool {
        self == .rightHalf || self == .rightThird
    }
}
