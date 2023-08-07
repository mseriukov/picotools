// A6.7.49 POP

// Encoding T1
// POP <registers>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 1  0  1  1| 1| 1  0| p|          register_list|
public struct POP: Instruction {
    public static var sig: [UInt16] = [0b1011_1100_0000_0000] // 0xbc00
    public static var msk: [UInt16] = [0b1111_1110_0000_0000]
    
    let registerList: UInt16
    let p: Bool

    public init(registerList: UInt16, p: Bool) {
        self.registerList = registerList
        self.p = p
    }

    public func encode() -> [UInt16] {
        var low: UInt16 = Self.sig[0]
        writeBit(&low, p, 8)
        set8(&low, registerList, 0)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            registerList: get8(low, 0),
            p: bitSet(low, 8)
        )
    }
}

extension POP: CustomDebugStringConvertible {
    public var debugDescription: String {
        // TODO: Pretty print register list.
        "POP \(registerList) p \(p)"
    }
}
