

public struct FunctionDeclaration {
	
	let location: LocationRange
	let name: String
	let type: String
	
	init?(node: ASTNode) {
		guard
			node.kind == .funcDecl,
			let locationToken = node[tokenKey: .range],
			let location = LocationRange(string: locationToken.value),
			let nameToken = node.info[safe: 1],
			let typeToken = node[tokenKey: .type]
			else { return nil }
		
		self.location = location
		self.name = nameToken.value
		self.type = typeToken.value
	}
	
}
