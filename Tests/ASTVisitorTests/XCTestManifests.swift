import XCTest

#if !canImport(ObjectiveC)
public func allManifestTests() -> [XCTestCaseEntry] {
    return [
        testCase(ASTVisitorTests.allTests)
    ]
}
#endif
