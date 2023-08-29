public enum Mnemonic {
    case ADC
    case ADCS
    case ADD
    case ADDS
    case ANDS
    case ASRS
    case ADR
    case B
    case BICS
    case BKPT
    case BL
    case BLX
    case BX
    case CMN
    case CMP
    case CPY
    case CPYS
    case DMB
    case DSB
    case EORS
    case ISB
    case LDM
    case LDR
    case LDRB
    case LDRH
    case LDRSB
    case LDRSH
    case LSLS
    case LSRS
    case MOV
    case MOVS
    case MRS
    case MSR
    case MULS
    case MVNS
    case NEG
    case RSBS
    case ORRS
    case POP
    case PUSH
    case REV
    case REV16
    case REVSH
    case RORS
    case SBCS
    case STM
    case STR
    case STRB
    case STRH
    case SUBS
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
        case Self.ADC.stringValue: self = .ADC
        case Self.ADCS.stringValue: self = .ADCS
        case Self.ADD.stringValue: self = .ADD
        case Self.ANDS.stringValue: self = .ANDS
        case Self.ASRS.stringValue: self = .ASRS
        case Self.ADR.stringValue: self = .ADR
        case Self.B.stringValue: self = .B
        case Self.BICS.stringValue: self = .BICS
        case Self.BKPT.stringValue: self = .BKPT
        case Self.BL.stringValue: self = .BL
        case Self.BLX.stringValue: self = .BLX
        case Self.BX.stringValue: self = .BX
        case Self.CMN.stringValue: self = .CMN
        case Self.CMP.stringValue: self = .CMP
        case Self.CPY.stringValue: self = .CPY
        case Self.CPYS.stringValue: self = .CPYS
        case Self.DMB.stringValue: self = .DMB
        case Self.DSB.stringValue: self = .DSB
        case Self.EORS.stringValue: self = .EORS
        case Self.ISB.stringValue: self = .ISB
        case Self.LDM.stringValue, "ldmia", "ldmfd": self = .LDM
        case Self.LDR.stringValue: self = .LDR
        case Self.LDRB.stringValue: self = .LDRB
        case Self.LDRH.stringValue: self = .LDRH
        case Self.LDRSB.stringValue: self = .LDRSB
        case Self.LDRSH.stringValue: self = .LDRSH
        case Self.LSLS.stringValue: self = .LSLS
        case Self.LSRS.stringValue: self = .LSRS
        case Self.MOV.stringValue: self = .MOV
        case Self.MOVS.stringValue: self = .MOVS
        case Self.MRS.stringValue: self = .MRS
        case Self.MSR.stringValue: self = .MSR
        case Self.MULS.stringValue: self = .MULS
        case Self.MVNS.stringValue: self = .MVNS
        case Self.NEG.stringValue: self = .NEG
        case Self.RSBS.stringValue: self = .RSBS
        case Self.ORRS.stringValue: self = .ORRS
        case Self.POP.stringValue: self = .POP
        case Self.PUSH.stringValue: self = .PUSH
        case Self.REV.stringValue: self = .REV
        case Self.REV16.stringValue: self = .REV16
        case Self.REVSH.stringValue: self = .REVSH
        case Self.RORS.stringValue: self = .RORS
        case Self.SBCS.stringValue: self = .SBCS
        case Self.STM.stringValue, "stmia", "stmea": self = .STM
        case Self.STR.stringValue: self = .STR
        case Self.STRB.stringValue: self = .STRB
        case Self.STRH.stringValue: self = .STRH
        case Self.SUBS.stringValue: self = .SUBS
        case Self.SUB.stringValue: self = .SUB
        case Self.SVC.stringValue: self = .SVC
        case Self.SXTB.stringValue: self = .SXTB
        case Self.SXTH.stringValue: self = .SXTH
        case Self.TST.stringValue: self = .TST
        case Self.UDF.stringValue: self = .UDF
        case Self.UXTB.stringValue: self = .UXTB
        case Self.UXTH.stringValue: self = .UXTH
        case Self.SEV.stringValue: self = .SEV
        case Self.NOP.stringValue: self = .NOP
        case Self.WFE.stringValue: self = .WFE
        case Self.WFI.stringValue: self = .WFI
        case Self.YIELD.stringValue: self = .YIELD
        default: return nil
        }
    }

    var stringValue: String {
        switch self {
        case .ADC: return "adc"
        case .ADCS: return "adcs"
        case .ADD: return "add"
        case .ADDS: return "adds"
        case .ANDS: return "ands"
        case .ASRS: return "asrs"
        case .ADR: return "adr"
        case .B: return "b"
        case .BICS: return "bics"
        case .BKPT: return "bkpt"
        case .BL: return "bl"
        case .BLX: return "blx"
        case .BX: return "bx"
        case .CMN: return "cmn"
        case .CMP: return "cmp"
        case .CPY: return "cpy"
        case .CPYS: return "cpys"
        case .DMB: return "dmb"
        case .DSB: return "dsb"
        case .EORS: return "eors"
        case .ISB: return "isb"
        case .LDM: return "ldm"
        case .LDR: return "ldr"
        case .LDRB: return "ldrb"
        case .LDRH: return "ldrh"
        case .LDRSB: return "ldrsb"
        case .LDRSH: return "ldrsh"
        case .LSLS: return "lsls"
        case .LSRS: return "lsrs"
        case .MOV: return "mov"
        case .MOVS: return "movs"
        case .MRS: return "mrs"
        case .MSR: return "msr"
        case .MULS: return "muls"
        case .MVNS: return "mvns"
        case .NEG: return "neg"
        case .RSBS: return "rsbs"
        case .ORRS: return "orrs"
        case .POP: return "pop"
        case .PUSH: return "push"
        case .REV: return "rev"
        case .REV16: return "rev16"
        case .REVSH: return "revsh"
        case .RORS: return "rors"
        case .SBCS: return "sbcs"
        case .STM: return "stm"
        case .STR: return "str"
        case .STRB: return "strb"
        case .STRH: return "strh"
        case .SUBS: return "subs"
        case .SUB: return "sub"
        case .SVC: return "svc"
        case .SXTB: return "sxtb"
        case .SXTH: return "sxth"
        case .TST: return "tst"
        case .UDF: return "udf"
        case .UXTB: return "uxtb"
        case .UXTH: return "uxth"
        case .SEV: return "sev"
        case .NOP: return "nop"
        case .WFE: return "wfe"
        case .WFI: return "wfi"
        case .YIELD: return "yield"
        }
    }
}
