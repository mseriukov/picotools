// A6.7.15 BX

// Encoding T1
// BX <Rm>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  1  0  0  0  1| 1  1| 0|         Rm| 0  0  0|
public struct BX: CodableInstruction {
    public static var sig: [UInt16] = [0b0100_0111_0000_0000] // 0x4700
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

extension BX: CustomDebugStringConvertible {
    public var debugDescription: String {
        "BX r\(m)"
    }
}
