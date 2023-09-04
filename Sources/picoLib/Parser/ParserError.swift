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

    static func tokenExpected(at token: Token, expected: Token.Kind) -> ParserError {
        ParserError(token: token, kind: .tokenExpected(expected))
    }

    static func unexpectedNumberOfArguments(at token: Token) -> ParserError {
        ParserError(token: token, kind: .unexpectedNumberOfArguments)
    }

    static func unexpectedCondition(at token: Token) -> ParserError {
        ParserError(token: token, kind: .unexpectedCondition)
    }

    static func unexpectedQualifier(at token: Token) -> ParserError {
        ParserError(token: token, kind: .unexpectedQualifier)
    }

    static func unexpectedError(at token: Token) -> ParserError {
        ParserError(token: token, kind: .unexpectedError)
    }

    static func undefinedLiteral(at token: Token, literal: String) -> ParserError {
        ParserError(token: token, kind: .undefinedLiteral(literal))
    }

    static func assertionFailure(at token: Token, message: String) -> ParserError {
        ParserError(token: token, kind: .assertionFailure(message))
    }
}

extension ParserError: CustomDebugStringConvertible {
    var debugDescription: String {
        "Error on line \(token.line) around token \(token.lexeme ?? ""). \(kind)"
    }
}
