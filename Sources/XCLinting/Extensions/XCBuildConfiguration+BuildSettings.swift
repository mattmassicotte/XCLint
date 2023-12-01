import Foundation

import XCConfig
import XcodeProj

extension XCBuildConfiguration {
	func baseConfigurationContent(with sourceRoot: String) throws -> String? {
		guard let fullPath = try baseConfiguration?.fullPath(sourceRoot: sourceRoot) else {
			return nil
		}

		return try String(contentsOf: URL(filePath: fullPath))
	}

	func baseConfigurationStatements(with sourceRoot: String) throws -> [Statement] {
		guard let content = try baseConfigurationContent(with: sourceRoot) else {
			return []
		}

		return Parser().parse(content)
	}

	var buildSettingsStatements: [Statement] {
		buildSettings.compactMap { (key, value) -> Statement? in
			guard let value = value as? String else { return nil }

			return Statement.assignment(Assignment(key: key, value: value))
		}
	}
}
