extension Thumb {
    // A6.7.4 ADD (SP plus immediate)

    // Encoding T1
    // ADD <Rd>,SP,#<imm8>
    // All versions of the Thumb instruction set.
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 1  0  1  0| 1|      Rd|                   imm8|
    public struct ADD_SP_Immediate_T1: CodableInstruction {
        public var debugDescription: String {""}
        public static var sig: [UInt16] = [0b1010_1000_0000_0000] // 0x4400
        public static var msk: [UInt16] = [0b1111_1000_0000_0000]

        let d: UInt16
        let imm8: UInt16

        public init(d: UInt16, imm8: UInt16) {
            self.d = d
            self.imm8 = imm8
        }

        public func encode() -> [UInt16] {
            guard imm8 % 4 == 0 else { fatalError("Immediate should be 4 bytes aligned.") }
            let imm8 = imm8 / 4

            var low: UInt16 = Self.sig[0]
            set3(&low, d, 8)
            set8(&low, imm8, 0)
            return [low]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            let low = data[0]
            return ADD_SP_Immediate_T1(
                d: get3(low, 8),
                imm8: get8(low, 0) * 4
            )
        }
    }

    // Encoding T2
    // ADD SP,SP,#<imm7>
    // All versions of the Thumb instruction set.
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 1  0  1  1| 0  0  0  0| 0|                imm7|
    public struct ADD_SP_Immediate_T2: CodableInstruction {
        public var debugDescription: String {""}
        public static var sig: [UInt16] = [0b1011_0000_0000_0000] // 0x4400
        public static var msk: [UInt16] = [0b1111_1111_1000_0000]

        let imm7: UInt16

        public init(imm7: UInt16) {
            self.imm7 = imm7
        }

        public func encode() -> [UInt16] {
            guard imm7 % 4 == 0 else { fatalError("Immediate should be 4 bytes aligned.") }
            let imm7 = imm7 / 4

            var low: UInt16 = Self.sig[0]
            set7(&low, imm7, 0)
            return [low]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            let low = data[0]
            return Self(
                imm7: get7(low, 0) * 4
            )
        }
    }
}
