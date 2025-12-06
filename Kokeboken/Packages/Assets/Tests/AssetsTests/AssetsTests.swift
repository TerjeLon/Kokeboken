import XCTest
@testable import Assets

final class AssetsTests: XCTestCase {
    func testMargins() {
        XCTAssertEqual(AppMargins.xs, 4)
        XCTAssertEqual(AppMargins.sm, 8)
        XCTAssertEqual(AppMargins.lg, 16)
    }
    
    func testRadiuses() {
        XCTAssertEqual(AppRadiuses.xs, 2)
        XCTAssertEqual(AppRadiuses.sm, 4)
        XCTAssertEqual(AppRadiuses.lg, 8)
    }
}

