import Foundation
import os
import Testing

@testable import DataLayer
@testable import Domain

struct ShortcutServiceTests {
    @Test
    func initializeShortcuts() async {
        let count = OSAllocatedUnfairLock(initialState: 0)
        let spiceKeyClient = testDependency(of: SpiceKeyClient.self) {
            $0.register = { _ in count.withLock { $0 += 1 } }
        }
        let userDefaultsClient = testDependency(of: UserDefaultsClient.self) {
            $0.data = { _ in
                var pattern = ShiftPattern(shiftType: .topHalf)
                pattern.spiceKeyData = .init(ShiftType.topHalf.id, .init(.a, .cmd))
                return try! JSONEncoder().encode([pattern])
            }
        }
        let sut = ShortcutService(spiceKeyClient, userDefaultsClient, .testValue)
        await sut.initializeShortcuts()
        let actual = count.withLock(\.self)
        #expect(actual == 1)
    }

    @Test
    func getIndex_正しくIndexが取得される() async {
        let userDefaultsClient = testDependency(of: UserDefaultsClient.self) {
            $0.data = { _ in
                try! JSONEncoder().encode([
                    ShiftPattern(shiftType: .topHalf),
                    ShiftPattern(shiftType: .bottomHalf),
                    ShiftPattern(shiftType: .leftHalf),
                ])
            }
        }
        let sut = ShortcutService(.testValue, userDefaultsClient, .testValue)
        let actual = await sut.getIndex(id: ShiftType.bottomHalf.id)
        #expect(actual == 1)
    }
}
