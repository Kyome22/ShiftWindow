//
//  ShortcutSettingsView.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2022/06/27.
//

import SwiftUI

struct ShortcutSettingsView: View {
    @StateObject var viewModel = ShortcutSettingsViewModel()
    @State var tmp: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Group {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image("WindowTopHalf")
                    wrapText("topHalf")
                    TextField("", text: $tmp)
                }
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image("WindowBottomHalf")
                    wrapText("bottomHalf")
                    TextField("", text: $tmp)
                }
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image("WindowLeftHalf")
                    wrapText("leftHalf")
                    TextField("", text: $tmp)
                }
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image("WindowRightHalf")
                    wrapText("rightHalf")
                    TextField("", text: $tmp)
                }
            }
            Divider()
            Group {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image("WindowLeftThird")
                    wrapText("leftThird")
                    TextField("", text: $tmp)
                }
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image("WindowLeftTwoThirds")
                    wrapText("leftTwoThirds")
                    TextField("", text: $tmp)
                }
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image("WindowMiddleThird")
                    wrapText("middleThird")
                    TextField("", text: $tmp)
                }
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image("WindowRightTwoThirds")
                    wrapText("rightTwoThirds")
                    TextField("", text: $tmp)
                }
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Image("WindowRightThird")
                    wrapText("rightThird")
                    TextField("", text: $tmp)
                }
            }
            Divider()
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Image("WindowMaximize")
                wrapText("maximize")
                TextField("", text: $tmp)
            }
        }
        .frame(width: 250)
        .fixedSize()
    }

    private func wrapText(_ key: LocalizedStringKey) -> some View {
        return Text("widthAnchor")
            .hidden()
            .overlay(alignment: .leading) {
                Text(key)
            }
            .fixedSize()
    }
}

struct ShortcutSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutSettingsView()
    }
}
