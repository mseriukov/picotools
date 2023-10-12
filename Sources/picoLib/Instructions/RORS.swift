public struct RORS: Instruction {
    enum Kind {
        case ROR_Register(Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .RORS else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        if desc.arguments.count == 2 {
            guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.registerExpected(0) }
            guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.registerExpected(1) }
            guard r1 == r2 else { throw InstructionError.RdRnMismatch }
            self.kind = .ROR_Register(r1, r2)
            return
        }
        throw InstructionError.unexpectedNumberOfArguments
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .ROR_Register(r1, r2):
            return Thumb.ROR_Register(dn: r1.number, m: r2.number).encode()
        }
    }
}

extension RORS: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .ROR_Register(r1, r2):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(r2.rawValue)"
        }
    }
}
