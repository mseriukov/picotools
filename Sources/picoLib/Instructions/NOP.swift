public struct NOP: Instruction {
    enum Kind {
        case NOP
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .NOP else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        self.kind = .NOP
    }

    public func encode(symbols: [String: UInt16]) throws -> [UInt16] {
        switch kind {
        case .NOP:
            return Thumb.NOP().encode()
        }
    }
}

extension NOP: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(desc.mnemonic)"
    }
}
