
/*
 program: line* EOF
 line: (label? instruction? comment? NEWLINE) *
 label: identifier ':'
 immediate: '#' number
 register: r1 | r2 | r3 | r4 | r5 | r6 | r7 | r8 | r9 | r10 | r11 | r12 | r13 | r14 | r15 | sp | lr | pc
 registerList: '{' register (',' register)? '}'

 instruction:
    ADCS (register ',')? register ',' register |
    ADDS (register ',')? register ',' immediate
    ...
 Instruction list:
 ADCS {<Rd>,} <Rn>, <Rm>
 ADDS {<Rd>,} <Rn>, #<const>
 ADD {<Rd>,} SP, #<const>
 ADD <Rd>, PC, #<const>
 CMP <Rn>, #<const>
 ADD{S} {<Rd>,} <Rn>, <Rm>
 ADD {<Rd>,} SP, <Rm>
 ADR <Rd>, <label>
 ANDS {<Rd>,} <Rn>, <Rm>
 ASRS <Rd>, <Rm>, #<imm5>
 ASRS <Rd>, <Rn>, <Rm>
 B{<c>} <label>
 BICS {<Rd>,} <Rn>, <Rm>
 BKPT {#}<imm8>
 BL <label>
 BLX <Rm>
 BX <Rm>
 CMN <Rn>, <Rm>
 CMP <Rn>, <Rm>
 CPY <Rd>, <Rn>
 DMB {<opt>}
 DSB {<opt>}
 EORS {<Rd>,} <Rn>, <Rm>
 ISB {<opt>}
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
 MOV{S} <Rd>, <Rm>
 MOVS <Rd>,<Rm>,ASR #<n>
 ASRS <Rd>,<Rm>,#<n>
 MOVS <Rd>,<Rm>,LSL #<n>
 LSLS <Rd>,<Rm>,#<n>
 MOVS <Rd>,<Rm>,LSR #<n>
 LSRS <Rd>,<Rm>,#<n>
 MOVS <Rd>,<Rm>,ASR <Rs>
 ASRS <Rd>,<Rm>,<Rs>
 MOVS <Rd>,<Rm>,LSL <Rs>
 LSLS <Rd>,<Rm>,<Rs>
 MOVS <Rd>,<Rm>,LSR <Rs>
 LSRS <Rd>,<Rm>,<Rs>
 MOVS <Rd>,<Rm>,ROR <Rs>
 RORS <Rd>,<Rm>,<Rs>
 MRS <Rd>,<spec_reg>
 MSR <spec_reg>,<Rn>
 MULS {<Rd>,} <Rn>, <Rm>
 MVNS <Rd>, <Rm>
 NEG {<Rd>,} <Rm>
 RSBS {<Rd>,} <Rm>, #0
 ORRS {<Rd>,} <Rn>, <Rm>
 POP <registers>
 PUSH <registers>
 REV <Rd>, <Rm>
 REV16 <Rd>, <Rm>
 REVSH <Rd>, <Rm>
 RORS <Rd>, <Rn>, <Rm>
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
 SVC {#}<imm>
 SXTB <Rd>, <Rm>
 SXTH <Rd>, <Rm>
 TST <Rn>, <Rm>
 UDF {#}<imm>
 UXTB <Rd>, <Rm>
 UXTH <Rd>, <Rm>
 SEV
 NOP
 WFE
 WFI
 YIELD

*/


enum InstructionArgument {
    case register(UInt16)
    case immediate(UInt16)
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
        throw ParserError.unexpectedError
    }
}

extension Parser {

    public func parse() throws -> [Statement] {
        var statements: [Statement] = []

        while !isAtEnd() {
            statements.append(try statement())
            try consume({$0 == .newline}, "newline expected")
        }
        return statements
    }


    private func statement() throws -> Statement {
        try instruction()
    }

    private func instruction() throws -> Statement {
        var label: String?
        if peek().kind.isIdentifier {
            let token = try consume({ $0.isIdentifier }, "Identifier expected.")
            try consume({ $0 == .colon }, "Colon expected")

            if case let .identifier(val) = token.kind {
                label = val
            } else {
                throw ParserError.unexpectedError
            }
        }
        let opcode: Token.Opcode
        if peek().kind.isOpcode {
            let token = try consume({ $0.isOpcode }, "Opcode expected")
            if case let .opcode(val) = token.kind {
                opcode = val
            } else {
                throw ParserError.unexpectedError
            }
        } else {
            throw ParserError.unexpectedError
        }

        let instruction = try instruction(opcode: opcode)

        let comment: String?
        if peek().kind.isComment {
            let token = try consume({ $0.isComment }, "Comment expected")
            if case let .comment(val) = token.kind {
                comment = val
            } else {
                throw ParserError.unexpectedError
            }
        } else {
            comment = nil
        }

        return InstructionStatement(
            label: label,
            instruction: instruction,
            comment: comment
        )
    }


    private func instruction(opcode: Token.Opcode) throws -> any Instruction {
        switch opcode {
        case .ADD:
            return try addInstruction()
        case .YIELD:
            return YIELD()
        default:
            return NOP()
        }
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
            if peek().kind == .hash {
                list.append(.immediate(try immediate()))

                if peek().kind == .comma {
                    try consume({ $0 == .comma }, "comma expcted")
                }
            }

            if peek().kind.isRegister {
                let token = try consume({ $0.isRegister }, "Register expected")
                if case let .register(val) = token.kind {
                    list.append(.register(val.number))
                } else {
                    throw ParserError.unexpectedError
                }
                if peek().kind == .comma {
                    try consume({ $0 == .comma }, "comma expcted")
                }
            }
        }
        return list
    }

    private func immediate() throws -> UInt16 {
        try consume({$0 == .hash}, "Immediates should start with #.")
        let token = try consume({ $0.isNumber }, "Immediates should be a number.")
        if case let .number(val) = token.kind {
            return UInt16(val)
        } else {
            throw ParserError.unexpectedError
        }
    }
}
