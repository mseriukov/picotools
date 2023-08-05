
/*
 program: line* EOF

 line: (label? instruction? NEWLINE) *
 instruction: opcode argumentList

 label: identifier ':'

 argumentlist: argument (',' argumentlist)?
 argument: prefix? (number | name) (('+' | '-') number)? | "(" argument ")"

 prefix: '#' | '='

 register: r1 | r2 | r3 | r4 | r5 | r6 | r7 | r8 | r9 | r10 | r11 | r12 | r13 | r14 | r15 | sp | lr | pc
 registerList: '{' registerListEntry (',' registerListEntry)? '}'
 registerListEntry: register | registerRange
 registerRange: register '-' register

 opcode: ...

 Instruction list:
 ADCS {<Rd>,} <Rn>, <Rm>
 ADDS {<Rd>,} <Rn>, #<const>
 ADD {<Rd>,} SP, #<const>
 ADD <Rd>, PC, #<const>
 CMP <Rn>, #<const>
 ADD{S} {<Rd>,} <Rn>, <Rm>
 ADD {<Rd>,} SP, <Rm>
 ADR <Rd>, <label>
 ANDS {<Rd>,} <Rn>, <Rm>
 ASRS <Rd>, <Rm>, #<imm5>
 ASRS <Rd>, <Rn>, <Rm>
 B{<c>} <label>
 BICS {<Rd>,} <Rn>, <Rm>
 BKPT {#}<imm8>
 BL <label>
 BLX <Rm>
 BX <Rm>
 CMN <Rn>, <Rm>
 CMP <Rn>, <Rm>
 CPY <Rd>, <Rn>
 DMB {<opt>}
 DSB {<opt>}
 EORS {<Rd>,} <Rn>, <Rm>
 ISB {<opt>}
 LDM <Rn>{!}, <registers>
 LDR <Rt>, [<Rn> {, #+/-<imm>}]
 LDR <Rt>, <label>
 LDR <Rt>, [PC, #<imm>]
 LDR <Rt>, [<Rn>, <Rm>]
 LDRB <Rt>, [<Rn> {, #+/-<imm>}]
 LDRB <Rt>, [<Rn>, <Rm>]
 LDRH <Rt>, [<Rn> {, #+/-<imm>}]
 LDRH <Rt>, [<Rn>, <Rm>]
 LDRSB <Rt>, [<Rn>, <Rm>]
 LDRSH <Rt>, [<Rn>, <Rm>]
 LSLS <Rd>, <Rm>, #<imm5>
 LSLS <Rd>, <Rn>, <Rm>
 LSRS <Rd>, <Rm>, #<imm5>
 LSRS <Rd>, <Rn>, <Rm>
 MOVS <Rd>, #<const>
 MOV{S} <Rd>, <Rm>
 MOVS <Rd>,<Rm>,ASR #<n>
 ASRS <Rd>,<Rm>,#<n>
 MOVS <Rd>,<Rm>,LSL #<n>
 LSLS <Rd>,<Rm>,#<n>
 MOVS <Rd>,<Rm>,LSR #<n>
 LSRS <Rd>,<Rm>,#<n>
 MOVS <Rd>,<Rm>,ASR <Rs>
 ASRS <Rd>,<Rm>,<Rs>
 MOVS <Rd>,<Rm>,LSL <Rs>
 LSLS <Rd>,<Rm>,<Rs>
 MOVS <Rd>,<Rm>,LSR <Rs>
 LSRS <Rd>,<Rm>,<Rs>
 MOVS <Rd>,<Rm>,ROR <Rs>
 RORS <Rd>,<Rm>,<Rs>
 MRS <Rd>,<spec_reg>
 MSR <spec_reg>,<Rn>
 MULS {<Rd>,} <Rn>, <Rm>
 MVNS <Rd>, <Rm>
 NEG {<Rd>,} <Rm>
 RSBS {<Rd>,} <Rm>, #0
 ORRS {<Rd>,} <Rn>, <Rm>
 POP <registers>
 PUSH <registers>
 REV <Rd>, <Rm>
 REV16 <Rd>, <Rm>
 REVSH <Rd>, <Rm>
 RORS <Rd>, <Rn>, <Rm>
 RSBS {<Rd>,} <Rn>, #<const>
 SBCS {<Rd>,} <Rn>, <Rm>
 STM{IA|EA} <Rn>!, <registers>
 STR <Rt>, [<Rn> {, #+/-<imm>}]
 STR <Rt>, [<Rn>, <Rm>]
 STRB <Rt>, [<Rn> {, #+/-<imm>}]
 STRB <Rt>, [<Rn>, <Rm> {, LSL #<shift>}]
 STRH <Rt>, [<Rn> {, #+/-<imm>}]
 STRH <Rt>, [<Rn>, <Rm>]
 SUBS {<Rd>,} <Rn>, #<const>
 SUBS {<Rd>,} <Rn>, <Rm>
 SUB {<Rd>,} SP, #<const>
 SVC {#}<imm>
 SXTB <Rd>, <Rm>
 SXTH <Rd>, <Rm>
 TST <Rn>, <Rm>
 UDF {#}<imm>
 UXTB <Rd>, <Rm>
 UXTH <Rd>, <Rm>
 SEV
 NOP
 WFE
 WFI
 YIELD

*/


class Parser {
    private let tokens: [Token]
    private var current = 0

    public init(tokens: [Token]) {
        self.tokens = tokens
    }

}
