
import Foundation

final class Parser {
	
	let groupingCharacterSet: CharacterSet = {
		var set = CharacterSet()
		set.insert(charactersIn: "\"<>[]'")
		return set
	}()
	
	func parse(content: String) -> AST {
		
		var startIndex = content.startIndex
		let node = extractChild(content: content, index: &startIndex)
		
		return AST(children: [node])
	}
	
	private func extractChild(content: String, index: inout String.Index) -> ASTNode {
		var token = Token(key: false, value: "")
		var groupCounter = 0
		var commaSet = Set<Character>()
		let isInGroup = { groupCounter > 0 || !commaSet.isEmpty }
		
		var node = ASTNode(kind: .unknown, children: [], info: [])
		
		while index != content.endIndex {
			let char = content[index]
			
			switch char {
			case ")":
				// We should not increment index here cause it will be incremented lower on func stack recursion
				return node
				
			case "(":
				index = content.index(after: index)
				let childNode = extractChild(content: content, index: &index)
				node.children.append(childNode)
				
			case "<", "[":
				groupCounter += 1
				
			case ">", "]":
				groupCounter -= 1
				
			case "\"", "'":
				if commaSet.contains(char) {
					commaSet.remove(char)
				} else {
					commaSet.insert(char)
				}
				
			case " " where isInGroup():
				token.value.append(char)
				
			case " " where !isInGroup():
				if !token.value.isEmpty {
					node.info.append(token)
					token = Token(key: false, value: "")
				}
				
			case "=" where !isInGroup():
				token.key = true
				node.info.append(token)
				token = Token(key: false, value: "")
				
			case "\n", "\r", "\t":
				break
				
			default:
				token.value.append(char)
			}
			
			index = content.index(after: index)
		}
		
		return node
	}
	
}
