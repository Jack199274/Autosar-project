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
* Test ALU module - Verify ALU Flag write control.
*
* Overall coverage:
* -----------------
* ALU control bus:
* - inline shift carry control
* - flag write control
* - ALU MUL flag
*
* DECODER:
* Thumb (16-bit) 
*   - Encoding of "Data processing" instructions
*   - Encoding of "Shift (immediate), add, subtract, move, and compare" instructions
* 测试总结：
* -------------
* 测试 ALU 模块 - 验证 ALU 标志写入控制。
*
* 整体覆盖：
* -----------------
* ALU 控制总线：
* - 内联移位进位控制
* - 标志写控制
* - ALU MUL 标志
*
* 解码器：
* 拇指（16 位）
* - “数据处理”指令的编码
* - “移位（立即）、加、减、移动和比较”指令的编码
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_alu_test2

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    SCST_EXTERN m4_scst_clear_flags
    SCST_EXTERN m4_scst_check_flags_cleared
    
    
    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_alu_test2" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_alu_test2, function)
m4_scst_alu_test2:

    PUSH.W  {R1-R12,R14}
    
    /* R9 is used as intermediate result */
    MOV     R9,#0x0
    
    /***************************************************************************************************
    * - flag write control (flags - N,Z,C,V)
    *   11 - NZCV
    *
    *   Note1: ALU - Flags N,Z,C,V are updated by ADCS, ADDS, CMN, CMP, RSBS, SBCS, SUBS instructions
    *   Note2: DECODER - Use all possible encodings types to check that they updates flags.
    * - 标志写入控制（标志 - N、Z、C、V）
     * 11 - NZCV
     *
     * 注 1：ALU - 标志 N、Z、C、V 由 ADCS、ADDS、CMN、CMP、RSBS、SBCS、SUBS 指令更新
     * 注 2：解码器 - 使用所有可能的编码类型来检查它们是否更新了标志。
    ***************************************************************************************************/
    /* --CMN-- */
    /* We need to check that CMN instruction updates N,Z,C,V flags  我们需要检查 CMN 指令是否更新了 N、Z、C、V 标志 */
    BL      m4_scst_clear_flags
    
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    MOV     R0,#0x0
    LDR.W   R7,=0x55555555
    /* CMN(register) Encoding T1 16bit */
    /* <Rm[5:3]>:R0  0b000
       <Rn[2:0]>:R7  0b111*/
    CMN.N   R0,R7    /* Clear N,Z,C,V */
    BL      m4_scst_check_flags_cleared
    
    /* Set N - Clear Z,C,V */
    MOV     R4,#0x70000000  /* Set Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR.W     R7,=0xAAAAAAAA
    MOV     R0,#0x0
    /* CMN(register) Encoding T1 16bit */
    /* <Rm[5:3]>:R7  0b111
       <Rn[2:0]>:R0  0b000*/
    CMN.N   R7,R0                   /* Set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N,C,V */
    MOV     R4,#0xB0000000  /* Set N,C,V */
    MSR     APSR_nzcvq,R4
    MOV     R5,#0x0
    MOV     R2,#0x0
    /* CMN(register) Encoding T1 16bit */
    CMN.N   R5,R2                   /* Set Z flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set C - Clear N,Z,V */
    MOV     R4,#0xD0000000  /* Set N,C,V */
    MSR     APSR_nzcvq,R4    
    LDR     R5,=0xFFFFFFFF
    MOV     R10,#0x2
    /* CMN(register) Encoding T2 32bit */
    CMN.W   R5,R10                  /* Set C flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
        
    /* Set C,V - Clear N,Z */
    MOV     R4,#0xC0000000  /* Set N,Z */
    MSR     APSR_nzcvq,R4
    LDR     R10,=0xFFFFFFFF
    LDR     R5,=0x80000000
    /* CMN(register) Encoding T2 32bit */
    CMN.W   R10,R5                  /* Set C,V flags */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set N,C - Clear Z,V */
    MOV     R4,#0x50000000  /* Set Z,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    /* CMN(immediate) Encoding T1 32bit */
    CMN.W   R1,#0xFFFFFFFF          /* Set N,C flags */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z,C - Clear N,V */
    MOV     R4,#0x90000000  /* Set N,V */
    MSR     APSR_nzcvq,R4
    LDR     R6,=0xFFFFFFFF
    /* CMN(immediate) Encoding T1 32bit */
    CMN.W   R6,#0x1                 /* Set Z,C flags */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x0256
    
    
    /* --CMP-- */
    /* We need to check that CMP instruction updates N,Z,C,V flags */
    BL      m4_scst_clear_flags
    
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    MOV     R1,#0x0
    LDR     R2,=0xAAAAAAAB
    /* CMP(register) Encoding T1 16bit */
    /* <Rm[5:3]>:R1  0b001
       <Rn[2:0]>:R2  0b010*/
    CMP.N   R1,R2    /* Clear N,Z,C,V */
    BL      m4_scst_check_flags_cleared
    
    /* Set N - Clear Z,C,V */
    MOV     R4,#0x70000000  /* Set Z,C,V */
    MSR     APSR_nzcvq,R4
    MOV     R10,#0x0
    LDR     R12,=0x55555556
    /* CMP(register) Encoding T2 16bit - "Special data" instruction !! */
    CMP.N   R10,R12                 /* Set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set C - Clear N,Z,V */
    MOV     R4,#0xD0000000  /* Set N,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R12,=0xFFFFFFFF
    LDR     R3,=0xFFFFFFFE
    /* CMP(register) Encoding T3 32bit */
    CMP.W   R12,R3                  /* Set C flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z,C - Clear N,V */
    MOV     R4,#0x90000000  /* Set N,V */
    MSR     APSR_nzcvq,R4
    MOV     R2,#0x55
    /* CMP(immediate) Encoding T1 16bit */
    CMP.N   R2,#0x55      /* Clear N,V */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is not !! */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set N - Clear Z,C,V */
    MOV     R4,#0x60000000  /* Set Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R5,=0x55
    /* CMP(immediate) Encoding T1 16bit */
    CMP.N   R5,#0xAA                /* Set C,V flags */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set N,V - Clear Z,C */
    MOV     R4,#0x60000000  /* Set Z,C */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x7FFFFFFF
    /* CMP(immediate) Encoding T2 32bit */
    CMP.W   R1,#0xFFFFFFFF                /* Set C,V flags */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    ADDW    R9,R9,#0x0C59
    
    
    /* --ADDS-- */
    /* We need to check that ADDS instruction updates N,Z,C,V flags 我们需要检查 ADDS 指令是否更新了 N、Z、C、V 标志*/
    BL      m4_scst_clear_flags
    
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x55555555
    MOV     R2,#0x0
    /* ADDS(register) Encoding T1 16bit */
    ADDS.N  R3,R1,R2    /* Clear N,Z,C,V */
    BL      m4_scst_check_flags_cleared
    
    /* Set N - Clear Z,C,V */
    MOV     R4,#0x70000000  /* Set Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    MOV     R2,#0x0
    /* ADDS(register) Encoding T1 16bit */
    ADDS.N  R3,R1,R2                /* Set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N,C,V */
    MOV     R4,#0xB0000000  /* Set N,C,V */
    MSR     APSR_nzcvq,R4
    MOV     R12,#0x0
    MOV     R10,#0x0
    /* ADDS(register) Encoding T3 32bit */
    ADDS.W  R3,R12,R10              /* Set Z flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z,C - Clear N,V */
    MOV     R4,#0x90000000  /* Set N,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xFFFFFFFF
    /* ADDS(immediate) Encoding T1 16bit */
    ADDS.N  R3,R1,#0x1                /* Set Z,C flags */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set C - Clear N,Z,V */
    MOV     R4,#0xD0000000  /* Set N,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xFFFFFF8A
    /* ADDS(immediate) Encoding T2 16bit */
    ADDS.N  R1,#0x77           /* Set C flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set C,V - Clear N,Z */
    MOV     R4,#0xC0000000  /* Set N,Z */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xFFFFFFFF
    /* ADDS(immediate) Encoding T3 32bit */
    ADDS.W  R3,R1,#0x80000000                /* Set C,V flags */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set N,C - Clear Z,V */
    MOV     R4,#0x50000000  /* Set Z,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    /* ADDS(immediate) Encoding T3 32bit */
    ADDS.W  R3,R1,#0xFFFFFFFF                /* Set N,C flags */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x01D5
    
    
    /* --SUBS--  */
    /* We need to check that SUBS instruction updates N,Z,C,V flags */
    BL      m4_scst_clear_flags
    
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    MOV     R1,#0x0
    LDR     R2,=0xAAAAAAAB
    /* SUBS (register) Encoding T1 16bit */
    SUBS.N  R3,R1,R2    /* Clear N,Z,C,V */
    BL      m4_scst_check_flags_cleared
    
    /* Set Z,C - Clear N,V */
    MOV     R4,#0x90000000  /* Set N,V */
    MSR     APSR_nzcvq,R4
    MOV     R1,#0x0
    MOV     R2,#0x0
    /* SUBS (register) Encoding T1 16bit */
    SUBS.N  R3,R1,R2                /* Set Z,C flags */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set C - Clear N,Z,V */
    MOV     R4,#0xD0000000  /* Set N,Z,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xFFFFFFFF
    LDR     R2,=0xFFFFFFFE
    /* SUBS(register) Encoding T2 32bit */
    SUBS.W  R3,R1,R2                /* Set C flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set N - Clear Z,C,V */
    MOV     R4,#0x70000000  /* Set Z,C,V */
    MSR     APSR_nzcvq,R4
    MOV     R1,#0x0
    /* SUBS(immediate) Encoding T1 16bit */
    SUBS.N  R3,R1,#0x3              /* Set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set N - Clear Z,C,V */
    MOV     R4,#0x70000000  /* Set Z,C,V */
    MSR     APSR_nzcvq,R4
    MOV     R1,#0x0
    /* SUBS(immediate) Encoding T3 16bit */
    SUBS.N  R1,#0x88                /* Set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set N,V - Clear Z,C */
    MOV     R4,#0x60000000  /* Set Z,C */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x7FFFFFFF
    /* SUBS(immediate) Encoding T3 32bit */
    SUBS.W  R3,R1,#0xFFFFFFFF       /* Set C,V flags */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    ADDW    R9,R9,#0x0B83
    
    
    /* --ADCS-- */
    /* We need to check that ADCS instruction updates N,Z,C,V flags */
    BL      m4_scst_clear_flags
    
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x55555555
    MOV     R2,#0x0
    /* ADCS(register) Encoding T1 16bit */
    ADCS.N  R1,R2    /* Clear N,Z,C,V */
    BL      m4_scst_check_flags_cleared
    
    /* Set N - Clear Z,C,V */
    MOV     R4,#0x70000000  /* Set Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    MOV     R2,#0x0
    /* ADCS(register) Encoding T1 16bit */
    ADCS.N  R1,R2                /* Set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N,V */
    MOV     R4,#0x90000000  /* Set N,V */
    MSR     APSR_nzcvq,R4
    MOV     R1,#0x0
    MOV     R2,#0x0
    /* ADCS(register) Encoding T1 16bit */
    ADCS.N  R1,R2                /* Set Z flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set C - Clear N,Z,V */
    MOV     R4,#0xD0000000  /* Set N,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xFFFFFFFF
    MOV     R2,#0x2
    /* ADCS(register) Encoding T2 32bit */
    ADCS.W  R3,R1,R2                /* Set C flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set C,V - Clear N,Z */
    MOV     R4,#0xC0000000  /* Set N,Z */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xFFFFFFFF
    LDR     R2,=0x80000000
    /* ADCS(register) Encoding T2 32bit */
    ADCS.W  R3,R1,R2                /* Set C,V flags */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set N,C - Clear Z,V */
    MOV     R4,#0x50000000  /* Set Z,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    /* ADCS(immediate) Encoding T1 32bit */
    ADCS.W  R3,R1,#0xFFFFFFFF       /* Set N,C flags */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z,C - Clear N,V */
    MOV     R4,#0x90000000  /* Set N,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xFFFFFFFF
    /* ADCS(immediate) Encoding T1 32bit */
    ADCS.W  R3,R1,#0x1              /* Set Z,C flags */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x048F
    
    B m4_scst_alu_test2_ltorg_jump_1 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_alu_test2_ltorg_jump_1:
    
    /* --SBCS-- */
    /* We need to check that SBCS instruction updates N,Z,C,V flags */
    BL      m4_scst_clear_flags
    
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    MOV     R1,#0x0
    LDR     R2,=0xAAAAAAAB
    /* SBCS(register) Encoding T1 16bit */
    SBCS.N  R1,R2    /* Clear N,Z,C,V */
    BL      m4_scst_check_flags_cleared
    
    /* Set N - Clear Z,C,V */
    MOV     R4,#0x70000000  /* Set Z,C,V */
    MSR     APSR_nzcvq,R4
    MOV     R1,#0x0
    LDR     R2,=0x55555556
    /* SBCS(register) Encoding T1 16bit */
    SBCS.N  R1,R2                /* Set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z,C - Clear N,V */
    MOV     R4,#0x90000000  /* Set N,V */
    MSR     APSR_nzcvq,R4
    MOV     R1,#0x1
    MOV     R2,#0x0
    /* SBCS(register) Encoding T2 32bit */
    SBCS.W  R3,R1,R2                /* Set Z,C flags */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set C - Clear N,Z,V */
    MOV     R4,#0xD0000000  /* Set N,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xFFFFFFFF
    LDR     R2,=0xFFFFFFFD
    /* SBCS(register) Encoding T2 32bit */
    SBCS.W  R3,R1,R2                /* Set C flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set N,V - Clear Z,C */
    MOV     R4,#0x60000000  /* Set Z,C */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x7FFFFFFF
    /* SBCS(immediate) Encoding T1 32bit */
    SBCS.W  R3,R1,#0xFFFFFFFF       /* Set C,V flags */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    ADDW    R9,R9,#0x05B8
    
    
    /* --RSBS-- */
    /* We need to check that RSBS instruction updates N,Z,C,V flags */
    BL      m4_scst_clear_flags
    
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R2,=0xAAAAAAAB
    /* RSBS(immediate) Encoding T1 16bit */
    /* RSBS.N  R3,R2,#0x0    Clear C,V flags */
    SCST_OPCODE_START
    SCST_OPCODE16(0x4253)   /* Use Instruction OpCode to avoid problem with compiler GHS 2013.5.4 */
    SCST_OPCODE_END
    
    BL      m4_scst_check_flags_cleared
    
    /* Set N - Clear Z,C,V */
    MOV     R4,#0x70000000  /* Set Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R2,=0xAAAAAAAB
    LDR     R1,=0xAAAAAAAA
    /* RSBS(register) Encoding T1 32bit */
    RSBS.W  R3,R2,R1        /* Set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !!*/
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set N,C - Clear Z,V */
    MOV     R4,#0x50000000  /* Set Z,V */
    MSR     APSR_nzcvq,R4
    LDR     R2,=0x55555555
    LDR     R3,=0xD5555555
    /* RSBS(register) Encoding T1 32bit */
    RSBS    R3,R2,R3        /* Set N,C flags */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set C - Clear N,Z,V */
    MOV     R4,#0xD0000000  /* Set N,Z,V */
    MSR     APSR_nzcvq,R4
    LDR     R2,=0xAAAAAAA9
    LDR     R1,=0xAAAAAAAA /* Will be shifted to 0xAAAAAAAA */
    /* RSBS(register) Encoding T1 32bit */
    RSBS    R3,R2,R1        /* Set C flags */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z,C - Clear N,V */
    MOV     R4,#0x90000000  /* Set N,V */
    MSR     APSR_nzcvq,R4
    LDR     R2,=0x55555555
    LDR     R1,=0x55555555
    /* RSBS(register) Encoding T1 32bit */
    RSBS    R3,R2,R1        /* Set Z,C flags */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set N,V - Clear Z,C */
    MOV     R4,#0x60000000  /* Set Z,C */
    MSR     APSR_nzcvq,R4
    LDR     R2,=0xAAAAAAAA
    /* RSBS(immediate) Encoding T2 32bit */
    RSBS.W  R3,R2,#0x55555555    /* Set N,V flags */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set C,V - Clear N,Z */
    MOV     R4,#0xC0000000  /* Set N,Z */
    MSR     APSR_nzcvq,R4
    LDR     R2,=0x55555555
    /* RSBS(immediate) Encoding T2 32bit */
    RSBS.W  R3,R2,#0xAAAAAAAA    /* Set C,V flags */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    ADDW    R9,R9,#0x0C62
    
    
    /***************************************************************************************************
    * - flag write control (flags - N,Z,C)
    *   10 - NZC
    *
    *   Note1: ALU - N,Z,C flags are updated by the ASRS, LSLS, LSRS, RORS, RRXS instructions
    *   Note2: DECODER - Use all possible encodings types to check that they updates flags.
    ***************************************************************************************************/
    /* --ASRS-- */
    /* We need to check that ASRS instruction updates N,Z,C flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z,C */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    MOV     R2,#0x2
    /* ASRS(immediate) Encoding T1 16bit */
    ASRS.N  R3,R2,#1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !!*/
    
    /* Set N - Clear Z,C */
    MOV     R4,#0x60000000  /* Set Z,C */
    MSR     APSR_nzcvq,R4
    LDR     R2,=0x80000000
    /* ASRS(immediate) Encoding T1 16bit */
    ASRS.N  R3,R2,#31
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N,C */
    MOV     R4,#0xA0000000  /* Set N,C */
    MSR     APSR_nzcvq,R4
    LDR     R5,=0x0
    /* ASRS(immediate) Encoding T2 32bit */
    ASRS.W  R10,R5,#1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set C - Clear N,Z */
    MOV     R4,#0xC0000000  /* Set N,Z */
    MSR     APSR_nzcvq,R4
    LDR     R10,=0x3
    /* ASRS(immediate) Encoding T2 32bit */
    ASRS.W  R5,R10,#1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set N,C - Clear Z */
    MOV     R4,#0x40000000  /* Set Z */
    MSR     APSR_nzcvq,R4
    LDR     R1,=32
    LDR     R3,=0x80000000
    /* ASRS(register) Encoding T1 16bit */
    ASRS.N  R3,R1
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z,C - Clear N */
    MOV     R4,#0x80000000  /* Set N */
    MSR     APSR_nzcvq,R4
    MOV     R2,#0x1
    MOV     R1,#1
    /* ASRS(register) Encoding T2 32bit */
    ASRS.W  R3,R2,R1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x03EA
    
    B m4_scst_alu_test2_ltorg_jump_2 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_alu_test2_ltorg_jump_2:
    
    
    /* --LSRS-- */
    /* We need to check that LSRS instruction updates N,Z,C flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z,C */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    MOV     R2,#0x2
    /* LSRS(immediate) Encoding T1 16bit */
    LSRS.N  R3,R2,#1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set Z - Clear N,C */
    MOV     R4,#0xA0000000  /* Set N,C */
    MSR     APSR_nzcvq,R4
    LDR     R2,=0x0
    /* LSRS(immediate) Encoding T2 32bit */
    LSRS.W  R3,R2,#1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set C - Clear N,Z */
    MOV     R4,#0xC0000000  /* Set N,Z */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x1
    LDR     R3,=0x3
    /* LSRS(register) Encoding T1 16bit */
    LSRS.N  R3,R1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z,C - Clear N */
    MOV     R4,#0x80000000  /* Set N */
    MSR     APSR_nzcvq,R4
    MOV     R2,#0x1
    MOV     R1,#1
    /* LSRS(register) Encoding T2 32bit */
    LSRS.W  R3,R2,R1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x04B8
    
    
    /* --LSLS-- */
    /* We need to check that LSLS instruction updates N,Z,C flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z,C */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    MOV     R2,#0x2
    /* LSLS(immediate) Encoding T1 16bit */
    LSLS.N  R3,R2,#1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !!*/
    
    /* Set N - Clear Z,C */
    MOV     R4,#0x60000000  /* Set Z,C */
    MSR     APSR_nzcvq,R4
    LDR     R2,=0x00000001
    /* LSLS(immediate) Encoding T1 16bit */
    LSLS.N  R3,R2,#31
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N,C */
    MOV     R4,#0xA0000000  /* Set N,C */
    MSR     APSR_nzcvq,R4
    LDR     R2,=0x0
    /* LSLS(immediate) Encoding T2 32bit */
    LSLS.W  R3,R2,#1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set C - Clear N,Z */
    MOV     R4,#0xC0000000  /* Set N,Z */
    MSR     APSR_nzcvq,R4
    MOV     R1,#1
    LDR     R3,=0x90000000
    /* LSLS(register) Encoding T1 16bit */
    LSLS.N  R3,R1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set N,C - Clear Z */
    MOV     R4,#0x40000000  /* Set Z */
    MSR     APSR_nzcvq,R4
    MOV     R1,#1
    LDR     R2,=0xC0000000
    /* LSLS(register) Encoding T2 32bit */
    LSLS.W  R3,R2,R1
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z,C - Clear N */
    MOV     R4,#0x80000000  /* Set N */
    MSR     APSR_nzcvq,R4
    MOV     R1,#1
    MOV     R2,#0x80000000
    /* LSLS(register) Encoding T2 32bit */
    LSLS.W  R3,R2,R1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x07CE
    
    
    /* --RORS-- */
    /* We need to check that RORS instruction updates N,Z,C flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z,C */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    MOV     R2,#0x2
    /* RORS(immediate) Encoding T1 32bit */
    RORS.W  R3,R2,#1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set Z - Clear N,C */
    MOV     R4,#0xA0000000  /* Set N,C */
    MSR     APSR_nzcvq,R4
    MOV     R1,#1
    LDR     R3,=0x0
    /* RORS(register) Encoding T1 16bit */
    RORS.N  R3,R1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set N,C - Clear Z */
    MOV     R4,#0x40000000  /* Set Z */
    MSR     APSR_nzcvq,R4
    MOV     R1,#2
    LDR     R2,=0x00000003
    /* RORS(register) Encoding T2 32bit */
    RORS.W  R3,R2,R1
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x092F
    
    
    /* --RRX-- */
    /* We need to check that RRX instruction updates N,Z,C flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z,C */
    MOV     R4,#0xD0000000  /* Set N,Z,V - Do not set C */
    MSR     APSR_nzcvq,R4
    MOV     R2,#0x2
    /* RRX Encoding T1 32bit */
    SCST_OPCODE_START   /* Used opcode due to compiler problem */
    SCST_OPCODE32_HIGH(0xEA5F)  /* RRXS    R3,R2 */
    SCST_OPCODE32_LOW(0x0332)
    SCST_OPCODE_END
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !!*/
    
    /* Set N - Clear Z,C */
    MOV     R4,#0x60000000  /* Set Z,C */
    MSR     APSR_nzcvq,R4
    MOV     R2,#0x0
    /* RRX Encoding T1 32bit */
    SCST_OPCODE_START   /* Used opcode due to compiler problem */
    SCST_OPCODE32_HIGH(0xEA5F)  /* RRXS    R3,R2 */
    SCST_OPCODE32_LOW(0x0332)
    SCST_OPCODE_END
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set N,C - Clear Z */
    MOV     R4,#0x60000000  /* Set Z,C - Carry must be set */
    MSR     APSR_nzcvq,R4
    MOV     R2,#0x1
    /* RRX Encoding T1 32bit */
    SCST_OPCODE_START   /* Used opcode due to compiler problem */
    SCST_OPCODE32_HIGH(0xEA5F)  /* RRXS    R3,R2 */
    SCST_OPCODE32_LOW(0x0332)
    SCST_OPCODE_END
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is not !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N,C */
    MOV     R4,#0x80000000  /* Set N  - Carry must be cleared */
    MSR     APSR_nzcvq,R4
    MOV     R2,#0x0
    /* RRX Encoding T1 32bit */
    SCST_OPCODE_START   /* Used opcode due to compiler problem */
    SCST_OPCODE32_HIGH(0xEA5F)  /* RRXS    R3,R2 */
    SCST_OPCODE32_LOW(0x0332)
    SCST_OPCODE_END
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z,C - Clear N */
    MOV     R4,#0x80000000  /* Set N */
    MSR     APSR_nzcvq,R4
    MOV     R2,#0x1
    /* RRX Encoding T1 32bit */
    SCST_OPCODE_START   /* Used opcode due to compiler problem */
    SCST_OPCODE32_HIGH(0xEA5F)  /* RRXS    R3,R2 */
    SCST_OPCODE32_LOW(0x0332)
    SCST_OPCODE_END
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set C flag - Clear N,Z */
    MOV     R4,#0xC0000000  /* Set N,Z */
    MSR     APSR_nzcvq,R4
    LDR     R2,=0x80000001
    /* RRX Encoding T1 32bit */
    SCST_OPCODE_START   /* Used opcode due to compiler problem */
    SCST_OPCODE32_HIGH(0xEA5F)  /* RRXS    R3,R2 */
    SCST_OPCODE32_LOW(0x0332)
    SCST_OPCODE_END
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x025A
    
    
    /***************************************************************************************************
    * - flag write control (flags - N,Z)
    *   01 - NZ
    *
    *   Note1: ALU - N,Z flags are updated by the ANDS, BICS, EORS, MOVS, MVNS, ORNS, ORRS, TEQ, TST instructions
    *   Note2: DECODER - Use all possible encodings types to check that they updates flags.
    *   Note3: DECODER - Focus on encoding of Data processing instructions
    ***************************************************************************************************/
    /* --ANDS-- */
    /* We need to check that ANDS instruction updates N,Z flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R2,=0x55555555
    LDR     R5,=0xFFFFFFFF
    /* ANDS(register) Encoding T1 16bit */
    /* <Rm[5:3]>:R2  0b010
       <Rdn[2:0]>:R5 0b101*/
    ANDS.N  R2,R5
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set N - Clear Z */
    MOV     R4,#0x40000000  /* Set Z */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    LDR     R2,=0xFFFFFFFF
    /* ANDS(register) Encoding T2 32bit */
    ANDS.W  R3,R1,R2    /* set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N */
    MOV     R4,#0x80000000  /* Set N */
    MSR     APSR_nzcvq,R4
    LDR     R2,=0xAAAAAAAA
    /* ANDS(register) Encoding T1 32bit */
    ANDS.W  R3,R2,#0x55555555    /* set Z flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x0D38
    
    
    /* --BICS-- */
    /* We need to check that BICS (register) instruction updates N,Z flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R5,=0x55555555
    MOV     R2,#0x0
    /* BICS(register) Encoding T1 16bit */
    /* <Rm[5:3]>:R5  0b101
       <Rdn[2:0]>:R2 0b010*/
    BICS.N  R5,R2
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set N - Clear Z */
    MOV     R4,#0x40000000  /* Set Z */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    MOV     R2,#0x0
    /* BICS(register) Encoding T2 32bit */
    BICS.W  R3,R1,R2    /* set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N */
    MOV     R4,#0x80000000  /* Set N */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    /* BICS(immediate) Encoding T1 32bit */
    BICS.W  R3,R1,#0xAAAAAAAA    /* set Z flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x0F2E
    
    
    /* --TST-- */
    /* We need to check that TST (register1) instruction updates N,Z flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R3,=0x55555555
    LDR     R4,=0xFFFFFFFF
    /* TST(register) Encoding T1 16bit */
    /* <Rm[5:3]>:R3  0b011
       <Rn[2:0]>:R4  0b100*/
    TST.N   R3,R4
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set N - Clear Z */
    MOV     R4,#0x40000000  /* Set Z */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    LDR     R2,=0xFFFFFFFF
    /* TST(register) Encoding T2 32bit */
    TST.W   R1,R2    /* set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N */
    MOV     R4,#0x80000000  /* Set N */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    /* TST(immediate) Encoding T1 32bit */
    TST.W   R1,#0x55555555    /* set Z flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x051D
    
    
    /* --EORS-- */
    /* We need to check that EORS (register) instruction updates N,Z flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R4,=0xAAAAAAAA
    LDR     R3,=0xFFFFFFFF
    /* EORS(register) Encoding T1 16bit */
    /* <Rm[5:3]>:R4  0b100
       <Rdn[2:0]>:R3 0b011*/
    EORS.N  R4,R3
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set N - Clear Z */
    MOV     R4,#0x40000000  /* Set Z */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x55555555
    LDR     R2,=0xAAAAAAAA
    /* EORS(register) Encoding T2 32bit */
    EORS.W  R3,R1,R2    /* Set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N */
    MOV     R4,#0x80000000  /* Set N */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x55555555
    /* EORS(immediate) Encoding T1 32bit */
    EORS.W  R3,R1,#0x55555555    /* Set Z flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x0E82
    
    B m4_scst_alu_test2_ltorg_jump_3    /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work.
                   /*标记转储伪指令池（文字池）的当前位置
                    包含 LDR 指令中使用的符号名称的数值）。
                    它是 4 字节对齐的，因为 2 字节对齐会导致错误的工作。 */
m4_scst_alu_test2_ltorg_jump_3： */
m4_scst_alu_test2_ltorg_jump_3:
    
    /* --ORRS-- */
    /* We need to check that ORRS instruction updates N,Z flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x55555555
    LDR     R2,=0x55555555
    /* ORRS(register) Encoding T1 16bit */
    /* <Rm[5:3]>:R1  0b001
       <Rdn[2:0]>:R2 0b010*/
    ORRS.N  R1,R2
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set Z - Clear N */
    MOV     R4,#0x80000000  /* Set N */
    MSR     APSR_nzcvq,R4
    MOV     R1,#0x0
    MOV     R2,#0x0
    /* ORR(register) Encoding T2 32bit */
    ORRS.W  R3,R1,R2    /* Set Z flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set N - Clear Z */
    MOV     R4,#0x40000000  /* Set Z */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x55555555
    /* ORR(immediate) Encoding T1 32bit */
    ORRS.W  R3,R1,#0xFFFFFFFF    /* Set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x0F29
    
    
    /* --TEQ-- */
    /* We need to check that TEQ instruction updates N,Z flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    LDR     R2,=0xFFFFFFFF
    /* TEQ(register) Encoding T1 32bit */
    TEQ.W   R1,R2
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set N - Clear Z */
    MOV     R4,#0x40000000  /* Set Z */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x55555555
    LDR     R2,=0xAAAAAAAA
    /* TEQ(register) Encoding T2 32bit */
    TEQ.W   R1,R2    /* Set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N */
    MOV     R4,#0x80000000  /* Set N */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x55555555
    /* TEQ(immediate) Encoding T1 32bit */
    TEQ.W   R1,#0x55555555    /* Set Z flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x04E6
    
    
    /* --ORN-- */
    /* We need to check that ORNS instruction updates N,Z flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x55555555
    LDR     R2,=0xAAAAAAAA
    /* ORN(register) Encoding T1 32bit */
    ORNS.W  R3,R1,R2
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set N - Clear Z */
    MOV     R4,#0x40000000  /* Set Z */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x55555555
    MOV     R2,#0x0
    /* ORN(register) Encoding T1 32bit */
    ORNS.W  R3,R1,R2    /* Set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N */
    MOV     R4,#0x80000000  /* Set N */
    MSR     APSR_nzcvq,R4
    MOV     R1,#0x0
    /* ORN(immediate) Encoding T1 32bit */
    ORNS.W  R3,R1,#0xFFFFFFFF    /* Set Z flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x06B5
    
    
    /* --MOVS--*/
    /* We need to check that MOVS instruction updates N,Z flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    /* MOVS(immediate) Encoding T1 16bit */
    MOVS.N  R3,#0x33
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    CMP.N   R3,#0x33
    BNE     m4_scst_test_tail_end
    
    /* Clear N,Z */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    /* MOVS(immediate) Encoding T2 32bit */
    MOVS    R3,#0x55555555
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set N - Clear Z */
    MOV     R4,#0x40000000  /* Set Z */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    
    /* MOVS (register) Encoding T2 16bit */ 
    SCST_OPCODE_START   /* Used opcode due to compiler problem */
    SCST_OPCODE16(0x000B)  /* MOVS    R3,R1 */
    SCST_OPCODE_END
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N */
    MOV     R4,#0x80000000  /* Set N */
    MSR     APSR_nzcvq,R4
    MOV     R1,#0x0
    /* MOVS (register) Encoding T3 32bit */
    MOVS.W  R3,R1   /* Set N flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x02CE
    
    
    /* --MVNS-- */
    /* We need to check that MVNS instruction updates N,Z flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    /* MVNS(register) Encoding T1 16bit */
    MVNS.N  R3,R1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set N - Clear Z */
    MOV     R4,#0x40000000  /* Set Z */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x55555555
    /* MVNS(register) Encoding T1 16bit */
    MVNS    R3,R1   /* Set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N */
    MOV     R4,#0x80000000  /* Set N */
    MSR     APSR_nzcvq,R4
    MOV     R1,#0xFFFFFFFF
    /* MVNS(register) Encoding T1 16bit */
    MVNS    R3,R1   /* Set Z flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Clear N,Z */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    /* MVNS(register) Encoding T2 32bit */
    MVNS.W  R3,R1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Clear N,Z */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0xAAAAAAAA
    /* MVNS(immediate) Encoding T1 32bit */
    MVNS    R3,#0xAAAAAAAA
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    ADDW    R9,R9,#0x09EB
    
    
    /***************************************************************************************************
    * ALU control bus:
    * - inline shift carry control
    *
    * Note: Inline shift carry is controlled by MOVS, MVNS, ANDS, ORRS, ORNS, EORS, BICS, TEQ or TST
    *       when an Operand2 is used.
    ***************************************************************************************************/
    BL      m4_scst_clear_flags
    
    LDR     R1,=0xAAAAAAAB
    MOVS    R3,R1, LSR #1
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    LDR     R1,=0xAAAAAAAA
    MOVS    R3,R1, LSR #1
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    
    LDR     R1,=0xD5555555
    MVNS    R3,R1, LSL #1
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    LDR     R1,=0x55555555
    MVNS    R3,R1, LSL #1
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    
    LDR     R2,=0x55555555
    LDR     R1,=0xAAAAAAAB
    ANDS    R3,R2,R1,LSR #1    
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    LDR     R1,=0xAAAAAAAA
    ANDS    R3,R2,R1,LSR #1
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    
    LDR     R2,=0x55555555
    LDR     R1,=0x99999999
    TST     R2,R1,LSL #1
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    LDR     R1,=0x33333333
    TST     R2,R1,LSL #1
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    
    LDR     R2,=0x55555555
    LDR     R1,=0x00000001
    ORRS    R3,R2,R1,ASR #1
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    LDR     R1,=0x00000002
    ORRS    R3,R2,R1,ASR #1
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    
    LDR     R2,=0x55555555
    LDR     R1,=0xFFFFFFFF
    ORNS    R3,R2,R1,ASR #1
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    LDR     R1,=0xFFFFFFFE
    ORNS    R3,R2,R1,ASR #1
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    
    LDR     R2,=0x99999999
    LDR     R1,=0x55555555
    EORS    R3,R2,R1,ROR #1
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    LDR     R2,=0x66666666
    LDR     R1,=0x55555555
    EORS    R3,R2,R1,ROR #2
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    
    LDR     R2,=0x99999999
    LDR     R1,=0x55555555
    BICS    R3,R2,R1,ROR #1
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    LDR     R2,=0x66666666
    LDR     R1,=0x55555555
    BICS    R3,R2,R1,ROR #2
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    
    LDR     R2,=0x99999999
    LDR     R1,=0x55555555
    TEQ     R2,R1,ROR #1
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    LDR     R2,=0x66666666
    LDR     R1,=0x55555555
    TEQ     R2,R1,ROR #2
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    
    ADDW    R9,R9,#0x03A5
    
    
    /***************************************************************************************************
    * ALU data path:
    * - MUL PSR flags (flags - N,Z)
    *
    * Note: Not linked directly with ALU control bus
    ***************************************************************************************************/
    /* We need to check that MUL instruction updates N,Z flags */
    BL      m4_scst_clear_flags
    
    /* Clear N,Z */
    MOV     R4,#0xF0000000  /* Set N,Z,C,V */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x55555555
    MOV     R2,#0x1
    MULS    R2,R1
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCC     m4_scst_test_tail_end   /* Check C flag is set !! */
    BVC     m4_scst_test_tail_end   /* Check V flag is set !! */
    
    /* Set N - Clear Z */
    MOV     R4,#0x40000000  /* Set Z */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x55555555
    MOV     R2,#0x2   
    MULS    R1,R2   /* Set N flag */
    BPL     m4_scst_test_tail_end   /* Check N flag is set !! */
    BEQ     m4_scst_test_tail_end   /* Check Z flag is not set */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    /* Set Z - Clear N */
    MOV     R4,#0x80000000  /* Set N */
    MSR     APSR_nzcvq,R4
    LDR     R1,=0x55555555
    MOV     R2,#0x0
    MULS    R1,R2   /* Set Z flag */
    BMI     m4_scst_test_tail_end   /* Check N flag is not set */
    BNE     m4_scst_test_tail_end   /* Check Z flag is set !! */
    BCS     m4_scst_test_tail_end   /* Check C flag is not set */
    BVS     m4_scst_test_tail_end   /* Check V flag is not set */
    
    ADDW    R9,R9,#0x041F
    
    
    MOV     R0,R9          /* Test result is returned in R0, according to the conventions */
    
    B       m4_scst_test_tail_end
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    