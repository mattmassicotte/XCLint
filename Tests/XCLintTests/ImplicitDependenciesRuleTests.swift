import XCTest

@testable import XCLinting
import XcodeProj

final class ImplicitDependenciesRuleTests: XCTestCase {
	func testProjectWithImplicitDependencies() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try ImplicitDependenciesRule().run(env)

		XCTAssertFalse(violations.isEmpty)
	}

	func testProjectWithImplicitDependenciesDisabled() throws {
		let url = try Bundle.module.testDataURL(named: "ImplicitDependenciesDisabled.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try ImplicitDependenciesRule().run(env)

		XCTAssertTrue(violations.isEmpty)
	}
}
