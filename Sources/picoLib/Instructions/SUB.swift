public struct SUB: Instruction {
    enum Kind {
        case SUB(Register, Register, UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .SUB else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        if desc.arguments.count == 3 {
            guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.registerExpected(0) }
            guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.registerExpected(1) }
            guard case let .immediate(imm) = desc.arguments[2] else { throw InstructionError.immediateExpected(2) }
            guard r1 == r2 else { throw InstructionError.RdRnMismatch }
            self.kind = .SUB(r1, r2, imm)
            return
        }
        throw InstructionError.unexpectedNumberOfArguments
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .SUB(_, _, imm):
            return Thumb.SUB_SP_Immediate(imm7: imm).encode()
        }
    }
}

extension SUB: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .SUB(r1, r2, imm):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(r2.rawValue), #\(imm)"
        }
    }
}
