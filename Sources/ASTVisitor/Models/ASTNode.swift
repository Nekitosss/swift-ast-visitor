
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
			kind = ASTNodeKind(rawValue: token.value) ?? .unknown
		} else {
			info.append(token)
		}
	}
	
	subscript(tokenKey key: TokenKey) -> Token? {
		return self.info.first(where: { $0.key == key.rawValue })
	}
	
}

public enum TypedNode {
	case functionDeclaration(FunctionDeclaration)
	case unknown
	
	init(node: ASTNode) {
		switch node.kind {
		case .funcDecl:
			self = FunctionDeclaration(node: node).map { .functionDeclaration($0) } ?? .unknown
		default:
			self = .unknown
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
	case tupleShuffleExpr = "tuple_shuffle_expr"
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
	
	case unspecified
	case unknown
}

