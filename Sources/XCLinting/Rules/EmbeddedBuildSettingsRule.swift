import Foundation

import XcodeProj

struct EmbeddedBuildSettingsRule {
	func run(_ environment: XCLinter.Environment) throws -> [Violation] {
		var violations = [Violation]()

		// check top-level
		for project in environment.project.pbxproj.projects {
			for config in project.buildConfigurationList?.buildConfigurations ?? [] {
				if config.buildSettings.isEmpty == false {
					violations.append(.init("found settings for project \(project.name), \(config.name)"))
				}
			}
		}

		// check targets
		environment.project.pbxproj.enumerateBuildConfigurations { name, configList in
			for config in configList.buildConfigurations {
				if config.buildSettings.isEmpty == false {
					violations.append(.init("found settings for target \(name), \(config.name)"))
				}
			}
		}

		return violations
	}
}
