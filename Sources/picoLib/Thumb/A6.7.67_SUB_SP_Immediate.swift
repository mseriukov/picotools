// A6.7.67 SUB (SP minus immediate)

// Encoding T1
// SUB SP,SP,#<imm7>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 1  0  1  1| 0  0  0  0| 1|                imm7|
public struct SUB_SP_Immediate: Instruction {
    public static var sig: [UInt16] = [0b1011_0000_1000_0000] // 0xb080
    public static var msk: [UInt16] = [0b1111_1111_1000_0000]
    
    let imm7: UInt16

    public func encode() -> [UInt16] {
        guard imm7 % 4 == 0 else { fatalError("Immediate should be 4 bytes aligned.") }
        let imm7 = imm7 >> 2
        var low: UInt16 = Self.sig[0]
        set7(&low, imm7, 0)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            imm7: get7(low, 0) << 2
        )
    }
}
