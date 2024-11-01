/*
 ShortcutView.swift
 ShiftWindowPackages

 Created by Takuto Nakamura on 2024/11/01.
 
*/

import SwiftUI

struct ShortcutView: View {
    var keyEquivalent: String

    var body: some View {
        Text(keyEquivalent)
            .font(.system(size: 100, weight: .bold, design: .default))
            .foregroundColor(Color.secondary)
            .padding(.horizontal, 20)
            .background(Color(.panelBackground))
            .cornerRadius(12)
            .fixedSize()
    }
}

#Preview {
    ShortcutView(keyEquivalent: "⌘→")
}
