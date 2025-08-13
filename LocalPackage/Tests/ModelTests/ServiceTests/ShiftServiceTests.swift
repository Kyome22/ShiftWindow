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
    func makeNewFrame_幅が負_nilが返される() async {
        let sut = ShiftService(.testDependencies())
        let actual = await sut.makeNewFrame(shiftType: .maximize, validFrame: CGRect(x: 0, y: 0, width: -1, height: 0))
        #expect(actual == nil)
    }

    @Test
    func makeNewFrame_高さが負_nilが返される() async {
        let sut = ShiftService(.testDependencies())
        let actual = await sut.makeNewFrame(shiftType: .maximize, validFrame: CGRect(x: 0, y: 0, width: 0, height: -1))
        #expect(actual == nil)
    }

    @Test(arguments: [
        .init(input: .topHalf, expect: CGRect(x: 0, y: 0, width: 100, height: 50)),
        .init(input: .bottomHalf, expect: CGRect(x: 0, y: 50, width: 100, height: 50)),
        .init(input: .leftHalf, expect: CGRect(x: 0, y: 0, width: 50, height: 100)),
        .init(input: .rightHalf, expect: CGRect(x: 50, y: 0, width: 50, height: 100)),
        .init(input: .leftThird, expect: CGRect(x: 0, y: 0, width: 33, height: 100)),
        .init(input: .leftTwoThirds, expect: CGRect(x: 0, y: 0, width: 66, height: 100)),
        .init(input: .middleThird, expect: CGRect(x: 33, y: 0, width: 33, height: 100)),
        .init(input: .rightTwoThirds, expect: CGRect(x: 33, y: 0, width: 67, height: 100)),
        .init(input: .rightThird, expect: CGRect(x: 66, y: 0, width: 34, height: 100)),
    ] as [MakeNewFrameProperty])
    func makeNewFrame_幅と高さが正_補正した領域が返される(_ property: MakeNewFrameProperty) async {
        let sut = ShiftService(.testDependencies())
        let actual = await sut.makeNewFrame(shiftType: property.input, validFrame: CGRect(x: 0, y: 0, width: 100, height: 100))
        #expect(actual == property.expect)
    }
}

struct MakeNewFrameProperty {
    var input: ShiftType
    var expect: CGRect
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
