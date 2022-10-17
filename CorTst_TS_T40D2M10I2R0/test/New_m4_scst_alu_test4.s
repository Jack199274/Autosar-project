/******************************************************************************
*
* Copyright 2015-2016 Freescale
* Copyright 2019 NXP
*
* NXP Confidential. This software is owned or controlled by NXP and may only 
* be used strictly in accordance with the applicable license terms. 
* By expressly accepting such terms or by downloading, installing, activating
* and/or otherwise using the software, you are agreeing that you have read, 
* and that you agree to comply with and are bound by, such license terms. 
* If you do not agree to be bound by the applicable license terms, 
* then you may not retain, install, activate or otherwise use the software.
*
******************************************************************************/

/******************************************************************************
* Test summary:
* -------------
* Test ALU module - ALU Shift operations
*
* Overall coverage:
* -----------------
* ALU control bus:
* - shift operation is of the form RRX
* - shifter control
* - ALU operation type:
*   - Shift (regular)
*   - Shift (BFX)
*   - Shift (BFI/BFC)
*   - Shift (Saturation)
*
* DECODER:
*(32Bit Thumb)
*   - Data processing (shifted register) - Move register and immediate shifts
*   - Data processing (register)
*   - Data processing (plain binary immediate)
* 测试总结：
* -------------
* 测试 ALU 模块 - ALU Shift 操作
*
* 整体覆盖：
* -----------------
* ALU 控制总线：
* - 移位操作的形式为 RRX
* - 换挡控制
* - ALU 操作类型：
* - 班次（常规）
* - 移位（BFX）
* - 换档（BFI/BFC）
* - 移位（饱和度）
*
* 解码器：
*（32位拇指）
* - 数据处理（移位寄存器） - 移动寄存器和立即移位
* - 数据处理（寄存器）
* - 数据处理（普通二进制立即数）
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"
 
    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_alu_test4

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    SCST_EXTERN m4_scst_clear_flags
    SCST_EXTERN m4_scst_check_q_flag
    SCST_EXTERN m4_scst_check_flags_cleared

    
    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_alu_test4" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_alu_test4, function)
m4_scst_alu_test4:

    PUSH.W  {R1-R12,R14}
    
    /* R9 is used as intermediate result */
    MOV     R9,#0x0
    
    /***************************************************************************************************
    * ALU control bus:
    *  - shift operation is of the form RRX
    *
    * Note: Linked with RRX instructions. (RRX is special form of ROR when imm3:imm2 = 0b00000)
    *
    ***************************************************************************************************/
    BL      m4_scst_clear_flags
    /* RRX - Rotate Right Extended */
    LDR     R2,=0xAAAAAAAA       
    
    SCST_OPCODE_START    /* RRX    R3,R2 - Used opcode due to compiler problem */
    SCST_OPCODE32_HIGH(0xEA4F)
    SCST_OPCODE32_LOW( 0x0332)    
    SCST_OPCODE_END
    
    CMP     R3,#0x55555555
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    LDR     R2,=0x55555555
    MOV     R4,#0x20000000
    MSR     APSR_nzcvq,R4     /* Set C flag */    
    ISB
    /* RRX    R3,R2 - Used opcode due to compiler problem */
    SCST_OPCODE_START    
    SCST_OPCODE32_HIGH(0xEA4F)
    SCST_OPCODE32_LOW( 0x0332)    
    SCST_OPCODE_END
    
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0BFB
    
    
    /***************************************************************************************************
    * ALU operation type:
    *   - 00100 - Shift (regular)
    *
    * Note: Shift regular is linked with ASR, ROR, LSR, LSL, ASR instructions
    *
    ***************************************************************************************************/
    /* ASR - Arithmetic Shift Right */
    LDR     R5,=0xAAAAAAAA /* Load value to be shifted */
    
    /* ASR (immediate) Encoding T2 32bit - "Move register and immediate shift" instruction */
    /* <Rd[11:8]>:R10 0b1010
       <Rm[3:0]>:R5  0b0101 */
    ASR     R10,R5,#1
    LDR     R6,=0xD5555555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    ASR     R10,R5,#2
    LDR     R6,=0xEAAAAAAA
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    ASR     R10,R5,#3
    LDR     R6,=0xF5555555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    ASR     R10,R5,#4
    LDR     R6,=0xFAAAAAAA
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    ASR     R10,R5,#5
    LDR     R6,=0xFD555555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    ASR     R10,R5,#6
    LDR     R6,=0xFEAAAAAA
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    ASR     R10,R5,#7
    LDR     R6,=0xFF555555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    ASR     R10,R5,#8
    LDR     R6,=0xFFAAAAAA
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    ASR     R10,R5,#9
    LDR     R6,=0xFFD55555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    ASR     R10,R5,#10
    LDR     R6,=0xFFEAAAAA
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    ASR     R10,R5,#11
    LDR     R6,=0xFFF55555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    ASR     R10,R5,#12
    LDR     R6,=0xFFFAAAAA
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    ASR     R10,R5,#13
    LDR     R6,=0xFFFD5555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    ASR     R10,R5,#14
    LDR     R6,=0xFFFEAAAA
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    ASR     R10,R5,#15
    LDR     R6,=0xFFFF5555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    /* For Decoder test swap R5, R10 */
    MOVS.W  R10,R5
    BL      m4_scst_clear_flags 
    MOV.W   R10,R5 /* MOV (register) Encoding T3 32bit - "Move register and immediate shift" instruction */
    BL      m4_scst_check_flags_cleared
    /* ASR (immediate) Encoding T2 32bit - "Move register and immediate shift" instruction */
    /* <Rd[11:8]>:R5 0b0101
       <Rm[3:0]>:R10  0b1010 */
    ASR     R5,R10,#16
    LDR     R6,=0xFFFFAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#17
    LDR     R6,=0xFFFFD555
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#18
    LDR     R6,=0xFFFFEAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#19
    LDR     R6,=0xFFFFF555
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#20
    LDR     R6,=0xFFFFFAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#21
    LDR     R6,=0xFFFFFD55
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#22
    LDR     R6,=0xFFFFFEAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#23
    LDR     R6,=0xFFFFFF55
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#24
    LDR     R6,=0xFFFFFFAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#25
    LDR     R6,=0xFFFFFFD5
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#26
    LDR     R6,=0xFFFFFFEA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#27
    LDR     R6,=0xFFFFFFF5
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#28
    LDR     R6,=0xFFFFFFFA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#29
    LDR     R6,=0xFFFFFFFD
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#30
    LDR     R6,=0xFFFFFFFE
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    ASR     R5,R10,#31
    LDR     R6,=0xFFFFFFFF
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    
    B m4_scst_alu_test4_ltorg_jump_1 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_alu_test4_ltorg_jump_1:
    
    /* ASR (register) Encoding T2 32bit - "Data processing register" instruction */
    /* <Rn[3:0]>:R10 0b1010
       <Rd[11:8]>:R5 0b0101
       <Rm[3:0]>:R5  0b0101 */
    LDR     R10,=0x55555555 /* Load value to be shifted */
    MOV     R5,#1
    ASR     R5,R10,R5
    LDR     R6,=0x2AAAAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    MOV     R5,#2
    ASR     R5,R10,R5
    LDR     R6,=0x15555555
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    MOV     R5,#3
    ASR     R5,R10,R5
    LDR     R6,=0x0AAAAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    MOV     R5,#4
    ASR     R5,R10,R5
    LDR     R6,=0x05555555
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    MOV     R5,#5
    ASR     R5,R10,R5
    LDR     R6,=0x02AAAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    MOV     R5,#6
    ASR     R5,R10,R5
    LDR     R6,=0x01555555
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    MOV     R5,#7
    ASR     R5,R10,R5
    LDR     R6,=0x00AAAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    MOV     R5,#8
    ASR     R5,R10,R5
    LDR     R6,=0x00555555
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    MOV     R5,#9
    ASR     R5,R10,R5
    LDR     R6,=0x002AAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    MOV     R5,#10
    ASR     R5,R10,R5
    LDR     R6,=0x00155555
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    MOV     R5,#11
    ASR     R5,R10,R5
    LDR     R6,=0x000AAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    MOV     R5,#12
    ASR     R5,R10,R5
    LDR     R6,=0x00055555
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    MOV     R5,#13
    ASR     R5,R10,R5
    LDR     R6,=0x0002AAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    MOV     R5,#14
    ASR     R5,R10,R5
    LDR     R6,=0x00015555
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    MOV     R5,#15
    ASR     R5,R10,R5
    LDR     R6,=0x0000AAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    /* For Decoder test swap R5, R10 */
    MOVS.W  R5,R10
    BL      m4_scst_clear_flags 
    MOV.W   R5,R10 /* MOV (register) Encoding T3 32bit - "Move register and immediate shift" instruction */
    BL      m4_scst_check_flags_cleared
    /* ASR (register) Encoding T2 32bit - "Data processing register" instruction */
    /* <Rn[3:0]>:R5   0b0101
       <Rd[11:8]>:R10 0b1010
       <Rm[3:0]>:R10  0b1010 */
    MOV     R10,#16
    ASR     R10,R5,R10
    LDR     R6,=0x00005555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#17
    ASR     R10,R5,R10
    LDR     R6,=0x00002AAA
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#18
    ASR     R10,R5,R10
    LDR     R6,=0x00001555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#19
    ASR     R10,R5,R10
    LDR     R6,=0x00000AAA
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#20
    ASR     R10,R5,R10
    LDR     R6,=0x00000555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#21
    ASR     R10,R5,R10
    LDR     R6,=0x000002AA
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#22
    ASR     R10,R5,R10
    MOVW    R6,#0x00000155 /* Warning command LDR  R6,=0x155 was not compiled by GHS 2013.5.4 */
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#23
    ASR     R10,R5,R10
    LDR     R6,=0x000000AA
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#24
    ASR     R10,R5,R10
    LDR     R6,=0x00000055
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#25
    ASR     R10,R5,R10
    LDR     R6,=0x0000002A
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#26
    ASR     R10,R5,R10
    LDR     R6,=0x00000015
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#27
    ASR     R10,R5,R10
    LDR     R6,=0x0000000A
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#28
    ASR     R10,R5,R10
    LDR     R6,=0x00000005
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#29
    ASR     R10,R5,R10
    LDR     R6,=0x00000002
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#30
    ASR     R10,R5,R10
    LDR     R6,=0x00000001
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    MOV     R10,#31
    ASR     R10,R5,R10
    LDR     R6,=0x00000000
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0D3F
    
    
    /* LSR - Logical Shift Right */
    LDR     R3,=0xAAAAAAAA /* Load value to be shifted */
    
    /* LSR (immediate) Encoding T2 32bit - "Move register and immediate shift" instruction */
    /* <Rd[11:8]>:R12 0b1100
       <Rm[3:0]>:R3  0b0011 */
    LSR     R12,R3,#1
    LDR     R6,=0x55555555
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    LSR     R12,R3,#2
    LDR     R6,=0x2AAAAAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    LSR     R12,R3,#3
    LDR     R6,=0x15555555
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    LSR     R12,R3,#4
    LDR     R6,=0x0AAAAAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    LSR     R12,R3,#5
    LDR     R6,=0x05555555
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    LSR     R12,R3,#6
    LDR     R6,=0x02AAAAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    LSR     R12,R3,#7
    LDR     R6,=0x01555555
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    LSR     R12,R3,#8
    LDR     R6,=0x00AAAAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    LSR     R12,R3,#9
    LDR     R6,=0x00555555
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    LSR     R12,R3,#10
    LDR     R6,=0x002AAAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    LSR     R12,R3,#11
    LDR     R6,=0x00155555
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    LSR     R12,R3,#12
    LDR     R6,=0x000AAAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    LSR     R12,R3,#13
    LDR     R6,=0x00055555
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    LSR     R12,R3,#14
    LDR     R6,=0x0002AAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    LSR     R12,R3,#15
    LDR     R6,=0x00015555
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    /* For Decoder test swap R12, R3 */
    MOVS.W  R12,R3
    BL      m4_scst_clear_flags 
    MOV.W   R12,R3 /* MOV (register) Encoding T3 32bit - "Move register and immediate shift" instruction */
    BL      m4_scst_check_flags_cleared
    /* LSR (immediate) Encoding T2 32bit - "Move register and immediate shift" instruction */
    /* <Rd[11:8]>:R3 0b0011
       <Rm[3:0]>:R12 0b1100 */
    LSR     R3,R12,#16
    LDR     R6,=0x0000AAAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#17
    LDR     R6,=0x00005555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#18
    LDR     R6,=0x00002AAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#19
    LDR     R6,=0x00001555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#20
    LDR     R6,=0x00000AAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#21
    LDR     R6,=0x00000555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#22
    LDR     R6,=0x000002AA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#23
    MOVW    R6,#0x00000155 /* Warning command LDR  R6,=0x155 was not compiled by GHS 2013.5.4 */
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#24
    LDR     R6,=0x000000AA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#25
    LDR     R6,=0x00000055
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#26
    LDR     R6,=0x0000002A
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#27
    LDR     R6,=0x00000015
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#28
    LDR     R6,=0x0000000A
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#29
    LDR     R6,=0x00000005
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#30
    LDR     R6,=0x00000002
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LSR     R3,R12,#31
    LDR     R6,=0x00000001
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    /*LSR     R3,R12,#32 - GHS doesn't compile this correct instruction*/
    SCST_OPCODE_START    
    SCST_OPCODE32_HIGH(0xEA4F)
    SCST_OPCODE32_LOW( 0x031C)    
    SCST_OPCODE_END    
    
    LDR     R6,=0x00000000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    B m4_scst_alu_test4_ltorg_jump_2 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_alu_test4_ltorg_jump_2:
    
    /* LSR (register) Encoding T2 32bit - "Data processing register" instruction */
    /* <Rn[3:0]>:R12 0b1100
       <Rd[11:8]>:R3 0b0011
       <Rm[3:0]>:R3  0b0011 */
    LDR     R12,=0x55555555 /* Load value to be shifted */
    MOV     R3,#1
    LSR     R3,R12,R3
    LDR     R6,=0x2AAAAAAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    MOV     R3,#2
    LSR     R3,R12,R3
    LDR     R6,=0x15555555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    MOV     R3,#3
    LSR     R3,R12,R3
    LDR     R6,=0x0AAAAAAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    MOV     R3,#4
    LSR     R3,R12,R3
    LDR     R6,=0x05555555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    MOV     R3,#5
    LSR     R3,R12,R3
    LDR     R6,=0x02AAAAAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    MOV     R3,#6
    LSR     R3,R12,R3
    LDR     R6,=0x01555555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    MOV     R3,#7
    LSR     R3,R12,R3
    LDR     R6,=0x00AAAAAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    MOV     R3,#8
    LSR     R3,R12,R3
    LDR     R6,=0x00555555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    MOV     R3,#9
    LSR     R3,R12,R3
    LDR     R6,=0x002AAAAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    MOV     R3,#10
    LSR     R3,R12,R3
    LDR     R6,=0x00155555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    MOV     R3,#11
    LSR     R3,R12,R3
    LDR     R6,=0x000AAAAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    MOV     R3,#12
    LSR     R3,R12,R3
    LDR     R6,=0x00055555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    MOV     R3,#13
    LSR     R3,R12,R3
    LDR     R6,=0x0002AAAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    MOV     R3,#14
    LSR     R3,R12,R3
    LDR     R6,=0x00015555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    MOV     R3,#15
    LSR     R3,R12,R3
    LDR     R6,=0x0000AAAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    /* For Decoder test swap R3, R12 */
    MOVS.W  R3,R12
    BL      m4_scst_clear_flags 
    MOV.W   R3,R12 /* MOV (register) Encoding T3 32bit - "Move register and immediate shift" instruction */
    BL      m4_scst_check_flags_cleared
    /* LSR (register) Encoding T2 32bit - "Data processing register" instruction */
    /* <Rn[3:0]>:R3   0b0011
       <Rd[11:8]>:R12 0b1100
       <Rm[3:0]>:R12  0b1100 */
    MOV     R12,#16
    LSR     R12,R3,R12
    LDR     R6,=0x00005555
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#17
    LSR     R12,R3,R12
    LDR     R6,=0x00002AAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#18
    LSR     R12,R3,R12
    LDR     R6,=0x00001555
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#19
    LSR     R12,R3,R12
    LDR     R6,=0x00000AAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#20
    LSR     R12,R3,R12
    LDR     R6,=0x00000555
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#21
    LSR     R12,R3,R12
    LDR     R6,=0x000002AA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#22
    LSR     R12,R3,R12
    MOVW    R6,#0x00000155 /* Warning command LDR  R6,=0x155 was not compiled by GHS 2013.5.4 */
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#23
    LSR     R12,R3,R12
    LDR     R6,=0x000000AA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#24
    LSR     R12,R3,R12
    LDR     R6,=0x00000055
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#25
    LSR     R12,R3,R12
    LDR     R6,=0x0000002A
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#26
    LSR     R12,R3,R12
    LDR     R6,=0x00000015
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#27
    LSR     R12,R3,R12
    LDR     R6,=0x0000000A
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#28
    LSR     R12,R3,R12
    LDR     R6,=0x00000005
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#29
    LSR     R12,R3,R12
    LDR     R6,=0x00000002
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#30
    LSR     R12,R3,R12
    LDR     R6,=0x00000001
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#31
    LSR     R12,R3,R12
    LDR     R6,=0x00000000
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    MOV     R12,#32
    LSR     R12,R3,R12
    LDR     R6,=0x00000000
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0F36    
    
    /* LSL - Logical Shift Left */
    LDR     R7,=0xAAAAAAAA     /* Load value to be shifted */
    /* LSL (immediate) Encoding T2 32bit - "Move register and immediate shift" instruction */
    /* <Rd[11:8]>:R8 0b1000
       <Rm[3:0]>:R7  0b0111 */
    LSL     R8,R7,#1
    LDR     R6,=0x55555554
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    LSL     R8,R7,#2
    LDR     R6,=0xAAAAAAA8
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    LSL     R8,R7,#3
    LDR     R6,=0x55555550
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    LSL     R8,R7,#4
    LDR     R6,=0xAAAAAAA0
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    LSL     R8,R7,#5
    LDR     R6,=0x55555540
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    LSL     R8,R7,#6
    LDR     R6,=0xAAAAAA80
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    LSL     R8,R7,#7
    LDR     R6,=0x55555500
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    LSL     R8,R7,#8
    LDR     R6,=0xAAAAAA00
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    LSL     R8,R7,#9
    LDR     R6,=0x55555400
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    LSL     R8,R7,#10
    LDR     R6,=0xAAAAA800
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    LSL     R8,R7,#11
    LDR     R6,=0x55555000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    LSL     R8,R7,#12
    LDR     R6,=0xAAAAA000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    LSL     R8,R7,#13
    LDR     R6,=0x55554000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    LSL     R8,R7,#14
    LDR     R6,=0xAAAA8000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    LSL     R8,R7,#15
    LDR     R6,=0x55550000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    /* For Decoder test swap R8, R7 */
    MOVS.W  R8,R7
    BL      m4_scst_clear_flags 
    MOV.W   R8,R7 /* MOV (register) Encoding T3 32bit - "Move register and immediate shift" instruction */
    BL      m4_scst_check_flags_cleared
    /* LSL (immediate) Encoding T2 32bit - "Move register and immediate shift" instruction */
    /* <Rd[11:8]>:R7 0b0111
       <Rm[3:0]>:R8 0b1000 */
    LSL     R7,R8,#16
    LDR     R6,=0xAAAA0000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#17
    LDR     R6,=0x55540000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#18
    LDR     R6,=0xAAA80000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#19
    LDR     R6,=0x55500000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#20
    LDR     R6,=0xAAA00000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#21
    LDR     R6,=0x55400000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#22
    LDR     R6,=0xAA800000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#23
    LDR     R6,=0x55000000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#24
    LDR     R6,=0xAA000000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#25
    LDR     R6,=0x54000000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#26
    LDR     R6,=0xA8000000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#27
    LDR     R6,=0x50000000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#28
    LDR     R6,=0xA0000000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#29
    LDR     R6,=0x40000000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#30
    LDR     R6,=0x80000000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    LSL     R7,R8,#31
    LDR     R6,=0x00000000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    
    B m4_scst_alu_test4_ltorg_jump_3 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_alu_test4_ltorg_jump_3:
    
    /* LSL (register) Encoding T2 32bit - "Data processing register" instruction */
    /* <Rn[3:0]>:R8 0b1000
       <Rd[11:8]>:R7 0b0111
       <Rm[3:0]>:R7  0b0111 */
    LDR     R8,=0x55555555 /* Load value to be shifted */
    MOV     R7,#1
    LSL     R7,R8,R7
    LDR     R6,=0xAAAAAAAA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    MOV     R7,#2
    LSL     R7,R8,R7
    LDR     R6,=0x55555554
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    MOV     R7,#3
    LSL     R7,R8,R7
    LDR     R6,=0xAAAAAAA8
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    MOV     R7,#4
    LSL     R7,R8,R7
    LDR     R6,=0x55555550
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    MOV     R7,#5
    LSL     R7,R8,R7
    LDR     R6,=0xAAAAAAA0
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    MOV     R7,#6
    LSL     R7,R8,R7
    LDR     R6,=0x55555540
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    MOV     R7,#7
    LSL     R7,R8,R7
    LDR     R6,=0xAAAAAA80
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    MOV     R7,#8
    LSL     R7,R8,R7
    LDR     R6,=0x55555500
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    MOV     R7,#9
    LSL     R7,R8,R7
    LDR     R6,=0xAAAAAA00
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    MOV     R7,#10
    LSL     R7,R8,R7
    LDR     R6,=0x55555400
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    MOV     R7,#11
    LSL     R7,R8,R7
    LDR     R6,=0xAAAAA800
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    MOV     R7,#12
    LSL     R7,R8,R7
    LDR     R6,=0x55555000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    MOV     R7,#13
    LSL     R7,R8,R7
    LDR     R6,=0xAAAAA000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    MOV     R7,#14
    LSL     R7,R8,R7
    LDR     R6,=0x55554000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    MOV     R7,#15
    LSL     R7,R8,R7
    LDR     R6,=0xAAAA8000
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    /* For Decoder test swap R7, R8 */
    MOVS.W  R7,R8
    BL      m4_scst_clear_flags 
    MOV.W   R7,R8 /* MOV (register) Encoding T3 32bit - "Move register and immediate shift" instruction */
    BL      m4_scst_check_flags_cleared
    /* LSL (register) Encoding T2 32bit - "Data processing register" instruction */
    /* <Rn[3:0]>:R7  0b0011
       <Rd[11:8]>:R8 0b1000
       <Rm[3:0]>:R8  0b1000 */
    MOV     R8,#16
    LSL     R8,R7,R8
    LDR     R6,=0x55550000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#17
    LSL     R8,R7,R8
    LDR     R6,=0xAAAA0000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#18
    LSL     R8,R7,R8
    LDR     R6,=0x55540000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#19
    LSL     R8,R7,R8
    LDR     R6,=0xAAA80000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#20
    LSL     R8,R7,R8
    LDR     R6,=0x55500000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#21
    LSL     R8,R7,R8
    LDR     R6,=0xAAA00000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#22
    LSL     R8,R7,R8
    LDR     R6,=0x55400000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#23
    LSL     R8,R7,R8
    LDR     R6,=0xAA800000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#24
    LSL     R8,R7,R8
    LDR     R6,=0x55000000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#25
    LSL     R8,R7,R8
    LDR     R6,=0xAA000000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#26
    LSL     R8,R7,R8
    LDR     R6,=0x54000000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#27
    LSL     R8,R7,R8
    LDR     R6,=0xA8000000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#28
    LSL     R8,R7,R8
    LDR     R6,=0x50000000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#29
    LSL     R8,R7,R8
    LDR     R6,=0xA0000000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#30
    LSL     R8,R7,R8
    LDR     R6,=0x40000000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    MOV     R8,#31
    LSL     R8,R7,R8
    LDR     R6,=0x80000000
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0B3E
    
    
    /* ROR - Rotate Right */
    LDR     R4,=0xAAAAAAAA     /* Load value to be shifted */
    /* ROR (immediate) Encoding T2 32bit - "Move register and immediate shift" instruction */
    /* <Rd[11:8]>:R11 0b1011
       <Rm[3:0]>:R4   0b0100 */
    ROR     R11,R4,#1
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    ROR     R11,R4,#2
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R11,R4,#3
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    ROR     R11,R4,#4
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R11,R4,#5
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    ROR     R11,R4,#6
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R11,R4,#7
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    ROR     R11,R4,#8
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R11,R4,#9
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    ROR     R11,R4,#10
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R11,R4,#11
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    ROR     R11,R4,#12
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R11,R4,#13
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    ROR     R11,R4,#14
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R11,R4,#15
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    /* For Decoder test swap R11, R4 */
    MOVS.W  R2,R4
    BL      m4_scst_clear_flags /* Note: Destroys R4, R2 helps */ 
    MOV.W   R11,R2 /* MOV (register) Encoding T3 32bit - "Move register and immediate shift" instruction */
    BL      m4_scst_check_flags_cleared
    /* ROR (immediate) Encoding T2 32bit - "Move register and immediate shift" instruction */
    /* <Rd[11:8]>:R4 0b0100
       <Rm[3:0]>:R11 0b1011 */
    ROR     R4,R11,#16
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#17
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#18
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#19
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#20
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#21
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#22
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#23
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#24
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#25
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#26
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#27
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#28
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#29
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#30
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    ROR     R4,R11,#31
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    
    B m4_scst_alu_test4_ltorg_jump_4 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_alu_test4_ltorg_jump_4:
    
    /* ROR (register) Encoding T2 32bit - "Data processing register" instruction */
    /* <Rn[3:0]>:R11 0b1011
       <Rd[11:8]>:R4 0b0100
       <Rm[3:0]>:R7  0b0100 */
    LDR     R11,=0x55555555 /* Load value to be shifted */
    MOV     R4,#0
    ROR     R4,R11,R4
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R4,#1
    ROR     R4,R11,R4
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    MOV     R4,#2
    ROR     R4,R11,R4
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R4,#3
    ROR     R4,R11,R4
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    MOV     R4,#4
    ROR     R4,R11,R4
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R4,#5
    ROR     R4,R11,R4
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    MOV     R4,#6
    ROR     R4,R11,R4
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R4,#7
    ROR     R4,R11,R4
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    MOV     R4,#8
    ROR     R4,R11,R4
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R4,#9
    ROR     R4,R11,R4
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    MOV     R4,#10
    ROR     R4,R11,R4
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R4,#11
    ROR     R4,R11,R4
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    MOV     R4,#12
    ROR     R4,R11,R4
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R4,#13
    ROR     R4,R11,R4
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    MOV     R4,#14
    ROR     R4,R11,R4
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R4,#15
    ROR     R4,R11,R4
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    /* For Decoder test swap R4, R11 */
    MOVS.W  R2,R11
    BL      m4_scst_clear_flags  /* Note: Destroys R4, R2 helps */
    MOV.W   R2,R11 /* MOV (register) Encoding T3 32bit - "Move register and immediate shift" instruction */
    BL      m4_scst_check_flags_cleared
    MOV.W   R4,R2
    /* ROR (register) Encoding T2 32bit - "Data processing register" instruction */
    /* <Rn[3:0]>:R4   0b0100
       <Rd[11:8]>:R11 0b1011
       <Rm[3:0]>:R11  0b1011 */
    MOV     R11,#16
    ROR     R11,R4,R11
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R11,#17
    ROR     R11,R4,R11
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    MOV     R11,#18
    ROR     R11,R4,R11
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R11,#19
    ROR     R11,R4,R11
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    MOV     R11,#20
    ROR     R11,R4,R11
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R11,#21
    ROR     R11,R4,R11
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    MOV     R11,#22
    ROR     R11,R4,R11
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R11,#23
    ROR     R11,R4,R11
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    MOV     R11,#24
    ROR     R11,R4,R11
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R11,#25
    ROR     R11,R4,R11
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    MOV     R11,#26
    ROR     R11,R4,R11
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R11,#27
    ROR     R11,R4,R11
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    MOV     R11,#28
    ROR     R11,R4,R11
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R11,#29
    ROR     R11,R4,R11
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    MOV     R11,#30
    ROR     R11,R4,R11
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    MOV     R11,#31
    ROR     R11,R4,R11
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0A8E
    
    
    /***************************************************************************************************
    * ALU operation type:
    *   - 00101 - Shift (BFX)
    *
    * Note: Shift (BFX) is linked with SBFX, UBFX
    *
    ***************************************************************************************************/
    /* SBFX */
    /* Verify signed extend to 32-bit */
    LDR     R8,=0xAAAAAAAA     /* Load negative value */
    /* SBFX - Encoding T1 32bit - "Data processing (plain binary immediate)" instruction */
    SBFX    R7,R8,#31,#1
    LDR     R6,=0xFFFFFFFF
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#30,#2
    LDR     R6,=0xFFFFFFFE
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#29,#3
    LDR     R6,=0xFFFFFFFD
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#28,#4
    LDR     R6,=0xFFFFFFFA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#27,#5
    LDR     R6,=0xFFFFFFF5
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#26,#6
    LDR     R6,=0xFFFFFFEA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#25,#7
    LDR     R6,=0xFFFFFFD5
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#24,#8
    LDR     R6,=0xFFFFFFAA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#23,#9
    LDR     R6,=0xFFFFFF55
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#22,#10
    LDR     R6,=0xFFFFFEAA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#21,#11
    LDR     R6,=0xFFFFFD55
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#20,#12
    LDR     R6,=0xFFFFFAAA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#19,#13
    LDR     R6,=0xFFFFF555
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#18,#14
    LDR     R6,=0xFFFFEAAA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#17,#15
    LDR     R6,=0xFFFFD555
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#16,#16
    LDR     R6,=0xFFFFAAAA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#15,#17
    LDR     R6,=0xFFFF5555
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#14,#18
    LDR     R6,=0xFFFEAAAA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#13,#19
    LDR     R6,=0xFFFD5555
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#12,#20
    LDR     R6,=0xFFFAAAAA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#11,#21
    LDR     R6,=0xFFF55555
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#10,#22
    LDR     R6,=0xFFEAAAAA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#9,#23
    LDR     R6,=0xFFD55555
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#8,#24
    LDR     R6,=0xFFAAAAAA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#7,#25
    LDR     R6,=0xFF555555
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#6,#26
    LDR     R6,=0xFEAAAAAA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#5,#27
    LDR     R6,=0xFD555555
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#4,#28
    LDR     R6,=0xFAAAAAAA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#3,#29
    LDR     R6,=0xF5555555
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#2,#30
    LDR     R6,=0xEAAAAAAA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#1,#31
    LDR     R6,=0xD5555555
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    SBFX    R7,R8,#0,#32
    LDR     R6,=0xAAAAAAAA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0x55555555     /* Load positive value */
    /* SBFX - Encoding T1 32bit - "Data processing (plain binary immediate)" instruction */
    SBFX    R8,R7,#31,#1
    LDR     R6,=0x0
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#30,#2
    LDR     R6,=0x1
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#29,#3
    LDR     R6,=0x2
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#28,#4
    LDR     R6,=0x5
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#27,#5
    LDR     R6,=0xA
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#26,#6
    LDR     R6,=0x15
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#25,#7
    LDR     R6,=0x2A
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#24,#8
    LDR     R6,=0x55
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#23,#9
    LDR     R6,=0xAA
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#22,#10
    MOVW    R6,#0x155   /* Warning command LDR  R6,=0x155 was not compiled by GHS 2013.5.4 */
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#21,#11
    LDR     R6,=0x2AA
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#20,#12
    LDR     R6,=0x555
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#19,#13
    LDR     R6,=0xAAA
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#18,#14
    LDR     R6,=0x1555
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#17,#15
    LDR     R6,=0x2AAA
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#16,#16
    LDR     R6,=0x5555
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#15,#17
    LDR     R6,=0xAAAA
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#14,#18
    LDR     R6,=0x15555
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#13,#19
    LDR     R6,=0x2AAAA
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#12,#20
    LDR     R6,=0x55555
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#11,#21
    LDR     R6,=0xAAAAA
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#10,#22
    LDR     R6,=0x155555
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#9,#23
    LDR     R6,=0x2AAAAA
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#8,#24
    LDR     R6,=0x555555
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#7,#25
    LDR     R6,=0xAAAAAA
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#6,#26
    LDR     R6,=0x1555555
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#5,#27
    LDR     R6,=0x2AAAAAA
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#4,#28
    LDR     R6,=0x5555555
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#3,#29
    LDR     R6,=0xAAAAAAA
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#2,#30
    LDR     R6,=0x15555555
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#1,#31
    LDR     R6,=0x2AAAAAAA
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    SBFX    R8,R7,#0,#32
    LDR     R6,=0x55555555
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0C3E
    
    B m4_scst_alu_test4_ltorg_jump_5 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_alu_test4_ltorg_jump_5:
    
    /* UBFX */
    /* Verify zero extend to 32-bit */
    LDR     R11,=0xAAAAAAAA    /* Load negative value */
    /* UBFX - Encoding T1 32bit - "Data processing (plain binary immediate)" instruction */
    UBFX    R4,R11,#31,#1
    LDR     R6,=0x1
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#30,#2
    LDR     R6,=0x2
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#29,#3
    LDR     R6,=0x5
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#28,#4
    LDR     R6,=0xA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#27,#5
    LDR     R6,=0x15
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#26,#6
    LDR     R6,=0x2A
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#25,#7
    LDR     R6,=0x55
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#24,#8
    LDR     R6,=0xAA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#23,#9
    MOVW    R6,#0x155   /* Warning command LDR  R6,=0x155 was not compiled by GHS 2013.5.4 */
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#22,#10
    LDR     R6,=0x2AA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#21,#11
    LDR     R6,=0x555
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#20,#12
    LDR     R6,=0xAAA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#19,#13
    LDR     R6,=0x1555
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#18,#14
    LDR     R6,=0x2AAA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#17,#15
    LDR     R6,=0x5555
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#16,#16
    LDR     R6,=0xAAAA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#15,#17
    LDR     R6,=0x15555
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#14,#18
    LDR     R6,=0x2AAAA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#13,#19
    LDR     R6,=0x55555
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#12,#20
    LDR     R6,=0xAAAAA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#11,#21
    LDR     R6,=0x155555
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#10,#22
    LDR     R6,=0x2AAAAA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#9,#23
    LDR     R6,=0x555555
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#8,#24
    LDR     R6,=0xAAAAAA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#7,#25
    LDR     R6,=0x1555555
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#6,#26
    LDR     R6,=0x2AAAAAA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#5,#27
    LDR     R6,=0x5555555
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#4,#28
    LDR     R6,=0xAAAAAAA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#3,#29
    LDR     R6,=0x15555555
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#2,#30
    LDR     R6,=0x2AAAAAAA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#1,#31
    LDR     R6,=0x55555555
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    UBFX    R4,R11,#0,#32
    LDR     R6,=0xAAAAAAAA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R4,=0x55555555     /* Load positive value */
    /* UBFX - Encoding T1 32bit - "Data processing (plain binary immediate)" instruction */
    UBFX    R11,R4,#31,#1
    LDR     R6,=0x0
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#30,#2
    LDR     R6,=0x1
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#29,#3
    LDR     R6,=0x2
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#28,#4
    LDR     R6,=0x5
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#27,#5
    LDR     R6,=0xA
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#26,#6
    LDR     R6,=0x15
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#25,#7
    LDR     R6,=0x2A
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#24,#8
    LDR     R6,=0x55
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#23,#9
    LDR     R6,=0xAA
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#22,#10
    MOVW    R6,#0x155   /* Warning command LDR  R6,=0x155 was not compiled by GHS 2013.5.4 */
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#21,#11
    LDR     R6,=0x2AA
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#20,#12
    LDR     R6,=0x555
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#19,#13
    LDR     R6,=0xAAA
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#18,#14
    LDR     R6,=0x1555
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#17,#15
    LDR     R6,=0x2AAA
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#16,#16
    LDR     R6,=0x5555
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#15,#17
    LDR     R6,=0xAAAA
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#14,#18
    LDR     R6,=0x15555
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#13,#19
    LDR     R6,=0x2AAAA
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#12,#20
    LDR     R6,=0x55555
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#11,#21
    LDR     R6,=0xAAAAA
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#10,#22
    LDR     R6,=0x155555
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#9,#23
    LDR     R6,=0x2AAAAA
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#8,#24
    LDR     R6,=0x555555
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#7,#25
    LDR     R6,=0xAAAAAA
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#6,#26
    LDR     R6,=0x1555555
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#5,#27
    LDR     R6,=0x2AAAAAA
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#4,#28
    LDR     R6,=0x5555555
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#3,#29
    LDR     R6,=0xAAAAAAA
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#2,#30
    LDR     R6,=0x15555555
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#1,#31
    LDR     R6,=0x2AAAAAAA
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    UBFX    R11,R4,#0,#32
    LDR     R6,=0x55555555
    CMP     R11,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x05E3
    
    B m4_scst_alu_test4_ltorg_jump_6 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_alu_test4_ltorg_jump_6:
    
    /***************************************************************************************************
    * ALU operation type:
    *   - 00110 - Shift (BFI/BFC)
    *
    * Note: Shift (BFI/BFC) is linked with BFC,BFI
    *
    ***************************************************************************************************/
    /* BFI */
    /* Load values */    
    LDR     R5,=0xAAAAAAAA
    LDR     R10,=0xAAAAAAAA
    LDR     R3,=0x55555555
    
    /* BFI - Encoding T1 32bit - "Data processing (plain binary immediate)" instruction */
    BFI     R5,R10,#31,#1
    LDR     R6,=0x2AAAAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#30,#2
    LDR     R6,=0x6AAAAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#29,#3
    LDR     R6,=0x4AAAAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#28,#4
    LDR     R6,=0x5AAAAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#27,#5
    LDR     R6,=0x52AAAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#26,#6
    LDR     R6,=0x56AAAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#25,#7
    LDR     R6,=0x54AAAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#24,#8
    LDR     R6,=0x55AAAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#23,#9
    LDR     R6,=0x552AAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#22,#10
    LDR     R6,=0x556AAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#21,#11
    LDR     R6,=0x554AAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#20,#12
    LDR     R6,=0x555AAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#19,#13
    LDR     R6,=0x5552AAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#18,#14
    LDR     R6,=0x5556AAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#17,#15
    LDR     R6,=0x5554AAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#16,#16
    LDR     R6,=0x5555AAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#15,#17
    LDR     R6,=0x55552AAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#14,#18
    LDR     R6,=0x55556AAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#13,#19
    LDR     R6,=0x55554AAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#12,#20
    LDR     R6,=0x55555AAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#11,#21
    LDR     R6,=0x555552AA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#10,#22
    LDR     R6,=0x555556AA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#9,#23
    LDR     R6,=0x555554AA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#8,#24
    LDR     R6,=0x555555AA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#7,#25
    LDR     R6,=0x5555552A
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#6,#26
    LDR     R6,=0x5555556A
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#5,#27
    LDR     R6,=0x5555554A
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#4,#28
    LDR     R6,=0x5555555A
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#3,#29
    LDR     R6,=0x55555552
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#2,#30
    LDR     R6,=0x55555556
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R10,#1,#31
    LDR     R6,=0x55555554
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    BFI     R5,R3,#0,#32
    LDR     R6,=0x55555555
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    
    /* Load values */
    LDR     R10,=0x55555555
    LDR     R12,=0x55555555
    LDR     R5,=0xAAAAAAAA
    
    /* BFI - Encoding T1 32bit - "Data processing (plain binary immediate)" instruction */
    BFI     R10,R12,#31,#1
    LDR     R6,=0xD5555555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#30,#2
    LDR     R6,=0x95555555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#29,#3
    LDR     R6,=0xB5555555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#28,#4
    LDR     R6,=0xA5555555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#27,#5
    LDR     R6,=0xAD555555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#26,#6
    LDR     R6,=0xA9555555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#25,#7
    LDR     R6,=0xAB555555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#24,#8
    LDR     R6,=0xAA555555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#23,#9
    LDR     R6,=0xAAD55555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#22,#10
    LDR     R6,=0xAA955555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#21,#11
    LDR     R6,=0xAAB55555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#20,#12
    LDR     R6,=0xAAA55555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#19,#13
    LDR     R6,=0xAAAD5555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#18,#14
    LDR     R6,=0xAAA95555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#17,#15
    LDR     R6,=0xAAAB5555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#16,#16
    LDR     R6,=0xAAAA5555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#15,#17
    LDR     R6,=0xAAAAD555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#14,#18
    LDR     R6,=0xAAAA9555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#13,#19
    LDR     R6,=0xAAAAB555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#12,#20
    LDR     R6,=0xAAAAA555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#11,#21
    LDR     R6,=0xAAAAAD55
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#10,#22
    LDR     R6,=0xAAAAA955
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#9,#23
    LDR     R6,=0xAAAAAB55
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#8,#24
    LDR     R6,=0xAAAAAA55
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#7,#25
    LDR     R6,=0xAAAAAAD5
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#6,#26
    LDR     R6,=0xAAAAAA95
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#5,#27
    LDR     R6,=0xAAAAAAB5
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#4,#28
    LDR     R6,=0xAAAAAAA5
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#3,#29
    LDR     R6,=0xAAAAAAAD
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#2,#30
    LDR     R6,=0xAAAAAAA9
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R12,#1,#31
    LDR     R6,=0xAAAAAAAB
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    BFI     R10,R5,#0,#32
    LDR     R6,=0xAAAAAAAA
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0E69
    
    B m4_scst_alu_test4_ltorg_jump_7 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_alu_test4_ltorg_jump_7:
    
    /* BFC - Test all bits can be cleared */
    /* Load values */
    LDR     R3,=0x55555555
    LDR     R12,=0xAAAAAAAA
    
    /* BFC - Encoding T1 32bit - "Data processing (plain binary immediate)" instruction */
    BFC     R12,#31,#1
    LDR     R6,=0x2AAAAAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#30,#2
    LDR     R6,=0x15555555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#29,#3
    LDR     R6,=0x0AAAAAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#28,#4
    LDR     R6,=0x05555555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#27,#5
    LDR     R6,=0x02AAAAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#26,#6
    LDR     R6,=0x01555555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#25,#7
    LDR     R6,=0x00AAAAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#24,#8
    LDR     R6,=0x00555555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#23,#9
    LDR     R6,=0x002AAAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#22,#10
    LDR     R6,=0x00155555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#21,#11
    LDR     R6,=0x000AAAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#20,#12
    LDR     R6,=0x00055555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#19,#13
    LDR     R6,=0x0002AAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#18,#14
    LDR     R6,=0x00015555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#17,#15
    LDR     R6,=0x0000AAAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#16,#16
    LDR     R6,=0x00005555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#15,#17
    LDR     R6,=0x00002AAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#14,#18
    LDR     R6,=0x00001555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#13,#19
    LDR     R6,=0x00000AAA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#12,#20
    LDR     R6,=0x00000555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#11,#21
    LDR     R6,=0x000002AA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#10,#22
    MOVW    R6,#0x00000155
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#9,#23
    LDR     R6,=0x000000AA
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#8,#24
    LDR     R6,=0x00000055
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#7,#25
    LDR     R6,=0x0000002A
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#6,#26
    LDR     R6,=0x00000015
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#5,#27
    LDR     R6,=0x0000000A
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#4,#28
    LDR     R6,=0x0000005
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#3,#29
    LDR     R6,=0x0000002
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#2,#30
    LDR     R6,=0x0000001
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    BFC     R12,#1,#31
    LDR     R6,=0x0
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    BFC     R3,#0,#32
    LDR     R6,=0x0
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x073A
    
    B m4_scst_alu_test4_ltorg_jump_8 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_alu_test4_ltorg_jump_8:
    /***************************************************************************************************
    * ALU operation type:
    *   - 00111 - Shift (Saturation) 
    * 
    * Note: Shift (Saturation) is linked with SSAT, USAT instructions
    *
    ***************************************************************************************************/
    /* SSAT - Negative number */
    /* Load value to saturate */
    LDR     R2,=0x55555555 /* Will be shifted to 0xAAAAAAAA */
    
    BL      m4_scst_clear_flags
    SSAT    R3,#32,R2,LSL #1
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    LDR     R6,=0xAAAAAAAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#31,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xC0000000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#30,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xE0000000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#29,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xF0000000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#28,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xF8000000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#27,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFC000000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#26,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFE000000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#25,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFF000000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#24,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFF800000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#23,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFC00000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#22,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFE00000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#21,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFF00000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#20,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFF80000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#19,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFC0000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#18,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFE0000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#17,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFF0000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#16,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFF8000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#15,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFC000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#14,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFE000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#13,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFF000
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#12,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFF800
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#11,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFFC00
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#10,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFFE00
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#9,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFFF00
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#8,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFFF80
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#7,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFFFC0
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#6,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFFFE0
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#5,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFFFF0
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#4,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFFFF8
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#3,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFFFFC
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#2,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFFFFE
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#1,R2,LSL #1
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    B m4_scst_alu_test4_ltorg_jump_9 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_alu_test4_ltorg_jump_9:
    
    /* SSAT - Positive number */
    /* Load value to saturate */
    /* R2=#0x55555555 */
    BL      m4_scst_clear_flags
    SSAT    R3,#32,R2
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x55555555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#31,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x3FFFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#30,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x1FFFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#29,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x0FFFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#28,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x07FFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#27,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x03FFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#26,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x01FFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#25,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x00FFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#24,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x007FFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#23,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x003FFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#22,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x001FFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#21,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x000FFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#20,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x0007FFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#19,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x0003FFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#18,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x0001FFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#17,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#16,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x7FFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#15,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x3FFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#14,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x1FFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#13,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x0FFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#12,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x07FF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#11,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x03FF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#10,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x01FF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#9,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#8,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x7F
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#7,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x3F
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#6,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x1F
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#5,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#4,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x7
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#3,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x3
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#2,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x1
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    SSAT    R3,#1,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x0
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0895
    
    B m4_scst_alu_test4_ltorg_jump_10 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_alu_test4_ltorg_jump_10:
    
    /* USAT - Positive number */
    /* Load value to saturate */
    /* R2=#0x55555555 */
    BL      m4_scst_clear_flags
    USAT    R3,#31,R2
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x55555555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#30,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x3FFFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#29,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x1FFFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#28,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x0FFFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#27,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x07FFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#26,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x03FFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#25,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x01FFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#24,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x00FFFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#23,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x007FFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#22,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x003FFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#21,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x001FFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#20,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x000FFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#19,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x0007FFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#18,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x0003FFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#17,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x0001FFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#16,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFFFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#15,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x7FFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#14,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x3FFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#13,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x1FFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#12,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x0FFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#11,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x07FF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#10,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x03FF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#9,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x01FF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#8,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xFF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#7,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x7F
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#6,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x3F
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#5,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x1F
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#4,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0xF
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#3,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x7
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#2,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x3
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#1,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x1
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#0,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x0
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x04FD
    
    
    /* Verify that value will not be saturated */
    /* Use ASR shift and verify Q flag was not set */
    BL      m4_scst_clear_flags
    USAT    R3,#30,R2,ASR #1
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x2AAAAAAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0A59
    
    
    /* USAT - Negative number */
    /* Negative value must be saturated to zero */
    /* Load value to saturate */
    LDR     R2,=0xAAAAAAAA
    
    BL      m4_scst_clear_flags
    USAT    R3,#31,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x0
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    USAT    R3,#0,R2
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    LDR     R6,=0x0
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0E7A
    
    MOV     R0,R9          /* Test result is returned in R0, according to the conventions */
    
    B       m4_scst_test_tail_end
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    