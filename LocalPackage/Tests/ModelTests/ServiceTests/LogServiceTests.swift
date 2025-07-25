import os
import Testing

@testable import DataSource
@testable import Model

struct LogServiceTests {
    @Test
    func bootstrapは一度しか実行されない() {
        let appState = OSAllocatedUnfairLock<AppState>(initialState: .init())
        let count = OSAllocatedUnfairLock(initialState: 0)
        let sut = LogService(.testDependencies(
            appStateClient: testDependency(of: AppStateClient.self) {
                $0.getAppState = { appState.withLock(\.self) }
                $0.setAppState = { value in appState.withLock { $0 = value } }
            },
            loggingSystemClient: testDependency(of: LoggingSystemClient.self) {
                $0.bootstrap = { _ in count.withLock { $0 += 1  } }
            }
        ))
        sut.bootstrap()
        sut.bootstrap()
        let actual = count.withLock(\.self)
        #expect(actual == 1)
    }
}
