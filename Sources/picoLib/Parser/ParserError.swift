import Foundation

public enum ParserError: Error {
    case unknownError
    case instructionError(underlying: Error)
    case assertionFailure(String)
    case tokenExpected(Token.Kind)
}

extension ParserError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .unknownError: return "Unknown error"
        case let .instructionError(underlying): return "Instruction parsing failed. Underlying: \(underlying.localizedDescription)"
        case let .assertionFailure(message): return "Assertion failure: \(message)"
        case let .tokenExpected(kind): return "Expected token with kind \(kind)"
        }
    }
}

extension ParserError: LocalizedError {
    public var errorDescription: String? {
        debugDescription
    }
}
