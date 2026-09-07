import XCTest
@testable import Codenotch

final class CornerPlacementTests: XCTestCase {
    private struct Screen: ScreenDescribing {
        let frameValue: CGRect
        let visibleFrameValue: CGRect
        var hardwareNotch: HardwareNotch? { HardwareNotch(width: 180, height: 32) }
    }
    private let corners: [NotchEdge] = [.topRight, .bottomRight, .topLeft, .bottomLeft]

    func testCornersStayInsideUsableAreaIncludingDockAndMenuBar() {
        for offset in [CGPoint.zero, CGPoint(x: -1800, y: 200)] {
            let usable = CGRect(x: offset.x + 60, y: offset.y + 80, width: 1720, height: 980)
            let screen = Screen(frameValue: CGRect(origin: offset, size: CGSize(width: 1800, height: 1100)),
                                visibleFrameValue: usable)
            for edge in corners {
                let frame = NotchGeometry.panelFrame(for: screen,
                                                    panelSize: CGSize(width: 334, height: 600), edge: edge)
                XCTAssertTrue(usable.contains(frame), "\(edge): \(frame)")
                let onRight = edge == .topRight || edge == .bottomRight
                let onTop = edge == .topRight || edge == .topLeft
                XCTAssertEqual(onRight ? frame.maxX : frame.minX,
                               onRight ? usable.maxX : usable.minX)
                XCTAssertEqual(onTop ? frame.maxY : frame.minY,
                               onTop ? usable.maxY : usable.minY)
            }
        }
    }

    func testCornersKeepTheSideShapeAndInwardTooltip() {
        for edge in corners {
            let side: NotchEdge = (edge == .topRight || edge == .bottomRight) ? .right : .left
            XCTAssertTrue(edge.isVertical)
            XCTAssertEqual(edge.tooltipDirection, side.tooltipDirection)
            XCTAssertEqual(edge.outward, side.outward)
            XCTAssertEqual(SideNotchShape.transform(for: edge, depth: 80),
                           SideNotchShape.transform(for: side, depth: 80))
            let size = CGSize(width: 334, height: 600)
            XCTAssertEqual(NotchPlacement(edge: edge, panelSize: size).point(along: 140, across: 40),
                           NotchPlacement(edge: side, panelSize: size).point(along: 140, across: 40))
        }
    }

    @MainActor
    func testCornerTooltipBudgetExcludesSystemChrome() {
        let screen = Screen(frameValue: CGRect(x: 0, y: 0, width: 1800, height: 1100),
                            visibleFrameValue: CGRect(x: 0, y: 100, width: 1800, height: 960))
        for edge in corners {
            let model = NotchViewModel()
            model.edge = edge
            model.adopt(screen: screen)
            XCTAssertNil(model.hardwareNotch)
            XCTAssertLessThanOrEqual(model.panelSize(cellCount: 7).height, screen.visibleFrameValue.height)
        }
    }

    @MainActor
    func testAllEightPlacementsSurvivePreferenceReload() {
        let domain = "CornerPlacementTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: domain)!
        defer { defaults.removePersistentDomain(forName: domain) }
        for edge in NotchEdge.allCases {
            Preferences(defaults: defaults).notchEdge = edge
            XCTAssertEqual(Preferences(defaults: defaults).notchEdge, edge)
        }
    }
    @MainActor
    func testVisibleBodyNotTransparentPanelIsPinnedToCorner() {
        let screen = Screen(frameValue: CGRect(x: 0, y: 0, width: 1800, height: 1440),
                            visibleFrameValue: CGRect(x: 0, y: 80, width: 1800, height: 1320))
        for edge in corners {
            let model = NotchViewModel()
            model.edge = edge
            model.snapshots = Array(Fixtures.snapshots().prefix(2))
            model.adopt(screen: screen)
            model.isExpanded = true
            let top = edge == .topRight || edge == .topLeft
            if top {
                XCTAssertEqual(model.notchLeadingInset, 0)
            } else {
                XCTAssertEqual(model.slack + model.shapeLength + model.cornerHandleClearance,
                               model.panelSize.height, accuracy: 0.001)
            }
            model.isExpanded = false
            if top {
                XCTAssertEqual(model.notchLeadingInset, 0)
            } else {
                XCTAssertEqual(model.notchLeadingInset + model.notchLength,
                               model.panelSize.height, accuracy: 0.001)
            }
        }
    }

    @MainActor
    func testCornerCardsFitAndTheirTailsStillPointToTheHoveredRing() {
        let screen = Screen(frameValue: CGRect(x: 0, y: 0, width: 1800, height: 1100),
                            visibleFrameValue: CGRect(x: 0, y: 100, width: 1800, height: 960))
        for edge in corners {
            let model = NotchViewModel()
            model.edge = edge
            model.snapshots = Fixtures.snapshots()
            model.adopt(screen: screen)
            for index in model.snapshots.indices {
                let center = model.tooltipCenterAlong(index: index)
                let half = model.tooltipHeight(index: index) / 2
                XCTAssertGreaterThanOrEqual(center - half, 0)
                XCTAssertLessThanOrEqual(center + half, model.panelSize.height)
                XCTAssertEqual(center + model.tooltipTailOffset(index: index),
                               model.slack + model.ringCenter(index: index), accuracy: 0.001)
            }
        }
    }

}
