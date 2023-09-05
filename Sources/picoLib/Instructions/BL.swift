public struct BL: Instruction {
    enum Kind {
        case BL(String)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .BL else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard desc.arguments.count == 1 else { throw InstructionError.unexpectedNumberOfArguments }
        guard case let .label(lit) = desc.arguments[0] else { throw InstructionError.unknownError }
        self.kind = .BL(lit)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .BL(literal):
            guard let offset = symbols[literal] else { throw InstructionError.undefinedLiteral(literal) }
            return Thumb.BL(offset: Int32(offset)).encode()
        }
    }
}

extension BL: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .BL(lit):
            return "\(desc.mnemonic.stringValue) \(lit)"
        }
    }
}
