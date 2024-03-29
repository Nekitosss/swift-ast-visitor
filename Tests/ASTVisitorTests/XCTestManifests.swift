#if !canImport(ObjectiveC)
import XCTest

extension ASTVisitorTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ASTVisitorTests = [
        ("testAstParsing", testAstParsing),
        ("testAstVisiting", testAstVisiting),
        ("testBracketInTokenUsage", testBracketInTokenUsage),
        ("testCommaGrouping", testCommaGrouping),
        ("testPlainChildrenParsing", testPlainChildrenParsing),
        ("testSourceFile", testSourceFile),
        ("testSquareBracketProperParsing", testSquareBracketProperParsing),
        ("testSubstitutionBuilding", testSubstitutionBuilding),
        ("testTypealiasDeclaration", testTypealiasDeclaration),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ASTVisitorTests.__allTests__ASTVisitorTests),
    ]
}
#endif
