import XCTest

import XCLinting
import XcodeProj

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

final class EmbeddedBuildSettingsRuleTests: XCTestCase {
	func testProjectWithBuildSettings() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let rules = XCLinter.defaultRules

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: URL(fileURLWithPath: "/dev/null"),
			configuration: Configuration()
		)

		let violations = try rules.flatMap { try $0(env) }

		XCTAssertFalse(violations.isEmpty)
	}

	func testProjectWithBuildSettingsRemoved() throws {
		let url = try Bundle.module.testDataURL(named: "BuildSettingsRemoved.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let rules = XCLinter.defaultRules

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: URL(fileURLWithPath: "/dev/null"),
			configuration: Configuration()
		)

		let violations = try rules.flatMap { try $0(env) }

		XCTAssertTrue(violations.isEmpty)
	}
}

