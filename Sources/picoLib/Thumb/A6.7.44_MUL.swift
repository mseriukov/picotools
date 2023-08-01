// A6.7.44 MUL

// Encoding T1
// MULS <Rdm>,<Rn>,<Rdm>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  1  0  0  0  0| 1  1  0  1|      Rn|     Rdm|
public struct MUL: Instruction {
    public static var sig: [UInt16] = [0b0100_0011_0100_0000] // 0x4340
    public static var msk: [UInt16] = [0b1111_1111_1100_0000]
    
    let n: UInt16
    let dm: UInt16

    public func encode() -> [UInt16] {
        var low: UInt16 = Self.sig[0]
        set3(&low, n, 3)
        set3(&low, dm, 0)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            n: get3(low, 3),
            dm: get3(low, 0)
        )
    }
}
