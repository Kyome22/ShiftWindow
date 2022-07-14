//
//  ShortcutView.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2022/07/15.
//

import SwiftUI

struct ShortcutView: View {
    let keyEquivalent: String

    var body: some View {
        Text(keyEquivalent)
            .font(.system(size: 100, weight: .bold, design: .default))
            .foregroundColor(Color.secondary)
            .padding(.horizontal, 20)
            .background(Color("PanelBackground"))
            .cornerRadius(12)
            .fixedSize()
    }
}

struct ShortcutView_Previews: PreviewProvider {
    static var previews: some View {
        ShortcutView(keyEquivalent: "⌘→")
    }
}
