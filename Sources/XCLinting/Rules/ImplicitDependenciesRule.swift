import Foundation

import XcodeProj
import XCConfig

// this is needed for XCScheme creation
import PathKit

/// Detect when scheme implicit dependencies are enabled for any schemes.
struct ImplicitDependenciesRule {
	func run(_ environment: XCLinter.Environment) throws -> [Violation] {
		let sharedSchemesURL = environment
			.projectRootURL
			.appendingPathComponent("xcshareddata/xcschemes", isDirectory: true)
			.standardizedFileURL

		var violations = [Violation]()

		violations.append(contentsOf: try validateSchemes(in: sharedSchemesURL))

		let userSchemesURL = environment
			.projectRootURL
			.appendingPathComponent("xcuserdata/xcschemes", isDirectory: true)
			.standardizedFileURL

		violations.append(contentsOf: try validateSchemes(in: userSchemesURL))

		return violations
	}

	private func validateSchemes(in url: URL) throws -> [Violation] {
		let fileManager = FileManager.default

		guard fileManager.isReadableFile(atPath: url.path) else { return [] }

		var violations = [Violation]()

		for entry in try fileManager.contentsOfDirectory(atPath: url.path) {
			let entryPath = url
				.appendingPathComponent(entry, isDirectory: false)
				.standardizedFileURL
				.path

			let scheme = try XCScheme(path: Path(entryPath))

			if scheme.buildAction?.buildImplicitDependencies == true {
				violations.append(.init("Scheme \"\(entry)\" has implicit dependencies enabled"))
			}
		}

		return violations
	}
}
