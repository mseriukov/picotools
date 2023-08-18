// A6.7.25 LDM, LDMIA, LDMFD

// Encoding T1
// LDM <Rn>!,<registers>    <Rn> not included in <registers>
// LDM <Rn>,<registers>     <Rn> included in <registers>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 1  1  0  0| 1|      Rn|          register_list|
public struct LDM: CodableInstruction {
    public static var sig: [UInt16] = [0b1100_1000_0000_0000] // 0xC800
    public static var msk: [UInt16] = [0b1111_1000_0000_0000]
    
    let n: UInt16
    let registerList: UInt16

    public init(n: UInt16, registerList: UInt16) {
        self.n = n
        self.registerList = registerList
    }

    public func encode() -> [UInt16] {
        var low: UInt16 = Self.sig[0]
        set8(&low, registerList, 0)
        set3(&low, n, 8)
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

extension LDM: CustomDebugStringConvertible {
    public var debugDescription: String {
        // TODO: Pretty print register list.
        // TODO: Add ! logic.
        "LDM \(n), \(registerList)"
    }
}
