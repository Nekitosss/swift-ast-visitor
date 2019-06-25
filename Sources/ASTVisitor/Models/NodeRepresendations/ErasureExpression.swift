
public struct ErasureExpression {
	
	public let type: String
	public let location: Location
	public let range: LocationRange
	
	init?(node: ASTNode) {
		guard node.kind == .erasureExpr,
			let typeToken = node[tokenKey: .type],
			let locationToken = node[tokenKey: .location]?.value,
			let location = Location(string: locationToken),
			let rangeToken = node[tokenKey: .range]?.value,
			let range = LocationRange(string: rangeToken)
			else { return nil }
		self.type = typeToken.value
		self.location = location
		self.range = range
	}
	
}
