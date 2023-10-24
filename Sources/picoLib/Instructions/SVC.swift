public struct SVC: Instruction {
    enum Kind {
        case SVC(UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .SVC else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        if desc.arguments.count == 1 {
            guard case let .immediate(imm) = desc.arguments[0] else { throw InstructionError.immediateExpected(0) }
            self.kind = .SVC(imm)
            return
        }
        throw InstructionError.unexpectedNumberOfArguments
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .SVC(imm):
            return Thumb.SVC(imm8: imm).encode()
        }
    }
}

extension SVC: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .SVC(imm):
            return "\(desc.mnemonic.stringValue) #\(imm)"
        }
    }
}
