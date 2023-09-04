public struct SVC: Instruction {
    enum Kind {
        case SVC(UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .SVC else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        guard case let .immediate(imm) = desc.arguments[0] else { throw ParserError.unexpectedError(at: desc.startToken) }
        self.kind = .SVC(imm)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .SVC(imm):
            return Thumb.SVC(imm8: imm).encode()
        }
    }
}
