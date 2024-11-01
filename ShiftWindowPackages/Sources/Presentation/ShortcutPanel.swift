/*
 ShortcutPanel.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/02.
 
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
