import Infrastructure
import Foundation
import os
import Testing

@testable import Model

struct ExtraMenuTests {
    @MainActor @Test
    func send_hideDesktopIconsButtonTapped_変更の要求_成功した_変更される() async {
        let sut = ExtraMenu(.testDependencies(
            executeClient: testDependency(of: ExecuteClient.self) {
                $0.toggleIconsVisible = { _ in }
            }
        ))
        await sut.send(.hideDesktopIconsButtonTapped(true))
        #expect(sut.hideIcons)
    }

    @MainActor @Test
    func send_hideDesktopIconsButtonTapped_変更の要求_失敗した_変更されない() async {
        let sut = ExtraMenu(.testDependencies(
            executeClient: testDependency(of: ExecuteClient.self) {
                $0.toggleIconsVisible = { _ in throw CocoaError(.fileNoSuchFile) }
            }
        ))
        await sut.send(.hideDesktopIconsButtonTapped(true))
        #expect(sut.hideIcons == false)
    }

    @MainActor @Test
    func send_checkForUpdatesButtonTapped() async {
        let count = OSAllocatedUnfairLock(initialState: 0)
        let sut = ExtraMenu(.testDependencies(
            spuUpdaterClient: testDependency(of: SPUUpdaterClient.self) {
                $0.checkForUpdates = { count.withLock { $0 += 1 } }
            }
        ))
        await sut.send(.checkForUpdatesButtonTapped)
        #expect(count.withLock(\.self) == 1)
    }

    @MainActor @Test
    func send_settingsButtonTapped() async {
        let count = OSAllocatedUnfairLock(initialState: 0)
        let sut = ExtraMenu(.testDependencies(
            nsAppClient: testDependency(of: NSAppClient.self) {
                $0.activate = { _ in count.withLock { $0 += 1 } }
            }
        ))
        await sut.send(.settingsButtonTapped)
        #expect(count.withLock(\.self) == 1)
    }

    @MainActor @Test
    func send_aboutButtonTapped() async {
        let callStack = OSAllocatedUnfairLock(initialState: [String]())
        let sut = ExtraMenu(.testDependencies(
            nsAppClient: testDependency(of: NSAppClient.self) {
                $0.activate = { _ in callStack.withLock { $0.append("activate") } }
                $0.orderFrontStandardAboutPanel = { _ in
                    callStack.withLock { $0.append("orderFrontStandardAboutPanel") }
                }
            }
        ))
        await sut.send(.aboutButtonTapped)
        #expect(callStack.withLock(\.self) == ["activate", "orderFrontStandardAboutPanel"])
    }

    @MainActor @Test
    func send_quitButtonTapped() async {
        let count = OSAllocatedUnfairLock(initialState: 0)
        let sut = ExtraMenu(.testDependencies(
            nsAppClient: testDependency(of: NSAppClient.self) {
                $0.terminate = { _ in count.withLock { $0 += 1 } }
            }
        ))
        await sut.send(.quitButtonTapped)
        #expect(count.withLock(\.self) == 1)
    }
}
