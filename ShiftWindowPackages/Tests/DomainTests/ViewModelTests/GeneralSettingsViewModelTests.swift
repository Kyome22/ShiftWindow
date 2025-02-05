import Foundation
import os
import ServiceManagement
import Testing

@testable import DataLayer
@testable import Domain

struct GeneralSettingsViewModelTests {
    @MainActor @Test
    func openSystemSettings() async {
        let calledURLs = OSAllocatedUnfairLock(initialState: [URL]())
        let nsWorkspaceClient = testDependency(of: NSWorkspaceClient.self) {
            $0.open = { url in
                calledURLs.withLock { $0.append(url) }
                return true
            }
        }
        let sut = GeneralSettingsViewModel(nsWorkspaceClient, .testValue, .testValue, .init(.testValue))
        sut.openSystemSettings()
        let actual = calledURLs.withLock(\.self)
        #expect(actual == [URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!])
    }

    @MainActor @Test
    func toggleLaunchAtLogin_有効の要求_成功した_有効に変更される() async {
        let currentStatus = OSAllocatedUnfairLock(initialState: SMAppService.Status.notRegistered)
        let smAppServiceClient = testDependency(of: SMAppServiceClient.self) {
            $0.status = { currentStatus.withLock(\.self) }
            $0.register = { currentStatus.withLock { $0 = .enabled } }
        }
        let sut = GeneralSettingsViewModel(.testValue, .testValue, smAppServiceClient, .init(.testValue))
        sut.toggleLaunchAtLogin(true)
        #expect(sut.launchAtLogin)
    }


    @MainActor @Test
    func toggleLaunchAtLogin_有効の要求_失敗した_無効に戻される() async {
        let smAppServiceClient = testDependency(of: SMAppServiceClient.self) {
            $0.status = { .notRegistered }
            $0.register = { throw NSError(domain: "", code: kSMErrorInternalFailure) }
        }
        let sut = GeneralSettingsViewModel(.testValue, .testValue, smAppServiceClient, .init(.testValue))
        sut.toggleLaunchAtLogin(true)
        #expect(sut.launchAtLogin == false)
    }

    @MainActor @Test
    func toggleLaunchAtLogin_無効の要求_成功した_無効に変更される() async {
        let currentStatus = OSAllocatedUnfairLock(initialState: SMAppService.Status.enabled)
        let smAppServiceClient = testDependency(of: SMAppServiceClient.self) {
            $0.status = { currentStatus.withLock(\.self) }
            $0.unregister = { currentStatus.withLock { $0 = .notRegistered } }
        }
        let sut = GeneralSettingsViewModel(.testValue, .testValue, smAppServiceClient, .init(.testValue))
        sut.toggleLaunchAtLogin(false)
        #expect(sut.launchAtLogin == false)
    }

    @MainActor @Test
    func toggleLaunchAtLogin_無効の要求_失敗した_有効に戻される() async {
        let smAppServiceClient = testDependency(of: SMAppServiceClient.self) {
            $0.status = { .enabled }
            $0.unregister = { throw NSError(domain: "", code: kSMErrorInternalFailure) }
        }
        let sut = GeneralSettingsViewModel(.testValue, .testValue, smAppServiceClient, .init(.testValue))
        sut.toggleLaunchAtLogin(false)
        #expect(sut.launchAtLogin)
    }
}
