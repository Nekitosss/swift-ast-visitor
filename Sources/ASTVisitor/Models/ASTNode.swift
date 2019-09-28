
public enum OptionalValue<T> {
	case one(T)
	case several([T])
	case none
	
	public func getOne() -> T? {
		switch self {
		case .one(let value):
			return value
		case .several(let value):
			return value.first
		default:
			return nil
		}
	}
	
	public func getSeveral() -> [T]? {
		switch self {
		case .several(let value) where !value.isEmpty:
			return value
		case .one(let value):
			return [value]
		default:
			return nil
		}
	}
	
}

public typealias OptionalNode = OptionalValue<ASTNode>
public typealias OptionalToken = OptionalValue<Token>

extension OptionalNode {
	
	public subscript(kind: ASTNodeKind) -> OptionalNode {
		switch self {
		case .one(let value):
			return value[kind]
		case .several(let value):
			let values = value.flatMap({ $0.children.filter({ $0.kind == kind }) })
			if values.isEmpty {
				return .none
			} else {
				return .several(values)
			}
			
		case .none:
			return .none
		}
	}
}


public class ASTNode {
	public var kind: ASTNodeKind
	public var children: [ASTNode]
	public var info: [Token]
	public lazy var typedNode = TypedNode(node: self)
	
	init(kind: ASTNodeKind, children: [ASTNode], info: [Token]) {
		self.kind = kind
		self.children = children
		self.info = info
	}
	
	func add(token: Token) {
		if kind == .unspecified {
			if let parsedKind = ASTNodeKind(rawValue: token.value) {
				kind = parsedKind
			} else {
				kind = .unknown
				info.append(token)
			}
		} else {
			info.append(token)
		}
	}
	
	public subscript(tokenKey key: TokenKey) -> OptionalToken {
		let foundedToken = self.info.filter { $0.key == key.rawValue }
		switch foundedToken.count {
		case 0:
			return .none
		case 1:
			return .one(foundedToken[0])
		default:
			return .several(foundedToken)
		}
	}
	
	public subscript(kind: ASTNodeKind) -> OptionalNode {
		let foundedChildren = children.filter({ $0.kind == kind })
		switch foundedChildren.count {
		case ...0:
			return .none
		case 1:
			return .one(foundedChildren[0])
		default:
			return .several(foundedChildren)
		}
	}
}

public enum TypedNode {
	case functionDeclaration(FunctionDeclaration)
	case dotSyntaxCall(DotSyntaxCall)
	case callExpression(CallExpression)
	case declrefExpression(DeclrefExpression)
	case substitution(Substitution)
	case patternTyped(PatternTyped)
	case component(Component)
	case typealiasDeclaration(TypealiasDeclaration)
	case unknown
	
	init(node: ASTNode) {
		switch node.kind {
		case .funcDecl:
			self = FunctionDeclaration(node: node).map { .functionDeclaration($0) } ?? .unknown
		case .dotSyntaxCallExpr:
			self = DotSyntaxCall(node: node).map { .dotSyntaxCall($0) } ?? .unknown
		case .callExpr:
			self = CallExpression(node: node).map { .callExpression($0) } ?? .unknown
		case .declrefExpr:
			self = DeclrefExpression(node: node).map { .declrefExpression($0) } ?? .unknown
		case .substitution:
			self = Substitution(node: node).map { .substitution($0) } ?? .unknown
		case .patternTyped:
			self = PatternTyped(node: node).map { .patternTyped($0) } ?? .unknown
		case .component:
			self = Component(node: node).map { .component($0) } ?? .unknown
		case .typealiasDecl:
			self = TypealiasDeclaration(node: node).map { .typealiasDeclaration($0) } ?? .unknown
		default:
			self = .unknown
		}
	}
	
	
	public func unwrap<T>(_ type: T.Type = T.self) -> T? {
		switch self {
		case .functionDeclaration(let value):
			return value as? T
		case .dotSyntaxCall(let value):
			return value as? T
		case .callExpression(let value):
			return value as? T
		case .declrefExpression(let value):
			return value as? T
		case .substitution(let value):
			return value as? T
		case .patternTyped(let value):
			return value as? T
		case .component(let value):
			return value as? T
		case .typealiasDeclaration(let value):
			return value as? T
		case .unknown:
			return nil
		}
	}
	
}

public enum ASTNodeKind: String {
	case sourceFile = "source_file"
	case importDecl = "import_decl"
	case protocolDecl = "protocol"
	case classDecl = "class_decl"
	case funcDecl = "func_decl"
	case parameter = "parameter"
	case parameterList = "parameter_list"
	case result = "result"
	case returnStmt = "return_stmt"
	case typeIdent = "type_ident"
	case component = "component"
	case braceStmt = "brace_stmt"
	case callExpr = "call_expr"
	case memberRefExpr = "member_ref_expr"
	case declrefExpr = "declref_expr"
	case tupleShuffleExpr = "argument_shuffle_expr"
	case tupleExpr = "tuple_expr"
	case constructorDecl = "constructor_decl"
	case destructorDecl = "destructor_decl"
	case typealiasDecl = "typealias"
	case patternBindingDecl = "pattern_binding_decl"
	case patternTyped = "pattern_typed"
	case patternNamed = "pattern_named"
	case closureExpr = "closure_expr"
	case varDecl = "var_decl"
	case dotSyntaxCallExpr = "dot_syntax_call_expr"
	case parenExpr = "paren_expr"
	case erasureExpr = "erasure_expr"
	case normalConformance = "normal_conformance"
	case dotSelfExpr = "dot_self_expr"
	case substitutionMap = "substitution_map"
	case substitution = "substitution"
	case typeExpr = "type_expr"
	case constructorRefCallExpr = "constructor_ref_call_expr"
	case booleanLiteralExpr = "boolean_literal_expr"
	case keypathExpr = "keypath_expr"
    case functionConversionExpr = "function_conversion_expr"
	
	
	case unspecified
	case unknown
}

