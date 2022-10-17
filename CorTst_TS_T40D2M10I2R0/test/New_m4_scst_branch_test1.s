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
* This test covers conditional and unconditional branches as well as their decoding.
* It tests special branch instructions like MOV,POP,LDR,LDM,LDMDB which update 
* the PC register.
*
* Overall coverage:
* -----------------
* Covers B.N,CBZ,CBNZ,TBB,TBH instructions and their decoding. 
* There are three test labels located on different addresses to test branch addresses 
* are decoded correctly.
*
* DECODER:
* Thumb (16-bit)
*   - Encoding of "Unconditional Branch" instruction
*   - Encoding of "Generate PC relative address" instructions - ADR.N
*   - Encoding of "Special data instructions and branch and exchange" instructions - MOV PC,<register> 
*   - Encoding of "Conditional branch, and supervisor call" instructions - conditional branch
*   - Encoding of "Miscellaneous 16-bit instructions" instructions - CBZ.N,CBNZ.N
* Thumb (32-bit)
*   - Encoding of "Load/store dual or exclusive, table branch" instructions - table branch
* 测试总结：
* -------------
* 此测试涵盖条件和无条件分支及其解码。
* 它测试更新的特殊分支指令，如 MOV、POP、LDR、LDM、LDMDB
* PC 寄存器。
*
* 整体覆盖：
* -----------------
* 涵盖 B.N、CBZ、CBNZ、TBB、TBH 指令及其解码。
* 三个测试标签位于不同的地址，用于测试分支地址
* 被正确解码。
*
* 解码器：
* 拇指（16 位）
* - “无条件分支”指令的编码
* - “生成 PC 相对地址”指令的编码 - ADR.N
* - “特殊数据指令和分支交换”指令的编码 - MOV PC,<寄存器>
* - “条件分支和主管调用”指令的编码 - 条件分支
* - “杂项 16 位指令”指令的编码 - CBZ.N,CBNZ.N
* 拇指（32 位）
* - “加载/存储双重或独占，表分支”指令的编码 - 表分支
******************************************************************************/

#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_branch_test1
    
    /* Symbols defined outside but used within current module */
    SCST_EXTERN SCST_RAM_TARGET0
    SCST_EXTERN SCST_RAM_TARGET1
    SCST_EXTERN m4_scst_test_tail_end
    
    /* Local defines */
SCST_SET(PRESIGNATURE, 0x38A63E47) /*this macro has to be at the beginning of the line*/

    
    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2    
    
/*-------------------------------------------------*/
/* This is Test Label 2 to test backward branches  */
/* ------------------------------------------------*/
    SCST_LABEL
m4_scst_branch_test1_testlabel2:
    SCST_CODE
    ADDW    R8,R8,#0xABC
    ORR     R5,R5,#0x1  /* Ensure bit0 is set */
    BX      R5

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_branch_test1" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_branch_test1, function)
m4_scst_branch_test1:

    PUSH.W  {R1-R12,R14}
    
    LDR     R8,=PRESIGNATURE
    
    MOVW    R0,#0x444
    /**********************************************************************************************
    * Branch instruction: 
    *   - B.N   Encoding T2 -> (unconditional) 
    *
    * Note: Unconditional branch (forward/back)
    **********************************************************************************************/
    /* ADR Encoding T1 - "Generate PC-relative address" instruction */
    ADR.N   R5,m4_scst_branch_test1_b_ret1
    B.N     m4_scst_branch_test1_testlabel1   /* forward */
    MOVW    R8,#0x444
    MOVW    R0,#0x444
    B       m4_scst_test_tail_end
    
    SCST_ALIGN_BYTES_4
    SCST_LABEL
m4_scst_branch_test1_b_ret1:
    SCST_CODE
    /* ADR Encoding T1 - "Generate PC-relative address" instruction */
    ADR.N   R5,m4_scst_branch_test1_b_ret2
    B.N     m4_scst_branch_test1_testlabel2   /* backward */
    MOVW    R8,#0x444
    MOVW    R0,#0x444
    B       m4_scst_test_tail_end
    
    SCST_ALIGN_BYTES_4
    SCST_LABEL
m4_scst_branch_test1_b_ret2:
    SCST_CODE
    /* ADR Encoding T1 - "Generate PC-relative address" instruction */
    ADR.N   R5,m4_scst_branch_test1_b_end
    B.N     m4_scst_branch_test1_testlabel3   /* forward */
    MOVW    R8,#0x444
    MOVW    R0,#0x444
    B       m4_scst_test_tail_end
    
    SCST_ALIGN_BYTES_4
    SCST_LABEL
m4_scst_branch_test1_b_end:
    SCST_CODE
    MOVW    R0,#0x445
    /**********************************************************************************************
    * Branch instruction: 
    *   - B.N   Encoding T1 (conditional) 
    *
    * Note: Conditional branch (forward/back)
    **********************************************************************************************/
    ADR.W   R5,m4_scst_branch_test1_bcond_ret1
    MOV     R4,#0x40000000  /* Z=1 */
    MSR     APSR_nzcvq,R4
    ISB
    BEQ.N   m4_scst_branch_test1_testlabel3 /* forward */
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end
    
m4_scst_branch_test1_bcond_ret2:
    ADR.W   R5,m4_scst_branch_test1_bcond_ret3
    MOV     R4,#0x20000000  /* C=1 */
    MSR     APSR_nzcvq,R4
    ISB
    BCS.N   m4_scst_branch_test1_testlabel3 /* forward */
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end
    
m4_scst_branch_test1_bcond_ret4:
    ADR.W   R5,m4_scst_branch_test1_bcond_ret5
    MOV     R4,#0x80000000  /* N=1 */
    MSR     APSR_nzcvq,R4
    ISB
    BMI.N   m4_scst_branch_test1_testlabel3 /* forward */
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end
    
m4_scst_branch_test1_bcond_ret6:
    ADR.W   R5,m4_scst_branch_test1_bcond_ret7
    MOV     R4,#0x10000000  /* V=1 */
    MSR     APSR_nzcvq,R4
    ISB
    BVS.N   m4_scst_branch_test1_testlabel3 /* forward */
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end
    
m4_scst_branch_test1_bcond_ret8:
    ADR.W   R5,m4_scst_branch_test1_bcond_ret9
    MOV     R4,#0x20000000  /* C=1 and Z=0 */
    MSR     APSR_nzcvq,R4
    ISB
    BHI.N   m4_scst_branch_test1_testlabel3 /* forward */
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end
    
m4_scst_branch_test1_bcond_ret10:
    ADR.W   R5,m4_scst_branch_test1_bcond_ret11
    MOV     R4,#0x90000000  /* N=V */
    MSR     APSR_nzcvq,R4
    ISB
    BGE.N   m4_scst_branch_test1_testlabel3 /* forward */
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end
    
m4_scst_branch_test1_bcond_ret12:
    ADR.W   R5,m4_scst_branch_test1_bcond_ret13
    MOV     R4,#0x00000000  /* Z=0 and N=V */
    MSR     APSR_nzcvq,R4
    ISB
    BGT.N   m4_scst_branch_test1_testlabel3 /* forward */
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end
    
    
/*--------------------------------------------------*/
/*  This is Test Label 3 to test forward/backward   */
/*  branches  for conditional B.N                   */
/* -------------------------------------------------*/
    SCST_LABEL
m4_scst_branch_test1_testlabel3:
    SCST_CODE
    ADDW    R8,R8,#0xABC
    ORR     R5,R5,#0x1  /* Ensure bit0 is set */
    BX      R5
   
   
m4_scst_branch_test1_bcond_ret1:
    ADR.W   R5,m4_scst_branch_test1_bcond_ret2
    MOV     R4,#0xB0000000  /* Z=0 */
    MSR     APSR_nzcvq,R4
    ISB
    BNE.N   m4_scst_branch_test1_testlabel3 /* backward */
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end
    
m4_scst_branch_test1_bcond_ret3:
    ADR.W   R5,m4_scst_branch_test1_bcond_ret4
    MOV     R4,#0xD0000000  /* C=0 */
    MSR     APSR_nzcvq,R4
    ISB
    BCC.N   m4_scst_branch_test1_testlabel3 /* backward */
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end
    
m4_scst_branch_test1_bcond_ret5:
    ADR.W   R5,m4_scst_branch_test1_bcond_ret6
    MOV     R4,#0x70000000  /* N=0 */
    MSR     APSR_nzcvq,R4
    ISB
    BPL.N   m4_scst_branch_test1_testlabel3 /* backward */
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end
    
m4_scst_branch_test1_bcond_ret7:
    ADR.W   R5,m4_scst_branch_test1_bcond_ret8
    MOV     R4,#0xE0000000  /* V=0  */
    MSR     APSR_nzcvq,R4
    ISB
    BVC.N   m4_scst_branch_test1_testlabel3 /* backward */
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end
    
m4_scst_branch_test1_bcond_ret9:
    ADR.W   R5,m4_scst_branch_test1_bcond_ret10
    MOV     R4,#0xD0000000  /* C=0 or Z=1 */
    MSR     APSR_nzcvq,R4
    ISB
    BLS.N   m4_scst_branch_test1_testlabel3 /* backward */
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end
    
m4_scst_branch_test1_bcond_ret11:
    ADR.W   R5,m4_scst_branch_test1_bcond_ret12
    MOV     R4,#0x80000000  /* N!=V */
    MSR     APSR_nzcvq,R4
    ISB
    BLT.N   m4_scst_branch_test1_testlabel3 /* backward */
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end
    
m4_scst_branch_test1_bcond_ret13:
    ADR.W   R5,m4_scst_branch_test1_bcond_end
    MOV     R4,#0xC0000000  /* Z=1 or N!=V */
    MSR     APSR_nzcvq,R4
    ISB
    BLE.N   m4_scst_branch_test1_testlabel3 /* backward */
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end
        
m4_scst_branch_test1_bcond_end:
    MOVW    R0,#0x446
    /**********************************************************************************************
    * Branch instruction:
    *   - Special branches:
    *        MOV,POP,LDR,LDM,LDMDB with PC as argument
    *
    * Note: We will test branching to three different test labels
    **********************************************************************************************/
    /* Start test for "m4_scst_branch_test1_testlabel1" */
m4_scst_branch_test1_bspecial_part1:
    ADR.W   LR,m4_scst_branch_test1_bspecial_part2
    ORR     LR,LR,#1
    ADR.W   R1,m4_scst_branch_test1_testlabel1      /* R1 contains address for branching */
    B       m4_scst_branch_test1_special_branches_common    /* Start testing */
    
    /* Repeat test for "m4_scst_branch_test1_testlabel2" */
m4_scst_branch_test1_bspecial_part2:
    ADR.W   LR,m4_scst_branch_test1_bspecial_part3
    ORR     LR,LR,#1
    ADR.W   R1,m4_scst_branch_test1_testlabel2      /* R1 contains address for branching */
    B       m4_scst_branch_test1_special_branches_common    /* Start testing */
    
    /* Repeat test for "m4_scst_branch_test1_testlabel3" */
m4_scst_branch_test1_bspecial_part3:
    ADR.W   LR,m4_scst_branch_test1_bspecial_end
    ORR     LR,LR,#1
    ADR.W   R1,m4_scst_branch_test1_testlabel3      /* R1 contains address for branching */
    B       m4_scst_branch_test1_special_branches_common    /* Start testing */

m4_scst_branch_test1_bspecial_end:    
    MOVW    R0,#0x447    
    /**********************************************************************************************
    * Branch instruction: 
    *   - CBZ,CBNZ   Encoding T1 (conditional) 
    *
    * Note: Supports only forward branches.
    **********************************************************************************************/
    MOV     R2,#0x0
    /* <Rn[2:0]>:R2 0b010
       <i:imm5>: 0b010101 */
    CBZ.N   R2,m4_scst_branch_test1_cbz_testlabel1        
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
          
m4_scst_branch_test1_cbz_testlabel1:
    
    ADD.W   R8,R8,#0xABC
    
    MOV     R5,#0x1
    /* <Rn[2:0]>:R5 0b101
       <i:imm5>: 0b101010 */
    CBNZ.N  R5,m4_scst_branch_test1_cbz_testlabel2
    NOP.N
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    
m4_scst_branch_test1_cbz_testlabel2:    
    ADD.W   R8,R8,#0xABC
    
    MOV     R3,#0x0
    /* <Rn[2:0]>:R3 0b011
       <i:imm5>: 0b110011 */
    CBZ.N   R3,m4_scst_branch_test1_cbz_testlabel3
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    
m4_scst_branch_test1_cbz_testlabel3:    
    ADD.W   R8,R8,#0xABC
    
    MOV     R4,#0x1
    /* <Rn[2:0]>:R4 0b100
       <i:imm5>: 0b001100 */
    CBNZ.N  R4,m4_scst_branch_test1_cbz_testlabel4
    NOP.N
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    
m4_scst_branch_test1_cbz_testlabel4:
    
    ADD.W   R8,R8,#0xABC
    
    MOV     R1,#0x0
    /* <Rn[2:0]>:R1 0b001
       <i:imm5>: 0b000111 */
    CBZ.N   R1,m4_scst_branch_test1_cbz_testlabel5
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    
m4_scst_branch_test1_cbz_testlabel5:
    
    ADD.W   R8,R8,#0xABC
    
    MOV     R7,#0x0
    /* <Rn[2:0]>:R1 0b111
       <i:imm5>: 0b010000 */
    CBZ.N   R7,m4_scst_branch_test1_cbz_testlabel6
    NOP.N
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    B.W     m4_scst_test_tail_end
    
m4_scst_branch_test1_cbz_testlabel6:
    
    ADD.W   R8,R8,#0xABC
    
    /**********************************************************************************************
    * Branch instruction: 
    *   - TBB,TBH   Encoding T1  
    *
    * Note:
    **********************************************************************************************/
    MOVW    R0,#0x448
    MOVW    R1,#0x448
    /* Store offset table to memory */
    LDR     R10,=SCST_RAM_TARGET0
    LDR     R3,=0x00063204  /* Offset table */
    STR     R3,[R10]         /* Store offset table to memory */
    DSB
    MOV     R5,#0x0     /* Load index */     
    TBB     [R10,R5]    /* branch Index 0 -> Offset 4*2=8 */
    MOVW    R1,#0x444
    B.W     m4_scst_test_tail_end
    MOVW    R0,#0x444   /* <- branch here */
    /* Check branching was correct */
    ADDW    R8,R8,#0xABC
    CMP     R0,R1       
    BEQ     m4_scst_test_tail_end

    MOVW    R1,#0x444
    LDR     R5,=SCST_RAM_TARGET1
    STR     R3,[R5]     /* Store offset table to memory */
    DSB
    MOV     R10,#0x1     /* Load index */         
    TBH     [R5,R10,LSL #1]     /* branch Index 1 - Offset 6*2=12 */
    MOVW    R1,#0x444
    MOVW    R2,#0x444
    B.W     m4_scst_test_tail_end
    MOVW    R0,#0x448   /* <- branch here */
    /* Check branching was correct */
    ADDW    R8,R8,#0xABC
    CMP     R0,R1       
    BEQ     m4_scst_test_tail_end
    
    MOVW    R1,#0x448
    
    MOV     R3,#0x3     /* Load index 3 */
    TBB     [PC,R3]     /* branch -> Index 3 -> Offset 6*2=12 */
    /* 0x06020202 - Offset table */
    SCST_OPCODE_START
    SCST_OPCODE32_HIGH(0x0202)
    SCST_OPCODE32_LOW( 0x0602)    
    SCST_OPCODE_END

    MOVW    R0,#0x444    
    B.W     m4_scst_test_tail_end
    MOVW    R0,#0x444   /* <- branch here */
    /* Check branching was correct */
    ADDW    R8,R8,#0xABC
    CMP     R0,R1
    BEQ     m4_scst_test_tail_end
   
    MOVW    R1,#0x444
    
    MOV     R12,#0x1     /* Load index 1 */     
    TBH     [PC,R12,LSL #1]     /* branch -> Index 1 -> Offset 8*2=16 */
    /* 0x00080002 - Offset table */
    SCST_OPCODE_START
    SCST_OPCODE32_HIGH(0x0002)
    SCST_OPCODE32_LOW( 0x0008)    
    SCST_OPCODE_END
    
    MOVW    R1,#0x444
    MOVW    R2,#0x444
    B.W     m4_scst_test_tail_end
    MOVW    R0,#0x448   /* <- branch here */
    /* Check branching was correct */
    ADDW    R8,R8,#0xABC
    CMP     R0,R1
    BEQ     m4_scst_test_tail_end
    
m4_scst_branch_test1_end:
    MOV     R0,R8       /* Test result is returned in R0 */
    
    B       m4_scst_test_tail_end


m4_scst_branch_test1_special_branches_common:
    /**********************************************************************************************
    * Branch instruction: 
    *   - MOV (register)   Encoding T1   
    *
    * Note: Unconditional B/MOV 
    **********************************************************************************************/
    ADR.W   R5,m4_scst_branch_test1_bspecial_ret1
    MOV.N   PC,R1   /* branch -> */
    MOVW    R0,#0x444
    MOVW    R8,#0x444
    B       m4_scst_test_tail_end

m4_scst_branch_test1_bspecial_ret1:
    /**********************************************************************************************
    * Branch instruction: 
    *   - POP   Encoding T1  
    *
    * Note: If the registers loaded include the PC, the word loaded for the PC 
    *       is treated as a branch address or exception return value.
    **********************************************************************************************/
    ADR.W   R5,m4_scst_branch_test1_bspecial_ret2
    MOV     R2,R1
    ORR     R2,R2,#0x1   /* We must ensure the address is odd */
    PUSH.N  {R1,R2}
    DSB
    POP.N   {R1,PC}     /* branch -> */
    MOVW    R8,#0x444
    MOVW    R0,#0x444
    B       m4_scst_test_tail_end    
    
m4_scst_branch_test1_bspecial_ret2:
    /**********************************************************************************************
    * Branch instruction: 
    *   - LDR (register)   Encoding T2  
    *
    * Note: If the registers loaded include the PC, the word loaded for the PC 
    *       is treated as a branch address or exception return value.
    **********************************************************************************************/
    ADR.W   R5,m4_scst_branch_test1_bspecial_ret3
    MOV     R2,R1
    ORR     R2,R2,#0x1  /* We must ensure the address is odd */
    STR     R2,[SP,#-4]!
    STR     R2,[SP,#-4]!
    DSB
    MOV     R2,#0x4
    LDR.W   PC,[SP,R2]  /* branch -> */
    MOVW    R8,#0x444
    MOVW    R0,#0x444
    LDR     R2,[SP],#4
    LDR     R2,[SP],#4
    B       m4_scst_test_tail_end
    
m4_scst_branch_test1_bspecial_ret3:    
    LDR     R2,[SP],#4  /* Restore stack */
    LDR     R2,[SP],#4  /* Restore stack */
    /**********************************************************************************************
    * Branch instruction: 
    *   - LDR (immediate)   Encoding T3  
    *
    * Note: If the registers loaded include the PC, the word loaded for the PC 
    *       is treated as a branch address or exception return value.
    **********************************************************************************************/
    ADR.W   R5,m4_scst_branch_test1_bspecial_ret4
    MOV     R2,R1
    ORR     R2,R2,#0x1  /* We must ensure the address is odd */
    STR     R2,[SP,#-4]!
    DSB
    LDR.W   PC,[SP]     /* branch -> */
    MOVW    R8,#0x444
    MOVW    R0,#0x444
    LDR     R2,[SP],#4  /* Restore stack */
    B       m4_scst_test_tail_end
    
m4_scst_branch_test1_bspecial_ret4:
    LDR     R2,[SP],#4  /* Restore stack */
    /**********************************************************************************************
    * Branch instruction: 
    *   - LDM   Encoding T2  
    *
    * Note: If the registers loaded include the PC, the word loaded for the PC 
    *       is treated as a branch address or exception return value.
    **********************************************************************************************/
    ADR.W   R5,m4_scst_branch_test1_bspecial_ret5
    MOV     R2,R1
    ORR     R2,R2,#0x1
    PUSH.N  {R0,R2}
    DSB
    LDM.W   SP!,{R0,PC}     /* branch -> */
    MOVW    R8,#0x444
    MOVW    R0,#0x444       
    B       m4_scst_test_tail_end

m4_scst_branch_test1_bspecial_ret5:   
    /**********************************************************************************************
    * Branch instruction: 
    *   - LDMDB   Encoding T1  
    *
    * Note: If the registers loaded include the PC, the word loaded for the PC 
    *       is treated as a branch address or exception return value.
    **********************************************************************************************/
    ADR.W   R5,m4_scst_branch_test1_bspecial_ret6
    LDR     R0,=SCST_RAM_TARGET0
    MOV     R2,R1
    ORR     R2,R2,#0x1      
    STM     R0!,{R1,R2}
    DSB
    LDMDB.W R0!,{R1,PC}     /* branch -> */
    MOVW    R8,#0x444
    MOVW    R0,#0x444
    B       m4_scst_test_tail_end

m4_scst_branch_test1_bspecial_ret6:
    /**********************************************************************************************
    * Branch instruction: 
    *   - MOV (register)   Encoding T1   
    *
    * Note: Decode Time branches
    **********************************************************************************************/
    MOV.N   PC,LR   /* Jump back */
    MOVW    R8,#0x444
    MOVW    R0,#0x444       
    B       m4_scst_test_tail_end
    
    
    
/*-------------------------------------------------*/
/* This is Test Label 1 to test forward  branches  */
/* ------------------------------------------------*/
    SCST_LABEL
m4_scst_branch_test1_testlabel1:
    SCST_CODE
    ADDW    R8,R8,#0xABC
    ORR     R5,R5,#0x1  /* Ensure bit0 is set */
    BX      R5
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    