import Foundation
import ArgumentParser
import XcodeProj
import PathKit
import XCLinting

struct XCLintCommand: ParsableCommand {
	static var configuration = CommandConfiguration(commandName: "xclint")

	@Flag(
		name: .shortAndLong,
		help: "Print the version and exit."
	)
	var version: Bool = false
	
	@Argument(help: "The path to the .xcodeproj bundle to lint.")
	var projectFile: String = ""

	func run() throws {
		if version {
			throw CleanExit.message("0.0.1")
		}
		
		let linter: XCLinter
		do {
			linter = try XCLinter(projectPath: projectFile)
		} catch {
			throw ValidationError(error.localizedDescription)
		}

		let violations: [Violation]
		do {
			violations = try linter.run()
		} catch {
			throw ValidationError(error.localizedDescription)
		}
		
		for violation in violations {
			print(violation.message)
		}
		
		if !violations.isEmpty {
			throw ExitCode.failure
		}
	}
}

XCLintCommand.main()
