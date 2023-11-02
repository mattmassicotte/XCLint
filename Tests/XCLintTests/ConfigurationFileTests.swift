import XCTest

import XCLinting

final class ConfigurationTests: XCTestCase {
	func testReadEmptyFile() throws {
		let string = "{}"

		let config = try JSONDecoder().decode(Configuration.self, from: Data(string.utf8))

		XCTAssertEqual(config, Configuration())
	}

	func testReadDisabledRules() throws {
		let string = """
{
	"disabled_rules": ["a", "b", "c"]
}
"""

		let config = try JSONDecoder().decode(Configuration.self, from: Data(string.utf8))

		let expected = Configuration(disabledRules: Set(["a", "b", "c"]))

		XCTAssertEqual(config, expected)
	}

	func testReadOptInRules() throws {
		let string = """
{
	"opt_in_rules": ["a", "b", "c"]
}
"""

		let config = try JSONDecoder().decode(Configuration.self, from: Data(string.utf8))

		let expected = Configuration(optInRules: Set(["a", "b", "c"]))

		XCTAssertEqual(config, expected)
	}

	func testReadRules() throws {
		let string = """
{
	"rule1": "warning",
	"rule2": "error",
}
"""

		let config = try JSONDecoder().decode(Configuration.self, from: Data(string.utf8))

		let expected = Configuration(rules: [
			"rule1": .warning,
			"rule2": .error
		])

		XCTAssertEqual(config, expected)
	}
}
