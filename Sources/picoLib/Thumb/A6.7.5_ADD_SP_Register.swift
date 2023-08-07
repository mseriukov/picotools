// A6.7.5 ADD (SP plus register)
//
// This instruction adds a register value to the SP value, and writes the result to the destination register.
//
// Encoding T1
// ADD <Rdm>, SP, <Rdm>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  1  0  0  0  1  0  0|DM| 1  1  0  1|     Rdm|
public struct ADD_SP_Register_T1: Instruction {
    public static var sig: [UInt16] = [0b0100_0100_0110_1000] // 0x4468
    public static var msk: [UInt16] = [0b1111_1111_0111_1000]

    let m: UInt16

    public init(m: UInt16) {
        self.m = m
    }

    public func encode() -> [UInt16] {
        ADD_Register_T2(dn: m, m: 13).encode()
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let inst = ADD_Register_T2.decode(data)
        return ADD_SP_Register_T1(
            m: inst.dn
        )
    }
}

extension ADD_SP_Register_T1: CustomDebugStringConvertible {
    public var debugDescription: String {
        "ADD r\(m), SP, r\(m)"
    }
}

// Encoding T2
// ADD SP,<Rm>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  1  0  0  0  1  0  0| 1|         Rm| 1  0  1|
public struct ADD_SP_Register_T2: Instruction {
    public static var sig: [UInt16] = [0b0100_0100_1000_0101] // 0x4485
    public static var msk: [UInt16] = [0b1111_1111_1000_0111]

    let m: UInt16

    public init(m: UInt16) {
        self.m = m
    }

    public func encode() -> [UInt16] {
        ADD_Register_T2(dn: 13, m: m).encode()
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let inst = ADD_Register_T2.decode(data)
        return Self(
            m: inst.m
        )
    }
}

extension ADD_SP_Register_T2: CustomDebugStringConvertible {
    public var debugDescription: String {
        "ADD SP, r\(m)"
    }
}
