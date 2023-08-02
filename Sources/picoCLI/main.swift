import Foundation
import picoLib

let inst: [any InstructionEncodable] = [
    MOV_Register_T1(d: 7, m: 8),
    PUSH(registerList: 42, m: true)
]

let nums = inst.flatMap { $0.encode() }.map { $0.byteSwapped }

print(nums.map { String(format: "%04X", $0) } )

let source = """
.text
.global main
main:
    mov r1, #0       // r1 ← 0
    mov r2, #1       // r2 ← 1
loop:
    cmp r2, #22      // compare r2 and 22
    bgt end          // branch if r2 > 22 to end
    add r1, r1, r2   // r1 ← r1 + r2
    add r2, r2, #1   // r2 ← r2 + 1
    b loop
end:
    mov r0, r1       // r0 ← r1
    bx lr


.global main
main:
    ldr r1, addr_of_a
    mov r2, #0
loop:
    cmp r2, #100
    beq end
    add r3, r1, r2, LSL #2
    str r2, [r3]
    add r2, r2, #1
    b loop
end:
    bx lr
addr_of_a: .word a
"""

let scanner = Scanner(source: source)

do {
    try scanner.scanTokens().forEach { print($0) }
} catch {
    print(error)
}
