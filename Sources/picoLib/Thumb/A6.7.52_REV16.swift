extension Thumb {
    // A6.7.52 REV16

    // Encoding T1
    // REV16 <Rd>,<Rm>
    // ARMv6-M, ARMv7-M
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 1  0  1  1| 1  0  1  0| 0  1|      Rm|      Rd|
    public struct REV16: CodableInstruction {
        public static var sig: [UInt16] = [0b1011_1010_0100_0000] // 0xba40
        public static var msk: [UInt16] = [0b1111_1111_1100_0000]

        let d: UInt16
        let m: UInt16

        public init(d: UInt16, m: UInt16) {
            self.d = d
            self.m = m
        }

        public func encode() -> [UInt16] {
            var low: UInt16 = Self.sig[0]
            set3(&low, d, 0)
            set3(&low, m, 3)
            return [low]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            let low = data[0]
            return Self(
                d: get3(low, 0),
                m: get3(low, 3)
            )
        }
    }
}

extension Thumb.REV16: CustomDebugStringConvertible {
    public var debugDescription: String {
        "REV16 r\(d), r\(m)"
    }
}
