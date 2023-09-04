public struct YIELD: Instruction {
    enum Kind {
        case YIELD
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .YIELD else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        self.kind = .YIELD
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case .YIELD:
            return Thumb.YIELD().encode()
        }
    }
}

extension YIELD: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(desc.mnemonic)"
    }
}
