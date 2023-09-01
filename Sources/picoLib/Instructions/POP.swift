public struct POP: Instruction {
    enum Kind {
        case POP(UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .PUSH else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        guard desc.arguments.count == 1 else { throw ParserError.unexpectedNumberOfArguments }
        guard case let .registerList(list) = desc.arguments[0] else { throw ParserError.unexpectedError }

        self.kind = .POP(list)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .POP(list):
            // TODO: Verify register range.
            return Thumb.POP(registerList: list, p: list & (1 << Register.lr.number) != 0).encode()
        }
    }
}

extension POP: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .POP(list):
            // TODO: Pretty print.
            return "\(desc.mnemonic.stringValue) \(list)"
        }
    }
}
