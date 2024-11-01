/*
 ExecuteClient.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import Foundation

public struct ExecuteClient: DependencyClient {
    public var checkIconsVisible: @Sendable () throws -> Bool
    public var toggleIconsVisible: @Sendable (Bool) throws -> Void

    public static let liveValue = Self(
        checkIconsVisible: {
            let shell = Process()
            let pipe = Pipe()
            shell.launchPath = "/bin/sh"
            shell.arguments = ["-c", .createDesktopRead]
            shell.standardOutput = pipe
            try shell.run()
            shell.waitUntilExit()
            guard shell.terminationStatus == 0,
                  let data = try pipe.fileHandleForReading.readToEnd(),
                  let str = String(data: data, encoding: .utf8),
                  str.trimmingCharacters(in: .newlines) == "0" else {
                return false
            }
            return true
        },
        toggleIconsVisible: {
            let shell = Process()
            shell.launchPath = "/bin/sh"
            shell.arguments = ["-c", $0 ? .createDesktopWriteFalse : .createDesktopDelete]
            try shell.run()
            shell.waitUntilExit()
        }
    )

    public static let testValue = Self(
        checkIconsVisible: { false },
        toggleIconsVisible: { _ in }
    )
}
