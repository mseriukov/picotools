public struct DSB: Instruction {
    enum Kind {
        case DSB(UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .DSB else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard desc.arguments.count == 1 else { throw InstructionError.unexpectedNumberOfArguments }

        guard case let .immediate(opt) = desc.arguments[0] else { throw InstructionError.unknownError }
        self.kind = .DSB(opt)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .DSB(opt):
            return Thumb.DSB(option: opt).encode()
        }
    }
}

extension DSB: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .DSB(opt):
            return "\(desc.mnemonic.stringValue) #\(opt)"
        }
    }
}
