

public struct Component {
	
	public let id: String
	public let bind: String
	
	init?(node: ASTNode) {
		guard
			node.kind == .component,
			let id = node[tokenKey: .id]?.value,
			let bind = node[tokenKey: .bind]?.value
			else { return nil }
		self.id = id
		self.bind = bind
	}
	
}
