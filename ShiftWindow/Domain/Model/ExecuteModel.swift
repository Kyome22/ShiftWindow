/*
 ExecuteModel.swift
 ShiftWindow

 Created by Takuto Nakamura on 2024/09/01.
 Copyright 2024 Takuto Nakamura (Kyome22)

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

protocol ExecuteModel {
    static func checkIconsVisible() -> Bool
    static func toggleIconsVisible(_ hideIcons: Bool)
}

struct ExecuteModelImpl: ExecuteModel {
    static func checkIconsVisible() -> Bool {
        let shell = Process()
        let pipe = Pipe()
        shell.launchPath = "/bin/sh"
        shell.arguments = ["-c", .createDesktopRead]
        shell.standardOutput = pipe
        do {
            try shell.run()
            shell.waitUntilExit()
            if shell.terminationStatus == 0,
               let data = try pipe.fileHandleForReading.readToEnd(),
               let str = String(data: data, encoding: .utf8),
               str.trimmingCharacters(in: .newlines) == "0" {
                return true
            }
        } catch {
            logput(error.localizedDescription)
        }
        return false
    }

    static func toggleIconsVisible(_ hideIcons: Bool) {
        Task.detached(priority: .background) {
            let args: String = hideIcons ? .createDesktopWriteFalse : .createDesktopDelete
            let shell = Process()
            shell.launchPath = "/bin/sh"
            shell.arguments = ["-c", args]
            do {
                try shell.run()
                shell.waitUntilExit()
            } catch {
                logput(error.localizedDescription)
            }
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    struct ExecuteModelMock: ExecuteModel {
        static func checkIconsVisible() -> Bool { false }
        static func toggleIconsVisible(_ hideIcons: Bool) {}
    }
}
