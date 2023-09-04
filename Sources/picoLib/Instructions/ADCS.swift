public struct ADCS: Instruction {
    enum Kind {
        case ADCS(Register, Register) // ADCS <Rn>, <Rm>
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .ADCS else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        guard desc.arguments.count == 2 else { throw ParserError.unexpectedNumberOfArguments(at: desc.startToken) }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError(at: desc.startToken) }
        guard case let .register(r2) = desc.arguments[1] else { throw ParserError.unexpectedError(at: desc.startToken) }
        self.kind = .ADCS(r1, r2)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .ADCS(r1, r2):
            return Thumb.ADC_Register(dn: r1.number, m: r2.number).encode()
        }
    }
}

extension ADCS: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .ADCS(r1, r2):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(r2.rawValue)"
        }
    }
}
