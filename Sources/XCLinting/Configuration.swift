import Foundation
import XcodeProj
import PathKit

public final class Configuration {
	public let project: XcodeProj
	public let projectText: String
	public let projectRoot: Path
	
	public init(project: XcodeProj, projectText: String, projectRoot: Path) {
		self.project = project
		self.projectText = projectText
		self.projectRoot = projectRoot
	}
}
