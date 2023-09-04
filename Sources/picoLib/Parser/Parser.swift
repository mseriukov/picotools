/*
 program: statement* EOF
 statement: instruction
 instruction: label? NEWLINE? instruction? comment? NEWLINE?
 label: identifier ':'
 immediate: '#' number
 register: r1 | r2 | r3 | r4 | r5 | r6 | r7 | r8 | r9 | r10 | r11 | r12 | r13 | r14 | r15 | sp | lr | pc
 registerList: '{' register (',' register)? '}'

*/

enum InstructionArgument {
    case register(Register)
    case specialRegister(SpecialRegister)
    case registerList(UInt16)
    case immediate(UInt16)
    case number(Int)
    case labelLiteral(String)
    case numberLiteral(Int)
    case label(String)
}

public struct InstructionDescriptor {
    let mnemonic: Mnemonic
    let condition: Condition?
    let qualifier: Qualifier?
    let arguments: [InstructionArgument]
    let startToken: Token
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
            do {
                statements.append(try statement())
            } catch {
                let token = peek()
                print("Error at line \(token.line) near \(token.lexeme ?? ""). \(error.localizedDescription)")
                // Ignore the rest of the string.
                while peek().kind != .newline { advance() }
                advance()
                continue
            }
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
            arguments: try argumentList(),
            startToken: token
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
        case .STRB: return try STRB(desc)
        case .LDM: return try LDM(desc)
        case .STM: return try STM(desc)
        case .PUSH: return try PUSH(desc)
        case .MRS: return try MRS(desc)
        case .MSR: return try MSR(desc)
        case .LDR: return try LDR(desc)
        case .ADR: return try ADR(desc)
        case .BKPT: return try BKPT(desc)
        case .BLX: return try BLX(desc)
        case .BX: return try BX(desc)
        case .B: return try B(desc)
        case .BL: return try BL(desc)
            
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
                continue
            }

            if peek().kind == .hash {
                list.append(.immediate(try immediate()))
                if peek().kind == .comma { advance() }
                continue
            }

            if peek().kind.isRegister {
                list.append(.register(advance().kind.registerValue!))
                if peek().kind == .comma { advance() }
                continue
            }

            if peek().kind.isSpecialRegister {
                list.append(.specialRegister(advance().kind.specialRegisterValue!))
                if peek().kind == .comma { advance() }
                continue
            }

            if peek().kind == .leftBrace {
                list.append(.registerList(try registerList()))
                continue
            }

            let ignored: [Token.Kind] = [
                .rightBracket,
                .leftBracket,
                .exclamationMark
            ]
            if ignored.contains(where: { $0 == peek().kind }) {
                advance()
                continue
            }
            throw ParserError.unknownError
        }
        return list
    }

    private func registerList() throws -> UInt16 {
        try consume({$0 == .leftBrace}, "Register list should start with `{`.")
        var result: UInt16 = 0
        var startReg: UInt16?
        while true {
            guard !atInstructionEnd() else { throw ParserError.tokenExpected(.rightBrace) }
            if peek().kind == .rightBrace {
                advance()
                if let _startReg = startReg {
                    result |= (1 << _startReg)
                }
                return result
            }

            if peek().kind.isRegister, let reg = peek().kind.registerValue {
                advance()
                if let _startReg = startReg {
                    for i in _startReg...reg.number {
                        result |= (1 << i)
                    }
                    startReg = nil
                } else {
                    startReg = reg.number
                    if peek().kind == .minus { advance() }
                }
                if peek().kind == .comma {
                    if let _startReg = startReg {
                        result |= (1 << _startReg)
                    }
                    startReg = nil
                    advance()
                }
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
