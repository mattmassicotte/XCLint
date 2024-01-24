import Foundation

import XcodeProj

/// Make sure all file references use relative paths.
struct RelativePathsRule {
	func run(_ environment: XCLinter.Environment) throws -> [Violation] {
		var violations = [Violation]()

		// check top-level
		for project in environment.project.pbxproj.projects {
			guard let group = project.mainGroup else { continue }

			violations.append(contentsOf: checkGroup(group))
		}

		return violations
	}

	private func checkGroup(_ group: PBXGroup) -> [Violation] {
		var violations = [Violation]()

		let groupName = group.name ?? group.path ?? "???"

		for element in group.children {
			let elementName = element.name ?? element.path ?? "???"

			if element.path?.starts(with: "/") == true {
				violations.append(.init("\(groupName):\(elementName) has an absolute file path"))
			}

			if let subgroup = element as? PBXGroup {
				violations.append(contentsOf: checkGroup(subgroup))
			}
		}

		return violations
	}
}
