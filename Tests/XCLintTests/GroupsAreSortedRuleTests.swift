import XCTest

@testable import XCLinting
import XcodeProj

final class GroupsAreSortedRuleTests: XCTestCase {
    func testProjectWithGroupsSorted() throws {
        let url = try Bundle.module.testDataURL(named: "SortedGroups.xcodeproj")
        
        let project = try XcodeProj(pathString: url.path)
        
        let env = XCLinter.Environment(
            project: project,
            projectRootURL: url,
            configuration: Configuration()
        )
        
        let violations = groupsAreSortedRule(env)
        XCTAssertTrue(violations.isEmpty)
    }
    
    func testProjectWithoutGroupsSorted() throws {
        let url = try Bundle.module.testDataURL(named: "UnsortedGroups.xcodeproj")
        
        let project = try XcodeProj(pathString: url.path)
        
        let env = XCLinter.Environment(
            project: project,
            projectRootURL: url,
            configuration: Configuration()
        )
        
        let violations = groupsAreSortedRule(env)
        XCTAssertFalse(violations.isEmpty)
    }
}

