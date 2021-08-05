//
//  ShiftManager.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/07/31.
//
//  Copyright 2021 Takuto Nakamura (Kyome22)
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Cocoa
import ApplicationServices

class ShiftManager {
    
    init() {}
    
    func shiftWindow(type: ShiftType) {
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
        guard let newFrame = self.makeNewFrame(type: type) else { return }
        self.setPosition(element: window, position: newFrame.origin)
        self.setSize(element: window, size: newFrame.size)
    }
    
    private func makeNewFrame(type: ShiftType) -> CGRect? {
        guard let mainScreen = NSScreen.main else { return nil }
        let validFrame = CGRect(x: mainScreen.visibleFrame.origin.x,
                                y: mainScreen.frame.height - mainScreen.visibleFrame.height,
                                width: mainScreen.visibleFrame.width,
                                height: mainScreen.visibleFrame.height)
        
        var newOrigin = validFrame.origin // 上からの距離
        switch type {
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
        switch type {
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
    
    // MARK: Get Window Attributes
    private func copyAttributeValue(_ element: AXUIElement, attribute: String) -> CFTypeRef? {
        var ref: CFTypeRef? = nil
        let error = AXUIElementCopyAttributeValue(element, attribute as CFString, &ref)
        if error == .success {
            return ref
        }
        return .none
    }
    
    private func getFocusedWindow(pid: pid_t) -> AXUIElement? {
        let element = AXUIElementCreateApplication(pid)
        if let window = self.copyAttributeValue(element, attribute: kAXFocusedWindowAttribute) {
            return (window as! AXUIElement)
        }
        return nil
    }
    
    private func getRole(element: AXUIElement) -> String? {
        return self.copyAttributeValue(element, attribute: kAXRoleAttribute) as? String
    }
    
    private func getSubRole(element: AXUIElement) -> String? {
        return self.copyAttributeValue(element, attribute: kAXSubroleAttribute) as? String
    }
    
    private func isFullscreen(element: AXUIElement) -> Bool {
        let result = self.copyAttributeValue(element, attribute: "AXFullScreen") as? NSNumber
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
        if let value = AXValueCreate(AXValueType.cgPoint, &position) {
            return self.setAttributeValue(element, attribute: kAXPositionAttribute, value: value)
        }
        return false
    }
    
    @discardableResult
    private func setSize(element: AXUIElement, size: CGSize) -> Bool {
        var size = size
        if let value = AXValueCreate(AXValueType.cgSize, &size) {
            return self.setAttributeValue(element, attribute: kAXSizeAttribute, value: value)
        }
        return false
    }
    
}
