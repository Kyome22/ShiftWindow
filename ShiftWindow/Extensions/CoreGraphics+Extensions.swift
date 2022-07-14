//
//  CoreGraphics+Extensions.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2022/06/27.
//

import CoreGraphics

extension CGFloat {
    var half: CGFloat {
        return CGFloat(Double(self / 2.0).rounded())
    }

    var third: CGFloat {
        return CGFloat(Double(self / 3.0).rounded())
    }

    var twoThirds: CGFloat {
        return 2.0 * CGFloat(Double(self / 3.0).rounded())
    }
}
