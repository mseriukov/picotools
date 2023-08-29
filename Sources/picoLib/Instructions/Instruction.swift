public protocol Instruction {
    func encode(symbols: [String: UInt16]) throws -> [UInt16]
}
