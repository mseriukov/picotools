public struct STRB: Instruction {
    enum Kind {
        case STRB_Immediate(Register, Register, UInt16)
        case STRB_Register(Register, Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .STRB else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        guard desc.arguments.count >= 2 else { throw ParserError.unexpectedNumberOfArguments(at: desc.startToken) }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError(at: desc.startToken) }
        guard case let .register(r2) = desc.arguments[1] else { throw ParserError.unexpectedError(at: desc.startToken) }

        if case let .register(r3) = desc.arguments[2] {
            self.kind = .STRB_Register(r1, r2, r3)
            return
        }

        if case let .immediate(imm) = desc.arguments[2] {
            self.kind = .STRB_Immediate(r1, r2, imm)
            return
        }

        throw ParserError.unexpectedError(at: desc.startToken)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .STRB_Register(r1, r2, r3):
            return Thumb.STRB_Register(t: r1.number, n: r2.number, m: r3.number).encode()
        case let .STRB_Immediate(r1, r2, imm):
            return Thumb.STRB_Immediate(t: r1.number, n: r2.number, imm5: imm).encode()
        }
    }
}
