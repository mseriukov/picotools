extension Thumb {
    // A6.7.58 STM, STMIA, STMEA

    // Encoding T1
    // STM <Rn>!,<registers>
    // All versions of the Thumb instruction set.
    // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
    // | 1  1  0  0| 0|      Rn|          register_list|
    public struct STM: CodableInstruction {
        public static var sig: [UInt16] = [0b1100_0000_0000_0000] // 0xc000
        public static var msk: [UInt16] = [0b1111_1000_0000_0000]

        let n: UInt16
        let registerList: UInt16

        public init(n: UInt16, registerList: UInt16) {
            self.n = n
            self.registerList = registerList
        }

        public func encode() -> [UInt16] {
            var low: UInt16 = Self.sig[0]
            set3(&low, n, 8)
            set8(&low, registerList, 0)
            return [low]
        }

        public static func decode(_ data: [UInt16]) -> Self {
            verifySignature(data)
            let low = data[0]
            return Self(
                n: get3(low, 8),
                registerList: get8(low, 0)
            )
        }
    }
}

extension Thumb.STM: CustomDebugStringConvertible {
    public var debugDescription: String {
        // TODO: Pretty print register list.
        "STM r\(n)!, \(registerList)"
    }
}
