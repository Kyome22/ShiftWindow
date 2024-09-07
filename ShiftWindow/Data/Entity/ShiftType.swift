/*
 ShiftType.swift
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

enum ShiftType: Int, Codable, Identifiable, CaseIterable {
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
    
    var id: String { String(describing: self) }

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
        return String(localized: localizationValue)
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
}
