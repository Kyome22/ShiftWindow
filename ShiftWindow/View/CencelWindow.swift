//
//  CencelWindow.swift
//  ShiftWindow
//
//  Created by Takuto Nakamura on 2021/08/01.
//

import Cocoa

class CancelWindow: NSWindow {

    override func cancelOperation(_ sender: Any?) {
        self.close()
    }
    
}
