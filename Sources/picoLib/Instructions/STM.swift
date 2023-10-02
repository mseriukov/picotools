public struct STM: Instruction {
    enum Kind {
        case STM(Register, UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .STM else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }
        
        if desc.arguments.count == 2 {
            guard case let .register(r) = desc.arguments[0] else { throw InstructionError.registerExpected(0) }
            guard case let .registerList(list) = desc.arguments[1] else { throw InstructionError.registerListExpected(1) }
            self.kind = .STM(r, list)
            return
        }

        throw InstructionError.unexpectedNumberOfArguments
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
