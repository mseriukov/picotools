public struct STRH: Instruction {
    enum Kind {
        case STRH_Immediate(Register, Register, UInt16)
        case STRH_Register(Register, Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .STRH else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        guard desc.arguments.count >= 2 else { throw ParserError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError }
        guard case let .register(r2) = desc.arguments[1] else { throw ParserError.unexpectedError }

        if case let .register(r3) = desc.arguments[2] {
            self.kind = .STRH_Register(r1, r2, r3)
            return
        }

        if case let .immediate(imm) = desc.arguments[2] {
            self.kind = .STRH_Immediate(r1, r2, imm)
            return
        }

        throw ParserError.unexpectedError
    }

    public func encode(symbols: [String: UInt16]) throws -> [UInt16] {
        switch kind {
        case let .STRH_Register(r1, r2, r3):
            return Thumb.STRH_Register(t: r1.number, n: r2.number, m: r3.number).encode()
        case let .STRH_Immediate(r1, r2, imm):
            return Thumb.STRH_Immediate(t: r1.number, n: r2.number, imm5: imm).encode()
        }
    }
}
