public struct MSR: Instruction {
    enum Kind {
        case MSR(SpecialRegister, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .MSR else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }


        if desc.arguments.count == 2 {
            guard case let .specialRegister(r1) = desc.arguments[0] else { throw InstructionError.specialRegisterExpected(0) }
            guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.registerExpected(1) }
            self.kind = .MSR(r1, r2)
        }
        throw InstructionError.unexpectedNumberOfArguments
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .MSR(r1, r2):
            return Thumb.MSR_Register(sysm: r1.number, n: r2.number).encode()
        }
    }
}

extension MSR: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .MSR(r1, r2):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(r2.rawValue)"
        }
    }
}
