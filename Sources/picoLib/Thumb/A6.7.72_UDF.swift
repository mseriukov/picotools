extension Thumb {
    // A6.7.72 UDF

    // Encoding T1
    // UDF #<imm8>
    // All versions of the Thumb instruction set.
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 1  1  0  1| 1  1  1  0|                   imm8|
    public struct UDF_T1: CodableInstruction {
        public static var sig: [UInt16] = [0b1101_1110_0000_0000] // 0xDE00
        public static var msk: [UInt16] = [0b1111_1111_0000_0000]

        let imm8: UInt16

        public init(imm8: UInt16) {
            self.imm8 = imm8
        }

        public func encode() -> [UInt16] {
            var low: UInt16 = Self.sig[0]
            set8(&low, imm8, 0)
            return [low]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            let low = data[0]
            return Self(
                imm8: get8(low, 0)
            )
        }
    }

    // Encoding T2
    // UDF.W #<imm16>
    // ARMv6-M, ARMv7-M
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 1  1  1| 1  0| 1  1  1  1  1  1  1|       imm4| 1| 0  1  0|                              imm12|
    public struct UDF_T2: CodableInstruction {
        public static var sig: [UInt16] = [0b1111_0111_1111_0000, 0b1010_0000_0000_0000] // 0xf7f0, 0xa000
        public static var msk: [UInt16] = [0b1111_1111_1111_0000, 0b1111_0000_0000_0000]

        let imm16: UInt16

        public init(imm16: UInt16) {
            self.imm16 = imm16
        }

        public func encode() -> [UInt16] {
            var high: UInt16 = Self.sig[0]
            set4(&high, (imm16 & 0xf000) >> 12, 0)

            var low: UInt16 = Self.sig[1]
            set12(&low, imm16 & 0x0fff, 0)
            return [high, low]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            let high = data[0]
            let low = data[1]

            var imm16: UInt16 = 0x0000
            imm16 |= get4(high, 0) << 12
            imm16 |= get12(low, 0)

            return Self(
                imm16: imm16
            )
        }
    }
}

extension Thumb.UDF_T1: CustomDebugStringConvertible {
    public var debugDescription: String {
        "UDF #\(imm8)"
    }
}

extension Thumb.UDF_T2: CustomDebugStringConvertible {
    public var debugDescription: String {
        "UDF #\(imm16)"
    }
}
