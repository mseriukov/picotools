import Foundation
import picoLib

let inst: [any InstructionEncodable] = [
    // MOV_Register_T1(d: 7, m: 8)
]

let nums = inst.flatMap { $0.encode() }.map { $0.byteSwapped }

print(nums.map { String(format: "%04X", $0) } )
