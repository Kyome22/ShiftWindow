//
//  PreferencesTabVC.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/08/01.
//

import Cocoa

class PreferencesTabVC: NSTabViewController {

    override func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        var array = super.toolbarDefaultItemIdentifiers(toolbar)
        array.insert(NSToolbarItem.Identifier.flexibleSpace, at: 0)
        array.append(NSToolbarItem.Identifier.flexibleSpace)
        return array
    }

    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        guard let tabViewItem = tabViewItem else { return assertionFailure() }
        guard let selectedVC = tabViewItem.viewController else { return assertionFailure() }
        var originalSize = CGSize.zero
        var title = ""
        if let generalPane = selectedVC as? GeneralPaneVC {
            originalSize = generalPane.originalSize
            title = generalPane.title!
        }
        if let shortcutsPane = selectedVC as? ShortcutsPaneVC {
            originalSize = shortcutsPane.originalSize
            title = shortcutsPane.title!
        }
        let delta = self.view.frame.height - originalSize.height
        guard let window = self.view.window else {
            self.view.frame.size = originalSize
            return
        }
        window.title = title
        var frame = window.frame
        frame.origin.y += delta
        frame.size.height -= delta
        frame.size.width = originalSize.width
        window.setFrame(frame, display: true, animate: true)
    }
    
}
