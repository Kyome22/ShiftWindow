//
//  ShiftDirection.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/07/31.
//

import Cocoa

enum ShiftPattern: Int {
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
    
    var title: String {
        switch self {
        case .topHalf: return "shiftTopHalf".localized
        case .bottomHalf: return "shiftBottomHalf".localized
        case .leftHalf: return "shiftLeftHalf".localized
        case .rightHalf: return "shiftRighthalf".localized
        case .leftThird: return "shiftLeftThird".localized
        case .leftTwoThirds: return "shiftLeftTwoThirds".localized
        case .middleThird: return "shiftMiddleThird".localized
        case .rightTwoThirds: return "shiftRightThirds".localized
        case .rightThird: return "shiftRightThird".localized
        case .maximize: return "maximize".localized
        }
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
