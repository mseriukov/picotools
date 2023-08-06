
public struct Token {
    public enum Register: String {
        case r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, sp, lr, pc

        var number: UInt16 {
            switch self {
            case .r0: return 0
            case .r1: return 1
            case .r2: return 2
            case .r3: return 3
            case .r4: return 4
            case .r5: return 5
            case .r6: return 6
            case .r7: return 7
            case .r8: return 8
            case .r9: return 9
            case .r10: return 10
            case .r11: return 11
            case .r12: return 12
            case .r13, .sp: return 13
            case .r14, .lr: return 14
            case .r15, .pc: return 15
            }
        }
    }

    public enum Opcode: String {
        case ADCS
        case ADD
        case ADDS
        case ANDS
        case ASRS
        case ADR
        case B // TODO: conditions
        case BICS
        case BKPT
        case BL
        case BLX
        case BX
        case CMN
        case CMP
        case CPY
        case DMB
        case DSB
        case EORS
        case ISB
        case LDM
        case LDR
        case LDRB
        case LDRH
        case LDRSB
        case LDRSH
        case LSLS
        case LSRS
        case MOVS
        case MOV
        case MRS
        case MSR
        case MULS
        case MVNS
        case NEG
        case RSBS
        case ORRS
        case POP
        case PUSH
        case REV
        case REV16
        case REVSH
        case RORS
        case SBCS
        case STM
        case STMIA
        case STMEA
        case STR
        case STRB
        case STRH
        case SUBS
        case SUB
        case SVC
        case SXTB
        case SXTH
        case TST
        case UDF
        case UXTB
        case UXTH
        case SEV
        case NOP
        case WFE
        case WFI
        case YIELD
    }

    public enum Kind {
        case leftParenthesis
        case rightParenthesis
        case leftBrace
        case rightBrace
        case leftBracket
        case rightBracket
        case comma
        case dot
        case minus
        case plus
        case colon
        case semicolon
        case exclamationMark
        case hash
        case star
        case equal
        case slash
        case newline
        case eof
        case string(String)
        case comment(String)
        case identifier(String)
        case number(Int)
        case opcode(Opcode)
        case register(Register)

        var isString: Bool {
            if case .string = self  {
                return true
            } else {
                return false
            }
        }

        var isComment: Bool {
            if case .comment = self  {
                return true
            } else {
                return false
            }
        }

        var isIdentifier: Bool {
            if case .identifier = self  {
                return true
            } else {
                return false
            }
        }

        var isNumber: Bool {
            if case .number = self  {
                return true
            } else {
                return false
            }
        }

        var isOpcode: Bool {
            if case .opcode = self  {
                return true
            } else {
                return false
            }
        }

        var isRegister: Bool {
            if case .register = self  {
                return true
            } else {
                return false
            }
        }

        init?(_ string: String) {
            if let opcode = Opcode(rawValue: string) {
                self = .opcode(opcode)
                return
            }
            if let register = Register(rawValue: string) {
                self = .register(register)
                return
            }
            guard let kind = Self.keywordMap[string] else { return nil }
            self = kind
        }

        static let keywordMap: [String: Self] = [
            ".eof" : .eof
        ]
    }

    public let kind: Kind
    public let lexeme: String?
    public let line: Int
}

public class Scanner {
    private let source: String
    private var tokens: [Token] = []
    private var start: String.Index
    private var current: String.Index
    private var line: Int

    public init(source: String) {
        self.source = source
        start = source.startIndex
        current = source.startIndex
        line = 1
    }

    public func scanTokens() throws -> [Token]  {
        while !isAtEnd() {
            // We are at the beginning of the next lexeme.
            start = current
            try scanToken()
        }
        tokens.append(Token(kind: .eof, lexeme: nil, line: line))
        return tokens
    }

    private func isAtEnd() -> Bool {
        current == source.endIndex
    }

    private func scanToken() throws {
        let c = advance()
        switch c {
        case "(":
            addToken(.leftParenthesis)

        case ")":
            addToken(.rightParenthesis)

        case "{":
            addToken(.leftBrace)

        case "}":
            addToken(.rightBrace)

        case "[":
            addToken(.leftBracket)

        case "]":
            addToken(.rightBracket)

        case ",":
            addToken(.comma)

        case ".":
            addToken(.dot)

        case "-":
            addToken(.minus)

        case "+":
            addToken(.plus)

        case ":":
            addToken(.colon)

        case "#":
            addToken(.hash)

        case ";":
            addToken(try comment())

        case "*":
            addToken(.star)

        case "!":
            addToken(.exclamationMark)

        case "=":
            addToken(.equal)

        case "/":
            addToken(.slash)

        case "\"":
            addToken(try string())

        case " ", "\r", "\t":
            break

        case "\n":
            line += 1
            addToken(.newline)

        default:
            if isDigit(c) {
                addToken(try number())
            } else if isAlpha(c) {
                addToken(try identifier())
            } else {
                throw ScannerError.unexpectedCharacter(c, line)
            }
        }
    }

    private func isDigit(_ character: Character) -> Bool {
        character.isNumber
    }

    private func isAlpha(_ character: Character) -> Bool {
        character.isLetter
    }

    private func isAlphaNumeric(_ character: Character) -> Bool {
        isAlpha(character) || isDigit(character)
    }

    private func peek() -> Character {
        guard !isAtEnd() else { return "\0" }
        return source[current]
    }

    private func peekNext() -> Character {
        guard source.index(after: current) != source.endIndex else { return "\0" }
        return source[source.index(after: current)]
    }

    private func match(_ expected: Character) -> Bool {
        guard !isAtEnd() else { return false }
        guard source[current] == expected else { return false }
        current = source.index(after: current)
        return true
    }

    @discardableResult
    private func advance() -> Character {
        let prev = current
        current = source.index(after: current)
        return source[prev]
    }

    private func addToken(_ kind: Token.Kind) {
        let lexeme = String(source[start..<current])
        tokens.append(Token(kind: kind, lexeme: lexeme, line: line))
    }

    private func string() throws -> Token.Kind {
        while peek() != "\"" && !isAtEnd() {
            if peek() == "\n" { line += 1 }
            advance()
        }

        if isAtEnd() {
            throw ScannerError.unterminatedString(line)
        }
        advance()
        let string = String(source[source.index(after: start)..<source.index(before: current)])
        return .string(string)
    }

    private func comment() throws -> Token.Kind {
        while peek() != "\n" && !isAtEnd() { advance() }
        let comment = String(source[start..<current])
        return .comment(comment)
    }

    private func number() throws -> Token.Kind {
        while isDigit(peek()) { advance() }

        let numStr = String(source[start..<current])
        guard let num = Int(numStr) else {
            throw ScannerError.invalidNumber(numStr, line)
        }
        return .number(num)
    }

    private func identifier() throws -> Token.Kind {
        while isAlphaNumeric(peek()) { advance() }
        let str = String(source[start..<current])
        return .init(str) ?? .identifier(str)
    }
}

extension Token: CustomDebugStringConvertible {
    public var debugDescription: String {
        "L\(line) \(kind)"
    }
}

extension Token.Kind: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .leftParenthesis: return "("
        case .rightParenthesis: return ")"
        case .leftBrace: return "{"
        case .rightBrace: return "}"
        case .leftBracket: return "["
        case .rightBracket: return "]"
        case .comma: return ","
        case .dot: return "."
        case .minus: return "-"
        case .plus: return "+"
        case .colon: return ":"
        case .semicolon: return ";"
        case .hash: return "#"
        case .star: return "*"
        case .equal: return "="
        case .exclamationMark: return "!"
        case .slash: return "/"
        case .eof: return "EOF"
        case let .string(val): return "STR(\(val))"
        case let .identifier(val): return "IDENT(\(val))"
        case let .number(val): return "NUM(\(val))"
        case .newline: return "NEWLINE"
        case let .opcode(val): return "OPCODE(\(val))"
        case let .register(val): return "REG(\(val))"
        case let .comment(val): return "COMMENT(\(val))"
        }
    }
}


extension Token.Kind: Equatable {
    
}
