// swift-tools-version: 5.9

import PackageDescription

let package = Package(
	name: "XCLint",
	platforms: [.macOS(.v13)],
	products: [
		.executable(name: "xclint", targets: ["clitool"]),
		// I'd prefer to name this "XCLint", but it seems like Xcode cannot handle two products with the same name, even if they differ in case
		.library(name: "XCLinting", targets: ["XCLinting"]),
	],
	dependencies: [
		.package(url: "https://github.com/tuist/XcodeProj", from: "8.15.0"),
		.package(url: "https://github.com/mattmassicotte/XCConfig", branch: "main"),
	],
	targets: [
		.executableTarget(name: "clitool", dependencies: ["XCLinting"]),
		.target(name: "XCLinting", dependencies: ["XCConfig", "XcodeProj"]),
		.testTarget(name: "XCLintTests", dependencies: ["XCLinting"]),

	]
)

let swiftSettings: [SwiftSetting] = [
	.enableExperimentalFeature("StrictConcurrency")
]

for target in package.targets {
	var settings = target.swiftSettings ?? []
	settings.append(contentsOf: swiftSettings)
	target.swiftSettings = settings
}
