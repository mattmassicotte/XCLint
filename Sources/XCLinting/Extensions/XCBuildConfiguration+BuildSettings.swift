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

	var buildSettingsAssignments: [Assignment] {
		buildSettings.compactMap { (key, value) -> Assignment? in
			guard let value = value as? String else { return nil }

			return Assignment(key: key, value: value)
		}
	}
}
