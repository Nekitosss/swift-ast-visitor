
extension Array {
	
	public subscript(safe safeIndex: Int) -> Array.Element? {
		get {
			guard safeIndex > 0 && safeIndex < self.count else { return nil }
			return self[safeIndex]
		}
		set {
			guard let new = newValue, safeIndex > 0 && safeIndex < self.count else { return }
			self[safeIndex] = new
		}
	}
	
}

extension String {
	
	subscript(elementBefore index: Index) -> Character? {
		if index <= self.startIndex || index > self.endIndex {
			return nil
		} else {
			return self[self.index(before: index)]
		}
	}
	
	subscript(elementAfter index: Index) -> Character? {
		if index < self.startIndex || index >= self.endIndex {
			return nil
		} else {
			return self[self.index(after: index)]
		}
	}
	
}
