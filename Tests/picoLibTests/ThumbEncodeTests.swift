import XCTest
@testable import picoLib

// Assemble:
// arm-none-eabi-as -mthumb -march=armv6-m main.S -o main.o
// Extract .text section:
// arm-none-eabi-objcopy -O binary --only-section=.text main.o main.text
// Disassemble .text section:
// arm-none-eabi-objdump -b binary -marm -Mforce-thumb -D main.text

final class ThumbEncodeTests: XCTestCase {
    func test_MOV_Register() throws {
        XCTAssertEqual(Thumb.MOV_Register_T1(d: 8, m: 8).encode(), [0x46c0]) // nop ; (mov r8, r8)
        XCTAssertEqual(Thumb.MOV_Register_T2(d: 7, m: 7).encode(), [0x003f]) // movs r7, r7
    }

    func test_MOV_Immediate() throws {
        XCTAssertEqual(Thumb.MOV_Immediate(d: 3, imm8: 42).encode(), [0x232a]) // movs r3, #42    ; 0x2a
    }

    func test_LSR_Register() throws {
        XCTAssertEqual(Thumb.LSR_Register(dn: 4, m: 0).encode(), [0x40c4]) // lsrs r4, r0
    }

    func test_LSR_Immediate() throws {
        XCTAssertEqual(Thumb.LSR_Immediate(d: 3, m: 7, imm5: 21).encode(), [0x0d7b]) // lsrs r3, r7, #21
    }

    func test_LSL_Register() throws {
        XCTAssertEqual(Thumb.LSL_Register(dn: 4, m: 0).encode(), [0x4084]) // lsls r4, r0
    }

    func test_LSL_Immediate() throws {
        XCTAssertEqual(Thumb.LSL_Immediate(d: 3, m: 7, imm5: 21).encode(), [0x057b]) // lsls r3, r7, #21
    }

    func test_LDRSH_Register() throws {
        XCTAssertEqual(Thumb.LDRSH_Register(t: 3, n: 4, m: 5).encode(), [0x5f63]) // ldrsh r3, [r4, r5]
    }

    func test_LDRSB_Register() throws {
        XCTAssertEqual(Thumb.LDRSB_Register(t: 3, n: 4, m: 5).encode(), [0x5763]) // ldrsb r3, [r4, r5]
    }

    func test_LDRH_Register() throws {
        XCTAssertEqual(Thumb.LDRH_Register(t: 3, n: 4, m: 5).encode(), [0x5b63]) // ldrh r3, [r4, r5]
    }

    func test_LDRH_Immediate() throws {
        XCTAssertEqual(Thumb.LDRH_Immediate(t: 3, n: 4, imm5: 14).encode(), [0x89e3]) // ldrh r3, [r4, #14]
    }

    func test_LDRB_Register() throws {
        XCTAssertEqual(Thumb.LDRB_Register(t: 3, n: 4, m: 5).encode(), [0x5d63]) // ldrb r3, [r4, r5]
    }

    func test_LDRB_Immediate() throws {
        XCTAssertEqual(Thumb.LDRB_Immediate(t: 3, n: 4, imm5: 21).encode(), [0x7d63]) // ldrb r3, [r4, #21]
    }

    func test_LDR_Register() throws {
        XCTAssertEqual(Thumb.LDR_Register(t: 3, n: 4, m: 5).encode(), [0x5963]) // ldr r3, [r4, r5]
    }

    func test_LDR_Literal() throws {
        XCTAssertEqual(Thumb.LDR_Literal(t: 3, offset: 8).encode(), [0x4b02]) // ldr r3, [pc, #8]
    }

    func test_LDR_Immediate() throws {
        XCTAssertEqual(Thumb.LDR_Immediate_T1(t: 3, n: 4, imm5: 8).encode(), [0x68a3]) // ldr r3, [r4, #8]
        XCTAssertEqual(Thumb.LDR_Immediate_T2(t: 3, imm8: 1020).encode(), [0x9bff]) // ldr r3, [sp, #1020]    ; 0x3fc
    }

    func test_LDM() throws {
        XCTAssertEqual(Thumb.LDM(n: 0, registerList: 0x2a).encode(), [0xc82a]) // ldmia r0!, {r1, r3, r5}
    }

    func test_ISB() throws {
        XCTAssertEqual(Thumb.ISB(option: 6).encode(), [0xf3bf, 0x8f66]) // isb #6
    }

    func test_EOR_Register() throws {
        XCTAssertEqual(Thumb.EOR_Register(dn: 3, m: 5).encode(), [0x406b]) // eors r3, r5
    }

    func test_DSB() throws {
        XCTAssertEqual(Thumb.DSB(option: 6).encode(), [0xf3bf, 0x8f46]) // dsb unst
    }

    func test_DMB() throws {
        XCTAssertEqual(Thumb.DMB(option: 6).encode(), [0xf3bf, 0x8f56]) // dmb unst
    }

    func test_CPS() throws {
        XCTAssertEqual(Thumb.CPS(ie: true).encode(), [0xB662]) // cpsie    i
        XCTAssertEqual(Thumb.CPS(ie: false).encode(), [0xB672]) // cpsid    i
    }

    func test_CMP_Register() throws {
        XCTAssertEqual(Thumb.CMP_Register_T1(n: 5, m: 6).encode(), [0x42b5]) // cmp r5, r6
        XCTAssertEqual(Thumb.CMP_Register_T2(n: 10, m: 12).encode(), [0x45e2]) // cmp sl, ip
    }

    func test_CMP_Immediate() throws {
        XCTAssertEqual(Thumb.CMP_Immediate(n: 7, imm8: 42).encode(), [0x2f2a]) // cmp r7, #42    ; 0x2a
    }

    func test_CMN_Register() throws {
        XCTAssertEqual(Thumb.CMN_Register(n: 3, m: 4).encode(), [0x42e3]) // cmn r3, r4
    }

    func test_BX() throws {
        XCTAssertEqual(Thumb.BX(m: 9).encode(), [0x4748]) // bx r9
    }

    func test_BLX() throws {
        XCTAssertEqual(Thumb.BLX(m: 7).encode(), [0x47b8]) // blx r7
    }

    func test_BL() throws {
        XCTAssertEqual(Thumb.BL(offset: -14).encode(), [0xf7ff, 0xfff9]) //
        XCTAssertEqual(Thumb.BL(offset: 14).encode(), [0xf000, 0xf807]) //
    }

    func test_BKPT() throws {
        XCTAssertEqual(Thumb.BKPT(imm8: 42).encode(), [0xbe2a]) // bkpt 0x002a
    }

    func test_BIC_Register() throws {
        XCTAssertEqual(Thumb.BIC_Register(dn: 6, m: 7).encode(), [0x43be]) // bics r6, r7
    }

    func test_B() throws {
        // TODO: Check it again
        XCTAssertEqual(Thumb.B_T2(imm11: 6).encode(), [0xe006]) // b.n 0x10
        XCTAssertEqual(Thumb.B_T2(imm11: -7).encode(), [0xe7f9]) // b.n 0xfffffff8
        XCTAssertEqual(Thumb.B_T1(cond: 0x00, imm8: 6).encode(), [0xd006]) // beq.n 0x14
        XCTAssertEqual(Thumb.B_T1(cond: 0x00, imm8: -7).encode(), [0xd0f9]) // beq.n 0xfffffffc
    }

    func test_ASR_Register() throws {
        XCTAssertEqual(Thumb.ASR_Register(dn: 4, m: 0).encode(), [0x4104]) // asrs r4, r0
    }

    func test_ASR_Immediate() throws {
        XCTAssertEqual(Thumb.ASR_Immediate(d: 3, m: 7, imm5: 21).encode(), [0x157b]) // asrs r3, r7, #21
    }

    func test_AND_Register() throws {
        XCTAssertEqual(Thumb.AND_Register(dn: 4, m: 0).encode(), [0x4004]) // ands r4, r0
    }

    func test_ADR() throws {
        // TODO: Check it again
        XCTAssertEqual(Thumb.ADR(d: 3, imm8: 42).encode(), [0xa32a]) // add    r3, pc, #168    ; (adr r3, 0xac)
    }

    func test_ADD_SP_Register() throws {
        XCTAssertEqual(Thumb.ADD_SP_Register_T1(m: 0).encode(), [0x4468]) // add r0, sp
        XCTAssertEqual(Thumb.ADD_SP_Register_T2(m: 0).encode(), [0x4485]) // add sp, r0
    }

    func test_ADD_SP_Immediate() throws {
        XCTAssertEqual(Thumb.ADD_SP_Immediate_T1(d: 3, imm8: 40).encode(), [0xab0a]) // add r3, sp, #40    ; 0x28
        XCTAssertEqual(Thumb.ADD_SP_Immediate_T2(imm7: 40).encode(), [0xb00a]) // add sp, #40    ; 0x28
    }

    func test_ADD_Register() throws {
        XCTAssertEqual(Thumb.ADD_Register_T1(d: 3, n: 4, m: 5).encode(), [0x1963]) // adds r3, r4, r5
        XCTAssertEqual(Thumb.ADD_Register_T2(dn: 14, m: 11).encode(), [0x44de]) // add lr, fp
    }

    func test_ADD_Immediate() throws {
        XCTAssertEqual(Thumb.ADD_Immediate_T1(d: 3, n: 4, imm3: 5).encode(), [0x1d63]) // adds r3, r4, #5
        XCTAssertEqual(Thumb.ADD_Immediate_T2(dn: 3, imm8: 5).encode(), [0x3305]) // adds r3, #5
    }

    func test_ADC_Register() throws {
        XCTAssertEqual(Thumb.ADC_Register(dn: 5, m: 6).encode(), [0x4175]) // adcs r5, r6
    }

    func test_MRS() throws {
        XCTAssertEqual(Thumb.MRS(d: 2, sysm: 6).encode(), [0xf3ef, 0x8206]) // mrs r2, EPSR
    }

    func test_MSR_Register() throws {
        XCTAssertEqual(Thumb.MSR_Register(sysm: 6, n: 2).encode(), [0xf382, 0x8806]) // msr EPSR, r2
    }

    func test_MUL() throws {
        XCTAssertEqual(Thumb.MUL(n: 3, dm: 4).encode(), [0x435c]) // muls r4, r3
    }

    func test_MVN_Register() throws {
        XCTAssertEqual(Thumb.MVN_Register(d: 5, m: 7).encode(), [0x43fd]) // mvns r5, r7
    }

    func test_NOP() throws {
        XCTAssertEqual(Thumb.NOP().encode(), [0xBF00]) // nop
    }

    func test_ORR_Register() throws {
        XCTAssertEqual(Thumb.ORR_Register(dn: 4, m: 7).encode(), [0x433c]) // orrs r4, r7
    }

    func test_POP() throws {
        XCTAssertEqual(Thumb.POP(registerList: 0x07, p: false).encode(), [0xbc07]) // pop {r0-r2}
        XCTAssertEqual(Thumb.POP(registerList: 0x07, p: true).encode(), [0xbd07]) // pop {r0-r2, pc}
    }

    func test_PUSH() throws {
        XCTAssertEqual(Thumb.PUSH(registerList: 0x07, m: false).encode(), [0xb407]) // push {r0-r2}
        XCTAssertEqual(Thumb.PUSH(registerList: 0x07, m: true).encode(), [0xb507]) // push {r0-r2, lr}
    }

    func test_REV() throws {
        XCTAssertEqual(Thumb.REV(d: 3, m: 7).encode(), [0xba3b]) // rev r3, r7
    }

    func test_REV16() throws {
        XCTAssertEqual(Thumb.REV16(d: 3, m: 7).encode(), [0xba7b]) // rev16 r3, r7
    }

    func test_REVSH() throws {
        XCTAssertEqual(Thumb.REVSH(d: 3, m: 7).encode(), [0xbafb]) // revsh r3, r7
    }

    func test_ROR_Register() throws {
        XCTAssertEqual(Thumb.ROR_Register(dn: 3, m: 7).encode(), [0x41fb]) // rors r3, r7
    }

    func test_RSB_Immediate() throws {
        XCTAssertEqual(Thumb.RSB_Immediate(d: 3, n: 7).encode(), [0x427b]) // rsbs r3, r7, #0
    }

    func test_SBC_Register() throws {
        XCTAssertEqual(Thumb.SBC_Register(dn: 3, m: 7).encode(), [0x41bb]) // sbcs r3, r7
    }

    func test_SEV() throws {
        XCTAssertEqual(Thumb.SEV().encode(), [0xbf40]) // sev
    }

    func test_STM() throws {
        XCTAssertEqual(Thumb.STM(n: 0, registerList: 0x2a).encode(), [0xc02a]) // stmia r0!, {r1, r3, r5}
    }

    func test_STR_Immediate() throws {
        XCTAssertEqual(Thumb.STR_Immediate_T1(t: 3, n: 4, imm5: 8).encode(), [0x60a3]) // str r3, [r4, #8]
        XCTAssertEqual(Thumb.STR_Immediate_T2(t: 3, imm8: 1020).encode(), [0x93ff]) // str r3, [sp, #1020]    ; 0x3fc
    }

    func test_STR_Register() throws {
        XCTAssertEqual(Thumb.STR_Register(t: 3, n: 4, m: 5).encode(), [0x5163]) // str r3, [r4, r5]
    }

    func test_STRB_Immediate() throws {
        XCTAssertEqual(Thumb.STRB_Immediate(t: 3, n: 4, imm5: 21).encode(), [0x7563]) // strb r3, [r4, #21]
    }

    func test_STRB_Register() throws {
        XCTAssertEqual(Thumb.STRB_Register(t: 3, n: 4, m: 5).encode(), [0x5563]) // strb r3, [r4, r5]
    }

    func test_STRH_Immediate() throws {
        XCTAssertEqual(Thumb.STRH_Immediate(t: 3, n: 4, imm5: 14).encode(), [0x81e3]) // strh r3, [r4, #14]
    }

    func test_STRH_Register() throws {
        XCTAssertEqual(Thumb.STRH_Register(t: 3, n: 4, m: 5).encode(), [0x5363]) // strh r3, [r4, r5]
    }

    func test_SUB_Immediate() throws {
        XCTAssertEqual(Thumb.SUB_Immediate_T1(d: 3, n: 4, imm3: 5).encode(), [0x1f63]) // subs r3, r4, #5
        XCTAssertEqual(Thumb.SUB_Immediate_T2(dn: 3, imm8: 5).encode(), [0x3b05]) // subs r3, #5
    }

    func test_SUB_Register() throws {
        XCTAssertEqual(Thumb.SUB_Register(d: 3, n: 4, m: 5).encode(), [0x1b63]) // subs r3, r4, r5
    }

    func test_SUB_SP_Immediate() throws {
        XCTAssertEqual(Thumb.SUB_SP_Immediate(imm7: 40).encode(), [0xb08a]) // sub sp, sp, #40    ; 0x28
    }

    func test_SVC() throws {
        XCTAssertEqual(Thumb.SVC(imm8: 42).encode(), [0xdf2a]) // svc #42    ; 0x2a
    }

    func test_SXTB() throws {
        XCTAssertEqual(Thumb.SXTB(d: 2, m: 6).encode(), [0xb272]) // sxtb r2, r6
    }

    func test_SXTH() throws {
        XCTAssertEqual(Thumb.SXTH(d: 2, m: 6).encode(), [0xb232]) // sxth r2, r6
    }

    func test_TST_Register() throws {
        XCTAssertEqual(Thumb.TST_Register(n: 2, m: 6).encode(), [0x4232]) // tst r2, r6
    }

    func test_UDF() throws {
        XCTAssertEqual(Thumb.UDF_T1(imm8: 42).encode(), [0xde2a]) // udf #42    ; 0x2a
        XCTAssertEqual(Thumb.UDF_T2(imm16: 0xCDDD).encode(), [0xf7fc, 0xADDD]) // udf.w #52701    ; 0xcddd
    }

    func test_UXTB() throws {
        XCTAssertEqual(Thumb.UXTB(d: 2, m: 6).encode(), [0xb2f2]) // uxtb r2, r6
    }

    func test_UXTH() throws {
        XCTAssertEqual(Thumb.UXTH(d: 2, m: 6).encode(), [0xb2b2]) // uxth r2, r6
    }

    func test_WFE() throws {
        XCTAssertEqual(Thumb.WFE().encode(), [0xBF20]) // wfe
    }

    func test_WFI() throws {
        XCTAssertEqual(Thumb.WFI().encode(), [0xBF30]) // wfi
    }

    func test_YIELD() throws {
        XCTAssertEqual(Thumb.YIELD().encode(), [0xBF10]) // yield
    }
}
