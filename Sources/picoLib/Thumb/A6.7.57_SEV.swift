extension Thumb {
    // A6.7.57 SEV

    // Encoding T1
    // SEV
    // ARMv6-M, ARMv7-M
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 1  0  1  1| 1  1  1  1| 0  1  0  0| 0  0  0  0|
    public struct SEV: CodableInstruction {
        public static var sig: [UInt16] = [0b1011_1111_0100_0000] // 0xbf40
        public static var msk: [UInt16] = [0b1111_1111_1111_1111]

        public init() { }

        public func encode() -> [UInt16] {
            [Self.sig[0]]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            return Self()
        }
    }
}

extension Thumb.SEV: CustomDebugStringConvertible {
    public var debugDescription: String {
        "SEV"
    }
}
