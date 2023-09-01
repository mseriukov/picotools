public struct SUBS: Instruction {
    enum Kind {
        case SUB_Immediate_T2(Register, UInt16)
        case SUB_Immediate_T1(Register, Register, UInt16)
        case SUB_Register(Register, Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .SUBS else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        if
            desc.arguments.count == 2,
            case let .register(r1) = desc.arguments[0],
            case let .immediate(imm) = desc.arguments[1]
        {
            self.kind = .SUB_Immediate_T2(r1, imm)
            return
        }

        if
            desc.arguments.count == 3,
            case let .register(r1) = desc.arguments[0],
            case let .register(r2) = desc.arguments[1],
            case let .immediate(imm) = desc.arguments[2]
        {
            self.kind = .SUB_Immediate_T1(r1, r2, imm)
            return
        }

        if
            desc.arguments.count == 3,
            case let .register(r1) = desc.arguments[0],
            case let .register(r2) = desc.arguments[1],
            case let .register(r3) = desc.arguments[2]
        {
            self.kind = .SUB_Register(r1, r2, r3)
            return
        }
        throw ParserError.unexpectedError
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .SUB_Immediate_T2(r, imm):
            return Thumb.SUB_Immediate_T2(dn: r.number, imm8: imm).encode()
        case let .SUB_Immediate_T1(r1, r2, imm):
            return Thumb.SUB_Immediate_T1(d: r1.number, n: r2.number, imm3: imm).encode()
        case let .SUB_Register(r1, r2, r3):
            return Thumb.SUB_Register(d: r1.number, n: r2.number, m: r3.number).encode()
        }
    }
}
