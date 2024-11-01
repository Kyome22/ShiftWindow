/*
 CriticalEvent.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import Logging

public enum CriticalEvent {
    case failedExecuteScript(any Error)

    public var message: Logger.Message {
        switch self {
        case .failedExecuteScript:
            "Failed to execute script."
        }
    }

    public var metadata: Logger.Metadata? {
        switch self {
        case let .failedExecuteScript(error):
            ["cause": "\(error.localizedDescription)"]
        }
    }
}
