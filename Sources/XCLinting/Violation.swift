import XcodeProj

public struct Violation: Hashable {
	public var message: String
	public var objects: [PBXObject]

	public init(_ message: String, objects: [PBXObject] = []) {
		self.message = message
		self.objects = objects
	}
}
