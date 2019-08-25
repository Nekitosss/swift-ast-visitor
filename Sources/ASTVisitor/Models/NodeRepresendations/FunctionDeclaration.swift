

public struct FunctionDeclaration {
	
	public let location: LocationRange
	public let name: String
	public let type: String
	
	init?(node: ASTNode) {
		guard
			node.kind == .funcDecl,
			let locationToken = node[tokenKey: .range].getOne(),
			let location = LocationRange(string: locationToken.value),
			let nameToken = node.info[safe: 1],
			let typeToken = node[tokenKey: .type].getOne()
			else { return nil }
		
		self.location = location
		self.name = nameToken.value
		self.type = typeToken.value
	}
	
}
