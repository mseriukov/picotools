// A6.7.68 SVC

// Encoding T1
// SVC #<imm8>
// All versions of the Thumb instruction set M profile specific behavior.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 1  1  0  1| 1  1  1  1|                   imm8|
public struct SVC: Instruction {
    public static var sig: [UInt16] = [0b1101_1111_0000_0000] // 0xdf00
    public static var msk: [UInt16] = [0b1111_1111_0000_0000]
    
    let imm8: UInt16

    public init(imm8: UInt16) {
        self.imm8 = imm8
    }

    public func encode() -> [UInt16] {
        var low: UInt16 = Self.sig[0]
        set8(&low, imm8, 0)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            imm8: get8(low, 0)
        )
    }
}
