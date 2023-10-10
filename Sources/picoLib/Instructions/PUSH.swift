public struct PUSH: Instruction {
    enum Kind {
        case PUSH(UInt16)
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
            self.kind = .PUSH(list)
            return
        }
        throw InstructionError.unexpectedNumberOfArguments
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .PUSH(list):
            // TODO: Verify register range.
            return Thumb.PUSH(registerList: list, m: list & (1 << Register.lr.number) != 0).encode()
        }
    }
}

extension PUSH: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .PUSH(list):
            // TODO: Pretty print.
            return "\(desc.mnemonic.stringValue) \(list)"
        }
    }
}
