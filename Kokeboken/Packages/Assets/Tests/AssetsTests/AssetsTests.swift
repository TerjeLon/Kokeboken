import Testing
@testable import Assets

struct AssetsTests {
    @Test func testMargins() {
        #expect(AppMargins.xs == 4)
        #expect(AppMargins.sm == 8)
        #expect(AppMargins.lg == 16)
    }
    
    @Test func testRadiuses() {
        #expect(AppRadiuses.xs == 2)
        #expect(AppRadiuses.sm == 4)
        #expect(AppRadiuses.lg == 8)
    }
}

