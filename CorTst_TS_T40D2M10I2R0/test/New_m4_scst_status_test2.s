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
* This test tests whether condition operatins (LSU, MAC, SIMDSAT, Branches) are executed 
* correctly depending on flags.
*
* Overall coverage:
* -----------------
* STATUS
*  - IT block folded to non-IT block
*  - Q flag setting in IT block
*  - GE setting in IT block
*  - Branching in IT block 
* 
* DECODER:
* Thumb (16-bit)
*   - Encoding of "Miscellaneous 16-bit instructions" - If-Then
* 测试总结：
* -------------
* 此测试测试是否执行条件操作（LSU、MAC、SIMDSAT、分支）
* 正确取决于标志。
*
* 整体覆盖：
* -----------------
* 地位
* - IT 块折叠到非 IT 块
* - IT 块中的 Q 标志设置
* - IT 区块中的 GE 设置
* - 在 IT 块中分支
*
* 解码器：
* 拇指（16 位）
* - “杂项 16 位指令”的编码 - If-Then

******************************************************************************/
   
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_status_test2
    
    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    SCST_EXTERN m4_scst_clear_flags
    SCST_EXTERN m4_scst_check_q_flag
    SCST_EXTERN m4_scst_check_flags_cleared
    SCST_EXTERN SCST_RAM_TARGET0
    SCST_EXTERN VAL1
    SCST_EXTERN VAL2
    SCST_EXTERN VAL3
    SCST_EXTERN VAL4
    SCST_EXTERN VAL5
    SCST_EXTERN VAL6
    
    /* Local defines */    
SCST_SET(PRESIGNATURE, 0x75DAE354) /* this macro has to be at the beginning of the line */


    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2
    
    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_status_test2" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */    
    SCST_TYPE(m4_scst_status_test2, function)
m4_scst_status_test2:

    PUSH.W  {R1-R12,R14}
    
    LDR     R9,=PRESIGNATURE
    
    LDR     R7,=SCST_RAM_TARGET0
    
    
    /******************************************************************************
    *  Test IT block branches test
    ******************************************************************************/
    MOVS    R6,#0xFFFFFFFF  /* Set N flag */
    ITET    MI
    LDRMI   R6,=m4_status_test2_ret1        /* Yes */
    MOVPL   R9,#0                           /* No */
    BMI     m4_scst_status_test2_testlabel  /* Yes */
    MOV     R9,#0   /* Destroy result ! */
    
m4_status_test2_ret1:
    MOVS    R6,#0   /* Set Z flag */
    ITE     EQ
    LDREQ   R6,=m4_status_test2_ret2         /* Yes */
    BNE     m4_scst_status_test2_testlabel  /* No */
    ADDW    R9,R9,#0x494                    
    
m4_status_test2_ret2:
    ADR.W   R6,m4_status_test2_ret3
    MOVS    R1,#0xFFFFFFFF  /* Set N flag */
    IT      MI
    BMI       m4_scst_status_test2_testlabel   /* Yes */
    MOV     R9,#0   /* Destroy result */
    
m4_status_test2_ret3:
    /******************************************************************************
    *  Test IT block folded to non-IT block
    ******************************************************************************/
    MOVS    R6,#0   /* Set Z flag */
    /* Use opcode to avoid problem with GCC compiler */
    SCST_OPCODE_START
    SCST_OPCODE16(0xBF16)                               /* ITET    NE */
    SCST_OPCODE_END
    MOV     R9,#0x0                                     /* MOVNE    No */
    BL      m4_scst_status_test2_clear_target_memory    /* BLEQ     Yes - IT block to non-IT block */
    ADDW    R9,R9,#0x494                                /* ADDWEQ   No -> Yes */
    
    MOVS    R6,#0xFFFFFFFF  /* Set N flag */
    /* Use opcode to avoid problem with GCC compiler */
    SCST_OPCODE_START
    SCST_OPCODE16(0xBF43)                               /* ITTTE   MI */
    SCST_OPCODE_END
    LDR     R6,=m4_scst_status_test2_init               /* LDRMI    Yes */
    ORR     R6,R6,#1                                    /* ORRMI    Yes */
    BLX     R6                                          /* BLXMI    Yes -> IT block to non-IT block */
    ADDW    R9,R9,#0x494                                /* ADDWPL   No -> Yes */
    
    MOVS    R6,#0   /* Set Z flag */
    /* Use opcode to avoid problem with GCC compiler */
    SCST_OPCODE_START
    SCST_OPCODE16(0xBF0C)                               /* ITE     EQ */
    SCST_OPCODE_END
    BL      m4_scst_clear_flags                         /* BLEQ     Yes -> IT block to non-IT block */
    ADDW    R9,R9,#0x494                                /* ADDWNE   No -> Yes */
    
    
    /******************************************************************************
    *  Test Conditional Load/Store 
    ******************************************************************************/
    /* -- Test Conditional Load/Store -- */
    MOVS    R6,#0x0     /* Sets Z flag */
    ITTE    EQ
    STREQ   R0,[R7]   /* Yes */ 
    STREQ   R2,[R7,#4]  /* Yes */
    STRNE   R4,[R7,#0]  /* No -> This destroys value loaded to R1 */
    DSB
    ITET    EQ
    LDREQ   R1,[R7]   /* Yes */ 
    LDRNE   R1,[R7,#8]  /* No -> This destroys R1 value */
    LDREQ   R3,[R7,#4]  /* Yes */
    /* We need to check data */
    CMP     R0,R1
    BNE     m4_scst_test_tail_end
    CMP     R2,R3
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x494
    
    BL      m4_scst_status_test2_clear_target_memory
    BL      m4_scst_status_test2_init
    BL      m4_scst_clear_flags
    MOV     R6,#0x1
    ADDS.N  R6,R1,R6        /* ALU sets N flag */
    ITTT    MI
    STRMI   R0,[R7]   /* <data_to_store>:R0=0x55555555 */
    DSBMI
    LDRMI   R1,[R7]   /* <data_to_load>:R1=0x55555555 */
    /* We need to check result */
    CMP     R1,R0
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x494
    
    
    /******************************************************************************
    *  Test Conditional Saturation Q flag 
    ******************************************************************************/
    BL      m4_scst_clear_flags
    LDR     R5,=0x40000000    
    MOVS    R6,#0   /* Set Z flag */
    ITT     EQ
    LDREQ   R4,=0x7FFFFFFF
    QDADDEQ R12,R6,R5
    /* We need to check result */
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    /* We need to check saturation expected */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x494
    
    BL      m4_scst_clear_flags
    LDR     R5,=0x2AAAAAAA
    MOVS    R6,#0   /* Set Z flag */
    ITEE    NE
    LDRNE   R5,=0x0         /* No */
    MOVEQ   R6,#1           /* Yes */
    QDADDEQ R12,R6,R5       /* Yes */
    /* We need to check result */
    LDR     R4,=0x55555555
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    /* We need to check saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x494
    
    
    /******************************************************************************
    *  Test Conditional MAC
    ******************************************************************************/
    BL      m4_scst_clear_flags
    
    LDR     R2,=0x55555556
    LDR     R3,=0xFFFFFFFF
    MOVS    R0,R3   /* Set V flag */
    ITE     PL
    UMULLPL   R0,R1,R2,R3 /* No */
    UMULLMI R1,R0,R2,R3 /* Yes */
    /* We need to check result */
    CMP     R0,#0x55555555
    BNE     m4_scst_test_tail_end
    CMP     R1,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x494
    
    
   /******************************************************************************
    *  Test IT block which behaves as non IT block
    ******************************************************************************/
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START
    SCST_OPCODE16(0xBFE2)       /* ITTT     AL */
    SCST_OPCODE_END
    LDR     R10,=0x55555555     /* LDRAL    R10,0x55555555 */
    LDR     R2,=0x55545554      /* LDRAL    R2,0x55545554 */
    ADDW    R9,R9,#0x494        /* ADDWAL   R9,R9,#0x494 */
    
    
    /******************************************************************************
    *  Test Conditional GE flags
    ******************************************************************************/
    BL      m4_scst_clear_flags
    
    LSLS    R5,R10,#0x1 /* Set N flag */
    ITE     MI
    SADD16MI  R3,R5,R5        /* Yes */
    SADD16PL  R3,R10,R10    /* No */
    /* We need to check result */
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    /* We need to check GE */
    LDR     R0,=0x00000000
    BL      m4_scst_status_test2_check_ge
    
    ADDW    R9,R9,#0x494
    
    BL      m4_scst_clear_flags
    LSLS    R4,R10,#2   /* Set C flag */    
    ITE     CC
    SADD16CC  R3,R5,R5        /* No*/
    SADD16CS  R3,R10,R10    /* Yes */
    LSLS    R4,R10,#1   /* Clear C flag */
    IT      CS
    SADD16CS  R3,R5,R5        /* No*/
    /* We need to check result */
    CMP     R3,R5
    BNE     m4_scst_test_tail_end
    /* We need to check GE */
    LDR     R0,=0x0000000F
    BL      m4_scst_status_test2_check_ge
    
    ADDW    R9,R9,#0x494
    
    
    MOV     R0,R9       /* Test result is returned in R0 */
    
    B       m4_scst_test_tail_end
    
    
m4_scst_status_test2_init:
    /*************************************************************************************************
    * Instruction: 
    * - LDR (literal)   Encoding T1 (16-bit)
    *
    * Note: Tested indirectly 
    **************************************************************************************************/
    LDR.N   R0,=VAL1
    LDR.N   R1,=VAL2
    LDR.N   R2,=VAL3
    LDR.N   R3,=VAL4
    LDR.N   R4,=VAL5
    LDR.N   R5,=VAL6
    
    
    BX      LR

m4_scst_status_test2_clear_target_memory:
    EORS    R1,R1   /* Clear R1 */
    MVN     R1,R1
    /* Clear memory */
    STR     R1,[R7]
    STR     R1,[R7,#4]
    STR     R1,[R7,#8]
    STR     R1,[R7,#12]
    BX      LR
    
m4_scst_status_test2_check_ge:
    /* Expected APSR[GE] content passed in R0 */
    MRS     R1,APSR     /* Load flags */
    LSL     R1,R1,#12
    LSR     R1,R1,#28
    CMP     R0,R1
    BNE     m4_scst_test_tail_end
    BX      LR
    
m4_scst_status_test2_testlabel:
    ADDW    R9,R9,#0x494    /* 2x */
    ORR     R6,R6,#0x1  /* Ensure bit0 is set */
    BX      R6
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
