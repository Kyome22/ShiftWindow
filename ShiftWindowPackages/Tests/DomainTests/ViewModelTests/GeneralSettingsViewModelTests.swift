import Foundation
import os
import ServiceManagement
import XCTest

@testable import DataLayer
@testable import Domain

final class GeneralSettingsViewModelTests: XCTestCase {
    @MainActor
    func test_openSystemSettings() async {
        let calledURLs = OSAllocatedUnfairLock(initialState: [URL]())
        let nsWorkspaceClient = testDependency(of: NSWorkspaceClient.self) {
            $0.open = { url in
                calledURLs.withLock { $0.append(url) }
                return true
            }
        }
        let sut = GeneralSettingsViewModel(nsWorkspaceClient, .testValue, .testValue, .init(.testValue))
        sut.openSystemSettings()
        let actual = calledURLs.withLock { $0 }
        XCTAssertEqual(actual, [URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!])
    }

    @MainActor
    func test_launchAtLoginSwitched_有効の要求_成功した_有効に変更される() async {
        let currentStatus = OSAllocatedUnfairLock(initialState: SMAppService.Status.notRegistered)
        let smAppServiceClient = testDependency(of: SMAppServiceClient.self) {
            $0.status = { currentStatus.withLock { $0 } }
            $0.register = { currentStatus.withLock { $0 = .enabled } }
        }
        let sut = GeneralSettingsViewModel(.testValue, .testValue, smAppServiceClient, .init(.testValue))
        sut.launchAtLoginSwitched(true)
        XCTAssertTrue(sut.launchAtLoginIsEnabled)
    }

    @MainActor
    func test_launchAtLoginSwitched_有効の要求_失敗した_無効に戻される() async {
        let smAppServiceClient = testDependency(of: SMAppServiceClient.self) {
            $0.status = { .notRegistered }
            $0.register = { throw NSError(domain: "", code: kSMErrorInternalFailure) }
        }
        let sut = GeneralSettingsViewModel(.testValue, .testValue, smAppServiceClient, .init(.testValue))
        sut.launchAtLoginSwitched(true)
        XCTAssertFalse(sut.launchAtLoginIsEnabled)
    }

    @MainActor
    func test_launchAtLoginSwitched_無効の要求_成功した_無効に変更される() async {
        let currentStatus = OSAllocatedUnfairLock(initialState: SMAppService.Status.enabled)
        let smAppServiceClient = testDependency(of: SMAppServiceClient.self) {
            $0.status = { currentStatus.withLock { $0 } }
            $0.unregister = { currentStatus.withLock { $0 = .notRegistered } }
        }
        let sut = GeneralSettingsViewModel(.testValue, .testValue, smAppServiceClient, .init(.testValue))
        sut.launchAtLoginSwitched(false)
        XCTAssertFalse(sut.launchAtLoginIsEnabled)
    }

    @MainActor
    func test_launchAtLoginSwitched_無効の要求_失敗した_有効に戻される() async {
        let smAppServiceClient = testDependency(of: SMAppServiceClient.self) {
            $0.status = { .enabled }
            $0.unregister = { throw NSError(domain: "", code: kSMErrorInternalFailure) }
        }
        let sut = GeneralSettingsViewModel(.testValue, .testValue, smAppServiceClient, .init(.testValue))
        sut.launchAtLoginSwitched(false)
        XCTAssertTrue(sut.launchAtLoginIsEnabled)
    }
}
