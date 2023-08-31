public enum SpecialRegister: String {
    case APSR, IPSR, EPSR, IEPSR, IAPSR, EAPSR, XPSR, MSP, PSP, PRIMASK, CONTROL

    var number: UInt16 {
        switch self {
        case .APSR: return 0
        case .IAPSR: return 1
        case .EAPSR: return 2
        case .XPSR: return 3
        case .IPSR: return 5
        case .EPSR: return 6
        case .IEPSR: return 7
        case .MSP: return 8
        case .PSP: return 9
        case .PRIMASK: return 16
        case .CONTROL: return 20
        }
    }
}
