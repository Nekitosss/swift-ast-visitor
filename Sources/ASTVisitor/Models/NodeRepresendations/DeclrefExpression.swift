
public struct DeclrefExpression {
	
	let type: String
	let location: Location?
	let range: LocationRange?
	let substitution: [String: String]
	
	init?(node: ASTNode) {
		guard node.kind == .declrefExpr,
			let typeToken = node[tokenKey: .type]
			else { return nil }
		
		self.type = typeToken.value
		
		if let locationToken = node[tokenKey: .location], let location = Location(string: locationToken.value) {
			self.location = location
		} else {
			self.location = nil
		}
		
		if let rangeToken = node[tokenKey: .range], let range = LocationRange(string: rangeToken.value) {
			self.range = range
		} else {
			self.range = nil
		}
		
		if let substitutionMap = node.children.first(where: { $0.kind == .substitutionMap }) {
			let substitutionTokenList = substitutionMap.children.filter { $0.kind == .substitution }
			substitution = substitutionTokenList.compactMap(Substitution.init(node:)).reduce(into: [:]) { $0[$1.from] = $1.to }
			print(1)
		} else {
			substitution = [:]
		}
	}
}
