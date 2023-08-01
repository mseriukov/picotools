import XCTest
@testable import picoLib

final class ThumbDecodeTests: XCTestCase {
    func test_ADC_Register() throws {
        let inst = ADC_Register.decode([0x4175])
        XCTAssertEqual(inst.dn, 5)
        XCTAssertEqual(inst.m, 6)
    }

    func test_ADD_Immediate_T1() throws {
        let inst = ADD_Immediate_T1.decode([0x1d63])
        XCTAssertEqual(inst.d, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.imm3, 5)
    }

    func test_ADD_Immediate_T2() throws {
        let inst = ADD_Immediate_T2.decode([0x3305])
        XCTAssertEqual(inst.dn, 3)
        XCTAssertEqual(inst.imm8, 5)
    }

    func test_ADD_Register_T1() throws {
        let inst = ADD_Register_T1.decode([0x1963])
        XCTAssertEqual(inst.d, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.m, 5)
    }

    func test_ADD_Register_T2() throws {
        let inst = ADD_Register_T2.decode([0x44de])
        XCTAssertEqual(inst.dn, 14)
        XCTAssertEqual(inst.m, 11)
    }

    func test_ADD_SP_Immediate_T1() throws {
        let inst = ADD_SP_Immediate_T1.decode([0xab0a])
        XCTAssertEqual(inst.d, 3)
        XCTAssertEqual(inst.imm8, 40)
    }

    func test_ADD_SP_Immediate_T2() throws {
        let inst = ADD_SP_Immediate_T2.decode([0xb00a])
        XCTAssertEqual(inst.imm7, 40)
    }

    func test_ADD_SP_Register_T1() throws {
        let inst = ADD_SP_Register_T1.decode([0x4468])
        XCTAssertEqual(inst.m, 0)
    }

    func test_ADD_SP_Register_T2() throws {
        let inst = ADD_SP_Register_T2.decode([0x4485])
        XCTAssertEqual(inst.m, 0)
    }

    func test_ADR() throws {
        let inst = ADR.decode([0xa32a])
        XCTAssertEqual(inst.d, 3)
        XCTAssertEqual(inst.imm8, 42)
    }

    func test_AND_Register() throws {
        let inst = AND_Register.decode([0x4004])
        XCTAssertEqual(inst.dn, 4)
        XCTAssertEqual(inst.m, 0)
    }

    func test_ASR_Immediate() throws {
        let inst = ASR_Immediate.decode([0x157b])
        XCTAssertEqual(inst.d, 3)
        XCTAssertEqual(inst.m, 7)
        XCTAssertEqual(inst.imm5, 21)
    }

    func test_ASR_Register() throws {
        let inst = ASR_Register.decode([0x4104])
        XCTAssertEqual(inst.dn, 4)
        XCTAssertEqual(inst.m, 0)
    }

    func test_B_T1() throws {
        let inst1 = B_T1.decode([0xd006])
        XCTAssertEqual(inst1.cond, 0x00)
        XCTAssertEqual(inst1.imm8, 6)
        let inst2 = B_T1.decode([0xd0f9])
        XCTAssertEqual(inst2.cond, 0x00)
        XCTAssertEqual(inst2.imm8, -7)
    }

    func test_B_T2() throws {
        let inst1 = B_T2.decode([0xe006])
        XCTAssertEqual(inst1.imm11, 6)
        let inst2 = B_T2.decode([0xe7f9])
        XCTAssertEqual(inst2.imm11, -7)
    }

    func test_BIC_Register() throws {
        let inst = BIC_Register.decode([0x43be])
        XCTAssertEqual(inst.dn, 6)
        XCTAssertEqual(inst.m, 7)
    }

    func test_BKPT() throws {
        let inst = BKPT.decode([0xbe2a])
        XCTAssertEqual(inst.imm8, 42)
    }

    func test_BL() throws {
        let inst1 = BL.decode([0xf7ff, 0xfff9])
        XCTAssertEqual(inst1.offset, -14)
        let inst2 = BL.decode([0xf000, 0xf807])
        XCTAssertEqual(inst2.offset, 14)
    }

    func test_BLX() throws {
        let inst = BLX.decode([0x47b8])
        XCTAssertEqual(inst.m, 7)
    }

    func test_BX() throws {
        let inst = BX.decode([0x4748])
        XCTAssertEqual(inst.m, 9)
    }

    func test_CMN_Register() throws {
        let inst = CMN_Register.decode([0x42e3])
        XCTAssertEqual(inst.n, 3)
        XCTAssertEqual(inst.m, 4)
    }

    func test_CMP_Immediate() throws {
        let inst = CMP_Immediate.decode([0x2f2a])
        XCTAssertEqual(inst.n, 7)
        XCTAssertEqual(inst.imm8, 42)
    }

    func test_CMP_Register_T1() throws {
        let inst = CMP_Register_T1.decode([0x42b5])
        XCTAssertEqual(inst.n, 5)
        XCTAssertEqual(inst.m, 6)
    }

    func test_CMP_Register_T2() throws {
        let inst = CMP_Register_T2.decode([0x45e2])
        XCTAssertEqual(inst.n, 10)
        XCTAssertEqual(inst.m, 12)
    }

    func test_CPS() throws {
        let inst1 = CPS.decode([0xB662])
        XCTAssertEqual(inst1.ie, true)
        let inst2 = CPS.decode([0xB672])
        XCTAssertEqual(inst2.ie, false)
    }

    func test_MOV_Register_T1() throws {
        let inst = MOV_Register_T1.decode([0x46c0])
        XCTAssertEqual(inst.d, 8)
        XCTAssertEqual(inst.m, 8)
    }

    func test_MOV_Register_T2() throws {
        let inst = MOV_Register_T2.decode([0x003f])
        XCTAssertEqual(inst.d, 7)
        XCTAssertEqual(inst.m, 7)
    }

    func test_DSB() throws {
        let inst = DSB.decode([0xf3bf, 0x8f46])
        XCTAssertEqual(inst.option, 6)
    }

    func test_DMB() throws {
        let inst = DMB.decode([0xf3bf, 0x8f56])
        XCTAssertEqual(inst.option, 6)
    }

    func test_EOR_Register() throws {
        let inst = EOR_Register.decode([0x406b])
        XCTAssertEqual(inst.dn, 3)
        XCTAssertEqual(inst.m, 5)
    }

    func test_ISB() throws {
        let inst = ISB.decode([0xf3bf, 0x8f66])
        XCTAssertEqual(inst.option, 6)
    }

    func test_LDM() throws {
        let inst = LDM.decode([0xc82a])
        XCTAssertEqual(inst.n, 0)
        XCTAssertEqual(inst.registerList, 0x2a)
    }

    func test_LDR_Immediate_T1() throws {
        let inst = LDR_Immediate_T1.decode([0x68a3])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.imm5, 8)
    }

    func test_LDR_Immediate_T2() throws {
        let inst = LDR_Immediate_T2.decode([0x9bff])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.imm8, 1020)
    }

    func test_LDR_Literal() throws {
        let inst = LDR_Literal.decode([0x4b02])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.offset, 8)
    }

    func test_LDR_Register() throws {
        let inst = LDR_Register.decode([0x5963])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.m, 5)
    }

    func test_LDRB_Immediate() throws {
        let inst = LDRB_Immediate.decode([0x7d63])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.imm5, 21)
    }

    func test_LDRB_Register() throws {
        let inst = LDRB_Register.decode([0x5d63])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.m, 5)
    }

    func test_LDRH_Register() throws {
        let inst = LDRH_Register.decode([0x5b63])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.m, 5)

    }

    func test_LDRH_Immediate() throws {
        let inst = LDRH_Immediate.decode([0x89e3])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.imm5, 14)
    }

    func test_LSR_Immediate() throws {
        let inst = LSR_Immediate.decode([0x0d7b])
        XCTAssertEqual(inst.d, 3)
        XCTAssertEqual(inst.m, 7)
        XCTAssertEqual(inst.imm5, 21)
    }

    func test_LSL_Register() throws {
        let inst = LSL_Register.decode([0x4084])
        XCTAssertEqual(inst.dn, 4)
        XCTAssertEqual(inst.m, 0)
    }

    func test_LSL_Immediate() throws {
        let inst = LSL_Immediate.decode([0x057b])
        XCTAssertEqual(inst.d, 3)
        XCTAssertEqual(inst.m, 7)
        XCTAssertEqual(inst.imm5, 21)
    }

    func test_LDRSH_Register() throws {
        let inst = LDRSH_Register.decode([0x5f63])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.m, 5)
    }

    func test_LDRSB_Register() throws {
        let inst = LDRSB_Register.decode([0x5763])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.m, 5)
    }


    func test_MOV_Immediate() throws {
        let inst = MOV_Immediate.decode([0x232a])
        XCTAssertEqual(inst.d, 3)
        XCTAssertEqual(inst.imm8, 42)
    }

    func test_LSR_Register() throws {
        let inst = LSR_Register.decode([0x40c4])
        XCTAssertEqual(inst.dn, 4)
        XCTAssertEqual(inst.m, 0)
    }

    func test_MRS() throws {
        let inst = MRS.decode([0xf3ef, 0x8206])
        XCTAssertEqual(inst.d, 2)
        XCTAssertEqual(inst.sysm, 6)
    }

    func test_MSR_Register() throws {
        let inst = MSR_Register.decode([0xf382, 0x8806])
        XCTAssertEqual(inst.sysm, 6)
        XCTAssertEqual(inst.n, 2)
    }

    func test_MUL() throws {
        let inst = MUL.decode([0x435c])
        XCTAssertEqual(inst.n, 3)
        XCTAssertEqual(inst.dm, 4)
    }

    func test_MVN_Register() throws {
        let inst = MVN_Register.decode([0x43fd])
        XCTAssertEqual(inst.d, 5)
        XCTAssertEqual(inst.m, 7)
    }

    func test_NOP() throws {
        _ = NOP.decode([0xBF00])
    }

    func test_ORR_Register() throws {
        let inst = ORR_Register.decode([0x433c])
        XCTAssertEqual(inst.dn, 4)
        XCTAssertEqual(inst.m, 7)
    }

    func test_POP() throws {
        let inst1 = POP.decode([0xbc07])
        XCTAssertEqual(inst1.registerList, 0x07)
        XCTAssertEqual(inst1.p, false)
        let inst2 = POP.decode([0xbd07])
        XCTAssertEqual(inst2.registerList, 0x07)
        XCTAssertEqual(inst2.p, true)
    }

    func test_PUSH() throws {
        let inst1 = PUSH.decode([0xb407])
        XCTAssertEqual(inst1.registerList, 0x07)
        XCTAssertEqual(inst1.m, false)
        let inst2 = PUSH.decode([0xb507])
        XCTAssertEqual(inst2.registerList, 0x07)
        XCTAssertEqual(inst2.m, true)
    }

    func test_REV() throws {
        let inst = REV.decode([0xba3b])
        XCTAssertEqual(inst.d, 3)
        XCTAssertEqual(inst.m, 7)
    }

    func test_REV16() throws {
        let inst = REV16.decode([0xba7b])
        XCTAssertEqual(inst.d, 3)
        XCTAssertEqual(inst.m, 7)
    }

    func test_REVSH() throws {
        let inst = REVSH.decode([0xbafb])
        XCTAssertEqual(inst.d, 3)
        XCTAssertEqual(inst.m, 7)
    }

    func test_ROR_Register() throws {
        let inst = ROR_Register.decode([0x41fb])
        XCTAssertEqual(inst.dn, 3)
        XCTAssertEqual(inst.m, 7)
    }

    func test_RSB_Immediate() throws {
        let inst = RSB_Immediate.decode([0x427b])
        XCTAssertEqual(inst.d, 3)
        XCTAssertEqual(inst.n, 7)
    }

    func test_SBC_Register() throws {
        let inst = SBC_Register.decode([0x41bb])
        XCTAssertEqual(inst.dn, 3)
        XCTAssertEqual(inst.m, 7)
    }

    func test_SEV() throws {
        _ = SEV.decode([0xbf40])
    }

    func test_STM() throws {
        let inst = STM.decode([0xc02a])
        XCTAssertEqual(inst.n, 0)
        XCTAssertEqual(inst.registerList, 0x2a)
    }

    func test_STR_Immediate() throws {
        let inst1 = STR_Immediate_T1.decode([0x60a3])
        XCTAssertEqual(inst1.t, 3)
        XCTAssertEqual(inst1.n, 4)
        XCTAssertEqual(inst1.imm5, 8)

        let inst2 = STR_Immediate_T2.decode([0x93ff])
        XCTAssertEqual(inst2.t, 3)
        XCTAssertEqual(inst2.imm8, 1020)
    }

    func test_STR_Register() throws {
        let inst = STR_Register.decode([0x5163])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.m, 5)
    }

    func test_STRB_Immediate() throws {
        let inst = STRB_Immediate.decode([0x7563])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.imm5, 21)
    }

    func test_STRB_Register() throws {
        let inst = STRB_Register.decode([0x5563])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.m, 5)
    }

    func test_STRH_Immediate() throws {
        let inst = STRH_Immediate.decode([0x81e3])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.imm5, 14)
    }

    func test_STRH_Register() throws {
        let inst = STRH_Register.decode([0x5363])
        XCTAssertEqual(inst.t, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.m, 5)
    }

    func test_SUB_Immediate_T1() throws {
        let inst = SUB_Immediate_T1.decode([0x1f63])
        XCTAssertEqual(inst.d, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.imm3, 5)
    }

    func test_SUB_Immediate_T2() throws {
        let inst = SUB_Immediate_T2.decode([0x3b05])
        XCTAssertEqual(inst.dn, 3)
        XCTAssertEqual(inst.imm8, 5)
    }

    func test_SUB_Register() throws {
        let inst = SUB_Register.decode([0x1b63])
        XCTAssertEqual(inst.d, 3)
        XCTAssertEqual(inst.n, 4)
        XCTAssertEqual(inst.m, 5)
    }

    func test_SUB_SP_Immediate() throws {
        let inst = SUB_SP_Immediate.decode([0xb08a])
        XCTAssertEqual(inst.imm7, 40)
    }

    func test_SVC() throws {
        let inst = SVC.decode([0xdf2a])
        XCTAssertEqual(inst.imm8, 42)
    }

    func test_SXTB() throws {
        let inst = SXTB.decode([0xb272])
        XCTAssertEqual(inst.d, 2)
        XCTAssertEqual(inst.m, 6)
    }

    func test_SXTH() throws {
        let inst = SXTH.decode([0xb232])
        XCTAssertEqual(inst.d, 2)
        XCTAssertEqual(inst.m, 6)
    }

    func test_TST_Register() throws {
        let inst = TST_Register.decode([0x4232])
        XCTAssertEqual(inst.n, 2)
        XCTAssertEqual(inst.m, 6)
    }

    func test_UDF_T1() throws {
        let inst = UDF_T1.decode([0xde2a])
        XCTAssertEqual(inst.imm8, 42)
    }

    func test_UDF_T2() throws {
        let inst = UDF_T2.decode([0xf7fc, 0xADDD])
        XCTAssertEqual(inst.imm16, 0xCDDD)
    }

    func test_UXTB() throws {
        let inst = UXTB.decode([0xb2f2])
        XCTAssertEqual(inst.d, 2)
        XCTAssertEqual(inst.m, 6)
    }

    func test_UXTH() throws {
        let inst = UXTH.decode([0xb2b2])
        XCTAssertEqual(inst.d, 2)
        XCTAssertEqual(inst.m, 6)
    }

    func test_WFE() throws {
        _ = WFE.decode([0xBF20])
    }

    func test_WFI() throws {
        _ = WFI.decode([0xBF30])
    }

    func test_YIELD() throws {
        _ = YIELD.decode([0xBF10])
    }
}
