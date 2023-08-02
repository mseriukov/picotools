// A6.7.14 BLX (register)

// Encoding T1
// BLX <Rm>
// ARMv5T*, ARMv6-M, ARMv7-M
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  1  0  0  0  1| 1  1| 1|         Rm| 0  0  0|
public struct BLX: Instruction {
    public static var sig: [UInt16] = [0b0100_0111_1000_0000] // 0x4780
    public static var msk: [UInt16] = [0b1111_1111_1000_0111]

    let m: UInt16

    public init(m: UInt16) {
        self.m = m
    }

    public func encode() -> [UInt16] {
        var low: UInt16 = Self.sig[0]
        set4(&low, m, 3)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            m: get4(low, 3)
        )
    }
}
