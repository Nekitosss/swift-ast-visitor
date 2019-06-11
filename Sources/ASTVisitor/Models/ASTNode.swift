
struct ASTNode {
	var kind: ASTNodeKind
	var children: [ASTNode]
	var info: [Token]
}

enum ASTNodeKind {
	case sourceFile
	case importDecl
	case protocolDecl
	case classDecl
	case funcDecl
	case parameter
	case parameterList
	case result
	case typeIdent
	case component
	case braceStmt
	case callExpr
	case declrefExpr
	case tupleShuffleExpr
	case tupleExpr
	case constructorDecl
	case destructorDecl
	case typealiasDecl
	case patternBindingDecl
	case patternTyped
	case closureExpr
	case varDecl
	case dotSyntaxCallExpr
	case parenExpr
	
	case unknown
}

