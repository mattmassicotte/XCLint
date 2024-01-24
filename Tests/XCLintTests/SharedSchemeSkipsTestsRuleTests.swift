import XCTest

@testable import XCLinting
import XcodeProj

final class SharedSchemeSkipsTestsRuleTests: XCTestCase {
	func testProjectWithNoSkippedTests() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try SharedSchemeSkipsTestsRule().run(env)

		XCTAssertTrue(violations.isEmpty)
	}

	func testProjectWithSkippedTests() throws {
		let url = try Bundle.module.testDataURL(named: "SchemeSkipsTests.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try SharedSchemeSkipsTestsRule().run(env)

		XCTAssertFalse(violations.isEmpty)
	}

	func testProjectWithSkippedTestBundles() throws {
		let url = try Bundle.module.testDataURL(named: "SchemeSkipsTestBundles.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try SharedSchemeSkipsTestsRule().run(env)

		XCTAssertFalse(violations.isEmpty)
	}
}
