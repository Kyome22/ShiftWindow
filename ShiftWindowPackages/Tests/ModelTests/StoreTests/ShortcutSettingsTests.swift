import Foundation
import os
import Testing

@testable import DataSource
@testable import Model

struct ShortcutSettingsTests {
    @MainActor @Test
    func send_onUpdateShortcut_ショートカットが入力された_ショートカットが設定される() {
        let appState = OSAllocatedUnfairLock(initialState: {
            var shiftPattern = ShiftPattern(shiftType: .topHalf)
            shiftPattern.spiceKeyData = .init(ShiftType.topHalf.id, .init(.a, .cmd))
            let state = AppState()
            state.shiftPatternsSubject.send([shiftPattern])
            return state
        }())
        let registerCount = OSAllocatedUnfairLock(initialState: 0)
        let setDataCount = OSAllocatedUnfairLock(initialState: 0)
        let sut = ShortcutSettings(.testDependencies(
            appStateClient: testDependency(of: AppStateClient.self) {
                $0.getAppState = { appState.withLock(\.self) }
                $0.setAppState = { value in appState.withLock { $0 = value } }
            },
            spiceKeyClient: testDependency(of: SpiceKeyClient.self) {
                $0.register = { _ in registerCount.withLock { $0 += 1 } }
            },
            userDefaultsClient: testDependency(of: UserDefaultsClient.self) {
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
        ))
        sut.send(.onUpdateShortcut(.init(shiftType: .topHalf), .init(.b, .cmd)))
        #expect(registerCount.withLock(\.self) == 1)
        #expect(setDataCount.withLock(\.self) == 1)
    }

    @MainActor @Test
    func send_onUpdateShortcut_ショートカット削除ボタンが押された_ショートカットが削除される() {
        let appState = OSAllocatedUnfairLock(initialState: {
            var shiftPattern = ShiftPattern(shiftType: .topHalf)
            shiftPattern.spiceKeyData = .init(ShiftType.topHalf.id, .init(.a, .cmd))
            let state = AppState()
            state.shiftPatternsSubject.send([shiftPattern])
            return state
        }())
        let setDataCount = OSAllocatedUnfairLock(initialState: 0)
        let sut = ShortcutSettings(.testDependencies(
            appStateClient: testDependency(of: AppStateClient.self) {
                $0.getAppState = { appState.withLock(\.self) }
                $0.setAppState = { value in appState.withLock { $0 = value } }
            },
            userDefaultsClient: testDependency(of: UserDefaultsClient.self) {
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
        ))
        sut.send(.onUpdateShortcut(.init(shiftType: .topHalf), nil))
        #expect(setDataCount.withLock(\.self) == 1)
    }
}
