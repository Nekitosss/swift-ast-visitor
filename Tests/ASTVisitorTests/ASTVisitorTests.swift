import XCTest
@testable import ASTVisitor

final class ASTVisitorTests: XCTestCase {
	
	private let parser = Parser()
	
	static var allTests = [
		("testAstParsing", testAstParsing),
		("testAstVisiting", testAstVisiting),
		("testSourceFile", testSourceFile),
		("testSquareBracketProperParsing", testSquareBracketProperParsing),
		("testPlainChildrenParsing", testPlainChildrenParsing),
		("testCommaGrouping", testCommaGrouping),
		("testBracketInTokenUsage", testBracketInTokenUsage),
		("testSubstitutionBuilding", testSubstitutionBuilding),
		("testTypealiasDeclaration", testTypealiasDeclaration)
	]
	
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
			default:
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
		
		XCTAssertEqual(node[tokenKey: .bind].getOne()?.value, "DITranquillity.(file).DIContainer")
	}
	
	func testSubstitutionBuilding() {
		let ast = parser.parse(content: fileContent(fileName: "TestSubstitutionBuilding"))
		
		guard let node = ast.children.first else {
			XCTFail()
			return
		}
		
		XCTAssertEqual(node.children.count, 2)
		
		let plainSubstitution = node.children[0]
		switch plainSubstitution.typedNode {
		case .substitution(let info):
			XCTAssertEqual(info.from, "Impl")
			XCTAssertEqual(info.to, "MyTypealias")
		default:
			XCTFail()
		}
		
		let complexSubstitution = node.children[1]
		switch complexSubstitution.typedNode {
		case .substitution(let info):
			XCTAssertEqual(info.from, "Parent")
			XCTAssertEqual(info.to, "MyProtocol & MySecondProtocol")
		default:
			XCTFail()
		}
	}
	
	func testTypealiasDeclaration() {
		let ast = parser.parse(content: fileContent(fileName: "TestTypealiasDeclaration"))
		
		guard let node = ast.children.first else {
			XCTFail()
			return
		}
		
		switch node.typedNode {
		case .typealiasDeclaration(let info):
			XCTAssertEqual(info.sourceTypeName, "MyClass")
			XCTAssertEqual(info.name, "MyClassTypealias.Type")
		default:
			XCTFail()
		}
	}
	
	func testGenericSubstitution() {
		let ast = parser.parse(content: fileContent(fileName: "TestGenericSubstitution"))
		
		guard let substitution = ast.children.first?[.substitutionMap].getOne()?[.substitution].getSeveral()?.last else {
			XCTFail()
			return
		}
		guard substitution.info.count == 3 else {
			XCTFail("Substitution should contains: P0, ->, A<B>. Actual: \(substitution.info.map({ $0.value }))")
			return
		}
		XCTAssertEqual(substitution.info[0].value, "P0")
		XCTAssertEqual(substitution.info[1].value, "->")
		XCTAssertEqual(substitution.info[2].value, "DIByTag<MyTag, String>")
	}
	
}

func fileContent(fileName: String) -> String {
	print(FileManager.default.currentDirectoryPath)
	#if canImport(ObjectiveC)

	let bundle = Bundle(for: ASTVisitorTests.self)
	let testFileBundlePath = bundle.path(forResource: "TestFiles", ofType: "bundle")!
	let filePath = Bundle(path: testFileBundlePath)!.path(forResource: fileName, ofType: "ast")!
	let data = FileManager.default.contents(atPath: filePath)!
	return String(data: data, encoding: .utf8)!

	#else

	let filePath = FileManager.default.currentDirectoryPath + "/TestFiles.bundle/" + fileName + ".ast"
	let data = FileManager.default.contents(atPath: filePath)!
	return String(data: data, encoding: .utf8)!
	#endif
}
