// A6.7.3 ADD (register)

// Encoding T1
// ADDS <Rd>,<Rn>,<Rm>
// ARMv6-M, ARMv7-M, if <Rd> and <Rm> both from R0-R7. Otherwise all versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  0  0| 1  1| 0| 0|      Rm|      Rn|      Rd|
public struct ADD_Register_T1: Instruction {
    public static var sig: [UInt16] = [0b0001_1000_0000_0000] // 0x1800
    public static var msk: [UInt16] = [0b1111_1000_0000_0000]

    let d: UInt16
    let n: UInt16
    let m: UInt16

    public init(d: UInt16, n: UInt16, m: UInt16) {
        self.d = d
        self.n = n
        self.m = m
    }

    public func encode() -> [UInt16] {
        var low: UInt16 = Self.sig[0]
        set3(&low, d, 0)
        set3(&low, n, 3)
        set3(&low, m, 6)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return ADD_Register_T1(
            d: get3(low, 0),
            n: get3(low, 3),
            m: get3(low, 6)
        )
    }
}

// Encoding T2
// ADD <Rdn>,<Rm>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  1  0  0  0  1| 0  0|dn|         Rm|     Rdn|
public struct ADD_Register_T2: Instruction {
    public static var sig: [UInt16] = [0b0100_0100_0000_0000] // 0x4400
    public static var msk: [UInt16] = [0b1111_1111_0000_0000]

    let dn: UInt16
    let m: UInt16

    public init(dn: UInt16, m: UInt16) {
        self.dn = dn
        self.m = m
    }

    public func encode() -> [UInt16] {
        var low: UInt16 = Self.sig[0]
        set2reg4(&low, r1: m, r2: dn)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        let split = get2reg4(low)
        return Self(
            dn: split.r2,
            m: split.r1
        )
    }
}
