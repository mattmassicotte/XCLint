public protocol Rule {
	init(configuration: Configuration)
	func run() throws -> [Violation]
}
