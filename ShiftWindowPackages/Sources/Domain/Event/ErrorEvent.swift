/*
 ErrorEvent.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import Logging

public enum ErrorEvent {
    case none

    public var message: Logger.Message { "" }
    public var metadata: Logger.Metadata? { nil }
}
