import Foundation
import picoLib

let source = """
main:
    YIELD               ; This is a comment
    ADD r0, r0
    ADD r0, sp, #40     ; asdf
    ADCS r7, r12        ;
    NOP
    NOP
    WFE
    CMP r2, r3
    CMP r7, r12
    CMP r5, #42
    ANDS r3, r7
    ASRS r5, r0
    ASRS r7, r10, #40
"""

let scanner = Scanner(source: source)

do {
    let parser = Parser(tokens: try scanner.scanTokens())
    let statements = try parser.parse()

    statements.forEach { print($0) }
} catch {
    print(error)
}
