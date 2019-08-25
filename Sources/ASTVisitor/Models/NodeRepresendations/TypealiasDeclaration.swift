

import Foundation

public struct TypealiasDeclaration {
	
	public let name: String
	public let sourceTypeName: String
	public let access: String
	public let range: LocationRange
	
	init?(node: ASTNode) {
		guard node.kind == .typealiasDecl,
			let typeToken = node[tokenKey: .type].getSeveral(),
			let name = typeToken.first?.value,
			let sourceTypeName = typeToken.last?.value,
			let access = node[tokenKey: .access].getOne()?.value,
			let rangeToken = node[tokenKey: .range].getOne()?.value,
			let range = LocationRange(string: rangeToken)
			else { return nil }
		
		self.name = name
		self.sourceTypeName = sourceTypeName
		self.access = access
		self.range = range
	}
}
