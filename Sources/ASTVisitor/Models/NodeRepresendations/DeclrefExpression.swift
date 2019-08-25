
public struct DeclrefExpression {
	
	public let type: String
	public let location: Location?
	public let range: LocationRange?
	public let substitution: [String: String]
	
	init?(node: ASTNode) {
		guard node.kind == .declrefExpr,
			let typeToken = node[tokenKey: .type].getOne()
			else { return nil }
		
		self.type = typeToken.value
		
		if let locationToken = node[tokenKey: .location].getOne(), let location = Location(string: locationToken.value) {
			self.location = location
		} else {
			self.location = nil
		}
		
		if let rangeToken = node[tokenKey: .range].getOne(), let range = LocationRange(string: rangeToken.value) {
			self.range = range
		} else {
			self.range = nil
		}
		
		if let substitutionMap = node.children.first(where: { $0.kind == .substitutionMap }) {
			let substitutionTokenList = substitutionMap.children.filter { $0.kind == .substitution }
			substitution = substitutionTokenList.compactMap(Substitution.init(node:)).reduce(into: [:]) { $0[$1.from] = $1.to }
		} else {
			substitution = [:]
		}
	}
}
