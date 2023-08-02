// A6.7.64 STRH (register)

// Encoding T1
// STRH <Rt>,[<Rn>,<Rm>]
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  1  0  1| 0  0  1|      Rm|      Rn|      Rt|
public struct STRH_Register: Instruction {
    public static var sig: [UInt16] = [0b0101_0010_0000_0000] // 0x5200
    public static var msk: [UInt16] = [0b1111_1110_0000_0000]
    
    let t: UInt16
    let n: UInt16
    let m: UInt16

    public init(t: UInt16, n: UInt16, m: UInt16) {
        self.t = t
        self.n = n
        self.m = m
    }

    public func encode() -> [UInt16] {
        var low: UInt16 = Self.sig[0]
        set3(&low, t, 0)
        set3(&low, n, 3)
        set3(&low, m, 6)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            t: get3(low, 0),
            n: get3(low, 3),
            m: get3(low, 6)
        )
    }
}
