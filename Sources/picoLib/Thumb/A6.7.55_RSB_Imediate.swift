// A6.7.55 RSB (immediate)

// Encoding T1
// RSBS <Rd>,<Rn>,#0
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  1  0  0  0  0| 1  0  0  1|      Rn|      Rd|
public struct RSB_Immediate: Instruction {
    public static var sig: [UInt16] = [0b0100_0010_0100_0000] // 0x4240
    public static var msk: [UInt16] = [0b1111_1111_1100_0000]
    
    let d: UInt16
    let n: UInt16

    public init(d: UInt16, n: UInt16) {
        self.d = d
        self.n = n
    }

    public func encode() -> [UInt16] {
        var low: UInt16 = Self.sig[0]
        set3(&low, d, 0)
        set3(&low, n, 3)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            d: get3(low, 0),
            n: get3(low, 3)
        )
    }
}
