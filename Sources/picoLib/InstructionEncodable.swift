public protocol InstructionEncodable {
    func encode() -> [UInt16]
}

public protocol InstructionDecodable {
    associatedtype Instruction
    static func decode(_ data: [UInt16]) -> Instruction
}

public protocol Instruction: InstructionEncodable, InstructionDecodable, CustomDebugStringConvertible {
    static var sig: [UInt16] { get }
    static var msk: [UInt16] { get }
}

extension Instruction {
    static func verifySignature(_ data: [UInt16]) {
        guard data.count == sig.count else { fatalError("Instruction requires exactly \(sig.count) word(s).") }

        for i in 0..<sig.count {
            guard (data[i] & msk[i]) == sig[i] else { fatalError("Bad encoding for instruction, signature verification failed.") }
        }
    }
}
