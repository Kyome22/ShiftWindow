/*
 HIServicesClient.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
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
