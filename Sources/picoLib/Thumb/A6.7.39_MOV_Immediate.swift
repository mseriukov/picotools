extension Thumb {
    // A6.7.39 MOV (immediate)

    // Encoding T1
    // MOVS <Rd>,#<imm8>
    // All versions of the Thumb instruction set.
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 0  0  1| 0  0|      Rd|                   imm8|
    public struct MOV_Immediate: CodableInstruction {
        public static var sig: [UInt16] = [0b0010_0000_0000_0000] // 0x2000
        public static var msk: [UInt16] = [0b1111_1000_0000_0000]

        let d: UInt16
        let imm8: UInt16

        public init(d: UInt16, imm8: UInt16) {
            self.d = d
            self.imm8 = imm8
        }

        public func encode() -> [UInt16] {
            var low: UInt16 = Self.sig[0]
            set3(&low, d, 8)
            set8(&low, imm8, 0)
            return [low]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            let low = data[0]
            return Self(
                d: get3(low, 8),
                imm8: get8(low, 0)
            )
        }
    }
}

extension Thumb.MOV_Immediate: CustomDebugStringConvertible {
    public var debugDescription: String {
        "MOVS r\(d), #\(imm8)"
    }
}
