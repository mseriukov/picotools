import Foundation
import picoLib

let source = """
main:
    YIELD               ;This is a comment
    ADD r0, r0
    ADD r0, sp, #40     ; asdf

"""

let scanner = Scanner(source: source)

do {
    let parser = Parser(tokens: try scanner.scanTokens())
    let statements = try parser.parse()

    statements.forEach { print($0) }
} catch {
    print(error)
}
