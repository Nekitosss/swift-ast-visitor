
import Foundation

public final class Visitor {
	
	private let parser = Parser()
	private let content: String
	
	public init(content: String) {
		self.content = content
	}
	
	public init(fileURL: URL) throws {
		let data = try Data(contentsOf: fileURL)
		self.content = String(data: data, encoding: .utf8)!
	}
	
	public func visit(predicate: (ASTNode) -> Bool, visitChildNodesForFoundedPredicate: Bool, handler: (ASTNode, [ASTNode]) -> Void) {
		let ast = self.parser.parse(content: content)
		
		withoutActuallyEscaping(predicate) { predicate in
			withoutActuallyEscaping(handler) { handler in
				func iterate(nodes: [ASTNode], parents: [ASTNode], predicateWasFoundInParent: Bool) {
					for node in nodes {
						var wasFound = false
						if predicate(node) || (predicateWasFoundInParent && visitChildNodesForFoundedPredicate) {
							handler(node, parents)
							wasFound = true
						}
						iterate(nodes: node.children, parents: parents + [node], predicateWasFoundInParent: wasFound || predicateWasFoundInParent)
					}
				}
				
				iterate(nodes: ast.children, parents: [], predicateWasFoundInParent: false)
			}
		}
		
	}
	
}
