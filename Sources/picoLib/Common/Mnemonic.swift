public enum Mnemonic: String {
    case ADC
    case ADD
    case AND
    case ASR
    case ADR
    case B
    case BIC
    case BKPT
    case BL
    case BLX
    case BX
    case CMN
    case CMP
    case CPY
    case DMB
    case DSB
    case EOR
    case ISB
    case LDM
    case LDR
    case LDRB
    case LDRH
    case LDRSB
    case LDRSH
    case LSL
    case LSR
    case MOV
    case MRS
    case MSR
    case MUL
    case MVN
    case NEG
    case RSB
    case ORR
    case POP
    case PUSH
    case REV
    case REV16
    case REVSH
    case ROR
    case SBC
    case STM
    case STMIA
    case STMEA
    case STR
    case STRB
    case STRH
    case SUB
    case SVC
    case SXTB
    case SXTH
    case TST
    case UDF
    case UXTB
    case UXTH
    case SEV
    case NOP
    case WFE
    case WFI
    case YIELD

    init?(_ string: String) {
        switch string.lowercased() {
        case "adc": self = .ADC
        case "add": self = .ADD
        case "and": self = .AND
        case "asr": self = .ASR
        case "adr": self = .ADR
        case "b": self = .B
        case "bic": self = .BIC
        case "bkpt": self = .BKPT
        case "bl": self = .BL
        case "blx": self = .BLX
        case "bx": self = .BX
        case "cmn": self = .CMN
        case "cmp": self = .CMP
        case "cpy": self = .CPY
        case "dmb": self = .DMB
        case "dsb": self = .DSB
        case "eor": self = .EOR
        case "isb": self = .ISB
        case "ldm": self = .LDM
        case "ldr": self = .LDR
        case "ldrb": self = .LDRB
        case "ldrh": self = .LDRH
        case "ldrsb": self = .LDRSB
        case "ldrsh": self = .LDRSH
        case "lsl": self = .LSL
        case "lsr": self = .LSR
        case "mov": self = .MOV
        case "mrs": self = .MRS
        case "msr": self = .MSR
        case "mul": self = .MUL
        case "mvn": self = .MVN
        case "neg": self = .NEG
        case "rsb": self = .RSB
        case "orr": self = .ORR
        case "pop": self = .POP
        case "push": self = .PUSH
        case "rev": self = .REV
        case "rev16": self = .REV16
        case "revsh": self = .REVSH
        case "ror": self = .ROR
        case "sbc": self = .SBC
        case "stm": self = .STM
        case "stmia": self = .STMIA
        case "stmea": self = .STMEA
        case "str": self = .STR
        case "strb": self = .STRB
        case "strh": self = .STRH
        case "sub": self = .SUB
        case "svc": self = .SVC
        case "sxtb": self = .SXTB
        case "sxth": self = .SXTH
        case "tst": self = .TST
        case "udf": self = .UDF
        case "uxtb": self = .UXTB
        case "uxth": self = .UXTH
        case "sev": self = .SEV
        case "nop": self = .NOP
        case "wfe": self = .WFE
        case "wfi": self = .WFI
        case "yield": self = .YIELD
        default: return nil
        }
    }
}
