import XCTest
@testable import picoLib

final class UtilsTests: XCTestCase {
    func testWriteBit() throws {
        var n: UInt16 = 0x0000

        writeBit(&n, true, 3)
        XCTAssertEqual(n, 0x0008)

        writeBit(&n, true, 15)
        XCTAssertEqual(n, 0x8008)

        writeBit(&n, false, 3)
        XCTAssertEqual(n, 0x8000)
    }
}
