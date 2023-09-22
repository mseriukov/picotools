public struct DMB: Instruction {
    enum Kind {
        case DMB(UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .DMB else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        if desc.arguments.count == 1 {
            guard case let .immediate(opt) = desc.arguments[0] else { throw InstructionError.immediateExpected(0) }
            self.kind = .DMB(opt)
            return
        }
        throw InstructionError.unexpectedNumberOfArguments
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .DMB(opt):
            return Thumb.DMB(option: opt).encode()
        }
    }
}

extension DMB: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .DMB(opt):
            return "\(desc.mnemonic.stringValue) #\(opt)"
        }
    }
}
