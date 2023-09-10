
public struct Token {
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
        case opcode(Mnemonic, Condition?, Qualifier?)
        case register(Register)
        case specialRegister(SpecialRegister)

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

        var isSpecialRegister: Bool {
            if case .specialRegister = self  {
                return true
            } else {
                return false
            }
        }

        var stringValue: String? {
            switch self {
            case let .string(val): return val
            case let .comment(val): return val
            case let .identifier(val): return val
            default: return nil
            }
        }

        var intValue: Int? {
            switch self {
            case let .number(val): return val
            default: return nil
            }
        }

        var opcodeValue: (Mnemonic, Condition?, Qualifier?)? {
            switch self {
            case let .opcode(mnemonic, condition, qualifier): return (mnemonic, condition, qualifier)
            default: return nil
            }
        }

        var registerValue: Register? {
            switch self {
            case let .register(val): return val
            default: return nil
            }
        }

        var specialRegisterValue: SpecialRegister? {
            switch self {
            case let .specialRegister(val): return val
            default: return nil
            }
        }

        init?(_ string: String) {
            var string = string

            var qualifier: Qualifier?
            if let _qualifier = Qualifier(String(string.suffix(2))) {
                string.removeLast(2)
                qualifier = _qualifier
            }

            if let mnemonic = Mnemonic(string) {
                self = .opcode(mnemonic, nil, qualifier)
                return
            }

            var condition: Condition?
            if let _condition = Condition(String(string.suffix(2))) {
                string.removeLast(2)
                condition = _condition
            }

            if let mnemonic = Mnemonic(string) {
                self = .opcode(mnemonic, condition, qualifier)
                return
            }

            if let register = Register(rawValue: string) {
                self = .register(register)
                return
            }

            if let register = SpecialRegister(rawValue: string) {
                self = .specialRegister(register)
                return
            }

            guard let kind = Self.keywordMap[string] else { return nil }
            self = kind
        }

        static let keywordMap: [String: Self] = [:]
    }

    public let kind: Kind
    public let lexeme: String?
    public let line: Int
}

public class Lexer {
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
                throw LexerError.unexpectedCharacter(c, line)
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
            throw LexerError.unterminatedString(line)
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
            throw LexerError.invalidNumber(numStr, line)
        }
        return .number(num)
    }

    private func identifier() throws -> Token.Kind {
        while isAlphaNumeric(peek()) || peek() == "." { advance() }
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
        case let .opcode(m, c, q): return "OPCODE(\(m.stringValue)\(c?.stringValue ?? "")\(q?.stringValue ?? ""))"
        case let .register(val): return "REG(\(val))"
        case let .specialRegister(val): return "SREG(\(val))"
        case let .comment(val): return "COMMENT(\(val))"
        }
    }
}


extension Token.Kind: Equatable {
    
}
