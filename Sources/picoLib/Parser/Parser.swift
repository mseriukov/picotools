
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

 LDR <Rt>, [PC, #<imm>]
 LDR <Rt>, <label>
 LDR <Rt>, [<Rn> {, #+/-<imm>}]
 LDR <Rt>, [<Rn>, <Rm>]

 BKPT {#}<imm8>
 BL <label>
 BLX <Rm>
 BX <Rm>

 LDM <Rn>{!}, <registers>
 POP <registers>
 PUSH <registers>
 STM{IA|EA} <Rn>!, <registers>

 LDRB <Rt>, [<Rn> {, #+/-<imm>}]
 LDRH <Rt>, [<Rn> {, #+/-<imm>}]
 STR <Rt>, [<Rn> {, #+/-<imm>}]
 STRH <Rt>, [<Rn> {, #+/-<imm>}]
 STRB <Rt>, [<Rn> {, #+/-<imm>}]

 MOVS <Rd>, #<const>
 MOVS <Rd>,<Rm>,ASR #<n>
 MOVS <Rd>,<Rm>,LSL #<n>
 MOVS <Rd>,<Rm>,LSR #<n>
 MOVS <Rd>,<Rm>,ASR <Rs>
 MOVS <Rd>,<Rm>,LSL <Rs>
 MOVS <Rd>,<Rm>,LSR <Rs>
 MOVS <Rd>,<Rm>,ROR <Rs>
 
 MRS <Rd>,<spec_reg>
 MSR <spec_reg>,<Rn>

 STRB <Rt>, [<Rn>, <Rm> {, LSL #<shift>}]
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

        let instruction = try instruction(opcode: opcode.0, condition: opcode.1, qualifier: opcode.2)

        var comment: String? = nil
        if peek().kind.isComment {
            comment = advance().kind.stringValue
        }

        while peek().kind == .newline { advance() }

        return InstructionStatement(label: label, instruction: instruction, comment: comment)
    }

    private func instruction(opcode: Mnemonic, condition: Condition?, qualifier: Qualifier?) throws -> any CodableInstruction {
        switch opcode {
        case .ADCS: return try adcsInstruction()
        case .ANDS: return try andsInstruction()
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

        case .ASRS: return try asrsInstruction()
        case .LSLS: return try lslsInstruction()
        case .LSRS: return try lsrsInstruction()
        case .RORS: return try rorsInstruction()
        case .RSBS: return try rsbsInstruction()
        case .ORRS: return try orrsInstruction()

        case .MULS: return try mulsInstruction()
        case .BICS: return try bicsInstruction()
        case .EORS: return try eorsInstruction()
        case .SBCS: return try sbcsInstruction()
        case .SUBS: return try subsInstruction()
        case .SUB: return try subInstruction()
            
        case .DMB: return try dmbInstruction()
        case .DSB: return try dsbInstruction()
        case .ISB: return try isbInstruction()
        case .SVC: return try svcInstruction()
        case .UDF: return try udfInstruction()

        case .LDRH: return try ldrhInstruction()
        case .LDRB: return try ldrbInstruction()
        case .LDRSH: return try ldrshInstruction()
        case .LDRSB: return try ldrsbInstruction()
        case .STR: return try strInstruction()
        case .STRH: return try strhInstruction()

        case .NOP: return Thumb.NOP()
        case .SEV: return Thumb.SEV()
        case .WFE: return Thumb.WFE()
        case .WFI: return Thumb.WFI()
        case .YIELD: return Thumb.YIELD()
        default: return Thumb.NOP() // FIXME: throw error when all instructions are here.
        }
    }

    private func rsbsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()

        if
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        {
            return Thumb.RSB_Immediate(d: r1, n: r2)
        }

        throw ParserError.unexpectedError
    }


    private func subInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()

        if
            arguments.count == 3,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1],
            case let .immediate(imm) = arguments[2]
        {
            return Thumb.SUB_SP_Immediate(imm7: imm)
        }

        throw ParserError.unexpectedError
    }

    private func subsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()

        if
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .immediate(imm) = arguments[1]
        {
            return Thumb.SUB_Immediate_T2(dn: r1, imm8: imm)
        }

        if
            arguments.count == 3,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1],
            case let .immediate(imm) = arguments[2]
        {
            return Thumb.SUB_Immediate_T1(d: r1, n: r2, imm3: imm)
        }

        if
            arguments.count == 3,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1],
            case let .register(r3) = arguments[2]
        {
            return Thumb.SUB_Register(d: r1, n: r2, m: r3)
        }

        throw ParserError.unexpectedError
    }

    private func sbcsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.SBC_Register(dn: r1, m: r2)
    }

    private func eorsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.EOR_Register(dn: r1, m: r2)
    }

    private func bicsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.BIC_Register(dn: r1, m: r2)
    }

    private func mulsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.MUL(n: r1, dm: r2)
    }

    private func orrsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.ORR_Register(dn: r1, m: r2)
    }

    private func rorsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.ROR_Register(dn: r1, m: r2)
    }

    private func lsrsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count >= 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }

        if arguments.count == 3, case let .immediate(imm) = arguments[2] {
            return Thumb.LSR_Immediate(d: r1, m: r2, imm5: imm)
        }
        return Thumb.LSR_Register(dn: r1, m: r2)
    }

    private func lslsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count >= 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }

        if arguments.count == 3, case let .immediate(imm) = arguments[2] {
            return Thumb.LSL_Immediate(d: r1, m: r2, imm5: imm)
        }
        return Thumb.LSL_Register(dn: r1, m: r2)
    }

    private func asrsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count >= 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }

        if arguments.count == 3, case let .immediate(imm) = arguments[2] {
            return Thumb.ASR_Immediate(d: r1, m: r2, imm5: imm)
        }
        return Thumb.ASR_Register(dn: r1, m: r2)
    }

    private func strInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 3,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1],
            case let .register(r3) = arguments[2]
        else { throw ParserError.unexpectedError }
        return Thumb.STR_Register(t: r1, n: r2, m: r3)
    }

    private func strhInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 3,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1],
            case let .register(r3) = arguments[2]
        else { throw ParserError.unexpectedError }
        return Thumb.STRH_Register(t: r1, n: r2, m: r3)
    }

    private func ldrhInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 3,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1],
            case let .register(r3) = arguments[2]
        else { throw ParserError.unexpectedError }
        return Thumb.LDRH_Register(t: r1, n: r2, m: r3)
    }

    private func ldrbInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 3,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1],
            case let .register(r3) = arguments[2]
        else { throw ParserError.unexpectedError }
        return Thumb.LDRB_Register(t: r1, n: r2, m: r3)
    }

    private func ldrsbInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 3,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1],
            case let .register(r3) = arguments[2]
        else { throw ParserError.unexpectedError }
        return Thumb.LDRSB_Register(t: r1, n: r2, m: r3)
    }

    private func ldrshInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 3,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1],
            case let .register(r3) = arguments[2]
        else { throw ParserError.unexpectedError }
        return Thumb.LDRSH_Register(t: r1, n: r2, m: r3)
    }



    private func mvnsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.MVN_Register(d: r1, m: r2)
    }

    private func revInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.REV(d: r1, m: r2)
    }

    private func rev16Instruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.REV16(d: r1, m: r2)
    }

    private func revshInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.REVSH(d: r1, m: r2)
    }

    private func sxtbInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.SXTB(d: r1, m: r2)
    }

    private func sxthInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.SXTH(d: r1, m: r2)
    }

    private func uxtbInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.UXTB(d: r1, m: r2)
    }

    private func uxthInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.UXTH(d: r1, m: r2)
    }

    private func tstInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.TST_Register(n: r1, m: r2)
    }

    private func cmnInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.CMN_Register(n: r1, m: r2)
    }

    private func cpyInstruction() throws -> any CodableInstruction {
        return try movInstruction()
    }

    private func cpysInstruction() throws -> any CodableInstruction {
        return try movsInstruction()
    }

    private func movInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.MOV_Register_T1(d: r1, m: r2)
    }

    private func movsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.MOV_Register_T2(d: r1, m: r2)
    }

    private func svcInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard case let .immediate(opt) = arguments[0] else { throw ParserError.unexpectedError }
        return Thumb.SVC(imm8: UInt16(opt))
    }

    private func udfInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard case let .immediate(imm) = arguments[0] else { throw ParserError.unexpectedError }
        let uimm = UInt16(imm)
        if uimm < 256 {
            return Thumb.UDF_T1(imm8: uimm)
        }
        return Thumb.UDF_T2(imm16: uimm)
    }

    private func dmbInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard case let .immediate(opt) = arguments[0] else { throw ParserError.unexpectedError }
        return Thumb.DMB(option: UInt16(opt))
    }

    private func dsbInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard case let .immediate(opt) = arguments[0] else { throw ParserError.unexpectedError }
        return Thumb.DSB(option: UInt16(opt))
    }

    private func isbInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard case let .immediate(opt) = arguments[0] else { throw ParserError.unexpectedError }
        return Thumb.ISB(option: UInt16(opt))
    }

    private func andsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.AND_Register(dn: r1, m: r2) // ANDS {<Rd>,} <Rn>, <Rm>
    }

    private func cmpInstruction() throws -> any CodableInstruction {
        // CMP <Rn>, #<const>
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0]
        else { throw ParserError.unexpectedError }

        if case let .register(r2) = arguments[1] {
            // TODO: Verify necessary conditions.
            if r1 < 8 && r2 < 8 {
                return Thumb.CMP_Register_T1(n: r1, m: r2)
            }
            return Thumb.CMP_Register_T2(n: r1, m: r2)

        } else if case let .immediate(imm) = arguments[1] {
            return Thumb.CMP_Immediate(n: r1, imm8: imm)
        } else {
            throw ParserError.unexpectedError
        }
    }

    private func adcsInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        guard
            arguments.count == 2,
            case let .register(r1) = arguments[0],
            case let .register(r2) = arguments[1]
        else { throw ParserError.unexpectedError }
        return Thumb.ADC_Register(dn: r1, m: r2) // ADCS <Rn>, <Rm>
    }

    private func addInstruction() throws -> any CodableInstruction {
        let arguments = try argumentList()
        switch arguments.count {
        case 2:
            guard
                case let .register(r1) = arguments[0],
                case let .register(r2) = arguments[1]
            else { throw ParserError.unexpectedError }

            if r1 == Register.sp.number {
                return Thumb.ADD_SP_Register_T2(m: r2) // ADD SP,<Rm>
            }
            return Thumb.ADD_Register_T2(dn: r1, m: r2) // ADD <Rdn>,<Rm>

        case 3:
            guard
                case let .register(r1) = arguments[0],
                case let .register(r2) = arguments[1]
            else { throw ParserError.unexpectedError }

            if case let .register(r3) = arguments[2] {
                guard r1 == r3, r2 == Register.sp.number else {
                    throw ParserError.unexpectedError
                }
                return Thumb.ADD_SP_Register_T1(m: r1) // ADD <Rdm>, SP, <Rdm>
            } else if case let .immediate(imm) = arguments[2] {
                guard r2 == Register.sp.number else {
                    throw ParserError.unexpectedError
                }
                if r1 == Register.sp.number {
                    return Thumb.ADD_SP_Immediate_T2(imm7: imm)
                } else {
                    return Thumb.ADD_SP_Immediate_T1(d: r1, imm8: imm) // ADD <Rd>,SP,#<imm8>
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
            if peek().kind == .rightBracket || peek().kind == .leftBracket { advance() }
        }
        return list
    }

    private func immediate() throws -> UInt16 {
        try consume({$0 == .hash}, "Immediates should start with #.")
        let token = try consume({ $0.isNumber }, "Immediates should be a number.")
        return UInt16(token.kind.intValue!)
    }
}
