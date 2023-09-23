import Foundation

public enum InstructionError: Error {
    case unexpectedCondition
    case unexpectedQualifier
    case qualifierIsNotSupported(Qualifier)
    case registerExpected(Int)
    case registerListExpected(Int)
    case specialRegisterExpected(Int)
    case pcExpected(Int)
    case labelExpected(Int)
    case immediateExpected(Int)
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
        case let .registerExpected(position): return "register is expected at argument position \(position)"
        case let .registerListExpected(position): return "register list is expected at argument position \(position)"
        case let .specialRegisterExpected(position): return "special register is expected at argument position \(position)"
        case let .pcExpected(position): return "only PC register can be used at position \(position)"
        case let .labelExpected(position): return "label expected at argument position \(position)"
        case let .immediateExpected(position): return "imeediate expected at argument position \(position)"
        case .unknownError: return "unknownError"
        }
    }
}

extension InstructionError: LocalizedError {
    public var errorDescription: String? {
        debugDescription
    }
}
