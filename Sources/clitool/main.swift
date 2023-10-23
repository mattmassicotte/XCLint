import Foundation
import ArgumentParser
import XcodeProj
import XCLinting
import Yams

struct XCLintCommand: ParsableCommand {
	static var configuration = CommandConfiguration(commandName: "xclint")

	@Flag(
		name: .shortAndLong,
		help: "Print the version and exit."
	)
	var version: Bool = false
	
	@Argument(help: "The path to the .xcodeproj bundle to lint (defaults to looking in the current working directory).")
	var projectFile: String?

	@Option(
		name: .customLong("config"),
		help: "The path to an xclint configuraton file (defaults to looking in the directory of the target .xcodeproj)."
	)
	var configFilePath: String?

	func run() throws {
		if version {
			throw CleanExit.message("0.0.1")
		}

		// find the xcodeproj file
		guard let projPath = resolvedProjectFilePath() else {
			throw XCLintError.noProjectFileSpecified
		}

		// find the effective environment
		let config = try resolvedConfiguration(projectRootURL: URL(filePath: projPath))
		let env = try XCLinter.Environment(projectPath: projPath, configuration: config)

		let linter = XCLinter(environment: env)

		let violations = try linter.run()
		
		for violation in violations {
			print(violation.message)
		}
		
		if !violations.isEmpty {
			throw ExitCode.failure
		}
	}
}

extension XCLintCommand {
	private func resolvedProjectFilePath() -> String? {
		if let path = projectFile {
			return path
		}

		let currentPath = FileManager.default.currentDirectoryPath

		guard let contents = try? FileManager.default.contentsOfDirectory(atPath: currentPath) else {
			return nil
		}

		return contents.first(where: { $0.hasSuffix(".xcodeproj") })
	}

	private func resolvedConfigFileURL(projectRootURL: URL) -> URL? {
		if let path = configFilePath {
			return URL(filePath: path, directoryHint: .notDirectory)
		}

		let defaultURL = projectRootURL.deletingLastPathComponent().appending(component: ".xclint.yml")
		let path = defaultURL.path(percentEncoded: true)

		guard FileManager.default.isReadableFile(atPath: path) else {
			return nil
		}

		return defaultURL
	}

	private func resolvedConfiguration(projectRootURL: URL) throws -> Configuration {
		guard let url = resolvedConfigFileURL(projectRootURL: projectRootURL) else {
			return Configuration()
		}

		let data = try Data(contentsOf: url)
		return try YAMLDecoder().decode(Configuration.self, from: data)
	}
}

XCLintCommand.main()
