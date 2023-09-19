public struct WFE: Instruction {
    enum Kind {
        case WFE
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .WFE else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        if desc.arguments.count == 0 {
            self.kind = .WFE
            return
        }
        throw InstructionError.unexpectedNumberOfArguments
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
