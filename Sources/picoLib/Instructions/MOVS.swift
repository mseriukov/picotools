#warning("TODO:")
//MOVS <Rd>, #<const>
//MOVS <Rd>,<Rm>,ASR #<n>
//MOVS <Rd>,<Rm>,LSL #<n>
//MOVS <Rd>,<Rm>,LSR #<n>
//MOVS <Rd>,<Rm>,ASR <Rs>
//MOVS <Rd>,<Rm>,LSL <Rs>
//MOVS <Rd>,<Rm>,LSR <Rs>
//MOVS <Rd>,<Rm>,ROR <Rs>

public struct MOVS: Instruction {
    enum Kind {
        case MOVS(Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .MOVS || desc.mnemonic == .CPYS else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        if desc.arguments.count == 2 {
            guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.registerExpected(0) }
            guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.registerExpected(1) }
            self.kind = .MOVS(r1, r2)
            return
        }
        throw InstructionError.unexpectedNumberOfArguments
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .MOVS(r1, r2):
            return Thumb.MOV_Register_T2(d: r1.number, m: r2.number).encode()
        }
    }
}

extension MOVS: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .MOVS(r1, r2):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(r2.rawValue)"
        }
    }
}
