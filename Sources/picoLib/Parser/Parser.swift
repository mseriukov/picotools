
/*
 program: statement* EOF
 statement: instruction
 instruction: label? NEWLINE? instruction? comment? NEWLINE?
 label: identifier ':'
 immediate: '#' number
 register: r1 | r2 | r3 | r4 | r5 | r6 | r7 | r8 | r9 | r10 | r11 | r12 | r13 | r14 | r15 | sp | lr | pc
 registerList: '{' register (',' register)? '}'

    ...
 Instruction list:
 ADR <Rd>, <label>

 B{<c>} <label>
 BICS {<Rd>,} <Rn>, <Rm>
 BKPT {#}<imm8>
 BL <label>
 BLX <Rm>
 BX <Rm>

 EORS {<Rd>,} <Rn>, <Rm>
 LDM <Rn>{!}, <registers>
 LDR <Rt>, [<Rn> {, #+/-<imm>}]
 LDR <Rt>, <label>
 LDR <Rt>, [PC, #<imm>]
 LDR <Rt>, [<Rn>, <Rm>]
 LDRB <Rt>, [<Rn> {, #+/-<imm>}]
 LDRB <Rt>, [<Rn>, <Rm>]
 LDRH <Rt>, [<Rn> {, #+/-<imm>}]
 LDRH <Rt>, [<Rn>, <Rm>]
 LDRSB <Rt>, [<Rn>, <Rm>]
 LDRSH <Rt>, [<Rn>, <Rm>]
 LSLS <Rd>, <Rm>, #<imm5>
 LSLS <Rd>, <Rn>, <Rm>
 LSRS <Rd>, <Rm>, #<imm5>
 LSRS <Rd>, <Rn>, <Rm>
 MOVS <Rd>, #<const>

 MOVS <Rd>,<Rm>,ASR #<n>
 MOVS <Rd>,<Rm>,LSL #<n>
 MOVS <Rd>,<Rm>,LSR #<n>
 MOVS <Rd>,<Rm>,ASR <Rs>
 MOVS <Rd>,<Rm>,LSL <Rs>
 MOVS <Rd>,<Rm>,LSR <Rs>
 MOVS <Rd>,<Rm>,ROR <Rs>

 ASRS <Rd>,<Rm>,#<n>
 LSLS <Rd>,<Rm>,#<n>
 LSRS <Rd>,<Rm>,#<n>
 ASRS <Rd>,<Rm>,<Rs>
 LSLS <Rd>,<Rm>,<Rs>
 LSRS <Rd>,<Rm>,<Rs>
 RORS <Rd>,<Rm>,<Rs>
 
 MRS <Rd>,<spec_reg>
 MSR <spec_reg>,<Rn>
 MULS {<Rd>,} <Rn>, <Rm>

 NEG {<Rd>,} <Rm>
 RSBS {<Rd>,} <Rm>, #0
 ORRS {<Rd>,} <Rn>, <Rm>
 POP <registers>
 PUSH <registers>


 RSBS {<Rd>,} <Rn>, #<const>
 SBCS {<Rd>,} <Rn>, <Rm>
 STM{IA|EA} <Rn>!, <registers>
 STR <Rt>, [<Rn> {, #+/-<imm>}]
 STR <Rt>, [<Rn>, <Rm>]
 STRB <Rt>, [<Rn> {, #+/-<imm>}]
 STRB <Rt>, [<Rn>, <Rm> {, LSL #<shift>}]
 STRH <Rt>, [<Rn> {, #+/-<imm>}]
 STRH <Rt>, [<Rn>, <Rm>]
 SUBS {<Rd>,} <Rn>, #<const>
 SUBS {<Rd>,} <Rn>, <Rm>
 SUB {<Rd>,} SP, #<const>
*/


enum InstructionArgument {
    case register(UInt16)
    case immediate(UInt16)
    case number(Int)
}

public class Parser {
    private let tokens: [Token]
    private var current = 0

    public init(tokens: [Token]) {
        self.tokens = tokens
    }

    func match(_ condition: (Token.Kind) -> Bool) -> Bool {
        if check(condition) {
            advance()
            return true
        }
        return false
    }

    func check(_ condition: (Token.Kind) -> Bool) -> Bool {
        guard !isAtEnd() else { return false }
        return condition(peek().kind)
    }

    @discardableResult
    private func advance() -> Token {
        if !isAtEnd() { current += 1 }
        return previous()
    }

    private func isAtEnd() -> Bool {
        peek().kind == .eof
    }

    private func peek() -> Token {
        tokens[current]
    }

    private func previous() -> Token {
        tokens[current - 1]
    }

    @discardableResult
    private func consume(_ condition: (Token.Kind) -> Bool, _ message: String) throws -> Token {
        if check(condition) { return advance() }
        throw ParserError.assertionFailure(message)
    }
}

extension Parser {
    public func parse() throws -> [Statement] {
        var statements: [Statement] = []

        while !isAtEnd() {
            statements.append(try statement())
        }
        return statements
    }

    private func statement() throws -> Statement {
        try instruction()
    }

    private func instruction() throws -> Statement {
        var label: String?
        if peek().kind.isIdentifier {
            label = advance().kind.stringValue!
            try consume({ $0 == .colon }, "Colon expected")

            if peek().kind == .newline { advance() }
        }
        
        let token = try consume({ $0.isOpcode }, "Opcode expected")
        let opcode = token.kind.opcodeValue!
        let instruction = try instruction(opcode: opcode)

        var comment: String? = nil
        if peek().kind.isComment {
            comment = advance().kind.stringValue
        }

        if peek().kind == .newline { advance() }

        return InstructionStatement(label: label, instruction: instruction, comment: comment)
    }

    private func instruction(opcode: Token.Opcode) throws -> any Instruction {
        switch opcode {
        case .ADCS: return try adcsInstruction()
        case .ANDS: return try andsInstruction()
        case .ASRS: return try asrsInstruction()
        case .ADD: return try addInstruction()
        case .CMP: return try cmpInstruction()

        case .CMN: return try cmnInstruction()
        case .CPY: return try cpyInstruction()
        case .CPYS: return try cpysInstruction()
        case .MOV: return try movInstruction()
        case .MOVS: return try movsInstruction()
        case .UXTH: return try uxthInstruction()
        case .UXTB: return try uxtbInstruction()
        case .SXTH: return try sxthInstruction()
        case .SXTB: return try sxtbInstruction()
        case .TST: return try tstInstruction()
        case .MVNS: return try mvnsInstruction()
        case .REV: return try revInstruction()
        case .REV16: return try rev16Instruction()
        case .REVSH: return try revshInstruction()
            
        case .DMB: return try dmbInstruction()
        case .DSB: return try dsbInstruction()
        case .ISB: return try isbInstruction()
        case .SVC: return try svcInstruction()
        case .UDF: return try udfInstruction()

        case .NOP: return NOP()
        case .SEV: return SEV()
        case .WFE: return WFE()
        case .WFI: return WFI()
        case .SEV: return SEV()
        case .YIELD: return YIELD()
        default: return NOP() // FIXME: throw error when all instructions are here.
        }
    }

    private func mvnsInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return MVN_Register(d: r1, m: r2)
    }

    private func revInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return REV(d: r1, m: r2)
    }

    private func rev16Instruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return REV16(d: r1, m: r2)
    }

    private func revshInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return REVSH(d: r1, m: r2)
    }

    private func sxtbInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return SXTB(d: r1, m: r2)
    }

    private func sxthInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return SXTH(d: r1, m: r2)
    }

    private func uxtbInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return UXTB(d: r1, m: r2)
    }

    private func uxthInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return UXTH(d: r1, m: r2)
    }

    private func tstInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return TST_Register(n: r1, m: r2)
    }

    private func cmnInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return CMN_Register(n: r1, m: r2)
    }

    private func cpyInstruction() throws -> any Instruction {
        return try movInstruction()
    }

    private func cpysInstruction() throws -> any Instruction {
        return try movsInstruction()
    }

    private func movInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return MOV_Register_T1(d: r1, m: r2)
    }

    private func movsInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return MOV_Register_T2(d: r1, m: r2)
    }

    private func svcInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard case let .immediate(opt) = arguments[0] else { throw ParserError.unexpectedError }
        return SVC(imm8: UInt16(opt))
    }

    private func udfInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard case let .immediate(imm) = arguments[0] else { throw ParserError.unexpectedError }
        let uimm = UInt16(imm)
        if uimm < 256 {
            return UDF_T1(imm8: uimm)
        }
        return UDF_T2(imm16: uimm)
    }

    private func dmbInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard case let .immediate(opt) = arguments[0] else { throw ParserError.unexpectedError }
        return DMB(option: UInt16(opt))
    }

    private func dsbInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard case let .immediate(opt) = arguments[0] else { throw ParserError.unexpectedError }
        return DSB(option: UInt16(opt))
    }

    private func isbInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard case let .immediate(opt) = arguments[0] else { throw ParserError.unexpectedError }
        return ISB(option: UInt16(opt))
    }

    private func asrsInstruction() throws -> any Instruction {
        let arguments = try argumentList()

        if arguments.count == 3 {
            guard
                case let .register(r1) = arguments[0],
                case let .register(r2) = arguments[1],
                case let .immediate(imm) = arguments[2]
            else { throw ParserError.unexpectedError }
            return ASR_Immediate(d: r1, m: r2, imm5: imm) // ASRS <Rd>, <Rm>, #<imm5>
        }
        if arguments.count == 2 {
            guard
                case let .register(r1) = arguments[0],
                case let .register(r2) = arguments[1]
            else { throw ParserError.unexpectedError }
            return ASR_Register(dn: r1, m: r2) // ASRS <Rd>, <Rn>, <Rm>
        }
        throw ParserError.unexpectedError
    }

    private func andsInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return AND_Register(dn: r1, m: r2) // ANDS {<Rd>,} <Rn>, <Rm>
    }

    private func cmpInstruction() throws -> any Instruction {
        // CMP <Rn>, #<const>
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0]
        else { throw ParserError.unexpectedError }

        if case let .register(r2) = arguments[1] {
            // TODO: Verify necessary conditions.
            if r1 < 8 && r2 < 8 {
                return CMP_Register_T1(n: r1, m: r2)
            }
            return CMP_Register_T2(n: r1, m: r2)

        } else if case let .immediate(imm) = arguments[1] {
            return CMP_Immediate(n: r1, imm8: imm)
        } else {
            throw ParserError.unexpectedError
        }
    }

    private func adcsInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return ADC_Register(dn: r1, m: r2) // ADCS <Rn>, <Rm>
    }

    private func addInstruction() throws -> any Instruction {
        let arguments = try argumentList()
        switch arguments.count {
        case 2:
            guard
                case let .register(r1) = arguments[0],
                case let .register(r2) = arguments[1]
            else { throw ParserError.unexpectedError }

            if r1 == Token.Register.sp.number {
                return ADD_SP_Register_T2(m: r2) // ADD SP,<Rm>
            }
            return ADD_Register_T2(dn: r1, m: r2) // ADD <Rdn>,<Rm>

        case 3:
            guard
                case let .register(r1) = arguments[0],
                case let .register(r2) = arguments[1]
            else { throw ParserError.unexpectedError }

            if case let .register(r3) = arguments[2] {
                guard r1 == r3, r2 == Token.Register.sp.number else {
                    throw ParserError.unexpectedError
                }
                return ADD_SP_Register_T1(m: r1) // ADD <Rdm>, SP, <Rdm>
            } else if case let .immediate(imm) = arguments[2] {
                guard r2 == Token.Register.sp.number else {
                    throw ParserError.unexpectedError
                }
                if r1 == Token.Register.sp.number {
                    return ADD_SP_Immediate_T2(imm7: imm)
                } else {
                    return ADD_SP_Immediate_T1(d: r1, imm8: imm) // ADD <Rd>,SP,#<imm8>
                }
            } else {
                throw ParserError.unexpectedError
            }
        default:
            throw ParserError.unexpectedError
        }
    }

    private func argumentList() throws -> [InstructionArgument] {
        var list: [InstructionArgument] = []
        while !peek().kind.isComment && !isAtEnd() && peek().kind != .newline {
            if peek().kind.isNumber {
                list.append(.number(advance().kind.intValue!))
                if peek().kind == .comma { advance() }
            }

            if peek().kind == .hash {
                list.append(.immediate(try immediate()))
                if peek().kind == .comma { advance() }
            }

            if peek().kind.isRegister {
                list.append(.register(advance().kind.registerValue!.number))
                if peek().kind == .comma { advance() }
            }
        }
        return list
    }

    private func immediate() throws -> UInt16 {
        try consume({$0 == .hash}, "Immediates should start with #.")
        let token = try consume({ $0.isNumber }, "Immediates should be a number.")
        return UInt16(token.kind.intValue!)
    }
}
