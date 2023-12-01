import XCTest

@testable import XCLinting
import XcodeProj

final class ValidateBuildSettingsRuleTests: XCTestCase {
	func testProjectWithNoInvalidBuildSettings() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try ValidateBuildSettingsRule().run(env)

		XCTAssertEqual(violations, [])
	}

	func testProjectWithInvalidBuildSettings() throws {
		let url = try Bundle.module.testDataURL(named: "InvalidEmbeddedBuildSettings.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try ValidateBuildSettingsRule().run(env)

		XCTAssertFalse(violations.isEmpty)
	}

	func testInvalidSettingsInXCConfigFile() throws {
		let url = try Bundle.module.testDataURL(named: "XCConfigFiles.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try ValidateBuildSettingsRule().run(env)

		XCTAssertFalse(violations.isEmpty)
	}
}
