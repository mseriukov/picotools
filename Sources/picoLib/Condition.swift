public enum Condition: UInt8 {
    // Equal, Z == 1
    case equal = 0b0000
    // Not equal, Z == 0
    case notEqual = 0b0001
    // Carry set, C == 1
    case carrySet = 0b0010
    // Carry clear, C == 0
    case carryClear = 0b0011
    // Minus, negative, N == 1
    case negative = 0b0100
    // Plus, positive, N == 0
    case positive = 0b0101
    // Overflow, V == 1
    case overflow = 0b0110
    // No overflow, V == 0
    case noOverflow = 0b0111
    // Unsigned higher, C == 1 and Z == 0
    case unsignedHigher = 0b1000
    // Unsigned lower or same, C == 0 or Z == 1
    case unsignedLower = 0b1001
    // Signed greater than or equal, N == V
    case signedGreaterThanOrEqual = 0b1010
    // Signed less than, N != V
    case signedLessThan = 0b1011
    // Signed greater than, Z == 0 and N == V
    case signedGreaterThan = 0b1100
    // Signed less than or equal, Z == 1 or N != V
    case signedLessThanOrEqual = 0b1101
    // Always(unconditional), Any
    case always = 0b1110

    init?(_ string: String) {
        switch string.lowercased() {
        case "eq":
            self = .equal

        case "ne":
            self = .notEqual

        case "cs",
             "hs":
            self = .carrySet

        case "cc",
             "lo":
            self = .carryClear

        case "mi":
            self = .negative

        case "pl":
            self = .positive

        case "vs":
            self = .overflow

        case "vc":
            self = .noOverflow

        case "hi":
            self = .unsignedHigher

        case "ls":
            self = .unsignedLower

        case "ge":
            self = .signedGreaterThanOrEqual

        case "lt":
            self = .signedLessThan

        case "gt":
            self = .signedGreaterThan

        case "le":
            self = .signedLessThanOrEqual

        case "al":
            self = .always

        default:
            return nil
        }
    }
}
