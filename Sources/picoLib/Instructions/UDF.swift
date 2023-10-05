public struct UDF: Instruction {
    enum Kind {
        case UDF_T1(UInt16)
        case UDF_T2(UInt16)
    }
    private let kind: Kind
    private let desc: InstructionDescriptor

    public init(_ desc: InstructionDescriptor) throws {
        self.desc = desc
        guard desc.mnemonic == .UDF else { throw InstructionError.mnemonicMismatch }
        guard desc.condition == nil else { throw InstructionError.unexpectedCondition }
        guard desc.qualifier == nil else { throw InstructionError.unexpectedQualifier }

        guard case let .immediate(imm) = desc.arguments[0] else { throw InstructionError.unknownError }
        let uimm = UInt16(imm)
        if uimm < 256 {
            self.kind = .UDF_T1(uimm)
        } else {
            self.kind = .UDF_T2(uimm)
        }
    }

    public func encode(symbols: [String: Int]) throws -> [UInt16] {
        switch kind {
        case let .UDF_T1(imm):
            return Thumb.UDF_T1(imm8: imm).encode()
        case let .UDF_T2(imm):
            return Thumb.UDF_T2(imm16: imm).encode()
        }
    }
}

extension UDF: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch kind {
        case let .UDF_T1(imm):
            return "\(desc.mnemonic.stringValue) #\(imm)"
        case let .UDF_T2(imm):
            return "\(desc.mnemonic.stringValue) #\(imm)"
        }
    }
}
