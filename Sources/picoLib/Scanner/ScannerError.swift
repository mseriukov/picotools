enum ScannerError: Error {
    case unexpectedCharacter(Character, Int)
    case unterminatedString(Int)
    case invalidNumber(String, Int)
}
