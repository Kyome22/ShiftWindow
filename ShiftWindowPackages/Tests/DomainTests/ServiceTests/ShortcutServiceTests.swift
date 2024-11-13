import os
import XCTest

@testable import DataLayer
@testable import Domain

final class ShortcutServiceTests: XCTestCase {
    func test_initializeShortcuts() async {
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
        let sut = ShortcutService(.testValue, spiceKeyClient, userDefaultsClient)
        await sut.initializeShortcuts()
        let actual = count.withLock { $0 }
        XCTAssertEqual(actual, 1)
    }

    func test_getIndex_正しくIndexが取得される() async {
        let userDefaultsClient = testDependency(of: UserDefaultsClient.self) {
            $0.data = { _ in
                try! JSONEncoder().encode([
                    ShiftPattern(shiftType: .topHalf),
                    ShiftPattern(shiftType: .bottomHalf),
                    ShiftPattern(shiftType: .leftHalf),
                ])
            }
        }
        let sut = ShortcutService(.testValue, .testValue, userDefaultsClient)
        let actual = await sut.getIndex(id: ShiftType.bottomHalf.id)
        XCTAssertEqual(actual, 1)
    }
}
