
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
		var raw = ""
		var token = Token(key: "", value: "")
		var groupCounter = 0
		var commaSet = Set<Character>()
		let isInGroup = { groupCounter > 0 || !commaSet.isEmpty }
		
		var node = ASTNode(kind: .unspecified, children: [], info: [])
		
		while index != content.endIndex {
			let char = content[index]
			
			switch char {
			case ")":
				if !raw.isEmpty {
					token.value = raw
					raw = ""
					node.add(token: token)
					token = Token(key: "", value: "")
				}
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
			
			index = content.index(after: index)
		}
		
		return node
	}
	
}
