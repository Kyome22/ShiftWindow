/*
 ExecuteClient.swift
 Infrastructure

 Created by Takuto Nakamura on 2024/11/01.
 Copyright 2022 Takuto Nakamura (Kyome22)

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
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
