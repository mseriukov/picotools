// A6.7.43 MSR (register)

// Encoding T1
// MSR <spec_reg>,<Rn>
// ARMv6-M Enhanced functionality in ARMv7-M
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 1  1  1  1  0| 0| 1  1  1  0| 0| 0|         Rn| 1  0| 0  0| 1  0  0  0|                   SYSm|
public struct MSR_Register: Instruction {
    public static var sig: [UInt16] = [0b1111_0011_1000_0000, 0b1000_1000_0000_0000] // 0xf380, 0x8800
    public static var msk: [UInt16] = [0b1111_1111_1111_0000, 0b1111_1111_0000_0000]
    
    let sysm: UInt16
    let n: UInt16

    public func encode() -> [UInt16] {
        var high: UInt16 = Self.sig[0]
        set4(&high, n, 0)

        var low: UInt16 = Self.sig[1]
        set8(&low, sysm, 0)
        return [high, low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let high = data[0]
        let low = data[1]
        return Self(
            sysm: get8(low, 0),
            n: get4(high, 0)
        )
    }
}

