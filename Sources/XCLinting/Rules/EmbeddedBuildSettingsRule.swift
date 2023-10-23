import Foundation

func embeddedBuildSettingsRule(_ environment: XCLinter.Environment) -> [Violation] {
	var violations = [Violation]()

	for target in environment.project.pbxproj.legacyTargets {
		for config in target.buildConfigurationList?.buildConfigurations ?? [] {
			if config.buildSettings.isEmpty == false {
				violations.append(.init("found some settings for \(target.name), \(config.name)"))
			}
		}
	}

	for target in environment.project.pbxproj.nativeTargets {
		for config in target.buildConfigurationList?.buildConfigurations ?? [] {
			if config.buildSettings.isEmpty == false {
				violations.append(.init("found some settings for \(target.name), \(config.name)"))
			}
		}
	}

	return violations
}
