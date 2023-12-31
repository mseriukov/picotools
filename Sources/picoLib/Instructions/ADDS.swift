
// TODO: "ADDS r\(d), r\(n), #\(imm3)"
// TODO: "ADDS r\(dn), #\(imm8)"
// "ADDS r\(d), r\(n), r\(m)"

public struct ADDS: Instruction {
    enum Kind {
        case ADD_Immediate_T1(Register, Register, UInt16)
        case ADD_Immediate_T2(Register, UInt16)
        case ADD_Register_T1(Register, Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .ADDS else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard desc.arguments.count == 3 else { throw InstructionError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.unknownError }

        if case let .immediate(imm) = desc.arguments[1] {
            self.kind = .ADD_Immediate_T2(r1, imm)
            return
        }

        guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.unknownError }

        if case let .register(r3) = desc.arguments[2] {
            self.kind = .ADD_Register_T1(r1, r2, r3)
            return
        }

        if case let .immediate(imm) = desc.arguments[2] {
            self.kind = .ADD_Immediate_T1(r1, r2, imm)
            return
        }
        throw InstructionError.unknownError
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .ADD_Immediate_T1(r1, r2, imm):
            return Thumb.ADD_Immediate_T1(d: r1.number, n: r2.number, imm3: imm).encode()
        case let .ADD_Immediate_T2(r, imm):
            return Thumb.ADD_Immediate_T2(dn: r.number, imm8: imm).encode()
        case let .ADD_Register_T1(r1, r2, r3):
            return Thumb.ADD_Register_T1(d: r1.number, n: r2.number, m: r3.number).encode()
        }
    }
}

extension ADDS: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .ADD_Immediate_T1(r1, r2, imm):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(r2.rawValue), #\(imm)"

        case let .ADD_Immediate_T2(r, imm):
            return "\(desc.mnemonic.stringValue) \(r.rawValue), #\(imm)"

        case let .ADD_Register_T1(r1, r2, r3):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(r2.rawValue), \(r3.rawValue)"
        }
    }
}
