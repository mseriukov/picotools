public enum Condition {
    // Equal, Z == 1
    static let eq = 0b0000
    // Not equal, Z == 0
    static let ne = 0b0001
    // Carry set, C == 1
    static let cs = 0b0010
    // Carry clear, C == 0
    static let cc = 0b0011
    // Minus, negative, N == 1
    static let mi = 0b0100
    // Plus, positive, N == 0
    static let pl = 0b0101
    // Overflow, V == 1
    static let vs = 0b0110
    // No overflow, V == 0
    static let vc = 0b0111
    // Unsigned higher, C == 1 and Z == 0
    static let hi = 0b1000
    // Unsigned lower or same, C == 0 or Z == 1
    static let ls = 0b1001
    // Signed greater than or equal, N == V
    static let ge = 0b1010
    // Signed less than, N != V
    static let lt = 0b1011
    // Signed greater than, Z == 0 and N == V
    static let gt = 0b1100
    // Signed less than or equal, Z == 1 or N != V
    static let le = 0b1101
    // Always(unconditional), Any
    static let al = 0b1110
    static let hs = cs
    static let lo = cc
}
