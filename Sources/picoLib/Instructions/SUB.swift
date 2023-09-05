public struct SUB: Instruction {
    enum Kind {
        case SUB(Register, Register, UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .SUB else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard desc.arguments.count == 3 else { throw InstructionError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.unknownError }
        guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.unknownError }
        guard case let .immediate(imm) = desc.arguments[2] else { throw InstructionError.unknownError }
        // TODO: Verify r1 and r2.
        self.kind = .SUB(r1, r2, imm)
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
