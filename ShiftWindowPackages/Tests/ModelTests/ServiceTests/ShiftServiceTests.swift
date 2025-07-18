import AppKit
import DataSource
import os
import Testing

@testable import Model

struct ShiftServiceTests {
    @Test
    func getValidFrame_MainScreenが取得不能_nilが返される() async {
        let sut = ShiftService(.testDependencies())
        let actual = await sut.getValidFrame()
        #expect(actual == nil)
    }

    @Test
    func getValidFrame_MainScreenが取得可能_Dockが下部に存在_有効領域が返される() async {
        let sut = ShiftService(.testDependencies(
            cgDirectDisplayClient: testDependency(of: CGDirectDisplayClient.self) {
                $0.bounds = { _ in CGRect(x: 0, y: 0, width: 100, height: 100) }
            },
            nsAppClient: testDependency(of: NSAppClient.self) {
                $0.mainMenu = { NSMenuMock() }
            },
            nsScreenClient: testDependency(of: NSScreenClient.self) {
                $0.mainScreen = { NSScreenMock(x: 0, y: 0, width: 100, height: 95) }
            }
        ))
        let actual = await sut.getValidFrame()
        #expect(actual == CGRect(x: 0, y: 5, width: 100, height: 95))
    }

    @Test
    func getValidFrame_MainScreenが取得可能_Dockが右側に存在_有効領域が返される() async {
        let sut = ShiftService(.testDependencies(
            cgDirectDisplayClient: testDependency(of: CGDirectDisplayClient.self) {
                $0.bounds = { _ in CGRect(x: 0, y: 0, width: 100, height: 100) }
            },
            nsAppClient: testDependency(of: NSAppClient.self) {
                $0.mainMenu = { NSMenuMock() }
            },
            nsScreenClient: testDependency(of: NSScreenClient.self) {
                $0.mainScreen = { NSScreenMock(x: 0, y: 0, width: 95, height: 95) }
            }
        ))
        let actual = await sut.getValidFrame()
        #expect(actual == CGRect(x: 0, y: 5, width: 94, height: 95))
    }

    @Test
    func getValidFrame_MainScreenが取得可能_Dockが左側に存在_有効領域が返される() async {
        let sut = ShiftService(.testDependencies(
            cgDirectDisplayClient: testDependency(of: CGDirectDisplayClient.self) {
                $0.bounds = { _ in CGRect(x: 0, y: 0, width: 100, height: 100) }
            },
            nsAppClient: testDependency(of: NSAppClient.self) {
                $0.mainMenu = { NSMenuMock() }
            },
            nsScreenClient: testDependency(of: NSScreenClient.self) {
                $0.mainScreen = { NSScreenMock(x: 5, y: 0, width: 95, height: 95) }
            }
        ))
        let actual = await sut.getValidFrame()
        #expect(actual == CGRect(x: 6, y: 5, width: 94, height: 95))
    }

    @Test
    func makeNewFrame_幅が負_nilが返される() {
        let sut = ShiftService(.testDependencies())
        let actual = sut.makeNewFrame(shiftType: .maximize, validFrame: CGRect(x: 0, y: 0, width: -1, height: 0))
        #expect(actual == nil)
    }

    @Test
    func makeNewFrame_高さが負_nilが返される() {
        let sut = ShiftService(.testDependencies())
        let actual = sut.makeNewFrame(shiftType: .maximize, validFrame: CGRect(x: 0, y: 0, width: 0, height: -1))
        #expect(actual == nil)
    }

    @Test
    func makeNewFrame_上側1／2_領域が返される() {
        let sut = ShiftService(.testDependencies())
        let actual = sut.makeNewFrame(shiftType: .topHalf, validFrame: CGRect(x: 0, y: 0, width: 100, height: 100))
        #expect(actual == CGRect(x: 0, y: 0, width: 100, height: 50))
    }

    @Test
    func makeNewFrame_下側1／2_領域が返される() {
        let sut = ShiftService(.testDependencies())
        let actual = sut.makeNewFrame(shiftType: .bottomHalf, validFrame: CGRect(x: 0, y: 0, width: 100, height: 100))
        #expect(actual == CGRect(x: 0, y: 50, width: 100, height: 50))
    }

    @Test
    func makeNewFrame_左側1／2_領域が返される() {
        let sut = ShiftService(.testDependencies())
        let actual = sut.makeNewFrame(shiftType: .leftHalf, validFrame: CGRect(x: 0, y: 0, width: 100, height: 100))
        #expect(actual == CGRect(x: 0, y: 0, width: 50, height: 100))
    }

    @Test
    func makeNewFrame_右側1／2_領域が返される() {
        let sut = ShiftService(.testDependencies())
        let actual = sut.makeNewFrame(shiftType: .rightHalf, validFrame: CGRect(x: 0, y: 0, width: 100, height: 100))
        #expect(actual == CGRect(x: 50, y: 0, width: 50, height: 100))
    }

    @Test
    func makeNewFrame_左側1／3_領域が返される() {
        let sut = ShiftService(.testDependencies())
        let actual = sut.makeNewFrame(shiftType: .leftThird, validFrame: CGRect(x: 0, y: 0, width: 100, height: 100))
        #expect(actual == CGRect(x: 0, y: 0, width: 33, height: 100))
    }

    @Test
    func makeNewFrame_左側2／3_領域が返される() {
        let sut = ShiftService(.testDependencies())
        let actual = sut.makeNewFrame(shiftType: .leftTwoThirds, validFrame: CGRect(x: 0, y: 0, width: 100, height: 100))
        #expect(actual == CGRect(x: 0, y: 0, width: 66, height: 100))
    }

    @Test
    func makeNewFrame_中央1／3_領域が返される() {
        let sut = ShiftService(.testDependencies())
        let actual = sut.makeNewFrame(shiftType: .middleThird, validFrame: CGRect(x: 0, y: 0, width: 100, height: 100))
        #expect(actual == CGRect(x: 33, y: 0, width: 33, height: 100))
    }

    @Test
    func makeNewFrame_右側2／3_領域が返される() {
        let sut = ShiftService(.testDependencies())
        let actual = sut.makeNewFrame(shiftType: .rightTwoThirds, validFrame: CGRect(x: 0, y: 0, width: 100, height: 100))
        #expect(actual == CGRect(x: 33, y: 0, width: 67, height: 100))
    }

    @Test
    func makeNewFrame_右側1／3_領域が返される() {
        let sut = ShiftService(.testDependencies())
        let actual = sut.makeNewFrame(shiftType: .rightThird, validFrame: CGRect(x: 0, y: 0, width: 100, height: 100))
        #expect(actual == CGRect(x: 66, y: 0, width: 34, height: 100))
    }
}

fileprivate class NSScreenMock: NSScreen {
    let _visibleFrame: NSRect

    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        _visibleFrame = NSRect(x: x, y: y, width: width, height: height)
        super.init()
    }

    override var visibleFrame: NSRect { _visibleFrame }
}

fileprivate class NSMenuMock: NSMenu {
    override var menuBarHeight: CGFloat { 5 }
}
