import Foundation
import os
import XCTest

@testable import DataLayer
@testable import Domain

final class ShortcutSettingsViewModelTests: XCTestCase {
    @MainActor
    func test_updateShortcut() async {
        let registerCount = OSAllocatedUnfairLock(initialState: 0)
        let spiceKeyClient = testDependency(of: SpiceKeyClient.self) {
            $0.register = { _ in registerCount.withLock { $0 += 1 } }
        }
        let setDataCount = OSAllocatedUnfairLock(initialState: 0)
        let userDefaultsClient = testDependency(of: UserDefaultsClient.self) {
            $0.data = { _ in
                var pattern = ShiftPattern(shiftType: .topHalf)
                pattern.spiceKeyData = .init(ShiftType.topHalf.id, .init(.a, .cmd))
                return try! JSONEncoder().encode([pattern])
            }
            $0.setData = { value, key in
                if key == .patterns {
                    setDataCount.withLock { $0 += 1 }
                }
            }
        }
        let sut = ShortcutSettingsViewModel(.testValue, .init(.testValue), .init(spiceKeyClient, userDefaultsClient, .testValue))
        await sut.updateKeyCombination(pattern: .init(shiftType: .topHalf), keyCombo: .init(.b, .cmd))
        XCTAssertEqual(registerCount.withLock { $0 }, 1)
        XCTAssertEqual(setDataCount.withLock { $0 }, 1)
    }

    @MainActor
    func test_removeShortcut() async {
        let setDataCount = OSAllocatedUnfairLock(initialState: 0)
        let userDefaultsClient = testDependency(of: UserDefaultsClient.self) {
            $0.data = { _ in
                var pattern = ShiftPattern(shiftType: .topHalf)
                pattern.spiceKeyData = .init(ShiftType.topHalf.id, .init(.a, .cmd))
                return try! JSONEncoder().encode([pattern])
            }
            $0.setData = { value, key in
                if key == .patterns {
                    setDataCount.withLock { $0 += 1 }
                }
            }
        }
        let sut = ShortcutSettingsViewModel(.testValue, .init(.testValue), .init(.testValue, userDefaultsClient, .testValue))
        await sut.updateKeyCombination(pattern: .init(shiftType: .topHalf), keyCombo: nil)
        XCTAssertEqual(setDataCount.withLock { $0 }, 1)
    }
}
