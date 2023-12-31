public struct BX: Instruction {
    enum Kind {
        case BX(Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .BX else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard desc.arguments.count == 1 else { throw InstructionError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.unknownError }
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
