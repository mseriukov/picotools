enum ParserErrorKind {
    case unexpectedError
    case undefinedLiteral(String)
    case assertionFailure(String)
    case unexpectedCondition
    case unexpectedQualifier
    case unexpectedNumberOfArguments
    case tokenExpected(Token.Kind)
}

struct ParserError: Error {
    let token: Token
    let kind: ParserErrorKind

    init(token: Token, kind: ParserErrorKind) {
        self.token = token
        self.kind = kind
    }
}
