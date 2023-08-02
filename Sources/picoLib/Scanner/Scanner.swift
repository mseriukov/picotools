
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
        case hash
        case star
        case equal
        case bangEqual
        case equalEqual
        case less
        case lessEqual
        case greater
        case greaterEqual
        case slash
        case eof
        case string(String)
        case identifier(String)
        case number(Int)
        case immediate(Int)

        init?(_ string: String) {
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
            if isAlphaNumeric(peek()) {
                addToken(try identifier())
            } else {
                addToken(.dot)
            }

        case "-":
            addToken(.minus)

        case "+":
            addToken(.plus)

        case ":":
            addToken(.colon)

        case "#":
            if isDigit(peek()) {
                addToken(try immediate())
            } else {
                addToken(.hash)
            }

        case ";":
            addToken(.semicolon)

        case "*":
            addToken(.star)

        case "!":
            addToken(match("=") ? .bangEqual : .equal)

        case "=":
            addToken(match("=") ? .equalEqual : .equal)

        case "/":
            if match("/") {
                while peek() != "\n" && !isAtEnd() { advance() }
            } else {
                addToken(.slash)
            }

        case "\"":
            addToken(try string())

        case " ", "\r", "\t":
            break

        case "\n":
            line += 1

        default:
            if isDigit(c) {
                addToken(try number())
            } else if isAlpha(c) || c == "_" {
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

    private func number() throws -> Token.Kind {
        while isDigit(peek()) { advance() }

        let numStr = String(source[start..<current])
        guard let num = Int(numStr) else {
            throw ScannerError.invalidNumber(numStr, line)
        }
        return .number(num)
    }

    private func identifier() throws -> Token.Kind {
        while isAlphaNumeric(peek()) || peek() == "_" { advance() }
        let str = String(source[start..<current])
        return .init(str) ?? .identifier(str)
    }

    private func immediate() throws -> Token.Kind {
        while isDigit(peek()) { advance() }

        let numStr = String(source[source.index(after: start)..<current])
        guard let num = Int(numStr) else {
            throw ScannerError.invalidNumber(numStr, line)
        }
        return .immediate(num)
    }
}

    }
}
