public struct STR: Instruction {
    enum Kind {
        case STR_Immediate_T1(Register, Register, UInt16) // STR <Rt>, [<Rn>{,#<imm5>}]
        case STR_Immediate_T2(Register, UInt16) // STR <Rt>,[SP,#<imm8>]
        case STR_Register(Register, Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .STR else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard desc.arguments.count >= 1 else { throw InstructionError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.unknownError }

        if case let .immediate(imm) = desc.arguments[1] {
            self.kind = .STR_Immediate_T2(r1, imm)
            return
        }

        guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.unknownError }

        if case let .immediate(imm) = desc.arguments[2] {
            self.kind = .STR_Immediate_T1(r1, r2, imm)
            return
        }

        if case let .register(r3) = desc.arguments[2] {
            self.kind = .STR_Register(r1, r2, r3)
            return
        }

        throw InstructionError.unknownError
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .STR_Immediate_T1(r1, r2, imm):
            return Thumb.STR_Immediate_T1(t: r1.number, n: r2.number, imm5: imm).encode()
        case let .STR_Immediate_T2(r1, imm):
            return Thumb.STR_Immediate_T2(t: r1.number, imm8: imm).encode()
        case let .STR_Register(r1, r2, r3):
            return Thumb.STR_Register(t: r1.number, n: r2.number, m: r3.number).encode()
        }
    }
}

extension STR: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .STR_Immediate_T1(r1, r2, imm):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(r2.rawValue), #\(imm)"
        case let .STR_Immediate_T2(r1, imm):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), #\(imm)"
        case let .STR_Register(r1, r2, r3):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(r2.rawValue), \(r3.rawValue)"
        }
    }
}
