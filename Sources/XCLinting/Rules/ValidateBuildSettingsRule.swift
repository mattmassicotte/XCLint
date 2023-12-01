import Foundation

import XcodeProj
import XCConfig

/// Detect build settings that are deprecated or no longer functional.
///
/// This currently runs a superficial check. It does not perform configuration evaluation yet.
struct ValidateBuildSettingsRule {
	func run(_ environment: XCLinter.Environment) throws -> [Violation] {
		var violations = [Violation]()

		try enumerateSettings(with: environment) { target, config, settings in
			print("\(target.name), \(config.name), \(settings)")
			
			violations.append(contentsOf: evaluateTargetSettings(target.name, settings: settings))
		}

		return violations
	}

	func evaluateTargetSettings(_ targetName: String, settings: [BuildSetting: String]) -> [Violation] {
		var violations = [Violation]()

		for (setting, value) in settings {
			let name = setting.rawValue
			let status = setting.evaluateValue(value)

			switch status {
			case .deprecated:
				violations.append(.init("\(targetName):\(name) = \(value) is deprecated"))
			case .invalid:
				violations.append(.init("\(targetName):\(name) = \(value) is invalid"))
			case .valid:
				break
			}
		}

		return violations
	}

	func enumerateSettings(
		with environment: XCLinter.Environment,
		block: (PBXTarget, XCBuildConfiguration, [BuildSetting: String]) throws -> Void
	) throws {
		let project = environment.project
		let sourceRootURL = environment.projectRootURL.deletingLastPathComponent()
		let evaluator = Evaluator(rootURL: sourceRootURL)
		let platformStatements: [Statement] = []

		try project.pbxproj.enumerateBuildSettingStatements(rootURL: sourceRootURL) { proj, target, config, statementsList in
			let heirarchy = [platformStatements] + statementsList

			let settings = try evaluator.evaluate(heirarchy: heirarchy)

			try block(target, config, settings)
		}
	}
}
