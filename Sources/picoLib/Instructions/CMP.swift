public struct CMP: Instruction {
    enum Kind {
        case CMP_Register_T1(Register, Register)
        case CMP_Register_T2(Register, Register)
        case CMP_Immediate(Register, UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .CMP else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        guard desc.arguments.count == 2 else { throw ParserError.unexpectedNumberOfArguments(at: desc.startToken) }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError(at: desc.startToken) }

        if case let .register(r2) = desc.arguments[1] {
            // TODO: Verify necessary conditions.
            if r1.number < 8 && r2.number < 8 {
                kind = .CMP_Register_T1(r1, r2)
            } else {
                kind = .CMP_Register_T2(r1, r2)
            }

        } else if case let .immediate(imm) = desc.arguments[1] {
            kind = .CMP_Immediate(r1, imm)
        } else {
            throw ParserError.unexpectedError(at: desc.startToken)
        }

    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .CMP_Register_T1(r1, r2):
            return Thumb.CMP_Register_T1(n: r1.number, m: r2.number).encode()
        case let .CMP_Register_T2(r1, r2):
            return Thumb.CMP_Register_T2(n: r1.number, m: r2.number).encode()
        case let .CMP_Immediate(r, imm):
            return Thumb.CMP_Immediate(n: r.number, imm8: imm).encode()
        }
    }
}
