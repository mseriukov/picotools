
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
    case register(Register)
    case registerList(UInt16)
    case immediate(UInt16)
    case number(Int)
    case literal(String)
    case lab(Register)
}

public struct InstructionDescriptor {
    let mnemonic: Mnemonic
    let condition: Condition?
    let qualifier: Qualifier?
    let arguments: [InstructionArgument]
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
        let desc = InstructionDescriptor(
            mnemonic: opcode.0,
            condition: opcode.1,
            qualifier: opcode.2,
            arguments: try argumentList()
        )

        let instruction = try instruction(desc)

        var comment: String? = nil
        if peek().kind.isComment {
            comment = advance().kind.stringValue
        }

        while peek().kind == .newline { advance() }

        return InstructionStatement(label: label, instruction: instruction, comment: comment)
    }

    private func instruction(_ desc: InstructionDescriptor) throws -> any Instruction {
        switch desc.mnemonic {
        case .ADCS: return try ADCS(desc)
        case .ANDS: return try ANDS(desc)
        case .ADD: return try ADD(desc)
        case .CMP: return try CMP(desc)

        case .CMN: return try CMN(desc)
        case .CPY: return try MOV(desc)
        case .CPYS: return try MOVS(desc)
        case .MOV: return try MOV(desc)
        case .MOVS: return try MOVS(desc)
        case .UXTH: return try UXTH(desc)
        case .UXTB: return try UXTB(desc)
        case .SXTH: return try SXTH(desc)
        case .SXTB: return try SXTB(desc)
        case .TST: return try TST(desc)
        case .MVNS: return try MVNS(desc)
        case .REV: return try REV(desc)
        case .REV16: return try REV16(desc)
        case .REVSH: return try REVSH(desc)

        case .ASRS: return try ASRS(desc)
        case .LSLS: return try LSLS(desc)
        case .LSRS: return try LSRS(desc)
        case .RORS: return try RORS(desc)
        case .RSBS: return try RSBS(desc)
        case .ORRS: return try ORRS(desc)

        case .MULS: return try MULS(desc)
        case .BICS: return try BICS(desc)
        case .EORS: return try EORS(desc)
        case .SBCS: return try SBCS(desc)
        case .SUBS: return try SUBS(desc)
        case .SUB: return try SUB(desc)
            
        case .DMB: return try DMB(desc)
        case .DSB: return try DSB(desc)
        case .ISB: return try ISB(desc)
        case .SVC: return try SVC(desc)
        case .UDF: return try UDF(desc)

        case .LDRH: return try LDRH(desc)
        case .LDRB: return try LDRB(desc)
        case .LDRSH: return try LDRSH(desc)
        case .LDRSB: return try LDRSB(desc)
        case .STR: return try STR(desc)
        case .STRH: return try STRH(desc)
        case .STM: return try STM(desc)

        case .NOP: return try NOP(desc)
        case .SEV: return try SEV(desc)
        case .WFE: return try WFE(desc)
        case .WFI: return try WFI(desc)
        case .YIELD: return try YIELD(desc)
        default: return try NOP(desc) // FIXME: throw error when all instructions are here.
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
                list.append(.register(advance().kind.registerValue!))
                if peek().kind == .comma { advance() }
            }

            if peek().kind == .leftBrace {
                list.append(.registerList(try registerList()))
            }

            let ignored: [Token.Kind] = [
                .rightBracket,
                .leftBracket,
                .exclamationMark
            ]
            if ignored.contains(where: { $0 == peek().kind }) { advance() }
        }
        return list
    }

    private func registerList() throws -> UInt16 {
        try consume({$0 == .leftBrace}, "Register list should start with `{`.")
        var result: UInt16 = 0
        while true {
            guard !atInstructionEnd() else { throw ParserError.tokenExpected(.rightBrace) }
            if peek().kind == .rightBrace {
                advance()
                return result
            }
        }
    }

    private func atInstructionEnd() -> Bool {
        peek().kind.isComment ||
        peek().kind == .newline ||
        isAtEnd()
    }

    private func immediate() throws -> UInt16 {
        try consume({$0 == .hash}, "Immediates should start with #.")
        let token = try consume({ $0.isNumber }, "Immediates should be a number.")
        return UInt16(token.kind.intValue!)
    }
}
