public struct ADCS: Instruction {
    enum Kind {
        /// Add with Carry (register) adds a register value, the carry flag value, and an optionally-shifted register value,
        /// and writes the result to the destination register. It updates the condition flags based on the result.
        case ADCS(Register, Register) // ADCS{<q>} {<Rd>,} <Rn>, <Rm>
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .ADCS else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil || desc.condition == .always else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.qualifierIsNotSupported(desc.qualifier!) }

        if desc.arguments.count == 2 {
            guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.registerExpected(0) }
            guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.registerExpected(1) }
            self.kind = .ADCS(r1, r2)
            return
        }

        if desc.arguments.count == 3 {
            guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.registerExpected(0) }
            guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.registerExpected(1) }
            guard case let .register(r3) = desc.arguments[2] else { throw InstructionError.registerExpected(2) }
            guard r1 == r2 else { throw InstructionError.RdRnMismatch }
            self.kind = .ADCS(r1, r3)
            return
        }
        throw InstructionError.unexpectedNumberOfArguments
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .ADCS(r1, r2):
            return Thumb.ADC_Register(dn: r1.number, m: r2.number).encode()
        }
    }
}

extension ADCS: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .ADCS(r1, r2):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(r2.rawValue)"
        }
    }
}
