//
//  main.swift
//  ShiftWindowLauncher
//
//  Created by Takuto Nakamura on 2021/08/01.
//

import Cocoa

let delegate = AppDelegate()
NSApplication.shared.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
