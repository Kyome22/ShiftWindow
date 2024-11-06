import os
import XCTest

@testable import DataLayer
@testable import Domain

final class ShortcutServiceTests: XCTestCase {
    func test_Example() async {
        var userDefaultsClient = UserDefaultsClient.testValue
        userDefaultsClient.data = { _ in
            try! JSONEncoder().encode([
                ShiftPattern(shiftType: .topHalf),
                ShiftPattern(shiftType: .bottomHalf),
                ShiftPattern(shiftType: .leftHalf),
            ])
        }
        let sut = ShortcutService(
            .init(userDefaultsClient, reset: false),
            .init(.testValue, .testValue, .testValue, .testValue, .testValue)
        )
        let actual = await sut.getIndex(id: ShiftType.bottomHalf.id)
        XCTAssertEqual(actual, 1)
    }
}
