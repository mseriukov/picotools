extension Thumb {
    // A6.7.19 CPS

    // Encoding T1
    // CPS<effect> i
    // ARMv6-M, ARMv7-M
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 1  0  1  1| 0  1  1  0| 0  1  1|im| 0  0  1  0|
    // No additional decoding required
    public struct CPS: CodableInstruction {
        public static var sig: [UInt16] = [0b1011_0110_0110_0010] // 0xB662
        public static var msk: [UInt16] = [0b1111_1111_1110_1111]

        let ie: Bool

        public init(ie: Bool) {
            self.ie = ie
        }

        public func encode() -> [UInt16] {
            var low: UInt16 = Self.sig[0]
            writeBit(&low, !ie, 4)
            return [low]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            let low = data[0]
            return Self(
                ie: !bitSet(low, 4)
            )
        }
    }
}

extension Thumb.CPS: CustomDebugStringConvertible {
    public var debugDescription: String {
        "CPS \(ie)"
    }
}
