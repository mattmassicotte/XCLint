import XCTest

@testable import XCLinting
import XcodeProj

final class TargetsUseXCConfigRuleTests: XCTestCase {
	func testTargetsWithoutXCConfigs() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try TargetsUseXCConfigRule().run(env)

		XCTAssertFalse(violations.isEmpty)
	}

	func testTargetsWithOnlyXCConfigs() throws {
		let url = try Bundle.module.testDataURL(named: "TargetsUseXCConfigFiles.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try TargetsUseXCConfigRule().run(env)

		XCTAssertTrue(violations.isEmpty)
	}
}
