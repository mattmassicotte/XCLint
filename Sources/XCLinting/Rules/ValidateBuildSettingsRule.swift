import Foundation

import XcodeProj
import XCConfig

/// Detect build settings that are deprecated or no longer functional.
///
/// This currently runs a superficial check. It does not perform configuration evaluation yet.
struct ValidateBuildSettingsRule {
	func run(_ environment: XCLinter.Environment) throws -> [Violation] {
		var violations = [Violation]()

		// check top-level
		for config in environment.project.pbxproj.buildConfigurations {
			violations.append(contentsOf: evaluateTargetSettings("Project", config: config))
		}

		// check targets
		environment.project.pbxproj.enumerateBuildConfigurations { name, configList in
			for config in configList.buildConfigurations {
				violations.append(contentsOf: evaluateTargetSettings(name, config: config))
			}
		}

		return violations
	}

	func evaluateTargetSettings(_ name: String, config: XCBuildConfiguration) -> [Violation] {
		var violations = [Violation]()

		for pair in config.buildSettings {
			guard let setting = BuildSetting(rawValue: pair.key) else { continue }

			let status = setting.evaluateValue(pair.value as? String ?? "")

			switch status {
			case .deprecated:
				violations.append(.init("\(name):\(pair.key) = \(pair.value) is deprecated"))
			case .invalid:
				violations.append(.init("\(name):\(pair.key) = \(pair.value) is invalid"))
			case .valid:
				break
			}
		}

		return violations
	}
}
