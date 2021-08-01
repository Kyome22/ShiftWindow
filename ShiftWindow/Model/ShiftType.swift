//
//  ShiftType.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/07/31.
//

import Cocoa

enum ShiftType: Int {
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
        case .topHalf: return "shiftTopHalf"
        case .bottomHalf: return "shiftBottomHalf"
        case .leftHalf: return "shiftLeftHalf"
        case .rightHalf: return "shiftRighthalf"
        case .leftThird: return "shiftLeftThird"
        case .leftTwoThirds: return "shiftLeftTwoThirds"
        case .middleThird: return "shiftMiddleThird"
        case .rightTwoThirds: return "shiftRightThirds"
        case .rightThird: return "shiftRightThird"
        case .maximize: return "maximize"
        }
    }
    
    var title: String {
        self.id.localized
    }
    
    var image: NSImage {
        switch self {
        case .topHalf: return .windowTopHalf
        case .bottomHalf: return .windowBottomHalf
        case .leftHalf: return .windowLeftHalf
        case .rightHalf: return .windowRightHalf
        case .leftThird: return .windowLeftThird
        case .leftTwoThirds: return .windowLeftTwoThirds
        case .middleThird: return .windowMiddleThird
        case .rightTwoThirds: return .windowRightTwoThirds
        case .rightThird: return .windowRightThird
        case .maximize: return .windowMaximize
        }
    }
}
