// A6.7.21 DMB

// Encoding T1
// DMB #<option>
// ARMv6-M, ARMv7-M
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 1  1  1  1  0| 0| 1  1  1| 0  1| 1| 1  1  1  1| 1  0| 0  0| 1  1  1  1| 0  1  0  1|     option|
public struct DMB: CodableInstruction {
    public static var sig: [UInt16] = [0b1111_0011_1011_1111, 0b1000_1111_0101_0000] // 0xf3bf, 0x8f50
    public static var msk: [UInt16] = [0b1111_1111_1111_1111, 0b1111_1111_1111_0000]

    let option: UInt16

    public init(option: UInt16) {
        self.option = option
    }

    public func encode() -> [UInt16] {
        let high: UInt16 = Self.sig[0]
        var low: UInt16 = Self.sig[1]
        set4(&low, option, 0)
        return [high, low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[1]

        return Self(
            option: get4(low, 0)
        )
    }
}

extension DMB: CustomDebugStringConvertible {
    public var debugDescription: String {
        "DMB #\(option)"
    }
}
