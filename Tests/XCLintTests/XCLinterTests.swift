import XCTest
import XCLinting

final class XCLinterTests: XCTestCase {
	
	func testEmptyProjectPathThrowsError() throws {
		do {
			_ = try XCLinter(projectPath: "")
			XCTFail()
		} catch XCLintError.noProjectFileSpecified {
		} catch {
			XCTFail("wrong error: \(error)")
		}
	}
	
	
	func testMissingProjectFileThrowsError() throws {
		do {
			_ = try XCLinter(projectPath: "/dev/null")
			XCTFail()
		} catch XCLintError.projectFileNotFound {
		} catch {
			XCTFail("wrong error: \(error)")
		}
	}
}
