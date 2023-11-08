import Foundation

import XcodeProj

extension PBXProj {
	func enumerateBuildConfigurations(_ block: (String, XCConfigurationList) throws -> Void) rethrows {
		for target in legacyTargets {
			guard let list = target.buildConfigurationList else { continue }

			try block(target.name, list)
		}

		for target in nativeTargets {
			guard let list = target.buildConfigurationList else { continue }

			try block(target.name, list)
		}
	}
}
