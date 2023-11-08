import Foundation
import XCTest

extension Bundle {
	func testDataURL(named: String) throws -> URL {
		let bundle = Bundle.module

		let resourceURL = try XCTUnwrap(bundle.resourceURL)

		return resourceURL
			.appendingPathComponent("TestData", isDirectory: true)
			.appendingPathComponent(named)
			.standardizedFileURL
	}
}
