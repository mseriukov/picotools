enum ParserError: Error {
    case unexpectedError
    case assertionFailure(String)
    case unexpectedCondition
    case unexpectedQualifier
    case unexpectedNumberOfArguments
    case tokenExpected(Token.Kind)
}
