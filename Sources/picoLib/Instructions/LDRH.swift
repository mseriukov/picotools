public struct LDRH: Instruction {
    enum Kind {
        case LDRH_Immediate(Register, Register, UInt16)
        case LDRH_Register(Register, Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .LDRH else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard desc.arguments.count >= 2 else { throw InstructionError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.unknownError }
        guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.unknownError }

        if case let .register(r3) = desc.arguments[2] {
            self.kind = .LDRH_Register(r1, r2, r3)
            return
        }

        if case let .immediate(imm) = desc.arguments[2] {
            self.kind = .LDRH_Immediate(r1, r2, imm)
            return
        }

        throw InstructionError.unknownError
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .LDRH_Register(r1, r2, r3):
            return Thumb.LDRH_Register(t: r1.number, n: r2.number, m: r3.number).encode()
        case let .LDRH_Immediate(r1, r2, imm):
            return Thumb.LDRH_Immediate(t: r1.number, n: r2.number, imm5: imm).encode()
        }
    }
}

extension LDRH: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .LDRH_Register(r1, r2, r3):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), [\(r2.rawValue), \(r3.rawValue)]"
        case let .LDRH_Immediate(r1, r2, imm):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), [\(r2.rawValue), #\(imm)]"
        }
    }
}

