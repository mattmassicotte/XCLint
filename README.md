[![Build Status][build status badge]][build status]

# XCLint
Xcode project linting

This project is still pretty young, and has rough edges. However, it kinda works! So, please do give it a shot.

## Installation

XCLint is available as both a commandline tool and a library.

Tool:

```
brew tap mattmassicotte/XCLint https://github.com/mattmassicotte/XCLint.git
brew install xclint
```

Package:

```swift
dependencies: [
    .package(url: "https://github.com/mattmassicotte/XCLint", branch: "main")
],
targets: [
    .testTarget(name: "MyTarget", dependencies: ["XCLinting"]),
]
```

## Tool Usage

Just point the `xclint` binary at your `.xcodeproj`. Check out its `-h` flag for more usage.

```
# xclint /path/to/MyProject.xcodeproj
```

This will run a default set of rules. But, you can customize its behavior with a `.xclint.yml` file. The basic structure borrows a lot from [SwiftLint](https://github.com/realm/SwiftLint).

```yaml
# Some rules may not be appropriate for all projects. You must opt-in those.
opt_in_rules:
  - embedded_build_setting # checks for build settings in the project file
  - groups_sorted          # checks that all group contents are alphabetically sorted

# Other rules make sense for all projects by default. You must opt-out of those.
disabled_rules:
  - build_files_ordered # checks that the ordering of techincally-unordered collections Xcode writes out is preserved
```

## Alternatives

I was kind of hoping that some else had built something like this. And they have! However, none of the things I found are maintained any more.

- [ProjLint](https://github.com/JamitLabs/ProjLint)
- [XcodeProjLint](https://github.com/RocketLaunchpad/XcodeProjLint)
- [xcprojectlint](https://github.com/americanexpress/xcprojectlint)

## Contributing and Collaboration

I'd love to hear from you! Get in touch via [mastodon](https://mastodon.social/@mattiem), an issue, or a pull request.

I prefer collaboration, and would love to find ways to work together if you have a similar project.

I prefer indentation with tabs for improved accessibility. But, I'd rather you use the system you want and make a PR than hesitate because of whitespace.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

[build status]: https://github.com/mattmassicotte/XCLint/actions
[build status badge]: https://github.com/mattmassicotte/XCLint/workflows/CI/badge.svg
