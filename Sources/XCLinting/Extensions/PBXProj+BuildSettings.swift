import Foundation

import XCConfig
import XcodeProj

extension Parser {
	func parse(contentsOf url: URL) throws -> [Statement] {
		let string = try String(contentsOf: url)

		return parse(string)
	}
}

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

	func enumerateTargets(_ block: (PBXProject, PBXTarget) throws -> Void) rethrows {
		for proj in projects {
			for target in proj.targets {
				try block(proj, target)
			}
		}
	}

	func enumerateBuildSettingStatements(
		rootURL: URL,
		_ block: (PBXProject, PBXTarget, XCBuildConfiguration, [[Statement]], URL?) throws -> Void
	) throws {
		let sourceRootPath = rootURL.path

		for proj in projects {
			let projConfigList = proj.buildConfigurationList

			for target in proj.targets {
				for config in target.buildConfigurationList?.buildConfigurations ?? [] {
					let projConfig = projConfigList?.configuration(name: config.name)
					let baseConfigURL = try projConfig?.baseConfigurationURL(with: sourceRootPath)
					let projConfigStatements = try baseConfigURL.map { try Parser().parse(contentsOf: $0) }
					let projStatements = projConfig?.buildSettingsStatements ?? []

					let configURL = try config.baseConfigurationURL(with: sourceRootPath)
					let configStatements = try configURL.map {try Parser().parse(contentsOf: $0) }
					let statements = config.buildSettingsStatements

					let heirarchy = [
						projConfigStatements ?? [],
						projStatements,
						configStatements ?? [],
						statements
					]

					try block(proj, target, config, heirarchy, configURL)
				}
			}
		}
	}
}
