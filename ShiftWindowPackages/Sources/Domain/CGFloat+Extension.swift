/*
 CGFloat+Extension.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

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
