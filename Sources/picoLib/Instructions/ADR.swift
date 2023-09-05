public struct ADR: Instruction {
    enum Kind {
        case ADR(Register, String)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .ADR else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard desc.arguments.count == 2 else { throw InstructionError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.unknownError }
        guard case let .label(lit) = desc.arguments[1] else { throw InstructionError.unknownError }
        self.kind = .ADR(r1, lit)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .ADR(r1, literal):
            guard let offset = symbols[literal] else { throw InstructionError.undefinedLiteral(literal) }
            return Thumb.ADR(d: r1.number, imm8: UInt16(offset)).encode()
        }
    }
}

extension ADR: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .ADR(r1, lit):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(lit)"
        }
    }
}
