/*
 String+Extension.swift
 DataLayer

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

import Foundation

extension String {
    static let patterns = "patterns"
    static let showShortcutPanel = "showShortcutPanel"
    static let createDesktopRead = "defaults read com.apple.finder CreateDesktop"
    static let createDesktopDelete = "defaults delete com.apple.finder CreateDesktop; killall Finder"
    static let createDesktopWriteFalse = "defaults write com.apple.finder CreateDesktop -bool FALSE; killall Finder"
}
