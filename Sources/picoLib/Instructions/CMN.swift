public struct CMN: Instruction {
    enum Kind {
        case CMN(Register, Register)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .CMN else { fatalError("Mnemonic doesn't match the expected one.") }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard desc.arguments.count == 2 else { throw InstructionError.unexpectedNumberOfArguments }
        guard case let .register(r1) = desc.arguments[0] else { throw InstructionError.unknownError }
        guard case let .register(r2) = desc.arguments[1] else { throw InstructionError.unknownError }
        self.kind = .CMN(r1, r2)
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .CMN(r1, r2):
            return Thumb.CMN_Register(n: r1.number, m: r2.number).encode()
        }
    }
}
