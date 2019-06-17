import XCTest
@testable import ASTVisitor

final class ASTVisitorTests: XCTestCase {
	
	private let parser = Parser()
	
	
	func testAstParsing() {
		let file = fileContent(fileName: "TestComposedTypealiasFailure")
		let ast = parser.parse(content: file)
		
		XCTAssertFalse(ast.children.isEmpty)
	}
	
	func testAstVisiting() {
		let file = fileContent(fileName: "TestComposedTypealiasFailure")
		let visitor = Visitor(content: file)
		
		visitor.visit(predicate: { $0.kind == .declrefExpr }, visitChildNodesForFoundedPredicate: true) { node, parents in
			
			switch node.typedNode {
			case .functionDeclaration(let info):
				print(info)
			case .unknown:
				break
			}
		}
		
	}
	
}

func fileContent(fileName: String) -> String {
	let testFileBundlePath = Bundle(for: ASTVisitorTests.self).path(forResource: "TestFiles", ofType: "bundle")!
	let filePath = Bundle(path: testFileBundlePath)!.path(forResource: fileName, ofType: "ast")!
	let data = FileManager.default.contents(atPath: filePath)!
	return String(data: data, encoding: .utf8)!
}
