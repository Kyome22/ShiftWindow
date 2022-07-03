//
//  ShortcutPanel.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/08/05.
//

import Cocoa
import SpiceKey

final class ShortcutPanel: NSPanel {
    let label = NSTextField(labelWithString: "")
    
    init(keyEquivalent: String) {
        super.init(contentRect: NSRect(x: 0, y: 0, width: 200, height: 100),
                   styleMask: [.borderless, .nonactivatingPanel],
                   backing: .buffered,
                   defer: true)
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces]
        self.isOpaque = false
        self.backgroundColor = NSColor.clear
        self.contentView?.wantsLayer = true
        self.contentView?.layer?.cornerRadius = 8
        self.contentView?.layer?.borderColor = CGColor.clear
        self.contentView?.layer?.backgroundColor = CGColor.panelBackground

        self.contentView?.addSubview(self.label)
        self.label.stringValue = keyEquivalent
        self.label.font = NSFont.systemFont(ofSize: 100, weight: .bold)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.sizeToFit()
        
        self.label
            .topAnchor
            .constraint(equalTo: self.contentView!.topAnchor, constant: 20)
            .isActive = true
        self.label
            .leftAnchor
            .constraint(equalTo: self.contentView!.leftAnchor, constant: 20)
            .isActive = true
        self.label
            .rightAnchor
            .constraint(equalTo: self.contentView!.rightAnchor, constant: -20)
            .isActive = true
        self.label
            .bottomAnchor
            .constraint(equalTo: self.contentView!.bottomAnchor, constant: -20)
            .isActive = true
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
