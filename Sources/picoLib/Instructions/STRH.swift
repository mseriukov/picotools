public struct STRH: Instruction {
    enum Kind {
        case STRH(Register, Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .STRH else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        guard desc.arguments.count == 3 else { throw ParserError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError }
        guard case let .register(r2) = desc.arguments[1] else { throw ParserError.unexpectedError }
        guard case let .register(r3) = desc.arguments[2] else { throw ParserError.unexpectedError }
        self.kind = .STRH(r1, r2, r3)
    }

    public func encode(symbols: [String: UInt16]) throws -> [UInt16] {
        switch kind {
        case let .STRH(r1, r2, r3):
            return Thumb.STRH_Register(t: r1.number, n: r2.number, m: r3.number).encode()
        }
    }
}
