/*
 HIServicesClient.swift
 DataSource

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

@preconcurrency import ApplicationServices.HIServices

public struct HIServicesClient: DependencyClient {
    public var trustedCheckOptionPrompt: @Sendable () -> Unmanaged<CFString>
    public var isProcessTrusted: @Sendable (CFDictionary?) -> Bool
    public var copyAttributeNames: @Sendable (AXUIElement, UnsafeMutablePointer<CFArray?>) -> AXError
    public var copyAttributeValue: @Sendable (AXUIElement, CFString, UnsafeMutablePointer<CFTypeRef?>) -> AXError
    public var setAttributeValue: @Sendable (AXUIElement, CFString, CFTypeRef) -> AXError
    public var valueCreate: @Sendable (AXValueType, UnsafeRawPointer) -> AXValue?

    public static let liveValue = Self(
        trustedCheckOptionPrompt: { kAXTrustedCheckOptionPrompt },
        isProcessTrusted: { AXIsProcessTrustedWithOptions($0) },
        copyAttributeNames: { AXUIElementCopyAttributeNames($0, $1) },
        copyAttributeValue: { AXUIElementCopyAttributeValue($0, $1, $2) },
        setAttributeValue: { AXUIElementSetAttributeValue($0, $1, $2) },
        valueCreate: { AXValueCreate($0, $1) }
    )

    public static let testValue = Self(
        trustedCheckOptionPrompt: { Unmanaged.passUnretained("" as CFString) },
        isProcessTrusted: { _ in false },
        copyAttributeNames: { _, _ in .failure },
        copyAttributeValue: { _, _, _ in .failure },
        setAttributeValue: { _, _, _ in .failure },
        valueCreate: { _, _ in nil }
    )
}
