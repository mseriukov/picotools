extension Thumb {
    // A6.7.42 MRS

    // Encoding T1
    // MRS <Rd>,<spec_reg>
    // ARMv6-M Enhanced functionality in ARMv7-M
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 1  1  1  1  0| 0| 1  1  1  1| 1| 0| 1  1  1  1| 1  0| 0  0|         Rd|                   SYSm|
    public struct MRS: CodableInstruction {
        public static var sig: [UInt16] = [0b1111_0011_1110_1111, 0b1000_0000_0000_0000] // 0xf3ef, 0x8000
        public static var msk: [UInt16] = [0b1111_1111_1111_1111, 0b1111_0000_0000_0000]

        let d: UInt16
        let sysm: UInt16

        public init(d: UInt16, sysm: UInt16) {
            self.d = d
            self.sysm = sysm
        }

        public func encode() -> [UInt16] {
            let high = Self.sig[0]
            var low: UInt16 = Self.sig[1]
            set4(&low, d, 8)
            set8(&low, sysm, 0)
            return [high, low]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            let low = data[1]
            return Self(
                d: get4(low, 8),
                sysm: get8(low, 0)
            )
        }
    }
}

extension Thumb.MRS: CustomDebugStringConvertible {
    public var debugDescription: String {
        "MRS r\(d), sysm(\(sysm))"
    }
}
