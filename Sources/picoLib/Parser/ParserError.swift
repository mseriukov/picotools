enum ParserError: Error {
    case unknownError
    case instructionError(underlying: Error)
    case assertionFailure(String)
    case tokenExpected(Token.Kind)
}
