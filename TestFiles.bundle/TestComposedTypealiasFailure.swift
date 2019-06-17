//
//  TestTypealiasedComposedTypealiasFailure.swift
//  LintableProject
//
//  Created by Nikita on 07/10/2018.
//  Copyright © 2018 Nikita. All rights reserved.
//

import DITranquillity

private protocol MyProtocol {}
private protocol MySecondProtocol {}

private class Nested {
	class MyClass: MyProtocol {
		
		var injectableStr: String!
		
		static func create(withInt intValue: Int) -> MyTypealias {
			fatalError()
		}
		
	}
}
private typealias MyTypealias = Nested.MyClass

private class ParsablePart: DIPart {
	
	static let container: DIContainer = {
		let container = DIContainer()
		container.append(part: ParsablePart.self)
		return container
	}()
	
	static func load(container: DIContainer) {
		container.register(MyTypealias.create)
			.as((MyProtocol & MySecondProtocol).self)
			.injection(\.injectableStr)
	}
	
}
