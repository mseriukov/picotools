extension Thumb {
    // A6.7.40 MOV (register)

    // Encoding T1
    // MOV <Rd>,<Rm>
    // ARMv6-M, ARMv7-M, if <Rd> and <Rm> both from R0-R7. Otherwise all versions of the Thumb instruction set.
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 0  1  0  0  0  1| 1  0| D|         Rm|      Rd|
    public struct MOV_Register_T1: CodableInstruction {
        public static var sig: [UInt16] = [0b0100_0110_0000_0000] // 0x4600
        public static var msk: [UInt16] = [0b1111_1111_0000_0000]

        let d: UInt16
        let m: UInt16

        public init(d: UInt16, m: UInt16) {
            self.d = d
            self.m = m
        }

        public func encode() -> [UInt16] {
            var low: UInt16 =  Self.sig[0]
            set2reg4(&low, r1: m, r2: d)
            return [low]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            let low = data[0]
            let split = get2reg4(low)
            return Self(
                d: split.r2,
                m: split.r1
            )
        }
    }

    // Encoding T2
    // MOVS <Rd>,<Rm>
    // All versions of the Thumb instruction set.
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 0  0  0| 0  0| 0  0  0  0  0|      Rm|      Rd|
    public struct MOV_Register_T2: CodableInstruction {
        public static var sig: [UInt16] = [0b0000_0000_0000_0000] // 0x0000
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

extension Thumb.MOV_Register_T1: CustomDebugStringConvertible {
    public var debugDescription: String {
        "MOV r\(d), r\(m)"
    }
}

extension Thumb.MOV_Register_T2: CustomDebugStringConvertible {
    public var debugDescription: String {
        "MOVS r\(d), r\(m)"
    }
}
