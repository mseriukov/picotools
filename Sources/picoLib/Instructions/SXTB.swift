public struct SXTB: Instruction {
    enum Kind {
        case SXTB(Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .SXTB else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard desc.arguments.count == 2 else { throw InstructionError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.unknownError }
        guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.unknownError }
        self.kind = .SXTB(r1, r2)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .SXTB(r1, r2):
            return Thumb.SXTB(d: r1.number, m: r2.number).encode()
        }
    }
}
