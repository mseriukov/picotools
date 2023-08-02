// A6.7.2 ADD (immediate)

// Encoding T1
// ADDS <Rd>,<Rn>,#<imm3>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  0  0| 1  1| 1| 0|    imm3|      Rn|      Rd|
public struct ADD_Immediate_T1: Instruction {
    public static var sig: [UInt16] = [0b0001_1100_0000_0000] // 0x1c00
    public static var msk: [UInt16] = [0b1111_1110_0000_0000]

    let d: UInt16
    let n: UInt16
    let imm3: UInt16

    public init(d: UInt16, n: UInt16, imm3: UInt16) {
        self.d = d
        self.n = n
        self.imm3 = imm3
    }

    public func encode() -> [UInt16] {
        var low: UInt16 = Self.sig[0]
        set3(&low, d, 0)
        set3(&low, n, 3)
        set3(&low, imm3, 6)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low: UInt16 = data[0]
        return ADD_Immediate_T1(
            d: get3(low, 0),
            n: get3(low, 3),
            imm3: get3(low, 6)
        )
    }
}

// Encoding T2
// ADDS <Rdn>,#<imm8>
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  0  1| 1  0|     Rdn|                   imm8|
public struct ADD_Immediate_T2: Instruction {
    public static var sig: [UInt16] = [0b0011_0000_0000_0000] // 0x3000
    public static var msk: [UInt16] = [0b1111_1000_0000_0000]

    let dn: UInt16
    let imm8: UInt16

    public init(dn: UInt16, imm8: UInt16) {
        self.dn = dn
        self.imm8 = imm8
    }

    public func encode() -> [UInt16] {
        var low: UInt16 = Self.sig[0]
        set3(&low, dn, 8)
        set8(&low, imm8, 0)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            dn: get3(low, 8),
            imm8: get8(low, 0)
        )
    }
}
