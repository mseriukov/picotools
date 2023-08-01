// A6.7.7 AND (register)

// Encoding T1
// ANDS <Rdn>,<Rm>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  1  0  0  0  0| 0  0  0  0|      Rm|     Rdn|
public struct AND_Register: Instruction {
    public static var sig: [UInt16] = [0b0100_0000_0000_0000] // 0x4000
    public static var msk: [UInt16] = [0b1111_1111_1100_0000]

    let dn: UInt16
    let m: UInt16

    public func encode() -> [UInt16] {
        var low: UInt16 = Self.sig[0]
        set3(&low, dn, 0)
        set3(&low, m, 3)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            dn: get3(low, 0),
            m: get3(low, 3)
        )
    }
}
