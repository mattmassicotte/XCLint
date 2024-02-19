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

		let targetNames = environment.project.pbxproj.projects.flatMap { $0.targets }.map { $0.name }
		var targetNameSet = Set(targetNames)

		for entry in try fileManager.contentsOfDirectory(atPath: sharedSchemesURL.path) {
			let entryPath = sharedSchemesURL
				.appendingPathComponent(entry, isDirectory: false)
				.standardizedFileURL
				.path

			let scheme = try XCScheme(pathString: entryPath)

			for entry in scheme.buildAction?.buildActionEntries ?? [] {
				let name = entry.buildableReference.blueprintName

				targetNameSet.remove(name)
			}

			for entry in scheme.testAction?.testables ?? [] {
				let name = entry.buildableReference.blueprintName

				targetNameSet.remove(name)
			}
		}

		return targetNameSet.map { name in
			Violation("No shared scheme found that references \(name)")
		}
	}
}
