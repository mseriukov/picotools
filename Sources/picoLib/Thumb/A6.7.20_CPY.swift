// A6.7.20 CPY
//
// Copy is a pre-UAL synonym for MOV (register).
//
public struct CPY_T1: Instruction {
    public static var sig: [UInt16] = [0b0100_0110_0000_0000] // 0x4600
    public static var msk: [UInt16] = [0b1111_1111_0000_0000]
    
    let d: UInt16
    let m: UInt16

    public init(d: UInt16, m: UInt16) {
        self.d = d
        self.m = m
    }

    public func encode() -> [UInt16] {
        MOV_Register_T1(d: d, m: m).encode()
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let inst = MOV_Register_T1.decode(data)
        return Self(
            d: inst.d,
            m: inst.m
        )
    }
}

extension CPY_T1: CustomDebugStringConvertible {
    public var debugDescription: String {
        "CPY r\(d), r\(m)"
    }
}

public struct CPY_T2: Instruction {
    public static var sig: [UInt16] = [0b0000_0000_0000_0000] // 0x0000
    public static var msk: [UInt16] = [0b1111_1111_1100_0000]

    let d: UInt16
    let m: UInt16

    public init(d: UInt16, m: UInt16) {
        self.d = d
        self.m = m
    }

    public func encode() -> [UInt16] {
        MOV_Register_T2(d: d, m: m).encode()
    }

    public static func decode(_ data: [UInt16]) -> Self {
        verifySignature(data)
        let inst = MOV_Register_T2.decode(data)
        return Self(
            d: inst.d,
            m: inst.m
        )
    }
}

extension CPY_T2: CustomDebugStringConvertible {
    public var debugDescription: String {
        "CPY r\(d), r\(m)"
    }
}
