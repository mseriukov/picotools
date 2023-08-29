extension Thumb {
    // A6.7.29 LDRB (immediate)

    // Encoding T1
    // LDRB <Rt>,[<Rn>{,#<imm5>}]
    // All versions of the Thumb instruction set.
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 0  1  1| 1| 1|          imm5|      Rn|      Rt|
    public struct LDRB_Immediate: CodableInstruction {
        public static var sig: [UInt16] = [0b0111_1000_0000_0000] // 0x7800
        public static var msk: [UInt16] = [0b1111_1000_0000_0000]

        let t: UInt16
        let n: UInt16
        let imm5: UInt16

        public init(t: UInt16, n: UInt16, imm5: UInt16) {
            self.t = t
            self.n = n
            self.imm5 = imm5
        }

        public func encode() -> [UInt16] {
            var low: UInt16 = Self.sig[0]
            set3(&low, t, 0)
            set3(&low, n, 3)
            set5(&low, imm5, 6)
            return [low]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            let low = data[0]
            return Self(
                t: get3(low, 0),
                n: get3(low, 3),
                imm5: get5(low, 6)
            )
        }
    }
}

extension Thumb.LDRB_Immediate: CustomDebugStringConvertible {
    public var debugDescription: String {
        "LDRB r\(t), [r\(n), #\(imm5)]"
    }
}
