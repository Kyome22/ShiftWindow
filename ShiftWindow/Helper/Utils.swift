/*
 Utils.swift
 ShiftWindow

 Created by Takuto Nakamura on 2023/01/24.
 Copyright 2023 Takuto Nakamura (Kyome22)

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

func logput(
    _ items: Any...,
    file: String = #file,
    line: Int = #line,
    function: String = #function
) {
#if DEBUG
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    var array: [Any] = ["💫Log: \(fileName)", "Line:\(line)", function]
    array.append(contentsOf: items)
    Swift.print(array)
#endif
}

let NOT_IMPLEMENTED = "not implemented"
enum PreviewMock {}
