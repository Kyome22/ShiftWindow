import Foundation
import os
import XCTest

@testable import DataLayer
@testable import Domain

final class MenuViewModelTests: XCTestCase {
    @MainActor
    func test_activateApp() {
        let count = OSAllocatedUnfairLock(initialState: 0)
        let nsAppClient = testDependency(of: NSAppClient.self) {
            $0.activate = { _ in count.withLock { $0 += 1 } }
        }
        let sut = MenuViewModel(
            .testValue,
            nsAppClient,
            .init(.testValue),
            .init(.testValue, .testValue, .testValue, .testValue, .testValue),
            .init(.testValue, .testValue, .testValue),
            .init(.testValue)
        )
        sut.activateApp()
        XCTAssertEqual(count.withLock(\.self), 1)
    }

    @MainActor
    func test_checkForUpdates() async {
        let count = OSAllocatedUnfairLock(initialState: 0)
        let spuUpdaterClient = testDependency(of: SPUUpdaterClient.self) {
            $0.checkForUpdates = { count.withLock { $0 += 1 } }
        }
        let sut = MenuViewModel(
            .testValue,
            .testValue,
            .init(.testValue),
            .init(.testValue, .testValue, .testValue, .testValue, .testValue),
            .init(.testValue, .testValue, .testValue),
            .init(spuUpdaterClient)
        )
        await sut.checkForUpdates()
        XCTAssertEqual(count.withLock(\.self), 1)
    }

    @MainActor
    func test_openAbout() {
        let callStack = OSAllocatedUnfairLock(initialState: [String]())
        let nsAppClient = testDependency(of: NSAppClient.self) {
            $0.activate = { _ in callStack.withLock { $0.append("activate") } }
            $0.orderFrontStandardAboutPanel = { _ in
                callStack.withLock { $0.append("orderFrontStandardAboutPanel") }
            }
        }
        let sut = MenuViewModel(
            .testValue,
            nsAppClient,
            .init(.testValue),
            .init(.testValue, .testValue, .testValue, .testValue, .testValue),
            .init(.testValue, .testValue, .testValue),
            .init(.testValue)
        )
        sut.openAbout()
        XCTAssertEqual(callStack.withLock(\.self), [
            "activate",
            "orderFrontStandardAboutPanel",
        ])
    }

    @MainActor
    func test_terminateApp() {
        let count = OSAllocatedUnfairLock(initialState: 0)
        let nsAppClient = testDependency(of: NSAppClient.self) {
            $0.terminate = { _ in count.withLock { $0 += 1 } }
        }
        let sut = MenuViewModel(
            .testValue,
            nsAppClient,
            .init(.testValue),
            .init(.testValue, .testValue, .testValue, .testValue, .testValue),
            .init(.testValue, .testValue, .testValue),
            .init(.testValue)
        )
        sut.terminateApp()
        XCTAssertEqual(count.withLock(\.self), 1)
    }

    @MainActor
    func test_toggleIconsVisible_変更の要求_成功した_変更される() {
        let executeClient = testDependency(of: ExecuteClient.self) {
            $0.toggleIconsVisible = { _ in }
        }
        let sut = MenuViewModel(
            executeClient,
            .testValue,
            .init(.testValue),
            .init(.testValue, .testValue, .testValue, .testValue, .testValue),
            .init(.testValue, .testValue, .testValue),
            .init(.testValue)
        )
        sut.toggleIconsVisible(true)
        XCTAssertTrue(sut.hideIcons)
    }

    @MainActor
    func test_toggleIconsVisible_変更の要求_失敗した_変更されない() {
        let executeClient = testDependency(of: ExecuteClient.self) {
            $0.toggleIconsVisible = { _ in throw CocoaError(.fileNoSuchFile) }
        }
        let sut = MenuViewModel(
            executeClient,
            .testValue,
            .init(.testValue),
            .init(.testValue, .testValue, .testValue, .testValue, .testValue),
            .init(.testValue, .testValue, .testValue),
            .init(.testValue)
        )
        sut.toggleIconsVisible(true)
        XCTAssertFalse(sut.hideIcons)
    }
}
