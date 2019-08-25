

public struct PatternTyped {
	
	public let type: String
	
	init?(node: ASTNode) {
		guard
			node.kind == .patternTyped,
			let type = node[tokenKey: .type].getOne()?.value
			else { return nil }
		self.type = type
	}
	
}
