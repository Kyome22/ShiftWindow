/*
 ExecuteModel.swift
 ShiftWindow

 Created by Takuto Nakamura on 2024/09/01.
 
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
