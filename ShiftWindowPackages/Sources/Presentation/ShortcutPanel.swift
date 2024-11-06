/*
 ShortcutPanel.swift
 Presentation

 Created by Takuto Nakamura on 2024/11/02.
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
import PanelSceneKit
import SwiftUI

public final class ShortcutPanel: NSPanel, HostingPanel {
    public init<Content: View>(content: () -> Content) {
        super.init(
            contentRect: .zero,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        level = .floating
        isOpaque = false
        collectionBehavior = [.canJoinAllSpaces]
        backgroundColor = NSColor.clear
        contentView = NSHostingView(rootView: content())
    }

    override public func center() {
        if let screenFrame = NSScreen.main?.frame {
            let origin = NSPoint(
                x: 0.5 * (screenFrame.width - frame.size.width),
                y: 0.5 * (screenFrame.height - frame.size.height)
            )
            setFrameOrigin(origin)
        } else {
            super.center()
        }
    }

    override public func close() {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.allowsImplicitAnimation = true
            self.animator().alphaValue = 0
        } completionHandler: {
            super.close()
        }
    }
}
