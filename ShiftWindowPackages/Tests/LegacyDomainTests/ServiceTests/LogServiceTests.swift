import LegacyDataLayer
import os
import Testing

@testable import LegacyDomain

struct LogServiceTests {
    @Test
    func bootstrapは一度しか実行されない() async {
        let count = OSAllocatedUnfairLock(initialState: 0)
        let loggingSystemClient = testDependency(of: LoggingSystemClient.self) {
            $0.bootstrap = { _ in count.withLock { $0 += 1  } }
        }
        let sut = LogService(loggingSystemClient)
        await sut.bootstrap()
        await sut.bootstrap()
        let actual = count.withLock(\.self)
        #expect(actual == 1)
    }
}
