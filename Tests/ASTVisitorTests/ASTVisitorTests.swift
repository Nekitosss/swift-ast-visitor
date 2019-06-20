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
		
		visitor.visit(predicate: { $0.kind == .substitutionMap }, visitChildNodesForFoundedPredicate: true) { node, parents in
			
			switch node.typedNode {
			case .functionDeclaration(let info):
				print(info)
			case .unknown:
				break
			}
		}
	}
	
	func testSourceFile() {
		let ast = parser.parse(content: fileContent(fileName: "TestSourceFile"))
		
		XCTAssertEqual(ast.children.count, 1)
		XCTAssertEqual(ast.children[0].kind, .sourceFile)
		XCTAssertTrue(ast.children[0].children.isEmpty)
	}
	
	
	func testSquareBracketProperParsing() {
		let ast = parser.parse(content: fileContent(fileName: "TestSquareBracketProperParsing"))
		
		guard let child = ast.children.first else {
			XCTFail()
			return
		}
		XCTAssertEqual(child.info.count, 1)
		
		let rangeToken = child.info[0]
		XCTAssertEqual(rangeToken.key, "range")
		XCTAssertEqual(rangeToken.value, "/Users/mockuser/development/ast/TestComposedTypealiasFailure.swift:9:1 - line:9:8")
	}
	
	
	func testPlainChildrenParsing() {
		let ast = parser.parse(content: fileContent(fileName: "TestPlainChildrenParsing"))
		
		guard let sourceFileNode = ast.children.first else {
			XCTFail()
			return
		}
		
		XCTAssertEqual(sourceFileNode.children.count, 2)
		XCTAssertEqual(sourceFileNode.children[0].kind, .importDecl)
		XCTAssertEqual(sourceFileNode.children[1].kind, .protocolDecl)
	}
	
	func testCommaGrouping() {
		let ast = parser.parse(content: fileContent(fileName: "TestCommaGrouping"))
		
		guard let node = ast.children.first else {
			XCTFail()
			return
		}
		XCTAssertEqual(node.info.count, 2)
		
		XCTAssertEqual(node.info[0].value, "create(withInt:)")
		XCTAssertEqual(node.info[1].value, "(Nested.MyClass.Type) -> (Int) -> MyTypealias")
	}
	
	func testBracketInTokenUsage() {
		let ast = parser.parse(content: fileContent(fileName: "TestBracketInTokenUsage"))
		guard let node = ast.children.first else {
			XCTFail()
			return
		}
		
		XCTAssertEqual(node[tokenKey: .bind]?.value, "DITranquillity.(file).DIContainer")
	}
	
}

func fileContent(fileName: String) -> String {
	let testFileBundlePath = Bundle(for: ASTVisitorTests.self).path(forResource: "TestFiles", ofType: "bundle")!
	let filePath = Bundle(path: testFileBundlePath)!.path(forResource: fileName, ofType: "ast")!
	let data = FileManager.default.contents(atPath: filePath)!
	return String(data: data, encoding: .utf8)!
}
