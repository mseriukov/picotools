// A6.7.13 BL
//
// Branch with Link (immediate) calls a subroutine at a PC-relative address.
//
// Encoding T1
// BL <label>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 1  1  1  1  0| S|                        imm10| 1  1|J1| 1|J2|                           imm11|
// I1 = NOT(J1 EOR S); I2 = NOT(J2 EOR S); imm32 = SignExtend(S:I1:I2:imm10:imm11:'0', 32);
// if InITBlock() && !LastInITBlock() then UNPREDICTABLE;
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// |                    | S|I1|I2|                        imm10|                           imm11| 0|
public struct BL: Instruction {
    public static var sig: [UInt16] = [0b1111_0000_0000_0000, 0b1101_0000_0000_0000] // 0xf000, 0xd000
    public static var msk: [UInt16] = [0b1111_1000_0000_0000, 0b1101_0000_0000_0000]

    let offset: Int32

    public init(offset: Int32) {
        self.offset = offset
    }

    public func encode() -> [UInt16] {
        guard offset >= -16777216, offset <= 16777214 else { fatalError("BL offset is out of range.") }
        guard offset % 2 == 0 else { fatalError("BL offset is not even.") }
        let offset = offset / 2
        var high: UInt16 = Self.sig[0]
        var low: UInt16 = Self.sig[1]

        let split = int32toUInt16(offset)

        let hOffset: UInt16 = split[1]
        let lOffset: UInt16 = split[0]


        let i2 = bitSet(hOffset, 6)
        let i1 = bitSet(hOffset, 7)
        let s = bitSet(hOffset, 8)

        let j1 = !i1 != s
        let j2 = !i2 != s

        let imm10: UInt16 = ((hOffset & 0x003f) << 4) | ((lOffset & 0xf000) >> 12)
        let imm11: UInt16 = (lOffset & 0x0fff) >> 0

        writeBit(&high, s, 10)
        set10(&high, imm10, 0)
        writeBit(&low, j1, 13)
        writeBit(&low, j2, 11)
        set11(&low, imm11, 0)
        return [high, low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let high = data[0]
        let low = data[1]

        let imm10 = get10(high, 0)
        let imm11 = get11(low, 0)

        let s = bitSet(high, 8)
        let j1 = bitSet(low, 13)
        let j2 = bitSet(low, 11)

        let i1 = !(j1 != s)
        let i2 = !(j2 != s)

        var lOffset: UInt16 = 0x0000
        var hOffset: UInt16 = 0x0000

        set11(&lOffset, imm11, 1)
        set4(&lOffset, imm10 & 0xF, 12)
        set6(&hOffset, (imm10 >> 4), 0)
        writeBit(&hOffset, i2, 6)
        writeBit(&hOffset, i1, 7)
        writeBit(&hOffset, s, 8)

        var offset: UInt32 = 0x00000000
        offset |= UInt32(hOffset) << 16
        offset |= UInt32(lOffset)

        return Self(
            offset: Int32(bitPattern: signExtend24(offset))
        )
    }
}
