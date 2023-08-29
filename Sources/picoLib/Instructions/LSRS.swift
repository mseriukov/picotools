public struct LSRS: Instruction {
    enum Kind {
        case LSR_Immediate(Register, Register, UInt16)
        case LSR_Register(Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .LSRS else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        guard desc.arguments.count >= 2 else { throw ParserError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError }
        guard case let .register(r2) = desc.arguments[1] else { throw ParserError.unexpectedError }

        if desc.arguments.count == 3, case let .immediate(imm) = desc.arguments[2] {
            self.kind = .LSR_Immediate(r1, r2, imm)
        } else {
            self.kind = .LSR_Register(r1, r2)
        }
    }

    public func encode(symbols: [String: UInt16]) throws -> [UInt16] {
        switch kind {
        case let .LSR_Immediate(r1, r2, imm):
            return Thumb.LSR_Immediate(d: r1.number, m: r2.number, imm5: imm).encode()
        case let .LSR_Register(r1, r2):
            return Thumb.LSR_Register(dn: r1.number, m: r2.number).encode()
        }
    }
}
