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
* Test ALU module - ALU move operations/types
*
* Overall coverage:
* -----------------
* ALU control bus:
* - ALU operation type:
*   - MOV (MSR flag/GE write depending on size register)
*   - MOV (normal)
*   - MOV (RBIT)
*   - MOV (MOVT)
*
* DECODER
*   - Encoding of "Miscellaneous 16-bit instructions" instructions
*   - Encoding of "Data processing (register)" - Miscellaneous operations 32-bit
* 
* 测试总结：
* -------------
* 测试 ALU 模块 - ALU 移动操作/类型
*
* 整体覆盖：
* -----------------
* ALU 控制总线：
* - ALU 操作类型：
* - MOV（MSR 标志/GE 写入取决于大小寄存器）
* - MOV（正常）
* - MOV (RBIT)
* - MOV (MOVT)
*
* 解码器
* - “杂项 16 位指令”指令的编码
* - “数据处理（寄存器）”的编码 - 其他操作 32 位
*
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    
    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_alu_test5

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    SCST_EXTERN m4_scst_clear_flags

    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_alu_test5" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_alu_test5, function)
m4_scst_alu_test5:

    PUSH.W  {R1-R12,R14}
    
    /* R9 is used as intermediate result */
    MOV     R9,#0x0
    
    /***************************************************************************************************
    * ALU operation type:
    *   - 01000 - MOV (MSR flag/GE write depending on size register)
    * 
    * Note: Note, only APSR available in the unprivileged mode.
    *
    ***************************************************************************************************/
    LDR     R2,=0xF8000000 /* N,Z,C,V,Q flags */
    
    BL      m4_scst_clear_flags
    
    LDR     R4,=0x000F0000  /* Set GE bits */
    
    SCST_OPCODE_START /* opcode for MSR APSR_g, R4 */
    SCST_OPCODE32_HIGH(0xF384)
    SCST_OPCODE32_LOW( 0x8400)    
    SCST_OPCODE_END
    
    MSR     APSR_nzcvq,R2 /* Set flags */        
    ISB     /* Fix problem with ETM-Trace on S32K14x, see CSTL-587 */
    ORR     R2,R2,R4        /* We have to prepare APSR expected value */
    
    MRS     R3,APSR /* Read flags */
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0D57
    
    
    /***************************************************************************************************
    * ALU operation type:
    * - 10100 - MOV (normal)
    *
    * Note: Linked with MOV, MOVW, SXTH, SXTB, UXTH, UXTB instructions
    *
    ***************************************************************************************************/
    /* MOV */
    MOV.W   R10,#0x55555555  /* Use immediate value*/
    /* MOV (register) Encoding T1 16bit */
    MOV.N   R5,R10   
    CMP     R5,#0x55555555
    BNE     m4_scst_test_tail_end
    
    MOV.W   R5,#0xAAAAAAAA   /* Use immediate value*/
    /* MOV (register) Encoding T1 16bit */
    MOV.N   R10,R5
    CMP     R10,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    MOV.W   R10,#0x33333333  /* Use immediate value*/
    /* MOV (register) Encoding T3 16bit */
    MOV.W   R5,R10   
    CMP     R5,#0x33333333
    BNE     m4_scst_test_tail_end
    
    MOV.W   R5,#0xCCCCCCCC   /* Use immediate value*/
    /* MOV (register) Encoding T3 16bit  */
    MOV.W   R10,R5
    CMP     R10,#0xCCCCCCCC
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0987
    
    /* MOVW */
    MOVW    R3,#0x5555  /* Use immediate value*/
    LDR     R2,=0x5555
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    
    MOVW    R2,#0xAAAA  /* Use immediate value*/
    MOV     R3,R2
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0A53
    
    /* SXTB */
    LDR     R2,=0xCC33AA55
    /* SXTB Encoding T1 16bit - "Miscellaneous 16-bit instructions" instruction */
    SXTB.N  R5,R2
    LDR     R6,=0x55
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    
    SXTB    R3,R2,ROR #8
    LDR     R6,=0xFFFFFFAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0E36
    
    /* UXTB */
    /* UXTB Encoding T1 16bit - "Miscellaneous 16-bit instructions" instruction */
    UXTB.N  R3,R2
    LDR     R6,=0x55
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    UXTB    R3,R2,ROR #8
    LDR     R6,=0xAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0785
    
    /* SXTH */
    LDR     R5,=0xAAAA5555
    /* SXTH Encoding T1 16bit - "Miscellaneous 16-bit instructions" instruction */
    SXTH.N  R4,R5
    LDR     R6,=0x5555
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    SXTH    R3,R5,ROR #16
    LDR     R6,=0xFFFFAAAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0698
    
    /* UXTH */
    /* UXTH Encoding T1 16bit - "Miscellaneous 16-bit instructions" instruction */
    UXTH.N  R3,R5
    LDR     R6,=0x5555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    UXTH    R3,R5,ROR #16
    LDR     R6,=0xAAAA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0943
    
    
    /***************************************************************************************************
    * ALU operation type:
    * - 10101 - MOV (RBIT)
    *
    * Note: Linked with RBIT
    *
    ***************************************************************************************************/
    LDR     R11,=0xAAAAAAAA
    /* RBIT Encoding T1 32bit - "Miscellaneous operations" instruction */
    RBIT    R4,R11
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R4,=0x55555555
    /* RBIT Encoding T1 32bit - "Miscellaneous operations" instruction */
    RBIT    R11,R4
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0EAF
    
    
    /***************************************************************************************************
    * ALU operation type:
    * - 10111 - MOV (MOVT)
    *
    * Note: Linked with MOVT
    *
    ***************************************************************************************************/
    LDR     R3,=0x55555555
    MOVT    R3,#0xAAAA
    LDR     R6,=0xAAAA5555
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0xAAAAAAAA
    MOVT    R6,#0x5555
    LDR     R3,=0x5555AAAA
    CMP     R6,R3
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x05F3
    
    
    /***************************************************************************************************
    * ALU operation type:
    * - 10110 - MOV (REV)
    *
    * Note: Linked with REV, REVSH, REV16
    *
    ***************************************************************************************************/
    /* REV */
    LDR     R2,=0x55AA33CC
    
    /* REV Encoding T1 16bit - "Miscellaneous 16-bit instructions" instruction */
    REV.N   R5,R2
    LDR     R6,=0xCC33AA55
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    
    /* REV Encoding T1 16bit - "Miscellaneous 16-bit instructions" instruction */
    REV.N   R2,R5
    LDR     R6,=0x55AA33CC
    CMP     R2,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R5,=0xAA55CC33
    /* REV Encoding T2 32bit - "Miscellaneous operations" instruction */
    REV.W   R10,R5
    LDR     R6,=0x33CC55AA
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    
    /* REV Encoding T2 32bit - "Miscellaneous operations" instruction */
    REV.W   R5,R10
    LDR     R6,=0xAA55CC33
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0734
    
    /* REVSH */
    LDR     R4,=0x000055AA
    /* REVSH Encoding T1 16bit - "Miscellaneous 16-bit instructions" instruction */
    REVSH.N R3,R4
    LDR     R6,=0xFFFFAA55
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    /* REVSH */
    LDR     R3,=0xFFFFCC33
    /* REVSH Encoding T1 16bit - "Miscellaneous 16-bit instructions" instruction */
    REVSH.N R4,R3
    LDR     R6,=0x33CC
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0xFFFFAA55    
    /* REVSH Encoding T2 32bit - "Miscellaneous operations" instruction */
    REVSH.W R3,R12
    LDR     R6,=0x55AA
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0x000033CC
    /* REVSH Encoding T2 32bit - "Miscellaneous operations" instruction */
    REVSH.W R12,R3
    LDR     R6,=0xFFFFCC33
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x08A4
    
    /* REV16 */
    LDR     R0,=0x55AAAA55
    /* REV16 Encoding T1 16bit - "Miscellaneous 16-bit instructions" instruction */
    REV16.N R7,R0
    LDR     R6,=0xAA5555AA
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    
    /* REV16 */
    LDR     R7,=0x33CCCC33
    /* REV16 Encoding T1 16bit - "Miscellaneous 16-bit instructions" instruction */
    REV16.N R0,R7
    LDR     R6,=0xCC3333CC
    CMP     R0,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0xAA5555AA
    /* REV16 Encoding T2 32bit - "Miscellaneous operations" instruction */
    REV16.W R8,R7
    LDR     R6,=0x55AAAA55
    CMP     R8,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0xCC3333CC
    /* REV16 Encoding T2 32bit - "Miscellaneous operations" instruction */
    REV16.W R7,R8
    LDR     R6,=0x33CCCC33
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0319
    
    
    MOV     R0,R9          /* Test result is returned in R0, according to the conventions */
    
    B       m4_scst_test_tail_end
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    