public struct SEV: Instruction {
    enum Kind {
        case SEV
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .SEV else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        self.kind = .SEV
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case .SEV:
            return Thumb.SEV().encode()
        }
    }
}

extension SEV: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(desc.mnemonic)"
    }
}
