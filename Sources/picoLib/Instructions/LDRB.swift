public struct LDRB: Instruction {
    enum Kind {
        case LDRB_Immediate(Register, Register, UInt16)
        case LDRB_Register(Register, Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .LDRB else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard desc.arguments.count == 3 else { throw InstructionError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.registerExpected(0) }
        guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.registerExpected(1) }

        if case let .register(r3) = desc.arguments[2] {
            self.kind = .LDRB_Register(r1, r2, r3)
            return
        }

        if case let .immediate(imm) = desc.arguments[2] {
            self.kind = .LDRB_Immediate(r1, r2, imm)
            return
        }

        throw InstructionError.unexpectedNumberOfArguments
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .LDRB_Register(r1, r2, r3):
            return Thumb.LDRB_Register(t: r1.number, n: r2.number, m: r3.number).encode()
        case let .LDRB_Immediate(r1, r2, imm):
            return Thumb.LDRB_Immediate(t: r1.number, n: r2.number, imm5: imm).encode()
        }
    }
}

extension LDRB: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .LDRB_Register(r1, r2, r3):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), [\(r2.rawValue), \(r3.rawValue)]"
        case let .LDRB_Immediate(r1, r2, imm):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), [\(r2.rawValue), #\(imm)]"
        }
    }
}
