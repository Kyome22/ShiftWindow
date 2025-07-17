/*
 ShiftService.swift
 Domain

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

import AppKit
import LegacyDataLayer
import Foundation

public actor ShiftService {
    private let cgDirectDisplayClient: CGDirectDisplayClient
    private let hiServicesClient: HIServicesClient
    private let nsAppClient: NSAppClient
    private let nsScreenClient: NSScreenClient
    private let nsWorkspaceClient: NSWorkspaceClient

    public init(
        _ cgDirectDisplayClient: CGDirectDisplayClient,
        _ hiServicesClient: HIServicesClient,
        _ nsAppClient: NSAppClient,
        _ nsScreenClient: NSScreenClient,
        _ nsWorkspaceClient: NSWorkspaceClient
    ) {
        self.cgDirectDisplayClient = cgDirectDisplayClient
        self.hiServicesClient = hiServicesClient
        self.nsAppClient = nsAppClient
        self.nsScreenClient = nsScreenClient
        self.nsWorkspaceClient = nsWorkspaceClient
    }

    func shiftWindow(shiftType: ShiftType) async {
        guard let app = nsWorkspaceClient.runningApplications().first(where: { $0.isActive }),
              app.bundleIdentifier != Bundle.main.bundleIdentifier,
              let window = getFocusedWindow(pid: app.processIdentifier),
              let role = getRole(element: window),
              role == kAXWindowRole,
              let subRole = getSubRole(element: window),
              subRole == kAXStandardWindowSubrole,
              !isFullscreen(element: window) else {
            return
        }
        // override new frame to window
        guard let validFrame = await getValidFrame(),
              let newFrame = makeNewFrame(shiftType: shiftType, validFrame: validFrame) else {
            return
        }
        setPosition(element: window, position: newFrame.origin)
        setSize(element: window, size: newFrame.size)
    }

    func getValidFrame() async -> CGRect? {
        guard let screen = nsScreenClient.mainScreen() else { return nil }
        let bounds = cgDirectDisplayClient.bounds(screen.displayID)
        let visibleFrame = screen.visibleFrame
        let menuBarHeight = await MainActor.run {
            nsAppClient.mainMenu()?.menuBarHeight
        } ?? .zero
        var validFrame = CGRect(
            x: visibleFrame.origin.x,
            y: bounds.origin.y + menuBarHeight,
            width: visibleFrame.width,
            height: visibleFrame.height
        )
        // Dock is Left or Right
        if visibleFrame.width < bounds.width {
            validFrame.size.width -= 1
            // Dock is Left
            if bounds.origin.x < visibleFrame.origin.x {
                validFrame.origin.x += 1
            }
        }
        return validFrame
    }

    func makeNewFrame(shiftType: ShiftType, validFrame: CGRect) -> CGRect? {
        var newOrigin = validFrame.origin
        switch shiftType {
        case .bottomHalf:
            newOrigin.y += validFrame.height.half
        case .rightHalf:
            newOrigin.x += validFrame.width.half
        case .middleThird, .rightTwoThirds:
            newOrigin.x += validFrame.width.third
        case .rightThird:
            newOrigin.x += validFrame.width.twoThirds
        default:
            break
        }

        var newSize = validFrame.size
        switch shiftType {
        case .topHalf:
            newSize.height = validFrame.height.half
        case .bottomHalf:
            newSize.height -= validFrame.height.half
        case .leftHalf:
            newSize.width = validFrame.width.half
        case .rightHalf:
            newSize.width -= validFrame.width.half
        case .leftThird, .middleThird:
            newSize.width = validFrame.width.third
        case .leftTwoThirds:
            newSize.width = validFrame.width.twoThirds
        case .rightTwoThirds:
            newSize.width -= validFrame.width.third
        case .rightThird:
            newSize.width -= validFrame.width.twoThirds
        default:
            break
        }

        guard 0 <= newSize.width && 0 <= newSize.height else { return nil }
        return CGRect(origin: newOrigin, size: newSize)
    }

    // MARK: Get Attribute Names of an AXUIElement
    #if DEBUG
    private func getAttributeNames(element: AXUIElement) -> [String]? {
        var ref: CFArray? = nil
        guard hiServicesClient.copyAttributeNames(element, &ref) == .success, let ref else {
            return nil
        }
        return ref as [AnyObject] as? [String]
    }
    #endif

    // MARK: Get Window Attributes
    private func copyAttributeValue(_ element: AXUIElement, attribute: String) -> CFTypeRef? {
        var ref: CFTypeRef? = nil
        guard hiServicesClient.copyAttributeValue(element, attribute as CFString, &ref) == .success else {
            return nil
        }
        return ref
    }

    private func getFocusedWindow(pid: pid_t) -> AXUIElement? {
        let element = AXUIElementCreateApplication(pid)
        guard let window = copyAttributeValue(element, attribute: kAXFocusedWindowAttribute) else {
            return nil
        }
        return (window as! AXUIElement)
    }

    private func getRole(element: AXUIElement) -> String? {
        copyAttributeValue(element, attribute: kAXRoleAttribute) as? String
    }

    private func getSubRole(element: AXUIElement) -> String? {
        copyAttributeValue(element, attribute: kAXSubroleAttribute) as? String
    }

    private func isFullscreen(element: AXUIElement) -> Bool {
        guard let number = copyAttributeValue(element, attribute: .kAXFullScreen) else {
            return false
        }
        return (number as? NSNumber)?.boolValue ?? false
    }

    // MARK: Override Window Attributes
    private func setAttributeValue(_ element: AXUIElement, attribute: String, value: CFTypeRef) -> Bool {
        hiServicesClient.setAttributeValue(element, attribute as CFString, value) == .success
    }

    @discardableResult
    private func setPosition(element: AXUIElement, position: CGPoint) -> Bool {
        var position = position
        guard let value = hiServicesClient.valueCreate(AXValueType.cgPoint, &position) else {
            return false
        }
        return setAttributeValue(element, attribute: kAXPositionAttribute, value: value)
    }

    @discardableResult
    private func setSize(element: AXUIElement, size: CGSize) -> Bool {
        var size = size
        guard let value = hiServicesClient.valueCreate(AXValueType.cgSize, &size) else {
            return false
        }
        return setAttributeValue(element, attribute: kAXSizeAttribute, value: value)
    }
}
