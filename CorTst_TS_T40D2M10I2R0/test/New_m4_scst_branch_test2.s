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
* This test has two parts where one part is located in the "m4_scst_test_code_unprivileged"
* section and the second part is located in the "m4_scst_test_code1_unprivileged" section.
* Both inner and inter section branches are tested. Both forward/backward branches
* are tested as well.
*
* Overall coverage:
* -----------------
* Covers B.W, BL, BX, BLX instructions and their decoding. 
* There are four test labels located on different addresses to test branch addresses 
* are decoded correctly.
*
* DECODER:
* Thumb (16-bit)
*   - Encoding of "Special data instructions and branch and exchange" instruction - branch and exchange
*   - Encoding of "Generate PC-relative address" instruction - ADR.N
* Thumb (32-bit)
*   - Encoding of "Branches and miscellaneous control" instructions - branches
* 
* 测试总结：
* -------------
* 此测试涵盖条件和无条件分支及其解码。
* 本次测试分为两部分，其中一部分位于“m4_scst_test_code_unprivileged”
* 部分，第二部分位于“m4_scst_test_code1_unprivileged”部分。
* 内部和内部分支都经过测试。 前向/后向分支
* 也经过测试。
*
* 整体覆盖：
* -----------------
* 涵盖 B.W、BL、BX、BLX 指令及其解码。
* 有四个测试标签位于不同的地址以测试分支地址
* 被正确解码。
*
* 解码器：
* 拇指（16 位）
* - “特殊数据指令和分支和交换”指令的编码 - 分支和交换
* - “Generate PC-relative address”指令的编码 - ADR.N
* 拇指（32 位）
* - “分支和杂项控制”指令的编码 - 分支
*
******************************************************************************/

#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_branch_test2
    
    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end

    /* Local defines */    
SCST_SET(PRESIGNATURE, 0x5326814B) /*this macro has to be at the beginning of the line*/

    
    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2    
    
/*-------------------------------------------------*/
/* This is Test Label 1                            */
/* ------------------------------------------------*/
    SCST_TYPE(m4_scst_branch_test2_testlabel1_code_unprivileged, function)
m4_scst_branch_test2_testlabel1_code_unprivileged:
    ADDW    R8,R8,#0x2EA
    ORR     R2,R2,#0x1  /* Ensure bit0 is set */
    BX      R2
    
/*-------------------------------------------------*/
/* This is Test Label 1 with LR check              */
/* ------------------------------------------------*/
    SCST_TYPE(m4_scst_branch_test2_testlabel1_link_code_unprivileged, function)
m4_scst_branch_test2_testlabel1_link_code_unprivileged:
    /* We must check bit0 in LR  is set */
    ORR     R2,R2,#1
    SUB     R2,LR,R2
    CBNZ    R2,m4_scst_branch_test2_testlabel1_link_error
    ADDW    R8,R8,#0x2EA
    /* <Rm[6:3]> 0b1110 */
    BX      LR
m4_scst_branch_test2_testlabel1_link_error:
    B       m4_scst_test_tail_end
    
    
    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_branch_test2" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_branch_test2, function)
m4_scst_branch_test2:

    PUSH.W  {R1-R12,R14}
    
    LDR     R8,=PRESIGNATURE
    
    MOVW    R0,#0x444   /* Load R0 with wrong value */
    /**********************************************************************************************
    * Branch instruction: 
    *   - B.W   Encoding T4 (conditional) 
    *
    * Note: Unconditional Part-1
    **********************************************************************************************/
m4_scst_branch_test2_b_code_unprivileged:
    /* ADR Encoding T1 - "Generate PC-relative address" instruction */
    ADR.N   R2,m4_scst_branch_test2_b_ret1_code_unprivileged    
    B.W     m4_scst_branch_test2_testlabel1_code_unprivileged   /* branch -> */
    MOVW    R8,#0x444
    
    SCST_ALIGN_BYTES_4
  SCST_LABEL
m4_scst_branch_test2_b_ret1_code_unprivileged:
  SCST_CODE
    /* ADR Encoding T1 - "Generate PC-relative address" instruction */
    ADR.N   R2,m4_scst_branch_test2_b_ret2_code_unprivileged    
    B.W     m4_scst_branch_test2_testlabel2_code1_unprivileged  /* branch -> intersection branch */
    MOVW    R8,#0x444
    
    SCST_ALIGN_BYTES_4
  SCST_LABEL
m4_scst_branch_test2_b_ret2_code_unprivileged:    
  SCST_CODE
    /* ADR Encoding T1 - "Generate PC-relative address" instruction */
    ADR.N   R2,m4_scst_branch_test2_b_ret3_code_unprivileged   
    B.W     m4_scst_branch_test2_testlabel3_code_unprivileged   /* branch -> */
    MOVW    R8,#0x444
    
    SCST_ALIGN_BYTES_4
  SCST_LABEL
m4_scst_branch_test2_b_ret3_code_unprivileged:
  SCST_CODE
    /* ADR Encoding T1 - "Generate PC-relative address" instruction */
    ADR.N   R2,m4_scst_branch_test2_b_ret4_code_unprivileged    
    B.W     m4_scst_branch_test2_testlabel4_code1_unprivileged  /* branch -> intersection branch */
    MOVW    R8,#0x444
    
    SCST_ALIGN_BYTES_4
  SCST_LABEL
m4_scst_branch_test2_b_ret4_code_unprivileged:    
  SCST_CODE
    /* Execute the same tests from the "m4_scst_test_code1_unprivileged" section 
       This ensures that branches will have different addresses !! */
    B       m4_scst_branch_test2_b_code1_unprivileged
    MOVW    R8,#0x444
    
    /**********************************************************************************************
    * Branch instruction: 
    *   - BX   Encoding T1
    *
    * Note: Thumb only, ensure bit0 is set - Part-1
    **********************************************************************************************/
  
m4_scst_branch_test2_bx_code_unprivileged:
  
    MOVW    R0,#0x445
    ADR.W   R2,m4_scst_branch_test2_bx_ret1_code_unprivileged
    ADR.W   R5,m4_scst_branch_test2_testlabel1_code_unprivileged
    ORR     R5,R5,#1
    /* <Rm[6:3]> 0b0101 */
    BX      R5     /* branch -> */
    MOVW    R8,#0x445
  
m4_scst_branch_test2_bx_ret1_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_bx_ret2_code_unprivileged
    LDR.W   R10,=m4_scst_branch_test2_testlabel2_code1_unprivileged     /* We must load absolute address !! */
    ORR     R10,R10,#1
    /* <Rm[6:3]> 0b1010 */
    BX      R10      /* branch -> intersection branch */
    MOVW    R8,#0x445
  
m4_scst_branch_test2_bx_ret2_code_unprivileged:    
  
    ADR.W   R2,m4_scst_branch_test2_bx_ret3_code_unprivileged
    ADR.W   R3,m4_scst_branch_test2_testlabel3_code_unprivileged
    ORR     R3,R3,#1
    /* <Rm[6:3]> 0b0011 */
    BX      R3     /* branch -> */
    MOVW    R8,#0x445
  
m4_scst_branch_test2_bx_ret3_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_bx_ret4_code_unprivileged
    LDR.W   R12,=m4_scst_branch_test2_testlabel4_code1_unprivileged     /* We must load absolute address !! */
    ORR     R12,R12,#1
    /* <Rm[6:3]> 0b1100 */
    BX      R12      /* branch -> intersection branch */
    MOVW    R8,#0x445
    
m4_scst_branch_test2_bx_ret4_code_unprivileged:
  
    /* Execute the same tests from the "m4_scst_test_code1_unprivileged" section 
       This ensures that branches will have different addresses !! */
    B       m4_scst_branch_test2_bx_code1_unprivileged
    MOVW    R8,#0x445
    
    /**********************************************************************************************
    * Branch instruction: 
    *   - BL    Encoding T1
    *
    * Note: Unconditional Part-1
    **********************************************************************************************/
  
m4_scst_branch_test2_bl_code_unprivileged:
  
    MOVW    R0,#0x446
    ADR.W   R2,m4_scst_branch_test2_bl_ret1_code_unprivileged
    BL      m4_scst_branch_test2_testlabel1_link_code_unprivileged  /* branch -> */
  
m4_scst_branch_test2_bl_ret1_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_bl_ret2_code_unprivileged
    BL      m4_scst_branch_test2_testlabel2_link_code1_unprivileged /* branch -> intersection branch */
  
m4_scst_branch_test2_bl_ret2_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_bl_ret3_code_unprivileged
    BL      m4_scst_branch_test2_testlabel3_link_code_unprivileged  /* branch -> */
    
m4_scst_branch_test2_bl_ret3_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_bl_ret4_code_unprivileged
    BL      m4_scst_branch_test2_testlabel4_link_code1_unprivileged /* branch -> intersection branch */
  
m4_scst_branch_test2_bl_ret4_code_unprivileged:
  
    /* Execute the same tests from the "m4_scst_test_code1_unprivileged" section 
       This ensures that branches will have different addresses !! */
    B       m4_scst_branch_test2_bl_code1_unprivileged
    MOVW    R8,#0x446
    
    /**********************************************************************************************
    * Branch instruction: 
    *   - BLX   Encoding T1
    *
    * Note: Thumb only, ensure bit0 is set - Part-1
    **********************************************************************************************/
  
m4_scst_branch_test2_blx_code_unprivileged:
  
    MOVW    R0,#0x447
    ADR.W   R2,m4_scst_branch_test2_blx_ret1_code_unprivileged
    ADR.W   R5,m4_scst_branch_test2_testlabel1_link_code_unprivileged
    ORR     R5,R5,#1
    /* <Rm[6:3]> 0b0101 */
    BLX     R5     /* branch -> */
  
m4_scst_branch_test2_blx_ret1_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_blx_ret2_code_unprivileged
    LDR.W   R10,=m4_scst_branch_test2_testlabel2_link_code1_unprivileged    /* We must load absolute address !! */
    ORR     R10,R10,#1
    /* <Rm[6:3]> 0b1010 */
    BLX     R10      /* branch -> intersection branch */
    
m4_scst_branch_test2_blx_ret2_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_blx_ret3_code_unprivileged
    ADR.W   R3,m4_scst_branch_test2_testlabel3_link_code_unprivileged
    ORR     R3,R3,#1
    /* <Rm[6:3]> 0b0011 */
    BLX     R3     /* branch -> */
  
m4_scst_branch_test2_blx_ret3_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_blx_ret4_code_unprivileged
    LDR.W   R12,=m4_scst_branch_test2_testlabel4_link_code1_unprivileged    /* We must load absolute address !! */
    ORR     R12,R12,#1
    /* <Rm[6:3]> 0b1100 */
    BLX     R12      /* branch -> intersection branch */
  
m4_scst_branch_test2_blx_ret4_code_unprivileged:
  
    /* Execute the same tests from the "m4_scst_test_code1_unprivileged" section 
       This ensures that branches will have different addresses !! */
    B       m4_scst_branch_test2_blx_code1_unprivileged
    MOVW    R8,#0x447
    
    /**********************************************************************************************
    * Branch instruction: 
    *   - B.W   Encoding T3 (conditional) 
    *
    * Note: Conditional branch (forward/back) Part-1
    **********************************************************************************************/
  
m4_scst_branch_test2_b_cond_code_unprivileged:
  
    MOVW    R0,#0x448
    ADR.W   R2,m4_scst_branch_test2_label1_code_unprivileged
    MOV     R4,#0x40000000  /* Z=1 */
    MSR     APSR_nzcvq,R4
    ISB
    BNE.W   m4_scst_test_tail_end
    BEQ.W   m4_scst_branch_test2_testlabel1_code_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label1_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label2_code_unprivileged
    MOV     R4,#0xB0000000  /* Z=0 */
    MSR     APSR_nzcvq,R4
    ISB
    BEQ.W   m4_scst_test_tail_end
    BNE.W   m4_scst_branch_test2_testlabel1_code_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label2_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label3_code_unprivileged
    MOV     R4,#0x20000000  /* C=1 */
    MSR     APSR_nzcvq,R4
    ISB
    BCC.W   m4_scst_test_tail_end
    BCS.W   m4_scst_branch_test2_testlabel3_code_unprivileged   /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label3_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label4_code_unprivileged
    MOV     R4,#0xD0000000  /* C=0 */
    MSR     APSR_nzcvq,R4
    ISB
    BCS.W   m4_scst_test_tail_end
    BCC.W   m4_scst_branch_test2_testlabel3_code_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
    
 m4_scst_branch_test2_label4_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label5_code_unprivileged
    MOV     R4,#0x80000000  /* N=1 */
    MSR     APSR_nzcvq,R4
    ISB
    BPL.W   m4_scst_test_tail_end
    BMI.W   m4_scst_branch_test2_testlabel1_code_unprivileged   /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label5_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label6_code_unprivileged
    MOV     R4,#0x70000000  /* N=0 */
    MSR     APSR_nzcvq,R4
    ISB
    BMI.W   m4_scst_test_tail_end
    BPL.W   m4_scst_branch_test2_testlabel1_code_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label6_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label7_code_unprivileged
    MOV     R4,#0x10000000  /* V=1 */
    MSR     APSR_nzcvq,R4
    ISB
    BVC.W   m4_scst_test_tail_end
    BVS.W   m4_scst_branch_test2_testlabel3_code_unprivileged   /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label7_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label8_code_unprivileged
    MOV     R4,#0xE0000000  /* V=0  */
    MSR     APSR_nzcvq,R4
    ISB
    BVS.W   m4_scst_test_tail_end
    BVC.W   m4_scst_branch_test2_testlabel3_code_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label8_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label9_code_unprivileged
    MOV     R4,#0x20000000  /* C=1 and Z=0 */
    MSR     APSR_nzcvq,R4
    ISB
    BLS.W   m4_scst_test_tail_end
    BHI.W   m4_scst_branch_test2_testlabel1_code_unprivileged   /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label9_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label10_code_unprivileged
    MOV     R4,#0xD0000000  /* C=0 or Z=1 */
    MSR     APSR_nzcvq,R4
    BHI.W   m4_scst_test_tail_end
    BLS.W   m4_scst_branch_test2_testlabel1_code_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label10_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label11_code_unprivileged
    MOV     R4,#0x90000000  /* N=V */
    MSR     APSR_nzcvq,R4
    ISB
    BLT.W   m4_scst_test_tail_end
    BGE.W   m4_scst_branch_test2_testlabel3_code_unprivileged   /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
    
m4_scst_branch_test2_label11_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label12_code_unprivileged
    MOV     R4,#0x80000000  /* N!=V */
    MSR     APSR_nzcvq,R4
    ISB
    BGE     m4_scst_test_tail_end
    BLT.W   m4_scst_branch_test2_testlabel3_code_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
    
m4_scst_branch_test2_label12_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label13_code_unprivileged
    MOV     R4,#0x00000000  /* Z=0 and N=V */
    MSR     APSR_nzcvq,R4
    ISB
    BLE.W   m4_scst_test_tail_end
    BGT.W   m4_scst_branch_test2_testlabel1_code_unprivileged   /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
    
m4_scst_branch_test2_label13_code_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label14_code_unprivileged
    MOV     R4,#0xC0000000  /* Z=1 or N!=V */
    MSR     APSR_nzcvq,R4
    ISB
    BGT.W   m4_scst_test_tail_end
    BLE.W   m4_scst_branch_test2_testlabel1_code_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label14_code_unprivileged:
  
    /* Run the same test from another section */
    B       m4_scst_branch_test2_b_cond_code1_unprivileged
    MOVW    R8,#0x448
  
m4_scst_branch_test2_end:
  
    MOV     R0,R8       /* Test result is returned in R0 */
    
    B       m4_scst_test_tail_end
    
/*-------------------------------------------------*/
/* This is Test Label 3                            */
/* ------------------------------------------------*/
    SCST_TYPE(m4_scst_branch_test2_testlabel3_code_unprivileged, function)
m4_scst_branch_test2_testlabel3_code_unprivileged:
    ADDW    R8,R8,#0x2EA
    ORR     R2,R2,#0x1  /* Ensure bit0 is set */
    BX      R2
    
/*-------------------------------------------------*/
/* This is Test Label 3 with LR check              */
/* ------------------------------------------------*/
    SCST_TYPE(m4_scst_branch_test2_testlabel3_link_code_unprivileged, function)
m4_scst_branch_test2_testlabel3_link_code_unprivileged:
    /* We must check bit0 in LR  is set */
    ORR     R2,R2,#1
    SUB     R2,LR,R2
    CBNZ    R2,m4_scst_branch_test2_testlabel3_link_error
    ADDW    R8,R8,#0x2EA
    BX      LR
m4_scst_branch_test2_testlabel3_link_error:
    B       m4_scst_test_tail_end
            
    SCST_SECTION_EXEC(m4_scst_test_code1_unprivileged)
    SCST_THUMB2
/*-------------------------------------------------*/
/* This is Test Label 2                            */
/* ------------------------------------------------*/
    SCST_TYPE(m4_scst_branch_test2_testlabel2_code1_unprivileged, function)
m4_scst_branch_test2_testlabel2_code1_unprivileged:
    ADDW    R8,R8,#0x2EA
    ORR     R2,R2,#0x1  /* Ensure bit0 is set */
    BX      R2

/*-------------------------------------------------*/
/* This is Test Label 2 with LR check              */
/* ------------------------------------------------*/
    SCST_TYPE(m4_scst_branch_test2_testlabel2_link_code1_unprivileged, function)
m4_scst_branch_test2_testlabel2_link_code1_unprivileged:
    /* We must check bit0 in LR  is set */
    ORR     R2,R2,#1
    SUB     R2,LR,R2
    CBNZ    R2,m4_scst_branch_test2_testlabel2_link_error
    ADDW    R8,R8,#0x2EA
    BX      LR
m4_scst_branch_test2_testlabel2_link_error:
    B       m4_scst_test_tail_end
    
    /**********************************************************************************************
    * Branch instruction: 
    *   - B.W   Encoding T4 (conditional) 
    *
    * Note: Unconditional Part-2
    **********************************************************************************************/
  
m4_scst_branch_test2_b_code1_unprivileged:
  
    /* ADR Encoding T1 - "Generate PC-relative address" instruction */
    ADR.N   R2,m4_scst_branch_test2_b_ret1_code1_unprivileged    
    B.W     m4_scst_branch_test2_testlabel1_code_unprivileged   /* branch -> intersection branch */
    MOVW    R8,#0x444
    
    SCST_ALIGN_BYTES_4
  SCST_LABEL
m4_scst_branch_test2_b_ret1_code1_unprivileged:
  SCST_CODE
    /* ADR Encoding T1 - "Generate PC-relative address" instruction */
    ADR.N   R2,m4_scst_branch_test2_b_ret2_code1_unprivileged    
    B.W     m4_scst_branch_test2_testlabel2_code1_unprivileged  /* branch -> */
    MOVW    R8,#0x444
    
    SCST_ALIGN_BYTES_4
  SCST_LABEL
m4_scst_branch_test2_b_ret2_code1_unprivileged:
  SCST_CODE
    /* ADR Encoding T1 - "Generate PC-relative address" instruction */
    ADR.N   R2,m4_scst_branch_test2_b_ret3_code1_unprivileged    
    B.W     m4_scst_branch_test2_testlabel3_code_unprivileged   /* branch -> intersection branch */
    MOVW    R8,#0x444
    
    SCST_ALIGN_BYTES_4
  SCST_LABEL
m4_scst_branch_test2_b_ret3_code1_unprivileged:  
  SCST_CODE
    /* ADR Encoding T1 - "Generate PC-relative address" instruction */
    ADR.N   R2,m4_scst_branch_test2_b_ret4_code1_unprivileged    
    B.W     m4_scst_branch_test2_testlabel4_code1_unprivileged  /* branch -> */
    MOVW    R8,#0x444
    
    SCST_ALIGN_BYTES_4
  SCST_LABEL
m4_scst_branch_test2_b_ret4_code1_unprivileged:
  SCST_CODE
    /* Go back to the "m4_scst_test_code_unprivileged" section */
    B       m4_scst_branch_test2_bx_code_unprivileged
    MOVW    R8,#0x444
    
     /**********************************************************************************************
    * Branch instruction: 
    *   - BX   Encoding T1
    *
    * Note: Note: Thumb only, ensure bit0 is set - Part-1
    **********************************************************************************************/
  
m4_scst_branch_test2_bx_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_bx_ret1_code1_unprivileged
    LDR.W   R7,=m4_scst_branch_test2_testlabel1_code_unprivileged   /* We must load absolute address !! */
    ORR     R7,R7,#1
    /* <Rm[6:3]> 0b0111 */
    BX      R7     /* branch -> intersection branch */
    MOVW    R8,#0x445
  
m4_scst_branch_test2_bx_ret1_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_bx_ret2_code1_unprivileged
    ADR.W   R9,m4_scst_branch_test2_testlabel2_code1_unprivileged
    ORR     R9,R9,#1
    /* <Rm[6:3]> 0b1001 */
    BX      R9      /* branch -> */
    MOVW    R8,#0x445
  
m4_scst_branch_test2_bx_ret2_code1_unprivileged:    
  
    ADR.W   R2,m4_scst_branch_test2_bx_ret3_code1_unprivileged
    LDR.W   R4,=m4_scst_branch_test2_testlabel3_code_unprivileged   /* We must load absolute address !! */
    ORR     R4,R4,#1
    /* <Rm[6:3]> 0b0100 */
    BX      R4     /* branch -> intersection branch */
    MOVW    R8,#0x445
  
m4_scst_branch_test2_bx_ret3_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_bx_ret4_code1_unprivileged
    ADR.W   R11,m4_scst_branch_test2_testlabel4_code1_unprivileged
    ORR     R11,R11,#1
    /* <Rm[6:3]> 0b1011 */
    BX      R11      /* branch -> */
    MOVW    R8,#0x445
    
m4_scst_branch_test2_bx_ret4_code1_unprivileged:
  
    /* Go back to the "m4_scst_test_code_unprivileged" section */
    B       m4_scst_branch_test2_bl_code_unprivileged
    MOVW    R8,#0x445
    
    /**********************************************************************************************
    * Branch instruction: 
    *   - BL   Encoding T1
    *
    * Note: Unconditional Part-2
    **********************************************************************************************/
  
m4_scst_branch_test2_bl_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_bl_ret1_code1_unprivileged
    BL      m4_scst_branch_test2_testlabel1_link_code_unprivileged  /* branch -> intersection branch */
  
m4_scst_branch_test2_bl_ret1_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_bl_ret2_code1_unprivileged
    BL      m4_scst_branch_test2_testlabel2_link_code1_unprivileged /* branch -> */
  
m4_scst_branch_test2_bl_ret2_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_bl_ret3_code1_unprivileged
    BL      m4_scst_branch_test2_testlabel3_link_code_unprivileged  /* branch -> intersection branch */
  
m4_scst_branch_test2_bl_ret3_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_bl_ret4_code1_unprivileged
    BL      m4_scst_branch_test2_testlabel4_link_code1_unprivileged /* branch -> */
  
m4_scst_branch_test2_bl_ret4_code1_unprivileged:
  
    /* Go back to the "m4_scst_test_code_unprivileged" section */
    B       m4_scst_branch_test2_blx_code_unprivileged
    MOVW    R8,#0x446
    
    /**********************************************************************************************
    * Branch instruction: 
    *   - BLX  Encoding T1
    *
    * Note: Thumb only, ensure bit0 is set - Part-2
    **********************************************************************************************/
  
m4_scst_branch_test2_blx_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_blx_ret1_code1_unprivileged
    LDR.W   R7,=m4_scst_branch_test2_testlabel1_link_code_unprivileged  /* We must load absolute address !! */
    ORR     R7,R7,#1
    /* <Rm[6:3]> 0b0111 */
    BLX     R7     /* branch -> intersection branch */
    
m4_scst_branch_test2_blx_ret1_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_blx_ret2_code1_unprivileged
    ADR.W   R9,m4_scst_branch_test2_testlabel2_link_code1_unprivileged
    ORR     R9,R9,#1
    /* <Rm[6:3]> 0b1001 */
    BLX     R9      /* branch -> */
    
m4_scst_branch_test2_blx_ret2_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_blx_ret3_code1_unprivileged
    LDR.W   R4,=m4_scst_branch_test2_testlabel3_link_code_unprivileged  /* We must load absolute address !! */
    ORR     R4,R4,#1
    /* <Rm[6:3]> 0b0100 */
    BLX     R4     /* branch -> intersection branch */
    
m4_scst_branch_test2_blx_ret3_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_blx_ret4_code1_unprivileged
    ADR.W   R11,m4_scst_branch_test2_testlabel4_link_code1_unprivileged
    ORR     R11,R11,#1
    /* <Rm[6:3]> 0b1011 */
    BLX     R11      /* branch -> */
  
m4_scst_branch_test2_blx_ret4_code1_unprivileged:
  
    /* Go back to the "m4_scst_test_code_unprivileged" section */
    B       m4_scst_branch_test2_b_cond_code_unprivileged
    MOVW    R8,#0x447
    
    /**********************************************************************************************
    * Branch instruction: 
    *   - B.W   Encoding T3 (conditional) 
    *
    * Note: Conditional branch (forward/back) Part-2
    **********************************************************************************************/
  
m4_scst_branch_test2_b_cond_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label1_code1_unprivileged
    MOV     R4,#0x40000000  /* Z=1 */
    MSR     APSR_nzcvq,R4
    ISB
    BNE.W   m4_scst_branch_test2_code1_error
    BEQ.W   m4_scst_branch_test2_testlabel2_code1_unprivileged   /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label1_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label2_code1_unprivileged
    MOV     R4,#0xB0000000  /* Z=0 */
    MSR     APSR_nzcvq,R4
    ISB
    BEQ.W   m4_scst_branch_test2_code1_error
    BNE.W   m4_scst_branch_test2_testlabel2_code1_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label2_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label3_code1_unprivileged
    MOV     R4,#0x20000000  /* C=1 */
    MSR     APSR_nzcvq,R4
    BCC.W   m4_scst_branch_test2_code1_error
    BCS.W   m4_scst_branch_test2_testlabel4_code1_unprivileged   /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
    
m4_scst_branch_test2_label3_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label4_code1_unprivileged
    MOV     R4,#0xD0000000  /* C=0 */
    MSR     APSR_nzcvq,R4
    ISB
    BCS.W   m4_scst_branch_test2_code1_error
    BCC.W   m4_scst_branch_test2_testlabel4_code1_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
 m4_scst_branch_test2_label4_code1_unprivileged:
   
    ADR.W   R2,m4_scst_branch_test2_label5_code1_unprivileged
    MOV     R4,#0x80000000  /* N=1 */
    MSR     APSR_nzcvq,R4
    ISB
    BPL.W   m4_scst_branch_test2_code1_error
    BMI.W   m4_scst_branch_test2_testlabel2_code1_unprivileged   /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
    
m4_scst_branch_test2_label5_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label6_code1_unprivileged
    MOV     R4,#0x70000000  /* N=0 */
    MSR     APSR_nzcvq,R4
    ISB
    BMI.W   m4_scst_branch_test2_code1_error
    BPL.W   m4_scst_branch_test2_testlabel2_code1_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label6_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label7_code1_unprivileged
    MOV     R4,#0x10000000  /* V=1 */
    MSR     APSR_nzcvq,R4
    ISB
    BVC.W   m4_scst_branch_test2_code1_error
    BVS.W   m4_scst_branch_test2_testlabel4_code1_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label7_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label8_code1_unprivileged
    MOV     R4,#0xE0000000  /* V=0  */
    MSR     APSR_nzcvq,R4
    ISB
    BVS.W   m4_scst_branch_test2_code1_error
    BVC.W   m4_scst_branch_test2_testlabel4_code1_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label8_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label9_code1_unprivileged
    MOV     R4,#0x20000000  /* C=1 and Z=0 */
    MSR     APSR_nzcvq,R4
    ISB
    BLS.W   m4_scst_branch_test2_code1_error
    BHI.W   m4_scst_branch_test2_testlabel2_code1_unprivileged   /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
  
m4_scst_branch_test2_label9_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label10_code1_unprivileged
    MOV     R4,#0xD0000000  /* C=0 or Z=1 */
    MSR     APSR_nzcvq,R4
    ISB
    BHI.W   m4_scst_branch_test2_code1_error
    BLS.W   m4_scst_branch_test2_testlabel2_code1_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
    
m4_scst_branch_test2_label10_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label11_code1_unprivileged
    MOV     R4,#0x90000000  /* N=V */
    MSR     APSR_nzcvq,R4
    ISB
    BLT.W   m4_scst_branch_test2_code1_error
    BGE.W   m4_scst_branch_test2_testlabel4_code1_unprivileged   /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
    
m4_scst_branch_test2_label11_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label12_code1_unprivileged
    MOV     R4,#0x80000000  /* N!=V */
    MSR     APSR_nzcvq,R4
    ISB
    BGE.W   m4_scst_branch_test2_code1_error
    BLT.W   m4_scst_branch_test2_testlabel4_code1_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
    
m4_scst_branch_test2_label12_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label13_code1_unprivileged
    MOV     R4,#0x00000000  /* Z=0 and N=V */
    MSR     APSR_nzcvq,R4
    ISB
    BLE.W   m4_scst_branch_test2_code1_error
    BGT.W   m4_scst_branch_test2_testlabel2_code1_unprivileged   /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
    
m4_scst_branch_test2_label13_code1_unprivileged:
  
    ADR.W   R2,m4_scst_branch_test2_label14_code1_unprivileged
    MOV     R4,#0xC0000000  /* Z=1 or N!=V */
    MSR     APSR_nzcvq,R4
    ISB
    BGT.W   m4_scst_branch_test2_code1_error
    BLE.W   m4_scst_branch_test2_testlabel2_code1_unprivileged  /* branch -> */
    MOVW    R8,#0x448
    B       m4_scst_test_tail_end
    
m4_scst_branch_test2_label14_code1_unprivileged:
  
    /* Go back to the "m4_scst_test_code_unprivileged" section */
    B       m4_scst_branch_test2_end
    MOVW    R8,#0x448
    

/* We branch here first - conditional branches supports max. -1048576 to 1048574 bytes */
m4_scst_branch_test2_code1_error:
    B       m4_scst_test_tail_end
    
/*-------------------------------------------------*/
/* This is Test Label 4                            */
/* ------------------------------------------------*/
    SCST_TYPE(m4_scst_branch_test2_testlabel4_code1_unprivileged, function)
m4_scst_branch_test2_testlabel4_code1_unprivileged:
    ADDW    R8,R8,#0x2EA
    ORR     R2,R2,#0x1  /* Ensure bit0 is set */
    BX      R2
    
/*-------------------------------------------------*/
/* This is Test Label 4 with LR check              */
/* ------------------------------------------------*/
    SCST_TYPE(m4_scst_branch_test2_testlabel4_link_code1_unprivileged, function)
m4_scst_branch_test2_testlabel4_link_code1_unprivileged:
    /* We must check bit0 in LR  is set */
    ORR     R2,R2,#1
    SUB     R2,LR,R2
    CBNZ    R2,m4_scst_branch_test2_testlabel4_link_error
    ADDW    R8,R8,#0x2EA
    BX      LR
m4_scst_branch_test2_testlabel4_link_error:
    B       m4_scst_test_tail_end
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
  
    SCST_FILE_END
    