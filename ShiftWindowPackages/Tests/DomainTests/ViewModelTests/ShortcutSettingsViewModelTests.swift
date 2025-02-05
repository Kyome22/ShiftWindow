import Foundation
import os
import Testing

@testable import DataLayer
@testable import Domain

struct ShortcutSettingsViewModelTests {
    @MainActor @Test
    func updateShortcut() async {
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
        #expect(registerCount.withLock(\.self) == 1)
        #expect(setDataCount.withLock(\.self) == 1)
    }

    @MainActor @Test
    func removeShortcut() async {
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
        #expect(setDataCount.withLock(\.self) == 1)
    }
}
