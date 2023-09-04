public struct DSB: Instruction {
    enum Kind {
        case DSB(UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .DSB else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        guard desc.arguments.count == 1 else { throw ParserError.unexpectedNumberOfArguments(at: desc.startToken) }

        guard case let .immediate(opt) = desc.arguments[0] else { throw ParserError.unexpectedError(at: desc.startToken) }
        self.kind = .DSB(opt)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .DSB(opt):
            return Thumb.DSB(option: opt).encode()
        }
    }
}
