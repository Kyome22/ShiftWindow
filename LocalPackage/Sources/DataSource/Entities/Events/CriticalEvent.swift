/*
 CriticalEvent.swift
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
