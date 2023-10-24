public enum XCLintError: Error {
	case noProjectFileSpecified
	case projectFileNotFound(String)
	case badProjectFile(String)
	
	public var localizedDescription: String {
		switch self {
		case .noProjectFileSpecified:
			return "Project file was not specified."
		case let .projectFileNotFound(path):
			return "Project file not found at '\(path)'."
		case let .badProjectFile(message):
			return "Bad project file: \(message)."
		}
	}
}
