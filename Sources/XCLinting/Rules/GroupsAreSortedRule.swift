import Foundation
import XcodeProj

func groupsAreSortedRule(_ environment: XCLinter.Environment) -> [Violation] {
    var violations = [Violation]()
    for group in environment.project.pbxproj.groups {
        violations.append(contentsOf: validateGroupIsSorted(group))
    }
    return violations
}

private func validateGroupIsSorted(_ group: PBXGroup) -> [Violation] {
    var violations = [Violation]()
    let children = group.children.compactMap(\.path)
    let sortedChildren = children.sorted { lhs, rhs in
        lhs.compare(
            rhs,
            options: [
                .numeric,
                .caseInsensitive,
                .widthInsensitive,
                .forcedOrdering
            ],
            locale: .current
        ) == .orderedAscending
    }
    if children != sortedChildren {
        violations.append(.init("Group \"\(group.path ?? "???")\" contains unsorted children"))
    }
    for childGroup in group.children.compactMap({ $0 as? PBXGroup }) {
        violations.append(contentsOf: validateGroupIsSorted(childGroup))
    }
    return violations
}
