public struct ASRS: Instruction {
    enum Kind {
        case ASR_Immediate(Register, Register, UInt16)
        case ASR_Register(Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .ASRS else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        guard desc.arguments.count >= 2 else { throw ParserError.unexpectedNumberOfArguments(at: desc.startToken) }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError(at: desc.startToken) }
        guard case let .register(r2) = desc.arguments[1] else { throw ParserError.unexpectedError(at: desc.startToken) }

        if desc.arguments.count == 3, case let .immediate(imm) = desc.arguments[2] {
            self.kind = .ASR_Immediate(r1, r2, imm)
        } else {
            self.kind = .ASR_Register(r1, r2)
        }
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .ASR_Immediate(r1, r2, imm):
            return Thumb.ASR_Immediate(d: r1.number, m: r2.number, imm5: imm).encode()
        case let .ASR_Register(r1, r2):
            return Thumb.ASR_Register(dn: r1.number, m: r2.number).encode()
        }
    }
}
