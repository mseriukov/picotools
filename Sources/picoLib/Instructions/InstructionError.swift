public enum InstructionError: Error {
    case unexpectedCondition
    case unexpectedQualifier
    case unexpectedNumberOfArguments
    case undefinedLiteral(String)
    case unknownError
}
