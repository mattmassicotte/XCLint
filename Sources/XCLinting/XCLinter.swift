import Foundation
import XcodeProj
import PathKit

public struct XCLinter {
	public var configuration: Configuration
	public var rules: [Rule.Type]
	
	public init(projectPath: String) throws {
		guard !projectPath.isEmpty else {
			throw XCLintError.noProjectFileSpecified
		}

		let path = Path(projectPath)
		guard path.isDirectory else {
			throw XCLintError.projectFileNotFound(projectPath)
		}

		let xcodeproj: XcodeProj
		let projectText: String
		do {
			xcodeproj = try XcodeProj(path: path)
			projectText = try String(contentsOf: URL(fileURLWithPath: projectPath).appendingPathComponent("project.pbxproj"))
		} catch {
			throw XCLintError.badProjectFile(error)
		}
		
		self.init(configuration: Configuration(project: xcodeproj, projectText: projectText, projectRoot: path), rules: [])
	}
	
	public init(configuration: Configuration, rules: [Rule.Type]) {
		self.configuration = configuration
		self.rules = rules
	}
	
	public func run() throws -> [Violation] {
		var violations = [Violation]()
		for ruleType in rules {
			let rule = ruleType.init(configuration: configuration)
			violations.append(contentsOf: try rule.run())
		}
		return violations
	}
}
