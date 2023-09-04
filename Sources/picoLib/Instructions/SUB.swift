public struct SUB: Instruction {
    enum Kind {
        case SUB(Register, Register, UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .SUB else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        guard desc.arguments.count == 3 else { throw ParserError.unexpectedNumberOfArguments(at: desc.startToken) }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError(at: desc.startToken) }
        guard case let .register(r2) = desc.arguments[1] else { throw ParserError.unexpectedError(at: desc.startToken) }
        guard case let .immediate(imm) = desc.arguments[2] else { throw ParserError.unexpectedError(at: desc.startToken) }
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
