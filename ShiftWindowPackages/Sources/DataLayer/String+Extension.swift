/*
 String+Extension.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.

*/

import Foundation

extension String {
    static let patterns = "patterns"
    static let showShortcutPanel = "showShortcutPanel"
    static let createDesktopRead = "defaults read com.apple.finder CreateDesktop"
    static let createDesktopDelete = "defaults delete com.apple.finder CreateDesktop; killall Finder"
    static let createDesktopWriteFalse = "defaults write com.apple.finder CreateDesktop -bool FALSE; killall Finder"
}
