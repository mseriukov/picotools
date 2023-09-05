import Foundation

public enum InstructionError: Error {
    case unexpectedCondition
    case unexpectedQualifier
    case unexpectedNumberOfArguments
    case undefinedLiteral(String)
    case unknownError
}

extension InstructionError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .unexpectedCondition: return "unexpectedCondition"
        case .unexpectedQualifier: return "unexpectedQualifier"
        case .unexpectedNumberOfArguments: return "unexpectedNumberOfArguments"
        case let .undefinedLiteral(literal): return "undefinedLiteral \(literal)"
        case .unknownError: return "unknownError"
        }
    }
}

extension InstructionError: LocalizedError {
    public var errorDescription: String? {
        debugDescription
    }
}
