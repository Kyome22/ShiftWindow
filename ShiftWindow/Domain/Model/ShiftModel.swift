/*
 ShiftModel.swift
 ShiftWindow

 Created by Takuto Nakamura on 2021/07/31.
 Copyright 2021 Takuto Nakamura (Kyome22)

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
import ApplicationServices

fileprivate let kAXFullScreen = "AXFullScreen"

@MainActor protocol ShiftModel: Sendable {
    func shiftWindow(shiftType: ShiftType)
}

struct ShiftModelImpl: ShiftModel {
    func shiftWindow(shiftType: ShiftType) {
        // get frontmoset window
        guard let app = NSWorkspace.shared.runningApplications.first(where: { $0.isActive }),
              let window = self.getFocusedWindow(pid: app.processIdentifier),
              let role = self.getRole(element: window),
              role == kAXWindowRole,
              let subRole = self.getSubRole(element: window),
              subRole == kAXStandardWindowSubrole,
              self.isFullscreen(element: window) == false
        else { return }

        // override new frame to window
        guard let validFrame = getValidFrame(),
              let newFrame = self.makeNewFrame(shiftType: shiftType, validFrame: validFrame)
        else { return }
        self.setPosition(element: window, position: newFrame.origin)
        self.setSize(element: window, size: newFrame.size)
    }

    private func getValidFrame() -> CGRect? {
        guard let screen = NSScreen.main else { return nil }
        let bounds = CGDisplayBounds(screen.displayID)
        let visibleFrame = screen.visibleFrame
        let menuBarHeight = NSApp.mainMenu?.menuBarHeight ?? 0
        var validFrame = CGRect(x: visibleFrame.origin.x,
                                y: bounds.origin.y + menuBarHeight,
                                width: visibleFrame.width,
                                height: visibleFrame.height)
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

    // CoreGraphicsの座標系で返す必要がある
    private func makeNewFrame(shiftType: ShiftType, validFrame: CGRect) -> CGRect? {
        var newOrigin = validFrame.origin // 上からの距離
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
    private func getAttributeNames(element: AXUIElement) -> [String]? {
        var ref: CFArray? = nil
        let error = AXUIElementCopyAttributeNames(element, &ref)
        guard error == .success else { return nil }
        return ref! as [AnyObject] as? [String]
    }

    // MARK: Get Window Attributes
    private func copyAttributeValue(_ element: AXUIElement, attribute: String) -> CFTypeRef? {
        var ref: CFTypeRef? = nil
        let error = AXUIElementCopyAttributeValue(element, attribute as CFString, &ref)
        guard error == .success else { return .none }
        return ref
    }

    private func getFocusedWindow(pid: pid_t) -> AXUIElement? {
        let element = AXUIElementCreateApplication(pid)
        guard let window = self.copyAttributeValue(element, attribute: kAXFocusedWindowAttribute) else {
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
        let result = copyAttributeValue(element, attribute: kAXFullScreen) as? NSNumber
        return result?.boolValue ?? false
    }

    // MARK: Override Window Attributes
    private func setAttributeValue(_ element: AXUIElement, attribute: String, value: CFTypeRef) -> Bool {
        let error = AXUIElementSetAttributeValue(element, attribute as CFString, value)
        return error == .success
    }

    @discardableResult
    private func setPosition(element: AXUIElement, position: CGPoint) -> Bool {
        var position = position
        guard let value = AXValueCreate(AXValueType.cgPoint, &position) else {
            return false
        }
        return setAttributeValue(element, attribute: kAXPositionAttribute, value: value)
    }

    @discardableResult
    private func setSize(element: AXUIElement, size: CGSize) -> Bool {
        var size = size
        guard let value = AXValueCreate(AXValueType.cgSize, &size) else {
            return false
        }
        return setAttributeValue(element, attribute: kAXSizeAttribute, value: value)
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    struct ShiftModelMock: ShiftModel {
        func shiftWindow(shiftType: ShiftType) {}
    }
}
