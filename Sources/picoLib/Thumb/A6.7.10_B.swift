extension Thumb {
    // A6.7.10 B

    // Encoding T1
    // B<c> <label>
    // All versions of the Thumb instruction set.
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 1  1  0  1|       cond|                   imm8|
    public struct B_T1: CodableInstruction {
        public static var sig: [UInt16] = [0b1101_0000_0000_0000] // 0xd000
        public static var msk: [UInt16] = [0b1111_0000_0000_0000]

        let cond: UInt16
        let imm8: Int16

        public init(cond: UInt16, imm8: Int16) {
            self.cond = cond
            self.imm8 = imm8
        }

        public func encode() -> [UInt16] {
            guard cond != Condition.always.rawValue else { fatalError("Consider using encoding T2 for condition AL.") }
            var low: UInt16 = Self.sig[0]
            set4(&low, cond, 8)
            set8(&low, UInt16(bitPattern: imm8), 0)
            return [low]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            let low = data[0]
            return Self(
                cond: get4(low, 8),
                imm8: Int16(bitPattern: signExtend8(get8(low, 0)))
            )
        }
    }

    // Encoding T2
    // B<c> <label>
    // All versions of the Thumb instruction set.
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 1  1  1  0  0|                           imm11|
    public struct B_T2: CodableInstruction {
        public static var sig: [UInt16] = [0b1110_0000_0000_0000] // 0xe000
        public static var msk: [UInt16] = [0b1111_1000_0000_0000]

        let imm11: Int16

        public init(imm11: Int16) {
            self.imm11 = imm11
        }

        public func encode() -> [UInt16] {
            var low: UInt16 = Self.sig[0]
            set11(&low, UInt16(bitPattern: imm11), 0)
            return [low]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            let low = data[0]
            return Self(
                imm11: Int16(bitPattern: signExtend11(get11(low, 0)))
            )
        }
    }
}

extension Thumb.B_T1: CustomDebugStringConvertible {
    public var debugDescription: String {
        "B cond\(cond), #\(imm8)"
    }
}

extension Thumb.B_T2: CustomDebugStringConvertible {
    public var debugDescription: String {
        "B #\(imm11)"
    }
}
