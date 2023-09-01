public protocol Instruction {
    func encode(symbols: [String: Int]) throws -> [UInt16]
}
