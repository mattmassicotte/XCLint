import ArgumentParser

struct XCLintCommand: ParsableCommand {
	static var configuration = CommandConfiguration(commandName: "xclint")

	@Flag(
		name: .shortAndLong,
		help: "Print the version and exit."
	)
	var version: Bool = false
	
	func run() throws {
		if version {
			throw CleanExit.message("0.0.1")
		}
	}
}

XCLintCommand.main()
