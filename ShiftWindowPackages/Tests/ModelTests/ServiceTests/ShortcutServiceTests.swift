import Foundation
import os
import Testing

@testable import Infrastructure
@testable import Model

struct ShortcutServiceTests {
    @Test
    func initializeShortcuts() {
        let appState = OSAllocatedUnfairLock<AppState>(initialState: .init())
        let count = OSAllocatedUnfairLock(initialState: 0)
        let sut = ShortcutService(.testDependencies(
            appStateClient: testDependency(of: AppStateClient.self) {
                $0.getAppState = { appState.withLock(\.self) }
                $0.setAppState = { value in appState.withLock { $0 = value } }
            },
            spiceKeyClient: testDependency(of: SpiceKeyClient.self) {
                $0.register = { _ in count.withLock { $0 += 1 } }
            },
            userDefaultsClient: testDependency(of: UserDefaultsClient.self) {
                $0.data = { _ in
                    var pattern = ShiftPattern(shiftType: .topHalf)
                    pattern.spiceKeyData = .init(ShiftType.topHalf.id, .init(.a, .cmd))
                    return try! JSONEncoder().encode([pattern])
                }
            }
        ))
        sut.initializeShortcuts()
        let actual = count.withLock(\.self)
        #expect(actual == 1)
    }

    @Test
    func getIndex_正しくIndexが取得される() async {
        let sut = ShortcutService(.testDependencies(
            appStateClient: testDependency(of: AppStateClient.self) {
                $0.getAppState = {
                    let state = AppState()
                    state.shiftPatternsSubject.send([
                        ShiftPattern(shiftType: .topHalf),
                        ShiftPattern(shiftType: .bottomHalf),
                        ShiftPattern(shiftType: .leftHalf),
                    ])
                    return state
                }
            }
        ))
        let actual = sut.getIndex(id: ShiftType.bottomHalf.id)
        #expect(actual == 1)
    }
}
