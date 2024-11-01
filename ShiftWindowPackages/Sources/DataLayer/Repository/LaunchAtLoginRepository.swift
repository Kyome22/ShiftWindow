/*
 File.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import Foundation

public struct LaunchAtLoginRepository: Sendable {
    private let smAppServiceClient: SMAppServiceClient

    public var isEnabled: Bool {
        smAppServiceClient.status() == .enabled
    }

    public init(_ smAppServiceClient: SMAppServiceClient) {
        self.smAppServiceClient = smAppServiceClient
    }

    public func switchStatus(_ isEnabled: Bool) -> Result<Void, LaunchAtLoginError> {
        let switchSucceeded: Bool = {
            do {
                if isEnabled {
                    try smAppServiceClient.register()
                } else {
                    try smAppServiceClient.unregister()
                }
                return true
            } catch {
                return false
            }
        }()
        let value = self.isEnabled
        return if switchSucceeded, value == isEnabled {
            .success(())
        } else {
            .failure(.switchFailed(value))
        }
    }
}
