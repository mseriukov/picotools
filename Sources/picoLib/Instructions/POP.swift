public struct POP: Instruction {
    enum Kind {
        case POP(UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .PUSH else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        if desc.arguments.count == 1 {
            guard case let .registerList(list) = desc.arguments[0] else { throw InstructionError.registerListExpected(0) }
            self.kind = .POP(list)
            return
        }
        throw InstructionError.unexpectedNumberOfArguments
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
