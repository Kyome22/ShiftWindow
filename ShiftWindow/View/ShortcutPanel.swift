//
//  ShortcutPanel.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/08/05.
//

import Cocoa
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
