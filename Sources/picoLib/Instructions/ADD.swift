public struct ADD: Instruction {
    enum Kind {
        case ADD_SP_Register_T2(Register) // ADD SP,<Rm>
        case ADD_Register_T2(Register, Register) // ADD <Rdn>,<Rm>
        case ADD_SP_Register_T1(Register) // ADD <Rdm>, SP, <Rdm>
        case ADD_SP_Immediate_T2(UInt16) //  ADD SP,SP,#<imm7>
        case ADD_SP_Immediate_T1(Register, UInt16) // ADD <Rd>,SP,#<imm8>
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .ADD else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        let kind: Kind
        switch desc.arguments.count {
        case 2:
            guard
                case let .register(r1) = desc.arguments[0],
                case let .register(r2) = desc.arguments[1]
            else { throw ParserError.unexpectedError }

            if r1.number == Register.sp.number {
                kind = .ADD_SP_Register_T2(r1)
            } else {
                kind = .ADD_Register_T2(r1, r2)
            }

        case 3:
            guard
                case let .register(r1) = desc.arguments[0],
                case let .register(r2) = desc.arguments[1]
            else { throw ParserError.unexpectedError }

            if case let .register(r3) = desc.arguments[2] {
                guard r1 == r3, r2.number == Register.sp.number else {
                    throw ParserError.unexpectedError
                }
                kind = .ADD_SP_Register_T1(r1)

            } else if case let .immediate(imm) = desc.arguments[2] {
                guard r2.number == Register.sp.number else {
                    throw ParserError.unexpectedError
                }
                if r1.number == Register.sp.number {
                    kind = .ADD_SP_Immediate_T2(imm)
                } else {
                    kind = .ADD_SP_Immediate_T1(r1, imm)
                }
            } else {
                throw ParserError.unexpectedError
            }
        default:
            throw ParserError.unexpectedError
        }
        self.kind = kind
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .ADD_SP_Register_T2(r):
            return Thumb.ADD_SP_Register_T2(m: r.number).encode()

        case let .ADD_Register_T2(r1, r2):
            return Thumb.ADD_Register_T2(dn: r1.number, m: r2.number).encode()

        case let .ADD_SP_Register_T1(r):
            return Thumb.ADD_SP_Register_T1(m: r.number).encode()

        case let .ADD_SP_Immediate_T2(imm):
            return Thumb.ADD_SP_Immediate_T2(imm7: imm).encode()

        case let .ADD_SP_Immediate_T1(r, imm):
            return Thumb.ADD_SP_Immediate_T1(d: r.number, imm8: imm).encode()
        }
    }
}

extension ADD: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .ADD_SP_Register_T2(r):
            return "\(desc.mnemonic) sp, \(r.rawValue)"

        case let .ADD_Register_T2(r1, r2):
            return "\(desc.mnemonic) \(r1.rawValue), \(r2.rawValue)"

        case let .ADD_SP_Register_T1(r):
            return "\(desc.mnemonic) \(r.rawValue), sp, \(r.rawValue)"

        case let .ADD_SP_Immediate_T2(imm):
            return "\(desc.mnemonic) sp, sp, #\(imm)"

        case let .ADD_SP_Immediate_T1(r, imm):
            return "\(desc.mnemonic) \(r.rawValue), sp, #\(imm)"
        }
    }
}
