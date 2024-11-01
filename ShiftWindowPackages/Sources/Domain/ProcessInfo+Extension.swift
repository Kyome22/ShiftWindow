/*
 ProcessInfo+Extension.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import Foundation

extension ProcessInfo {
    static var needsResetUserDefaults: Bool {
        Self.processInfo.arguments.contains("ResetUserDefaults")
    }
}
