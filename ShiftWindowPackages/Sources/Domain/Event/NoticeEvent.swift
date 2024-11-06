/*
 NoticeEvent.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import Logging

public enum NoticeEvent {
    case launchApp
    case screenView(name: String)

    public var message: Logger.Message {
        switch self {
        case .launchApp:
            "launch_app"
        case .screenView:
            "screen_view"
        }
    }

    public var metadata: Logger.Metadata? {
        switch self {
        case .launchApp:
            [:]
        case let .screenView(name):
            ["screen": .string(name)]
        }
    }
}
