public struct SVC: Instruction {
    enum Kind {
        case SVC(UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .SVC else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard case let .immediate(imm) = desc.arguments[0] else { throw InstructionError.unknownError }
        self.kind = .SVC(imm)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .SVC(imm):
            return Thumb.SVC(imm8: imm).encode()
        }
    }
}
