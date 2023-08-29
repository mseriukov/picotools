public struct MOVS: Instruction {
    enum Kind {
        case MOVS(Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .MOVS || desc.mnemonic == .CPYS else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        guard desc.arguments.count == 2 else { throw ParserError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError }
        guard case let .register(r2) = desc.arguments[1] else { throw ParserError.unexpectedError }
        self.kind = .MOVS(r1, r2)
    }

    public func encode(symbols: [String: UInt16]) throws -> [UInt16] {
        switch kind {
        case let .MOVS(r1, r2):
            return Thumb.MOV_Register_T2(d: r1.number, m: r2.number).encode()
        }
    }
}
