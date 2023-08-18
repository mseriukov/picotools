// A6.7.22 DSB

// Encoding T1
// DSB #<option>
// ARMv6-M, ARMv7-M
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 1  1  1  1  0| 0| 1  1  1| 0  1| 1| 1  1  1  1| 1  0| 0  0| 1  1  1  1| 0  1  0  0|     option|
public struct DSB: CodableInstruction {
    public static var sig: [UInt16] = [0b1111_0011_1011_1111, 0b1000_1111_0100_0000] // 0xf3bf, 0x8f40
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

extension DSB: CustomDebugStringConvertible {
    public var debugDescription: String {
        "DSB #\(option)"
    }
}
