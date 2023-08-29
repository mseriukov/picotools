public struct DMB: Instruction {
    enum Kind {
        case DMB(UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .DMB else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        guard case let .immediate(opt) = desc.arguments[0] else { throw ParserError.unexpectedError }
        self.kind = .DMB(opt)
    }

    public func encode(symbols: [String: UInt16]) throws -> [UInt16] {
        switch kind {
        case let .DMB(opt):
            return Thumb.DMB(option: opt).encode()
        }
    }
}
