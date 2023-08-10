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
    DMB #42
    DSB #43
    ISB #44
    CMN r4, r5
    MOV r1, r2
    MOVS r2, r3
    CPY r1, r2
    CPYS r2, r3
    MVNS r2, r3
    REV r4, r5
    REV16 r5, r0
    REVSH r2, r3
    SVC #42
    UDF #42
    UDF #4242
    LDRH r1, [r2, r3]
    LDRSB r1, [r2, r3]
    LDRSH r1, [r2, r3]
    LDRB r1, [r2, r3]
    STR r1, [r2, r3]
    STRH r1, [r2, r3]
"""

let scanner = Scanner(source: source)

do {
    let parser = Parser(tokens: try scanner.scanTokens())
    let statements = try parser.parse()

    statements.forEach { print($0) }
} catch {
    print(error)
}
