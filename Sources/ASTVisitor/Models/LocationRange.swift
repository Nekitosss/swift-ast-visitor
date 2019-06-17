
public struct Location {
	public let file: String
	public let line: Int
	public let char: Int
	
	// "/Users/mockuser/development/ast/TestComposedTypealiasFailure.swift:27:13" -> Location
	public init?(string: String) {
		let parts = string.split(separator: ":")
		guard parts.count == 3,
			let line = Int(parts[1]),
			let char = Int(parts[2])
			else { return nil }
		self.file = String(parts[0])
		self.line = line
		self.char = char
	}
}

public struct LocationRange {
	public let start: Location
	public let end: Location
	
	// "/Users/mockuser/development/ast/TestComposedTypealiasFailure.swift:27:13 - line:27:13" -> LocationRange
	init?(string: String) {
		let parts = string.split(separator: "-")
		guard parts.count == 2 else { return nil }
		let first = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
		let last = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
		
		guard let start = Location(string: first),
			let end = Location(string: last)
			else { return nil }
		
		self.start = start
		self.end = end
	}
	
}
