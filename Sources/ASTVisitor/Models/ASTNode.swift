
struct ASTNode {
	var kind: ASTNodeKind
	var children: [ASTNode]
	var info: [Token]
	
	mutating func add(token: Token) {
		if kind == .unspecified {
			kind = ASTNodeKind(rawValue: token.value) ?? .unknown
		} else {
			info.append(token)
		}
	}
}

enum ASTNodeKind: String {
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
	
	case unspecified
	case unknown
}

