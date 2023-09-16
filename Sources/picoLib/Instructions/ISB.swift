public struct ISB: Instruction {
    enum Kind {
        case ISB(UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .ISB else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        if desc.arguments.count == 1 {
            guard case let .immediate(opt) = desc.arguments[0] else { throw InstructionError.immediateExpected(0) }
            self.kind = .ISB(opt)
            return
        }
        throw InstructionError.unexpectedNumberOfArguments
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .ISB(opt):
            return Thumb.ISB(option: opt).encode()
        }
    }
}

extension ISB: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .ISB(opt):
            return "\(desc.mnemonic.stringValue) #\(opt)"
        }
    }
}
