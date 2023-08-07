// A6.7.37 LSR (immediate)

// Encoding T1
// LSRS <Rd>,<Rm>,#<imm5>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  0  0| 0  1|          Imm5|      Rm|      Rd|
public struct LSR_Immediate: Instruction {
    public static var sig: [UInt16] = [0b0000_1000_0000_0000] // 0x0800
    public static var msk: [UInt16] = [0b1111_1000_0000_0000]
    
    let d: UInt16
    let m: UInt16
    let imm5: UInt16

    public init(d: UInt16, m: UInt16, imm5: UInt16) {
        self.d = d
        self.m = m
        self.imm5 = imm5
    }

    public func encode() -> [UInt16] {
        var low: UInt16 = Self.sig[0]
        set3(&low, d, 0)
        set3(&low, m, 3)
        set5(&low, imm5, 6)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            d: get3(low, 0),
            m: get3(low, 3),
            imm5: get5(low, 6)
        )
    }
}

extension LSR_Immediate: CustomDebugStringConvertible {
    public var debugDescription: String {
        "LSRS r\(d), r\(m), #\(imm5)"
    }
}
