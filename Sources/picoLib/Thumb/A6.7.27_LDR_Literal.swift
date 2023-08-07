// A6.7.27 LDR (literal)

// Encoding T1
// LDR <Rt>,<label>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  1  0  0  1|      Rt|                   imm8|
public struct LDR_Literal: Instruction {
    public static var sig: [UInt16] = [0b0100_1000_0000_0000] // 0x4800
    public static var msk: [UInt16] = [0b1111_1000_0000_0000]

    let t: UInt16
    let offset: UInt16

    public init(t: UInt16, offset: UInt16) {
        self.t = t
        self.offset = offset
    }

    public func encode() -> [UInt16] {
        guard offset % 4 == 0 else { fatalError("LDR literal should have offset aligned by 4 bytes.") }
        let offset = offset >> 2
        var low: UInt16 = Self.sig[0]
        set8(&low, offset, 0)
        set3(&low, t, 8)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            t: get3(low, 8),
            offset: get8(low, 0) << 2
        )
    }
}

extension LDR_Literal: CustomDebugStringConvertible {
    public var debugDescription: String {
        "LDR r\(t), offset(\(offset)"
    }
}
