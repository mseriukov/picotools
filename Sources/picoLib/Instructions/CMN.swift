public struct CMN: Instruction {
    enum Kind {
        case CMN(Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .CMN else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        if desc.arguments.count == 2 {
            guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.registerExpected(0) }
            guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.registerExpected(1) }
            self.kind = .CMN(r1, r2)
            return
        }
        throw InstructionError.unexpectedNumberOfArguments
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .CMN(r1, r2):
            return Thumb.CMN_Register(n: r1.number, m: r2.number).encode()
        }
    }
}

extension CMN: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .CMN(r1, r2):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue) \(r2.rawValue)"
        }
    }
}
