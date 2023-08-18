public enum Register: String {
    case r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, sp, lr, pc

    var number: UInt16 {
        switch self {
        case .r0: return 0
        case .r1: return 1
        case .r2: return 2
        case .r3: return 3
        case .r4: return 4
        case .r5: return 5
        case .r6: return 6
        case .r7: return 7
        case .r8: return 8
        case .r9: return 9
        case .r10: return 10
        case .r11: return 11
        case .r12: return 12
        case .r13, .sp: return 13
        case .r14, .lr: return 14
        case .r15, .pc: return 15
        }
    }
}
