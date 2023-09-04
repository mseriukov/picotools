public struct BLX: Instruction {
    enum Kind {
        case BLX(Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .BLX else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        guard desc.arguments.count == 1 else { throw ParserError.unexpectedNumberOfArguments(at: desc.startToken) }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError(at: desc.startToken) }
        self.kind = .BLX(r1)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .BLX(r1):
            return Thumb.BLX(m: r1.number).encode()
        }
    }
}

extension BLX: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .BLX(r1):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue)"
        }
    }
}
