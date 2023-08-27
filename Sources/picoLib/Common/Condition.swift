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
        case Self.equal.stringValue: self = .equal
        case Self.notEqual.stringValue: self = .notEqual
        case Self.carrySet.stringValue, "hs": self = .carrySet
        case Self.carryClear.stringValue, "lo": self = .carryClear
        case Self.negative.stringValue: self = .negative
        case Self.positive.stringValue: self = .positive
        case Self.overflow.stringValue: self = .overflow
        case Self.noOverflow.stringValue: self = .noOverflow
        case Self.unsignedHigher.stringValue: self = .unsignedHigher
        case Self.unsignedLower.stringValue: self = .unsignedLower
        case Self.signedGreaterThanOrEqual.stringValue: self = .signedGreaterThanOrEqual
        case Self.signedLessThan.stringValue: self = .signedLessThan
        case Self.signedGreaterThan.stringValue: self = .signedGreaterThan
        case Self.signedLessThanOrEqual.stringValue: self = .signedLessThanOrEqual
        case Self.always.stringValue: self = .always
        default: return nil
        }
    }

    var stringValue: String {
        switch self {
        case .equal: return "eq"
        case .notEqual: return "ne"
        case .carrySet: return "cs"
        case .carryClear: return "cc"
        case .negative: return "mi"
        case .positive: return "pl"
        case .overflow: return "vs"
        case .noOverflow: return "vc"
        case .unsignedHigher: return "hi"
        case .unsignedLower: return "ls"
        case .signedGreaterThanOrEqual: return "ge"
        case .signedLessThan: return "lt"
        case .signedGreaterThan: return "gt"
        case .signedLessThanOrEqual: return "le"
        case .always: return "al"
        }
    }
}
