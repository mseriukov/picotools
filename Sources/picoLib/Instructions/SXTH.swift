public struct SXTH: Instruction {
    enum Kind {
        case SXTH(Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .SXTH else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        guard desc.arguments.count == 2 else { throw ParserError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError }
        guard case let .register(r2) = desc.arguments[1] else { throw ParserError.unexpectedError }
        self.kind = .SXTH(r1, r2)
    }

    public func encode(symbols: [String: UInt16]) throws -> [UInt16] {
        switch kind {
        case let .SXTH(r1, r2):
            return Thumb.SXTH(d: r1.number, m: r2.number).encode()
        }
    }
}
