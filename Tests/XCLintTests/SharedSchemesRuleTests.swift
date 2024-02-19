import XCTest

@testable import XCLinting
import XcodeProj

final class SharedSchemesRuleTests: XCTestCase {
	func testProjectWithSharedSchemes() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try SharedSchemesRule().run(env)

		XCTAssertTrue(violations.isEmpty)
	}

	func testProjectWithMissingSharedSchemes() throws {
		let url = try Bundle.module.testDataURL(named: "SchemeSkipsTests.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try SharedSchemesRule().run(env)

		XCTAssertFalse(violations.isEmpty)
	}
}
