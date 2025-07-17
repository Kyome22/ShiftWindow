import Foundation
import os
import ServiceManagement
import Testing

@testable import Infrastructure
@testable import Model

struct GeneralSettingsTests {
    @MainActor @Test
    func send_launchAtLoginToggleSwitched_有効の要求_成功した_有効に変更される() {
        let currentStatus = OSAllocatedUnfairLock(initialState: SMAppService.Status.notRegistered)
        let sut = GeneralSettings(.testDependencies(
            smAppServiceClient: testDependency(of: SMAppServiceClient.self) {
                $0.status = { currentStatus.withLock(\.self) }
                $0.register = { currentStatus.withLock { $0 = .enabled } }
            }
        ))
        sut.send(.launchAtLoginToggleSwitched(true))
        #expect(sut.launchAtLogin)
    }

    @MainActor @Test
    func send_launchAtLoginToggleSwitched_有効の要求_失敗した_無効に戻される() {
        let sut = GeneralSettings(.testDependencies(
            smAppServiceClient: testDependency(of: SMAppServiceClient.self) {
                $0.status = { .notRegistered }
                $0.register = { throw NSError(domain: "", code: kSMErrorInternalFailure) }
            }
        ))
        sut.send(.launchAtLoginToggleSwitched(true))
        #expect(sut.launchAtLogin == false)
    }

    @MainActor @Test
    func send_checkForUpdatesToggleSwitched_無効の要求_成功した_無効に変更される() {
        let currentStatus = OSAllocatedUnfairLock(initialState: false)
        let sut = GeneralSettings(.testDependencies(
            spuUpdaterClient: testDependency(of: SPUUpdaterClient.self) {
                $0.automaticallyChecksForUpdates = {
                    currentStatus.withLock(\.self)
                }
                $0.setAutomaticallyChecksForUpdates = { value in
                    currentStatus.withLock { $0 = value }
                }
            }
        ))
        sut.send(.checkForUpdatesToggleSwitched(false))
        #expect(sut.checkForUpdates == false)
    }

    @MainActor @Test
    func send_openSystemSettingsButtonTapped() {
        let calledURLs = OSAllocatedUnfairLock(initialState: [URL]())
        let sut = GeneralSettings(.testDependencies(
            nsWorkspaceClient: testDependency(of: NSWorkspaceClient.self) {
                $0.open = { url in
                    calledURLs.withLock { $0.append(url) }
                    return true
                }
            }
        ))
        sut.send(.openSystemSettingsButtonTapped)
        let actual = calledURLs.withLock(\.self)
        #expect(actual == [URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!])
    }
}
