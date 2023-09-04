public struct RORS: Instruction {
    enum Kind {
        case ROR_Register(Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .RORS else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard desc.arguments.count == 2 else { throw InstructionError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.unknownError }
        guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.unknownError }

        self.kind = .ROR_Register(r1, r2)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .ROR_Register(r1, r2):
            return Thumb.ROR_Register(dn: r1.number, m: r2.number).encode()
        }
    }
}
