public struct LDRSH: Instruction {
    enum Kind {
        case LDRSH(Register, Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .LDRSH else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        if desc.arguments.count == 3 {
            guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.registerExpected(0) }
            guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.registerExpected(1) }
            guard case let .register(r3) = desc.arguments[2] else { throw InstructionError.registerExpected(2) }
            self.kind = .LDRSH(r1, r2, r3)
            return
        }
        throw InstructionError.unexpectedNumberOfArguments
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .LDRSH(r1, r2, r3):
            return Thumb.LDRSH_Register(t: r1.number, n: r2.number, m: r3.number).encode()
        }
    }
}

extension LDRSH: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .LDRSH(r1, r2, r3):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(r2.rawValue), \(r3.rawValue)"
        }
    }
}
