//
//  ShortcutPanel.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/08/05.
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

import AppKit
import SpiceKey
import SwiftUI

final class ShortcutPanel: NSPanel {
    init(keyEquivalent: String) {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 200, height: 100),
                   styleMask: [.borderless, .nonactivatingPanel],
                   backing: .buffered,
                   defer: true)
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces]
        self.isOpaque = false
        self.backgroundColor = NSColor.clear

        let hostingView = NSHostingView(rootView: ShortcutView(keyEquivalent: keyEquivalent))
        hostingView.setFrameSize(hostingView.fittingSize)
        self.contentView = hostingView
    }
    
    override func orderFrontRegardless() {
        super.orderFrontRegardless()
        if let screenFrame = NSScreen.main?.frame {
            let size = self.frame.size
            let origin = NSPoint(x: 0.5 * (screenFrame.width - size.width),
                                 y: 0.5 * (screenFrame.height - size.height))
            self.setFrameOrigin(origin)
        } else {
            self.center()
        }
    }
    
    func fadeOut() {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.allowsImplicitAnimation = true
            self.animator().alphaValue = 0
        } completionHandler: {
            self.close()
        }
    }
}
