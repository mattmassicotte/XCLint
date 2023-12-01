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
		.package(url: "https://github.com/mattmassicotte/XCConfig", revision: "2379629e1f44a6476afc709d9fcffb02bf7fa724"),
		.package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.3"),
		.package(url: "https://github.com/jpsim/Yams.git", from: "5.0.0"),
	],
	targets: [
		.executableTarget(name: "clitool", dependencies: [
			"XCLinting",
			.product(name: "ArgumentParser", package: "swift-argument-parser"),
			"Yams"
		]),
		.target(name: "XCLinting", dependencies: ["XCConfig", "XcodeProj"]),
		.testTarget(
			name: "XCLintTests",
			dependencies: ["XCLinting", "XcodeProj"],
			resources: [
				.copy("TestData"),
			]
		),
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
