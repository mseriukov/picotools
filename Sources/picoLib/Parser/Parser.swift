
/*
 program: line* EOF

 line: (label? instruction? NEWLINE) *
 instruction: opcode argumentList

 label: identifier ':'

 argumentlist: argument (',' argumentlist)?
 argument: prefix? (number | name) (('+' | '-') number)? | "(" argument ")"

 prefix: '#' | '='

 register: r1 | r2 | r3 | r4 | r5 | r6 | r7 | r8 | r9 | r10 | r11 | r12 | r13 | r14 | r15 | sp | lr | pc
 registerList: '{' registerListEntry (',' registerListEntry)? '}'
 registerListEntry: register | registerRange
 registerRange: register '-' register

 opcode: ...

*/


class Parser {
    private let tokens: [Token]
    private var current = 0

    public init(tokens: [Token]) {
        self.tokens = tokens
    }

}
