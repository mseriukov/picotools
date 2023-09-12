public struct ADR: Instruction {
    enum Kind {
        /// Address to Register adds an immediate value to the PC value, and writes the result to the destination register.
        case ADR(Register, String)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .ADR else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        if desc.arguments.count == 2 {
            guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.registerExpected(0) }
            guard case let .label(label) = desc.arguments[1] else { throw InstructionError.labelExpected(1) }
            self.kind = .ADR(r1, label)
            return
        }
        throw InstructionError.unexpectedNumberOfArguments
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
        case let .ADR(r1, label):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(label)"
        }
    }
}
