// A6.7.71 TST (register)

// Encoding T1
// TST <Rn>,<Rm>
// ARMv6-M, ARMv7-M
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  1  0  0  0  0| 1  0  0  0|      Rm|      Rn|
public struct TST_Register: Instruction {
    public static var sig: [UInt16] = [0b0100_0010_0000_0000] // 0x4200
    public static var msk: [UInt16] = [0b1111_1111_1100_0000]
    
    let n: UInt16
    let m: UInt16

    public func encode() -> [UInt16] {
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

