import Foundation

public enum InstructionError: Error {
    case unexpectedCondition
    case unexpectedQualifier
    case qualifierIsNotSupported(Qualifier)
    case registerExpected(Int)
    case mnemonicMismatch
    case RdRnMismatch
    case unexpectedNumberOfArguments
    case undefinedLiteral(String)
    case unknownError
}

extension InstructionError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .unexpectedCondition: return "unexpectedCondition"
        case .unexpectedQualifier: return "unexpectedQualifier"
        case let .qualifierIsNotSupported(qualifier): return "Qualifier \"\(qualifier)\" is not supported by this instruction."
        case .mnemonicMismatch: return "Mnemonic doesn't match the expected one."
        case .RdRnMismatch: return "Rd doesn't match Rn."
        case .unexpectedNumberOfArguments: return "unexpectedNumberOfArguments"
        case let .undefinedLiteral(literal): return "undefinedLiteral \(literal)"
        case let .registerExpected(position): return "register expected at argument position \(position)"
        case .unknownError: return "unknownError"
        }
    }
}

extension InstructionError: LocalizedError {
    public var errorDescription: String? {
        debugDescription
    }
}
