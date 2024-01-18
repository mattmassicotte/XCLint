import Foundation

import XCConfig
import XcodeProj

extension XCBuildConfiguration {
	func baseConfigurationURL(with sourceRoot: String) throws -> URL? {
		guard let fullPath = try baseConfiguration?.fullPath(sourceRoot: sourceRoot) else {
			return nil
		}

		return URL(fileURLWithPath: fullPath, isDirectory: false)
	}

	var buildSettingsStatements: [Statement] {
		buildSettings.compactMap { (key, value) -> Statement? in
			guard let value = value as? String else { return nil }

			return Statement.assignment(Assignment(key: key, value: value))
		}
	}
}
