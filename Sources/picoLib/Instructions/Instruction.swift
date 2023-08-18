import Foundation

enum Operand {
    case register(Register)
    case immediate(Int)
    case label(String)
    case address(Register)
}

struct Instruction {
    let mnemonic: Mnemonic
    let setsFlags: Bool
    let condition: Condition
    let operands: [Operand]
}
