
public struct ErasureExpression {
	
	public let type: String
	public let location: Location
	public let range: LocationRange
	
	init?(node: ASTNode) {
		guard node.kind == .erasureExpr,
			let typeToken = node[tokenKey: .type].getOne(),
			let locationToken = node[tokenKey: .location].getOne()?.value,
			let location = Location(string: locationToken),
			let rangeToken = node[tokenKey: .range].getOne()?.value,
			let range = LocationRange(string: rangeToken)
			else { return nil }
		self.type = typeToken.value
		self.location = location
		self.range = range
	}
	
}
