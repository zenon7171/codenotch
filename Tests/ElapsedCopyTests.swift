import XCTest
@testable import Codenotch

final class ElapsedCopyTests: XCTestCase {
    private let now = Date(timeIntervalSince1970: 1_787_900_000)

    func testFreshChangesReadAsJustNow() {
        XCTAssertEqual(ElapsedCopy.text(since: now.addingTimeInterval(-5), now: now), "たった今")
        XCTAssertEqual(ElapsedCopy.text(since: now.addingTimeInterval(-44), now: now), "たった今")
    }

    func testMinutes() {
        XCTAssertEqual(ElapsedCopy.text(since: now.addingTimeInterval(-6 * 60), now: now), "6分")
        XCTAssertEqual(ElapsedCopy.text(since: now.addingTimeInterval(-59 * 60), now: now), "59分")
    }

    func testHours() {
        XCTAssertEqual(ElapsedCopy.text(since: now.addingTimeInterval(-60 * 60), now: now), "1時間")
        XCTAssertEqual(ElapsedCopy.text(since: now.addingTimeInterval(-65 * 60), now: now), "1時間5分")
    }

    /// A clock that has drifted backwards must not print a negative age.
    func testFutureTimestampsDoNotGoNegative() {
        XCTAssertEqual(ElapsedCopy.text(since: now.addingTimeInterval(120), now: now), "たった今")
    }
}
