public struct UXTH: Instruction {
    enum Kind {
        case UXTH(Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .UXTH else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        guard desc.arguments.count == 2 else { throw ParserError.unexpectedNumberOfArguments(at: desc.startToken) }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError(at: desc.startToken) }
        guard case let .register(r2) = desc.arguments[1] else { throw ParserError.unexpectedError(at: desc.startToken) }
        self.kind = .UXTH(r1, r2)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .UXTH(r1, r2):
            return Thumb.UXTH(d: r1.number, m: r2.number).encode()
        }
    }
}
