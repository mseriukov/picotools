public struct WFE: Instruction {
    enum Kind {
        case WFE
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .WFE else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        self.kind = .WFE
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case .WFE:
            return Thumb.WFE().encode()
        }
    }
}

extension WFE: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(desc.mnemonic)"
    }
}
