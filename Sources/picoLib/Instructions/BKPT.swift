public struct BKPT: Instruction {
    enum Kind {
        case BKPT(UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .BKPT else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        guard desc.arguments.count == 1 else { throw ParserError.unexpectedNumberOfArguments(at: desc.startToken) }

        if case let .immediate(imm) = desc.arguments[0] {
            self.kind = .BKPT(imm)
            return
        }
        if case let .number(imm) = desc.arguments[0] {
            self.kind = .BKPT(UInt16(imm))
            return
        }
        throw ParserError.unexpectedError(at: desc.startToken)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .BKPT(imm):
            return Thumb.BKPT(imm8: imm).encode()
        }
    }
}

extension BKPT: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .BKPT(imm):
            return "\(desc.mnemonic.stringValue) #\(imm)"
        }
    }
}
