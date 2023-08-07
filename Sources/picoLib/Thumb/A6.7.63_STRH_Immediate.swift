// A6.7.63 STRH (immediate)

// Encoding T1
// STRH <Rt>,[<Rn>{,#<imm5>}]
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 1  0  0  0| 0|          imm5|      Rn|      Rt|
public struct STRH_Immediate: Instruction {
    public static var sig: [UInt16] = [0b1000_0000_0000_0000] // 0x8000
    public static var msk: [UInt16] = [0b1111_1000_0000_0000]
    
    let t: UInt16
    let n: UInt16
    let imm5: UInt16

    public init(t: UInt16, n: UInt16, imm5: UInt16) {
        self.t = t
        self.n = n
        self.imm5 = imm5
    }

    public func encode() -> [UInt16] {
        guard imm5 % 2 == 0 else { fatalError("Immediate for STRH should be multiple of 2") }
        let imm5 = imm5 >> 1
        var low: UInt16 = Self.sig[0]
        set3(&low, t, 0)
        set3(&low, n, 3)
        set5(&low, imm5, 6)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            t: get3(low, 0),
            n: get3(low, 3),
            imm5: get5(low, 6) << 1
        )
    }
}

extension STRH_Immediate: CustomDebugStringConvertible {
    public var debugDescription: String {
        "STRH r\(t), [r\(n), #\(imm5)]"
    }
}
