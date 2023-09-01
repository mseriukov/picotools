public struct MRS: Instruction {
    enum Kind {
        case MRS(Register, SpecialRegister)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .MRS else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw ParserError.unexpectedCondition }
        guard desc.qualifier == nil else { throw ParserError.unexpectedQualifier }

        guard desc.arguments.count == 2 else { throw ParserError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw ParserError.unexpectedError }
        guard case let .specialRegister(r2) = desc.arguments[1] else { throw ParserError.unexpectedError }
        self.kind = .MRS(r1, r2)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .MRS(r1, r2):
            return Thumb.MRS(d: r1.number, sysm: r2.number).encode()
        }
    }
}

extension MRS: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .MRS(r1, r2):
            return "\(desc.mnemonic.stringValue) \(r1.rawValue), \(r2.rawValue)"
        }
    }
}
