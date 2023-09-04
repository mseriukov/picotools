public struct BX: Instruction {
    enum Kind {
        case BX(Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .BX else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        guard desc.arguments.count == 1 else { throw ParserError.unexpectedNumberOfArguments(at: desc.startToken) }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError(at: desc.startToken) }
        self.kind = .BX(r1)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .BX(r1):
            return Thumb.BX(m: r1.number).encode()
        }
    }
}

extension BX: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .BX(r1):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue)"
        }
    }
}
