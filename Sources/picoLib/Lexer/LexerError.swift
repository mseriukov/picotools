enum LexerError: Error {
    case unexpectedCharacter(Character, Int)
    case unterminatedString(Int)
    case invalidNumber(String, Int)
    case unexpectedError
}
