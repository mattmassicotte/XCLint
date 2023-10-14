import XcodeProj

public struct Violation {
	public var message: String
	public var objects: [PBXObject]
	
	public init(_ message: String, objects: [PBXObject] = []) {
		self.message = message
		self.objects = objects
	}
}
