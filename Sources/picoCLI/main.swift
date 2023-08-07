import Foundation
import picoLib

let inst: [any InstructionEncodable] = [
    MOV_Register_T1(d: 7, m: 8),
    PUSH(registerList: 42, m: true)
]

let nums = inst.flatMap { $0.encode() }.map { $0.byteSwapped }

print(nums.map { String(format: "%04X", $0) } )

let source = """
main:   YIELD ;This is a comment
        ADD r0, r0
        ADD r0, sp, #40 ; asdf

"""

let scanner = Scanner(source: source)

do {
    let parser = Parser(tokens: try scanner.scanTokens())
    let statements = try parser.parse()

    statements.forEach { print($0) }
} catch {
    print(error)
}


