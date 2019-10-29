
final class Parser {
	
	let whitespaceOrNewline = Set<Character>(["\n", "\r", "\t", " "])
	
	func parse(content: String) -> AST {
		
		var startIndex = content.startIndex
		let node = extractChild(content: content, index: &startIndex)
		let astChildren = node.children.isEmpty ? [node] : node.children
		
		return AST(children: astChildren)
	}
	
	private func extractChild(content: String, index: inout String.Index) -> ASTNode {
		var raw = ""
		var token = Token(key: "", value: "")
		var group: [Character: Int] = [:]
		var commaSet = Set<Character>()
		let isInGroup = { group.reduce(0, { $0 + $1.value }) > 0 }
		let isInConcreteGroup: (Character) -> Bool = { group[$0, default: 0] > 0 }
		let isWhitespaceOrNewline: (Character?) -> Bool = {
			$0.map({ self.whitespaceOrNewline.contains($0) }) ?? true
		}
		
		let node = ASTNode(kind: .unspecified, children: [], info: [])
		
		while index != content.endIndex {
			let char = content[index]
			
			switch char {
			case ")":
				
				if isInGroup() {
					raw.append(char)
					if isInConcreteGroup("(") {
						group["(", default: 0] -= 1
					}
				} else {
					if !raw.isEmpty {
						token.value = raw
						raw = ""
						node.add(token: token)
						token = Token(key: "", value: "")
					}
					// We should not increment index here cause it will be incremented lower on func stack recursion
					return node
				}
				
				
			case "(":
				let previousChar = content[elementBefore: index]
				if isInGroup() {
					raw.append(char)
				} else if isWhitespaceOrNewline(previousChar) {
					index = content.index(after: index)
					let childNode = extractChild(content: content, index: &index)
					node.children.append(childNode)
				} else {
					raw.append(char)
					group["(", default: 0] += 1
				}
				
			case "]":
				// TODO: String -> Int неверно обрабатывается из-за ">"
				group["[", default: 0] -= 1
				
			case "[":
				if content[elementBefore: index] != " " {
					group["[", default: 0] += 1
				}
				
			case "<":
				group[char, default: 0] += 1
				raw.append(char)
				
			case ">":
				group["<", default: 0] -= 1
				raw.append(char)
				
			case "\"", "'":
				if commaSet.contains(char) {
					commaSet.remove(char)
					group[char, default: 0] -= 1
				} else {
					commaSet.insert(char)
					group[char, default: 0] += 1
				}
				
			case " " where isInGroup():
				raw.append(char)
				
			case " " where !isInGroup():
				if !raw.isEmpty {
					token.value = raw
					raw = ""
					node.add(token: token)
					token = Token(key: "", value: "")
				}
				
			case "=" where !isInGroup():
				token.key = raw
				raw = ""
				
			case "\n", "\r", "\t":
				break
				
			default:
				raw.append(char)
			}
			
			for element in group {
				group[element.key] = max(element.value, 0)
			}
			
			index = content.index(after: index)
		}
		
		return node
	}
	
}
