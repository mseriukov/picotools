public struct STM: Instruction {
    enum Kind {
        case STM(Register, UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .STM else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        guard desc.arguments.count == 2 else { throw ParserError.unexpectedNumberOfArguments(at: desc.startToken) }
        guard case let .register(r) = desc.arguments[0] else { throw ParserError.unexpectedError(at: desc.startToken) }
        guard case let .registerList(list) = desc.arguments[1] else { throw ParserError.unexpectedError(at: desc.startToken) }
        self.kind = .STM(r, list)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .STM(r, regList):
            return Thumb.STM(n: r.number, registerList: regList).encode()
        }
    }
}

extension STM: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .STM(r1, regList):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(regList)"
        }
    }
}
