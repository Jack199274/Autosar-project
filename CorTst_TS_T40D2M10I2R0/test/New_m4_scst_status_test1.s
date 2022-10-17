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
* This test tests whether condition code is executed correctly depending
* on flags.
*
* Overall coverage:
* -----------------
* STATUS
*  - N,Z,C,V flags forwarding from ALU to the STATUS module.
*  - N,Z flags forwarding from the MUL command to the STATUS module.
*  - IT conditions (MI,PL,EQ,NE,CS,CC,VS,VC,HI,LS,GT,LE,GE,LT)
* 
* DECODER:
* Thumb (16-bit)
*   - Encoding of "Miscellaneous 16-bit instructions" - If-Then
* 测试总结：
* -------------
* 此测试测试条件代码是否正确执行取决于
* 在旗帜上。
*
* 整体覆盖：
* -----------------
* 地位
* - N、Z、C、V 标志从 ALU 转发到 STATUS 模块。
* - N,Z 标志从 MUL 命令转发到 STATUS 模块。
* - IT 条件（MI、PL、EQ、NE、CS、CC、VS、VC、HI、LS、GT、LE、GE、LT）
*
* 解码器：
* 拇指（16 位）
* - “杂项 16 位指令”的编码 - If-Then

******************************************************************************/

#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_status_test1
    
    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    SCST_EXTERN m4_scst_clear_flags
    SCST_EXTERN m4_scst_check_flags_cleared

    /* Local defines */
SCST_SET(PRESIGNATURE, 0x17A3E152) /* this macro has to be at the beginning of the line */


    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2
    
    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_status_test1" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_status_test1, function)
m4_scst_status_test1:

    PUSH.W  {R1-R12,R14}
    
    LDR     R9,=PRESIGNATURE
    
    /******************************************************************************
    *   Test connection from the ALU module to the STATUS module
    ******************************************************************************/
    /* -- Tests ALU N flag forwarding */
    /* -- Test Conditions MI,PL -- */
    BL      m4_scst_status_prepare_data
    
    BL      m4_scst_clear_flags
    ADDS.N  R2,R2,R0        /* ALU sets N flag */
    ITTTT   PL
    ADDPL   R3,R2,R1        /* No! */
    ADDPL   R5,R2,R1        /* No! */
    ADDPL   R6,R2,R1        /* No! */
    ADDPL   R7,R2,R1        /* No! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    ADDS.N  R2,R2,R0        /* ALU sets N flag */
    ITTTT   MI
    ADDMI   R3,R2,R0        /* Yes! */
    ADDMI   R5,R2,R0        /* Yes! */
    ADDMI   R6,R2,R0        /* Yes! */
    ADDMI   R7,R2,R0        /* Yes! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    ADDS.N  R2,R2,R0        /* ALU sets N flag */
    ITEEE   MI
    CMPMI   R3,#0xAAAAAAAA  /* Yes! -> ALU Clears N flag */
    ADDPL   R5,R2,R0        /* Yes! */
    ADDPL   R6,R2,R0        /* Yes! */
    ADDPL   R7,R2,R0        /* Yes! */
    /* We need to check result */
    MOV     R3,#0xAAAAAAAA
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    ADDS.N  R2,R2,R0        /* ALU sets N flag */
    ITTTE   MI
    ADDMI   R3,R2,R0        /* Yes! */
    ADDMI   R5,R2,R0        /* Yes! */
    ADDMI   R6,R2,R0        /* Yes! */
    MOVPL   R7,#0x44        /* No! */
    /* We need to check result */
    BL      m4_scst_status_check_result1
    
    BL      m4_scst_clear_flags
    ADDS.N  R2,R2,R0        /* ALU sets N flag */
    ITTEE   MI
    ADDMI   R3,R2,R0        /* Yes! */
    ADDMI   R5,R2,R0        /* Yes! */
    MOVPL   R6,#0x44        /* No! */
    MOVPL   R7,#0x44        /* No! */
    /* We need to check result */
    BL      m4_scst_status_check_result2
    
    ADDW    R9,R9,#0x358
    
    
    /* -- Tests ALU Z flag forwarding */
    /* -- Test Conditions EQ,NE -- */
    BL      m4_scst_status_prepare_data
   
    BL      m4_scst_clear_flags
    EORS.N  R4,R0           /* ALU sets Z flag */
    ITTTT   NE
    ADDNE   R3,R2,R1        /* No! */
    ADDNE   R5,R2,R1        /* No! */
    ADDNE   R6,R2,R1        /* No! */
    ADDNE   R7,R2,R1        /* No! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    MOV     R3,#0xFFFFFFFF
    EORS.N  R4,R0           /* ALU sets Z flag */
    ITTTT   EQ
    /* Select instruction which updates flags outside IT block */    
    ANDEQ   R3,R2           /* Yes! - This instruction can not clear Z flag !!!! */
    ADDEQ   R5,R2,R0        /* Yes! */
    ADDEQ   R6,R2,R0        /* Yes! */
    ADDEQ   R7,R2,R0        /* Yes! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    EORS.N  R4,R0           /* ALU sets Z flag */
    ITEEE   EQ
    CMPEQ   R3,#0xAAAAAAAA  /* Yes! -> ALU Clears Z flag */
    ADDNE   R5,R2,R0        /* Yes! */
    ADDNE   R6,R2,R0        /* Yes! */
    ADDNE   R7,R2,R0        /* Yes! */
    /* We need to check result */
    MOV     R3,#0xAAAAAAAA
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    EORS.N  R4,R0           /* ALU sets Z flag */
    ITTET   EQ
    ADDEQ   R3,R2,R0        /* Yes! */
    ADDEQ   R5,R2,R0        /* Yes! */
    MOVNE   R7,#0x44        /* No! */
    ADDEQ   R6,R2,R0        /* Yes! */
    /* We need to check result */
    BL      m4_scst_status_check_result1
    
    BL      m4_scst_clear_flags
    EORS.N  R4,R0           /* ALU sets Z flag */
    ITEET   EQ
    ADDEQ   R3,R2,R0        /* Yes! */
    MOVNE   R6,#0x44        /* No! */
    MOVNE   R7,#0x44        /* No! */
    ADDEQ   R5,R2,R0        /* Yes! */
    /* We need to check result */
    BL      m4_scst_status_check_result2
    
    ADDW    R9,R9,#0x358
    
    
    /* -- Tests ALU C flag forwarding */
    /* -- Test Conditions CS,CC -- */
    BL      m4_scst_status_prepare_data
    
    BL      m4_scst_clear_flags
    LSLS.N  R4,R2,#1        /* ALU sets C flag */
    ITTTT   CC
    ADDCC   R3,R2,R1        /* No! */
    ADDCC   R5,R2,R1        /* No! */
    ADDCC   R6,R2,R1        /* No! */
    ADDCC   R7,R2,R1        /* No! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    LSLS.N  R4,R2,#1        /* ALU sets C flag */
    ITTTT   CS
    ADDCS   R3,R2,R0        /* Yes! */
    ADDCS   R5,R2,R0        /* Yes! */
    ADDCS   R6,R2,R0        /* Yes! */
    ADDCS   R7,R2,R0        /* Yes! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    LSLS.N  R4,R2,#1        /* ALU sets C flag */
    ITEEE   CS
    CMPCS   R3,#0xAAAAAAAA  /* Yes! -> ALU Clears C flag */
    ADDCC   R5,R2,R0        /* Yes! */
    ADDCC   R6,R2,R0        /* Yes! */
    ADDCC   R7,R2,R0        /* Yes! */
    /* We need to check result */
    MOV     R3,#0xAAAAAAAA
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    LSLS.N  R4,R2,#1        /* ALU sets C flag */
    ITETT   CS
    ADDCS   R3,R2,R0        /* Yes! */
    MOVCC   R7,#0x44        /* No! */
    ADDCS   R5,R2,R0        /* Yes! */
    ADDCS   R6,R2,R0        /* Yes! */
    /* We need to check result */
    BL      m4_scst_status_check_result1
    
    BL      m4_scst_clear_flags
    LSLS.N  R4,R2,#1        /* ALU sets C flag */
    ITETE   CS
    ADDCS   R3,R2,R0        /* Yes! */
    MOVCC   R6,#0x44        /* No! */
    ADDCS   R5,R2,R0        /* Yes! */
    MOVCC   R7,#0x44        /* No! */
    /* We need to check result */
    BL      m4_scst_status_check_result2
    
    ADDW    R9,R9,#0x358
    
    
    /* -- Tests ALU V flag forwarding */
    /* -- Test Conditions VS,VC -- */
    BL      m4_scst_status_prepare_data
    
    BL      m4_scst_clear_flags
    ADDS.N  R4,R2,R2        /* ALU sets V flag */
    ITTTT   VC
    ADDVC   R3,R2,R1        /* No! */
    ADDVC   R5,R2,R1        /* No! */
    ADDVC   R6,R2,R1        /* No! */
    ADDVC   R7,R2,R1        /* No! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    ADDS.N  R4,R2,R2        /* ALU sets V flag */
    ITTTT   VS
    ADDVS   R3,R2,R0        /* Yes! */
    ADDVS   R5,R2,R0        /* Yes! */
    ADDVS   R6,R2,R0        /* Yes! */
    ADDVS   R7,R2,R0        /* Yes! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    ADDS.N  R4,R2,R2        /* ALU sets V flag */
    ITEEE   VS
    CMPVS   R3,#0xAAAAAAAA  /* Yes! -> ALU Clears V flag */
    ADDVC   R5,R2,R0        /* Yes! */
    ADDVC   R6,R2,R0        /* Yes! */
    ADDVC   R7,R2,R0        /* Yes! */
    /* We need to check result */
    MOV     R3,#0xAAAAAAAA
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    ADDS.N  R4,R2,R2        /* ALU sets V flag */
    ITTET   VS
    ADDVS   R3,R2,R0        /* Yes! */
    ADDVS   R5,R2,R0        /* Yes! */
    MOVVC   R7,#0x44        /* No! */
    ADDVS   R6,R2,R0        /* Yes! */
    /* We need to check result */
    BL      m4_scst_status_check_result1
    
    BL      m4_scst_clear_flags
    ADDS.N  R4,R2,R2        /* ALU sets V flag */
    ITETE   VS
    ADDVS   R3,R2,R0        /* Yes! */
    MOVVC   R6,#0x44        /* No! */
    ADDVS   R5,R2,R0        /* Yes! */
    MOVVC   R7,#0x44        /* No! */
    /* We need to check result */
    BL      m4_scst_status_check_result2
    
    ADDW    R9,R9,#0x358
    
    
    /* -- Test Conditions HI,LS -- */
    BL      m4_scst_status_prepare_data
    
    BL      m4_scst_clear_flags
    CMP     R1,R0        /* ALU sets flags */
    ITTTT   LS
    ADDLS   R3,R2,R1        /* No! */
    ADDLS   R5,R2,R1        /* No! */
    ADDLS   R6,R2,R1        /* No! */
    ADDLS   R7,R2,R1        /* No! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    CMP     R1,R0        /* ALU sets flags */
    ITTTT   HI
    ADDHI   R3,R2,R0        /* Yes! */
    ADDHI   R5,R2,R0        /* Yes! */
    ADDHI   R6,R2,R0        /* Yes! */
    ADDHI   R7,R2,R0        /* Yes! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    CMP     R1,R0        /* ALU sets flags */
    ITEEE   HI
    CMPHI   R0,R1           /* Yes! -> ALU sets new flags */
    ADDLS   R5,R2,R0        /* Yes! */
    ADDLS   R6,R2,R0        /* Yes! */
    ADDLS   R7,R2,R0        /* Yes! */
    /* We need to check result */
    MOV     R3,#0xAAAAAAAA
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    CMP     R1,R0        /* ALU sets flags */
    ITEEE   LS
    MOVLS   R7,#0x44        /* No! */
    ADDHI   R3,R2,R0        /* Yes! */
    ADDHI   R5,R2,R0        /* Yes! */
    ADDHI   R6,R2,R0        /* Yes! */
    /* We need to check result */
    MOV     R3,#0xAAAAAAAA
    BL      m4_scst_status_check_result1
    
    ADDW    R9,R9,#0x358
    
    
    /* -- Test Conditions GE,LT -- */
    BL      m4_scst_status_prepare_data
    
    BL      m4_scst_clear_flags
    CMP     R0,R2        /* ALU sets flags */
    ITTTT   LT
    ADDLT   R3,R2,R1        /* No! */
    ADDLT   R5,R2,R1        /* No! */
    ADDLT   R6,R2,R1        /* No! */
    ADDLT   R7,R2,R1        /* No! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    CMP     R0,R2        /* ALU sets flags */
    ITTTT   GE
    ADDGE   R3,R2,R0        /* Yes! */
    ADDGE   R5,R2,R0        /* Yes! */
    ADDGE   R6,R2,R0        /* Yes! */
    ADDGE   R7,R2,R0        /* Yes! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    CMP     R0,R2        /* ALU sets flags */
    ITEEE   GE
    CMPGE   R2,R0           /* Yes! -> ALU sets new flags */
    ADDLT   R5,R2,R0        /* Yes! */
    ADDLT   R6,R2,R0        /* Yes! */
    ADDLT   R7,R2,R0        /* Yes! */
    /* We need to check result */
    MOV     R3,#0xAAAAAAAA
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    CMP     R0,R2        /* ALU sets flags */
    ITEET   LT
    MOVLT   R6,#0x44        /* No! */
    ADDGE   R3,R2,R0        /* Yes! */
    ADDGE   R5,R2,R0        /* Yes! */
    MOVLT   R7,#0x44        /* No! */
    /* We need to check result */
    BL      m4_scst_status_check_result2
    
    ADDW    R9,R9,#0x358
    
    
    /* -- Test Conditions GT,LE -- */
    BL      m4_scst_status_prepare_data
    
    BL      m4_scst_clear_flags
    CMP     R0,R2        /* ALU sets flags */
    ITTTT   LE
    ADDLE   R3,R2,R1        /* No! */
    ADDLE   R5,R2,R1        /* No! */
    ADDLE   R6,R2,R1        /* No! */
    ADDLE   R7,R2,R1        /* No! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    CMP     R0,R2        /* ALU sets flags */
    ITTTT   GT
    ADDGT   R3,R2,R0        /* Yes! */
    ADDGT   R5,R2,R0        /* Yes! */
    ADDGT   R6,R2,R0        /* Yes! */
    ADDGT   R7,R2,R0        /* Yes! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    CMP     R0,R2        /* ALU sets flags */
    ITEEE   GT
    CMPGT   R0,#0           /* Yes! -> ALU sets new flags */
    ADDLE   R5,R2,R0        /* Yes! */
    ADDLE   R6,R2,R0        /* Yes! */
    ADDLE   R7,R2,R0        /* Yes! */
    /* We need to check result */
    MOV     R3,#0xAAAAAAAA
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    CMP     R0,R2        /* ALU sets flags */
    ITETE   LE
    MOVLE   R6,#0x44        /* No! */
    ADDGT   R3,R2,R0        /* Yes! */
    MOVLE   R7,#0x44        /* No! */
    ADDGT   R5,R2,R0        /* Yes! */
    /* We need to check result */
    BL      m4_scst_status_check_result2
    
    ADDW    R9,R9,#0x358
    
    
    /******************************************************************************
    *   Test connection from the MUL command to the STATUS module
    ******************************************************************************/
    /* -- Tests MUL N flag forwarding */
    BL      m4_scst_clear_flags
    MULS.N  R2,R1                /* Set N flag */
    ITTTE   MI
    ADDMI   R3,R2,R0    /* Yes! */
    ADDMI   R5,R2,R0    /* Yes! */
    ADDMI   R6,R2,R0    /* Yes! */
    MOVPL   R7,#0x44    /* No! */
    /* We need to check result */
    BL      m4_scst_status_check_result1
    
    BL      m4_scst_clear_flags
    MULS.N  R2,R1                /* Set N flag */
    ITTEE   PL
    MOVPL   R6,#0x44    /* No! */
    MOVPL   R7,#0x44    /* No! */
    ADDMI   R3,R2,R0    /* Yes! */
    ADDMI   R5,R2,R0    /* Yes! */
    
    /* We need to check result */
    BL      m4_scst_status_check_result2
    
    ADDW    R9,R9,#0x358
    
    
    /* -- Tests MUL Z flag forwarding */
    MOV     R3,#1
    BL      m4_scst_clear_flags
    MULS.N  R0,R2                /* Set Z flag */
    ITTTT   EQ
    /* Select instruction which updates flags outside IT block */
    MULEQ   R3,R2       /* Yes! - This instruction can not clear Z flag !!!! */ 
    ADDEQ   R5,R2,R0    /* Yes! */
    ADDEQ   R6,R2,R0    /* Yes! */
    ADDEQ   R7,R2,R0    /* Yes! */
    /* We need to check result */
    BL      m4_scst_status_check_result0
    
    BL      m4_scst_clear_flags
    MULS.N  R0,R2                /* Set Z flag */
    ITETE   NE
    MOVNE   R6,#0x44    /* No! */
    ADDEQ   R3,R2,R0    /* Yes! */
    MOVNE   R7,#0x44    /* No! */
    ADDEQ   R5,R2,R0    /* Yes! */
    /* We need to check result */
    BL      m4_scst_status_check_result2
    
    ADDW    R9,R9,#0x358
    
    
    MOV     R0,R9       /* Test result is returned in R0 */
    
    B       m4_scst_test_tail_end

m4_scst_status_prepare_data:
    MOV     R0,#0
    MOV     R1,#1
    MOV     R2,#0xAAAAAAAA
    MOV     R3,R2
    MOV     R5,R2
    MOV     R6,R2
    MOV     R7,R2
    BX      LR

m4_scst_status_check_result0:
    EORS    R3,R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    EORS    R5,R5,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    EORS    R6,R6,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    EORS    R7,R7,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    BX      LR

m4_scst_status_check_result1:
    EORS    R3,R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    EORS    R5,R5,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    EORS    R6,R6,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    CMP     R7,#0x44
    BEQ     m4_scst_test_tail_end
    BX      LR
    
m4_scst_status_check_result2:
    EORS    R3,R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    EORS    R5,R5,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    CMP     R6,#0x44
    BEQ     m4_scst_test_tail_end
    CMP     R7,#0x44
    BEQ     m4_scst_test_tail_end
    BX      LR    
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
