import XCTest

import ASTVisitorTests

var tests = [XCTestCaseEntry]()
tests += ASTVisitorTests.__allTests()

XCTMain(tests)
