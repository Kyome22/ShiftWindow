/*
 LogService.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import DataLayer
import Foundation
import Logging

public actor LogService {
    private var hasAlreadyBootstrap = false
    private let loggingSystemClient: LoggingSystemClient

    public init(_ loggingSystemClient: LoggingSystemClient) {
        self.loggingSystemClient = loggingSystemClient
    }

    public func bootstrap() {
        guard !hasAlreadyBootstrap else { return }
        #if DEBUG
        loggingSystemClient.bootstrap { label in
            StreamLogHandler.standardOutput(label: label)
        }
        #endif
        hasAlreadyBootstrap = true
    }

    public nonisolated func notice(
        _ event: NoticeEvent,
        source: @autoclosure () -> String? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        Logger(label: Bundle.main.bundleIdentifier!).notice(
            event.message,
            metadata: event.metadata,
            source: source(),
            file: file,
            function: function,
            line: line
        )
    }

    public nonisolated func error(
        _ event: ErrorEvent,
        source: @autoclosure () -> String? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        Logger(label: Bundle.main.bundleIdentifier!).error(
            event.message,
            metadata: event.metadata,
            source: source(),
            file: file,
            function: function,
            line: line
        )
    }

    public nonisolated func critical(
        _ event: CriticalEvent,
        source: @autoclosure () -> String? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line
    ) {
        Logger(label: Bundle.main.bundleIdentifier!).critical(
            event.message,
            metadata: event.metadata,
            source: source(),
            file: file,
            function: function,
            line: line
        )
    }
}
