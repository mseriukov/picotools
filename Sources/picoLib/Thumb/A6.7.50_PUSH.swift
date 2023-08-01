// A6.7.50 PUSH

// Encoding T1
// PUSH <registers>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 1  0  1  1| 0| 1  0| m|          register_list|
public struct PUSH: Instruction {
    public static var sig: [UInt16] = [0b1011_0100_0000_0000] // 0xb400
    public static var msk: [UInt16] = [0b1111_1110_0000_0000]
    
    let registerList: UInt16
    let m: Bool

    public func encode() -> [UInt16] {
        var low: UInt16 = Self.sig[0]
        writeBit(&low, m, 8)
        set8(&low, registerList, 0)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            registerList: get8(low, 0),
            m: bitSet(low, 8)
        )
    }
}
