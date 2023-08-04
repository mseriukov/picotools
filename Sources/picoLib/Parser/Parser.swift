
/*
prog: line* EOF
line: label? opcode argumentlist?
label: name ':'
argumentlist: argument (',' argumentlist)?
opcode: ...
argument: prefix? (number | name) (('+' | '-') number)? | "(" argument ")"
prefix: '#' | '='


*/


class Parser {
    private let tokens: [Token]
    private var current = 0

    public init(tokens: [Token]) {
        self.tokens = tokens
    }

}
