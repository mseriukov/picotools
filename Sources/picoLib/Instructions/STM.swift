public struct STM: Instruction {
    enum Kind {
        case STM(Register, UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .STM else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        guard desc.arguments.count == 2 else { throw ParserError.unexpectedNumberOfArguments }
        guard case let .register(r) = desc.arguments[0] else { throw ParserError.unexpectedError }
        guard case let .registerList(list) = desc.arguments[1] else { throw ParserError.unexpectedError }
        self.kind = .STM(r, list)
    }

    public func encode(symbols: [String: UInt16]) throws -> [UInt16] {
        switch kind {
        case let .STM(r, regList):
            return Thumb.STM(n: r.number, registerList: regList).encode()
        }
    }
}
