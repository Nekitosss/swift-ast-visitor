

public struct DotSyntaxCall {
	
	public let type: String
	public let location: Location
	public let range: LocationRange
	
	init?(node: ASTNode) {
		guard node.kind == .dotSyntaxCallExpr,
			let typeToken = node[tokenKey: .type],
			let locationToken = node[tokenKey: .location],
			let rangeToken = node[tokenKey: .range],
			let location = Location(string: locationToken.value),
			let range = LocationRange(string: rangeToken.value)
			else { return nil }
		
		self.type = typeToken.value
		self.location = location
		self.range = range
	}
	
}
