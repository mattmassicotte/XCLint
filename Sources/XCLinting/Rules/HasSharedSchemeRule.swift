import Foundation

import XcodeProj
import XCConfig

/// Ensure that targets have a shared scheme on disk.
struct SharedSchemesRule {
	func run(_ environment: XCLinter.Environment) throws -> [Violation] {
		let sharedSchemesURL = environment
			.projectRootURL
			.appendingPathComponent("xcshareddata/xcschemes", isDirectory: true)
			.standardizedFileURL

		let fileManager = FileManager.default

		guard fileManager.isReadableFile(atPath: sharedSchemesURL.path) else {
			return [.init("Shared scheme directory not found")]
		}

		let schemes = Set(try fileManager.contentsOfDirectory(atPath: sharedSchemesURL.path))

		var violations = [Violation]()

		// check targets
		environment.project.pbxproj.enumerateBuildConfigurations { name, configList in
			let schemeName = name + ".xcscheme"

			if schemes.contains(schemeName) {
				return
			}

			violations.append(.init("No shared scheme found for \"\(name)\""))
		}

		return violations
	}
}
