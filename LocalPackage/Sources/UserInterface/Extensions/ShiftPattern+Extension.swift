/*
 ShiftPattern+Extension.swift
 Presentation

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

import DataSource
import SwiftUI

extension ShiftPattern {
    var label: String {
        shiftType.label
    }

    var imageResource: ImageResource {
        shiftType.imageResource
    }

    var description: String {
        let str = spiceKeyData?.keyCombination?.string ?? "nil"
        return "type: \(label), spiceKeyData: \(str)"
    }
}
