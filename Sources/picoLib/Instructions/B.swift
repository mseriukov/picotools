public struct B: Instruction {
    enum Kind {
        case B_T1(String)
        case B_T2(String)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .B else { throw InstructionError.mnemonicMismatch }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }
        let condition = desc.condition ?? .always


        guard desc.arguments.count == 1 else { throw InstructionError.unexpectedNumberOfArguments }
        guard case let .label(lit) = desc.arguments[0] else { throw InstructionError.unknownError }

        if condition == .always {
            self.kind = .B_T2(lit)
        } else {
            self.kind = .B_T1(lit)
        }
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .B_T1(literal):
            guard let offset = symbols[literal] else { throw InstructionError.undefinedLiteral(literal) }
            return Thumb.B_T1(cond: UInt16((desc.condition ?? .always).rawValue), imm8: Int16(offset)).encode()

        case let .B_T2(literal):
            guard let offset = symbols[literal] else { throw InstructionError.undefinedLiteral(literal) }
            return Thumb.B_T2(imm11: Int16(offset)).encode()
        }
    }
}

extension B: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .B_T1(lit):
            return "\(desc.mnemonic.stringValue)\((desc.condition ?? .always).stringValue) \(lit)"
        case let .B_T2(lit):
            return "\(desc.mnemonic.stringValue)\((desc.condition ?? .always).stringValue) \(lit)"
        }
    }
}
