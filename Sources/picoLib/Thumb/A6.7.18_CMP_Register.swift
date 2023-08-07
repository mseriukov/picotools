// A6.7.18 CMP (register)

// Encoding T1
// CMP <Rn>,<Rm>        <Rn> and <Rm> both from R0-R7
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  1  0  0  0  0| 1  0  1  0|      Rm|      Rn|
public struct CMP_Register_T1: Instruction {
    public static var sig: [UInt16] = [0b0100_0010_1000_0000] // 0x4280
    public static var msk: [UInt16] = [0b1111_1111_1100_0000]

    let n: UInt16
    let m: UInt16

    public init(n: UInt16, m: UInt16) {
        self.n = n
        self.m = m
    }

    public func encode() -> [UInt16] {
        guard n < 8 && m < 8 else { fatalError("<Rn> and <Rm> should be both from r0-r7 for CMP T1 encoding.") }
        var low: UInt16 = Self.sig[0]
        set3(&low, n, 0)
        set3(&low, m, 3)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            n: get3(low, 0),
            m: get3(low, 3)
        )
    }
}

extension CMP_Register_T1: CustomDebugStringConvertible {
    public var debugDescription: String {
        "CMP r\(n), r\(m)"
    }
}

// Encoding T2
// CMP <Rn>,<Rm>        <Rn> and <Rm> not both from R0-R7
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  1  0  0  0  1| 0  1| N|         Rm|      Rn|
public struct CMP_Register_T2: Instruction {
    public static var sig: [UInt16] = [0b0100_0101_0000_0000] // 0x4500
    public static var msk: [UInt16] = [0b1111_1111_0000_0000]

    let n: UInt16
    let m: UInt16

    public init(n: UInt16, m: UInt16) {
        self.n = n
        self.m = m
    }

    public func encode() -> [UInt16] {
        guard n >= 8 || m >= 8 else { fatalError("<Rn> and <Rm> should be not both from r0-r7 for CMP T1 encoding.") }
        var low: UInt16 = Self.sig[0]
        set2reg4(&low, r1: m, r2: n)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        let split = get2reg4(low)
        return Self(
            n: split.r2,
            m: split.r1
        )
    }
}

extension CMP_Register_T2: CustomDebugStringConvertible {
    public var debugDescription: String {
        "CMP r\(n), r\(m)"
    }
}
