public struct LDM: Instruction {
    enum Kind {
        case LDM(Register, UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .LDM else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition(at: desc.startToken) }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier(at: desc.startToken) }

        guard desc.arguments.count == 2 else { throw ParserError.unexpectedNumberOfArguments(at: desc.startToken) }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError(at: desc.startToken) }
        guard case let .registerList(regList) = desc.arguments[1] else { throw ParserError.unexpectedError(at: desc.startToken) }
        self.kind = .LDM(r1, regList)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .LDM(r1, regList):
            return Thumb.LDM(n: r1.number, registerList: regList).encode()
        }
    }
}

extension LDM: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .LDM(r1, regList):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(regList)"
        }
    }
}
