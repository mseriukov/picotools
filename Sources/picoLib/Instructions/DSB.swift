public struct DSB: Instruction {
    enum Kind {
        case DSB(UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .DSB else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        guard case let .immediate(opt) = desc.arguments[0] else { throw ParserError.unexpectedError }
        self.kind = .DSB(opt)
    }

    public func encode(symbols: [String: UInt16]) throws -> [UInt16] {
        switch kind {
        case let .DSB(opt):
            return Thumb.DSB(option: opt).encode()
        }
    }
}
