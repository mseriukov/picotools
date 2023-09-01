public struct BL: Instruction {
    enum Kind {
        case BL(String)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .B else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        guard desc.arguments.count == 1 else { throw ParserError.unexpectedNumberOfArguments }
        guard case let .labelLiteral(lit) = desc.arguments[0] else { throw ParserError.unexpectedError }
        self.kind = .BL(lit)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .BL(literal):
            guard let offset = symbols[literal] else { throw ParserError.undefinedLiteral(literal) }
            return Thumb.BL(offset: Int32(offset)).encode()
        }
    }
}

extension BL: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .BL(lit):
            return "\(desc.mnemonic.stringValue) \(lit)"
        }
    }
}
