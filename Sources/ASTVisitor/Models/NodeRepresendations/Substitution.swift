
public struct Substitution {
	public let from: String
	public let to: String
	
	init?(node: ASTNode) {
		guard node.kind == .substitution,
			let from = node.info.first?.value
			else { return nil }
		self.from = from
		
		if let to = node.info.last?.value, to != "-" {
			self.to = to
		} else if let child = node.children.first { // TODO: Check something like (A) -> (B) -> (C)
			self.to = child.info.map({ $0.value }).joined(separator: " ")
		} else {
			return nil
		}
	}
	
}
