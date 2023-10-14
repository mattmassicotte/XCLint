public enum XCLintError: Error {
	case noProjectFileSpecified
	case projectFileNotFound(String)
	case badProjectFile(Error)
	
	public var localizedDescription: String {
		switch self {
		case .noProjectFileSpecified:
			return "Project file was not specified."
		case let .projectFileNotFound(path):
			return "Project file not found at '\(path)'."
		case let .badProjectFile(error):
			return "Bad project file: \(error.localizedDescription)."
		}
	}
}
