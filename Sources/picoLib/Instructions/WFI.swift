public struct WFI: Instruction {
    enum Kind {
        case WFI
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .WFI else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        self.kind = .WFI
    }

    public func encode(symbols: [String: UInt16]) throws -> [UInt16] {
        switch kind {
        case .WFI:
            return Thumb.WFI().encode()
        }
    }
}

extension WFI: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(desc.mnemonic)"
    }
}
