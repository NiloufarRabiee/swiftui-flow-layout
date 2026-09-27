import XCTest
@testable import FlowLayout

final class FlowLayoutTests: XCTestCase {
    func testItemsWrapToNextRow() {
        let result = FlowLayoutEngine.layout(
            sizes: [
                CGSize(width: 60, height: 20),
                CGSize(width: 60, height: 20),
                CGSize(width: 40, height: 20)
            ],
            containerWidth: 130,
            horizontalSpacing: 8,
            verticalSpacing: 10,
            alignment: .leading
        )

        XCTAssertEqual(result.frames[0].origin.x, 0, accuracy: 0.0001)
        XCTAssertEqual(result.frames[1].origin.x, 68, accuracy: 0.0001)
        XCTAssertEqual(result.frames[2].origin.x, 0, accuracy: 0.0001)
        XCTAssertEqual(result.frames[2].origin.y, 30, accuracy: 0.0001)
        XCTAssertEqual(result.size.height, 50, accuracy: 0.0001)
    }

    func testCenterAlignmentCentersEachRow() {
        let result = FlowLayoutEngine.layout(
            sizes: [
                CGSize(width: 40, height: 20),
                CGSize(width: 40, height: 20)
            ],
            containerWidth: 120,
            horizontalSpacing: 10,
            verticalSpacing: 8,
            alignment: .center
        )

        XCTAssertEqual(result.frames[0].origin.x, 15, accuracy: 0.0001)
        XCTAssertEqual(result.frames[1].origin.x, 65, accuracy: 0.0001)
    }

    func testTrailingAlignmentAlignsRowToTrailingEdge() {
        let result = FlowLayoutEngine.layout(
            sizes: [
                CGSize(width: 30, height: 20),
                CGSize(width: 30, height: 20)
            ],
            containerWidth: 100,
            horizontalSpacing: 10,
            verticalSpacing: 8,
            alignment: .trailing
        )

        XCTAssertEqual(result.frames[0].origin.x, 30, accuracy: 0.0001)
        XCTAssertEqual(result.frames[1].origin.x, 70, accuracy: 0.0001)
    }

    func testEmptyLayoutHasZeroSize() {
        let result = FlowLayoutEngine.layout(
            sizes: [],
            containerWidth: 200,
            horizontalSpacing: 8,
            verticalSpacing: 8,
            alignment: .leading
        )

        XCTAssertEqual(result.size, .zero)
        XCTAssertTrue(result.frames.isEmpty)
    }

    func testNegativeSpacingIsClampedToZero() {
        XCTAssertEqual(
            FlowLayoutConfiguration.normalizedSpacing(-8),
            0,
            accuracy: 0.0001
        )
    }

    func testInfiniteSpacingIsNormalizedToZero() {
        XCTAssertEqual(
            FlowLayoutConfiguration.normalizedSpacing(.infinity),
            0,
            accuracy: 0.0001
        )
    }
}
