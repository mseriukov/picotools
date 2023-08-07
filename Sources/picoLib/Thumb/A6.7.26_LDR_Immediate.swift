// A6.7.26 LDR (immediate)

// Encoding T1
// LDR <Rt>, [<Rn>{,#<imm5>}]
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 0  1  1| 0| 1|          imm5|      Rn|      Rt|
public struct LDR_Immediate_T1: Instruction {
    public static var sig: [UInt16] = [0b0110_1000_0000_0000] // 0x6800
    public static var msk: [UInt16] = [0b1111_1000_0000_0000]

    let t: UInt16
    let n: UInt16
    let imm5: UInt16

    public init(t: UInt16, n: UInt16, imm5: UInt16) {
        self.t = t
        self.n = n
        self.imm5 = imm5
    }

    public func encode() -> [UInt16] {
        guard imm5 % 4 == 0 else { fatalError("LDR immediate should be 4 bytes aligned.") }
        let imm5 = imm5 >> 2
        var low: UInt16 = Self.sig[0]
        set3(&low, t, 0)
        set3(&low, n, 3)
        set5(&low, imm5, 6)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            t: get3(low, 0),
            n: get3(low, 3),
            imm5: get5(low, 6) << 2
        )
    }
}

extension LDR_Immediate_T1: CustomDebugStringConvertible {
    public var debugDescription: String {
        "LDR r\(t), [r\(n), #\(imm5)]"
    }
}

// Encoding T2
// LDR <Rt>,[SP{,#<imm8>}]
// All versions of the Thumb instruction set.
// |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|
// | 1  0  0  1| 1|      Rt|                   imm8|
struct LDR_Immediate_T2: Instruction {
    public static var sig: [UInt16] = [0b1001_1000_0000_0000] // 0x9800
    public static var msk: [UInt16] = [0b1111_1000_0000_0000]

    let t: UInt16
    let imm8: UInt16

    public init(t: UInt16, imm8: UInt16) {
        self.t = t
        self.imm8 = imm8
    }

    public func encode() -> [UInt16] {
        guard imm8 % 4 == 0 else { fatalError("LDR immediate should be 4 bytes aligned.") }
        let imm8 = imm8 >> 2
        var low: UInt16 = Self.sig[0]
        set8(&low, imm8, 0)
        set3(&low, t, 8)
        return [low]
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let low = data[0]
        return Self(
            t: get3(low, 8),
            imm8: get8(low, 0) << 2
        )
    }
}

extension LDR_Immediate_T2: CustomDebugStringConvertible {
    public var debugDescription: String {
        "LDR r\(t), [SP, #\(imm8)]"
    }
}
