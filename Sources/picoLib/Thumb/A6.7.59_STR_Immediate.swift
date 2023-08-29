extension Thumb {
    // A6.7.59 STR (immediate)

    // Encoding T1
    // STR <Rt>, [<Rn>{,#<imm5>}]
    // All versions of the Thumb instruction set.
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 0  1  1| 0| 0|          imm5|      Rn|      Rt|
    public struct STR_Immediate_T1: CodableInstruction {
        public static var sig: [UInt16] = [0b0110_0000_0000_0000] // 0x6000
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
            guard imm5 % 4 == 0 else { fatalError("STR immediate should be 4 bytes aligned.") }
            let imm5 = imm5 >> 2
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
                imm5: get5(low, 6) << 2
            )
        }
    }

    // Encoding T2
    // STR <Rt>,[SP,#<imm8>]
    // All versions of the Thumb instruction set.
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 1  0  0  1| 0|      Rt|                   imm8|
    struct STR_Immediate_T2: CodableInstruction {
        public static var sig: [UInt16] = [0b1001_0000_0000_0000] // 0x9000
        public static var msk: [UInt16] = [0b1111_1000_0000_0000]

        let t: UInt16
        let imm8: UInt16

        public init(t: UInt16, imm8: UInt16) {
            self.t = t
            self.imm8 = imm8
        }

        public func encode() -> [UInt16] {
            guard imm8 % 4 == 0 else { fatalError("STR immediate should be 4 bytes aligned.") }
            let imm8 = imm8 >> 2
            var low: UInt16 = Self.sig[0]
            set3(&low, t, 8)
            set8(&low, imm8, 0)
            return [low]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            let low = data[0]
            return Self(
                t: get3(low, 8),
                imm8: get8(low, 0) << 2
            )
        }
    }
}

extension Thumb.STR_Immediate_T1: CustomDebugStringConvertible {
    public var debugDescription: String {
        "STR r\(t), [r\(n), #\(imm5)]"
    }
}

extension Thumb.STR_Immediate_T2: CustomDebugStringConvertible {
    public var debugDescription: String {
        "STR r\(t), [SP, #\(imm8)]"
    }
}
