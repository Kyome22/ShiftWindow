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
    
    var id: String {
        switch self {
        case .topHalf:        return "shiftTopHalf"
        case .bottomHalf:     return "shiftBottomHalf"
        case .leftHalf:       return "shiftLeftHalf"
        case .rightHalf:      return "shiftRighthalf"
        case .leftThird:      return "shiftLeftThird"
        case .leftTwoThirds:  return "shiftLeftTwoThirds"
        case .middleThird:    return "shiftMiddleThird"
        case .rightTwoThirds: return "shiftRightThirds"
        case .rightThird:     return "shiftRightThird"
        case .maximize:       return "shiftMaximize"
        }
    }
    
    var titleKey: LocalizedStringKey {
        return LocalizedStringKey(id)
    }

    var imageResource: ImageResource {
        switch self {
        case .topHalf:        return .windowTopHalf
        case .bottomHalf:     return .windowBottomHalf
        case .leftHalf:       return .windowLeftHalf
        case .rightHalf:      return .windowRightHalf
        case .leftThird:      return .windowLeftThird
        case .leftTwoThirds:  return .windowLeftTwoThirds
        case .middleThird:    return .windowMiddleThird
        case .rightTwoThirds: return .windowRightTwoThirds
        case .rightThird:     return .windowRightThird
        case .maximize:       return .windowMaximize
        }
    }
}
