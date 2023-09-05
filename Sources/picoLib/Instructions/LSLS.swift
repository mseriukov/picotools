public struct LSLS: Instruction {
    enum Kind {
        case LSL_Immediate(Register, Register, UInt16)
        case LSL_Register(Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .LSLS else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard desc.arguments.count >= 2 else { throw InstructionError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.unknownError }
        guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.unknownError }

        if desc.arguments.count == 3, case let .immediate(imm) = desc.arguments[2] {
            self.kind = .LSL_Immediate(r1, r2, imm)
        } else {
            self.kind = .LSL_Register(r1, r2)
        }
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .LSL_Immediate(r1, r2, imm):
            return Thumb.LSL_Immediate(d: r1.number, m: r2.number, imm5: imm).encode()
        case let .LSL_Register(r1, r2):
            return Thumb.LSL_Register(dn: r1.number, m: r2.number).encode()
        }
    }
}

extension LSLS: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .LSL_Immediate(r1, r2, imm):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(r2.rawValue), \(imm)"
        case let .LSL_Register(r1, r2):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(r2.rawValue)"
        }
    }
}
