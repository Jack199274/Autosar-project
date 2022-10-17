/******************************************************************************
*
* Copyright 2015-2016 Freescale
* Copyright 2019-2020 NXP
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
* This test focuses on branches under special conditions. 
* E.g. branch decoder relies on ALU, MAC or LSU modules which have to update flags 
* on time.
* It also tests "Time branches" and BLX,BX instructions usage fault 
* exception triggering.
*
* Overall coverage:
* -----------------
* - Special branch condition, see above
* - Time branches BLX LR, MOV PC,LR
* - BLX,BX (change instruction set)
* 
* 测试总结：
* -------------
* 此测试针对特殊条件下的分支。
* 例如 分支解码器依赖于必须更新标志的 ALU、MAC 或 LSU 模块
* 准时。
* 它还测试“时间分支”和BLX，BX指令使用错误
* 异常触发。
*
* 整体覆盖：
* -----------------
* - 特殊分支条件，见上文
* - 时间分支 BLX LR, MOV PC,LR
* - BLX,BX（更改指令集）

******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_branch_test3
    
    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_store_registers_content
    SCST_EXTERN m4_scst_set_scst_interrupt_vector_table
    SCST_EXTERN m4_scst_restore_registers_content
    SCST_EXTERN m4_scst_exception_test_tail_end
    SCST_EXTERN m4_scst_ISR_address
    SCST_EXTERN m4_scst_test_was_interrupted    

    /* Local defines */
SCST_DEFINE(PRESIGNATURE, 0x7E251A35) /*this macro has to be at the beginning of the line*/


    SCST_SECTION_EXEC(m4_scst_test_code)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_branch_test3" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_branch_test3, function)
m4_scst_branch_test3:

    PUSH.W  {R1-R8,R14}
    
    /* R5 is used as intermediate result */
    LDR     R5,=PRESIGNATURE
    
    /* Store registers content */
    BL      m4_scst_store_registers_content
    
    /* Save current content of PRIMASK in R1 and current content of FAULTMASK to R6 */
    /* ! Don't use R1, R6 for any other purpose until PRIMASK, FAULTMASK is restored. */
    MRS     R1,PRIMASK
    MRS     R6,FAULTMASK
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_branch_test3_ISR1
    ORR     R4,R4,#1        /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    /* Before vector table is changed to the SCST-own one, clear R2.
    If any interrupt occurs after table is switched but before R2 is set to a pre-defined value.

    Also before table is switched, set R0 to the return address from the ISR. Content of R0 and R2
    will allow determining whether interrupt was triggered by SCST library or by alien SW.

    ! Don't use R0 for any other purpose until vector table is changed to a user one.
    ! Don't use R2 for any other purpose until vector table is changed to a user one. */
    
    MOV     R2,#0x0
    ADR.W   R0,m4_scst_branch_test3_ret9
    
    /* Set SCST interrupt vector table */
    BL      m4_scst_set_scst_interrupt_vector_table
    
    /* We need to check Usage fault is not active or pending */
    LDR     R3,=M4_SHCSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<3)          /* Check SHCSR[USGFAULTACT] bit is not set */
    BNE.W   m4_scst_branch_test3_pending_active
    TST     R4,#(1<<12)         /* Check SHCSR[USGFAULTPENDED] bit is not set */
    BNE.W   m4_scst_branch_test3_pending_active
    
    /* We need to enable Usage fault exception */
    ORR     R4,R4,#(1<<18)      /* Set SHCSR[USGFAULTENA] bit */
    STR     R4,[R3]             /* Modify SHCSR register */
    
    LDR     R3,=M4_SHPR1_REG
    MOV     R4,#0x0
    STRB    R4,[R3,#2]          /* Clear SHPR1[PRI_6] to enable possibly masked Usage fault exception only */
    
    CPSIE   i    /* Enable interrupts and configurable fault handlers (clear PRIMASK) */
    CPSIE   f    /* Enable interrupts and fault handlers (clear FAULTMASK) */
    
    /**********************************************************************************************
    *   Test time branches:
    *   - Test connection from MAC,ALU to the branch decoder in the following case:
    *     Conditional branch instruction immediately follows MAC,ALU instruction which updates flags.
    *
    *   We assume the following scenario for CPU pipeline:
    *      cmd1: MULS    (execute) -> MULS    (write)
    *      cmd2: B<cond> (decode)  -> B<cond> (execute)
    *      
    **********************************************************************************************/
    MOV     R2,#0x0
    MSR     APSR_nzcvq,R2     /* Set N,Z,C,V,Q flags */
    
    /**********************************************************************************************
    * Branch instruction: 
    *   - B.N   Encoding T1 (16bit Thumb)
    *
    * Note: Test MAC,ALU modules connection to the branch decoder.
    **********************************************************************************************/
    LDR     R4,=0x55555556
    LDR     R3,=0xFFFFFFFF
    ADR.W   R7,m4_scst_branch_test3_ret1
    MULS    R3,R4   /* This will set N flag */
    /* (16bit Thumb) Check MAC module flag generation is not too late to be used in branch decoder */
    BMI.N   m4_scst_branch_test3_testlabel1 /* Branch -> */
    MOVW    R5,#0x444
    B       m4_scst_branch_test3_end
    
m4_scst_branch_test3_ret1:
    LDR     R4,=0xAAAAAAAB
    LDR     R3,=0xFFFFFFFF
    ADR.W   R7,m4_scst_branch_test3_ret2
    MULS    R3,R4   /* This will clear N flag which is set from previous test */
    /* (16bit Thumb) Check MAC module flag generation is not too late to be used in branch decoder */
    BPL.N   m4_scst_branch_test3_testlabel1 /* Branch -> */
    MOVW    R5,#0x444
    B       m4_scst_branch_test3_end

m4_scst_branch_test3_ret2:
    LDR     R4,=0x55555555
    ADR.W   R7,m4_scst_branch_test3_ret3
    EORS    R3,R4   /* This will set Z flag */
    /* (16bit Thumb) Check ALU module flag generation is not too late to be used in branch decoder */
    BEQ.N   m4_scst_branch_test3_testlabel1 /* Branch -> */
    MOVW    R5,#0x444
    B       m4_scst_branch_test3_end
    
m4_scst_branch_test3_ret3:
    LDR     R3,=0xFFFFFFFF
    ADR.W   R7,m4_scst_branch_test3_ret4
    ANDS    R3,R4   /* This will clear Z flag which is set from previous test */
    /* (16bit Thumb) Check ALU module flag generation is not too late to be used in branch decoder */
    BNE.N   m4_scst_branch_test3_testlabel1 /* Branch -> */
    MOVW    R5,#0x444
    B       m4_scst_branch_test3_end
    
/*-------------------------------------------------*/
/* This is Test Label                              */
/* ------------------------------------------------*/
m4_scst_branch_test3_testlabel1:
    ADDW    R5,R5,#0x543    /* <- branch here 10x */
    MOV.N   PC,R7
    
    /**********************************************************************************************
    * Branch instruction: 
    *   - B.W   Encoding T3 (32bit Thumb)
    *
    * Note: Test MAC,ALU modules connection to the branch decoder. 
    **********************************************************************************************/
m4_scst_branch_test3_ret4:
    /* Test BMI, BPL branches which checks N flag */
    LDR     R4,=0x55555556
    LDR     R3,=0xFFFFFFFF
    ADR.W   R7,m4_scst_branch_test3_ret5
    MULS    R3,R4   /* This will set N flag */
    /* (32bit Thumb) Check MAC module flag generation is not too late to be used in branch decoder */
    BMI.W   m4_scst_branch_test3_testlabel1 /* Branch -> */
    MOVW    R5,#0x444
    B       m4_scst_branch_test3_end
    
m4_scst_branch_test3_ret5:
    LDR     R4,=0xAAAAAAAB
    LDR     R3,=0xFFFFFFFF
    ADR.W   R7,m4_scst_branch_test3_ret6
    MULS    R3,R4   /* This will clear N flag which is set from previous test */
    /* (32bit Thumb) Check MAC module flag generation is not too late to be used in branch decoder */
    BPL.W   m4_scst_branch_test3_testlabel1 /* Branch -> */
    MOVW    R5,#0x444
    B       m4_scst_branch_test3_end

    /* Test BEQ, BNE branches which checks N flag */
m4_scst_branch_test3_ret6:
    LDR     R4,=0x55555555
    ADR.W   R7,m4_scst_branch_test3_ret7
    EORS    R3,R4   /* This will set Z flag */
    /* (32bit Thumb) Check ALU module flag generation is not too late to be used in branch decoder */
    BEQ.W   m4_scst_branch_test3_testlabel1 /* Branch -> */
    MOVW    R5,#0x444
    B       m4_scst_branch_test3_end
    
m4_scst_branch_test3_ret7:
    LDR     R3,=0xFFFFFFFF
    ADR.W   R7,m4_scst_branch_test3_ret8
    ANDS    R3,R4   /* This will clear Z flag which is set from previous test */
    /* (32bit Thumb) Check ALU module flag generation is not too late to be used in branch decoder */
    BNE.W   m4_scst_branch_test3_testlabel1 /* Branch -> */
    MOVW    R5,#0x444
    B       m4_scst_branch_test3_end
    
m4_scst_branch_test3_ret8:
    ADR.W   R7,m4_scst_branch_test3_ret9         /* Return address for B<cond> */
    LDR     R4,=0x55555556
    LDR     R3,=0xFFFFFFFF
    MULS    R3,R4   /* This will set N flag */
    /* Prepare R2 for exception */
    MOV     R2,#0xB
    SVC     0   /* Trigger Exception !! */
    
m4_scst_branch_test3_ISR_ret_addr1:
    /* (16bit Thumb) Check xPSR(APSR) is not restored too late to be used in branch decoder */
    BMI.N   m4_scst_branch_test3_testlabel1 /* Branch -> */
    MOVW    R5,#0x444
    B       m4_scst_branch_test3_end
    
m4_scst_branch_test3_ret9:   
    ADR.W   R7,m4_scst_branch_test3_ret10       /* Return address for B<cond> */
    LDR     R4,=0x55555556
    LDR     R3,=0xFFFFFFFF
    MULS    R3,R4   /* This will set N flag */
    /* Prepare R0, R2 for exception */
    ADR.W   R0,m4_scst_branch_test3_ISR_ret_addr2
    MOV     R2,#0xB
    SVC     0   /* Trigger Exception !! */
    
m4_scst_branch_test3_ISR_ret_addr2:
    /* (32bit Thumb) Check xPSR(APSR) is not restored too late to be used in branch decoder */
    BMI.W   m4_scst_branch_test3_testlabel1 /* Branch -> */
    MOVW    R5,#0x444
    B       m4_scst_branch_test3_end
    
m4_scst_branch_test3_ret10:
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_branch_test3_ISR2_error
    ORR     R4,R4,#1        /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    /* Prepare R0, R2 for exception */
    ADR.W   R0,m4_scst_branch_test3_testlabel2_link 
    MOV     R2,#0x6
    /**********************************************************************************************
    * Branch instruction: 
    *   - BLX LR (Time branches)
    *
    * Note: Bit0 is set -> no exception will be triggered.
    *       We are prepared for exception but we expect that no exception will be triggered !!
    *       In case of exception is triggered result in R5 will be destroyed.
    **********************************************************************************************/
    ADR.W   R7,m4_scst_branch_test3_ret11   /* Load address which we expect in LR */
    ORR     R7,R7,#1    /* We expect bit0 will be set */
    MOV     LR,R0       /* Store address we plan to branch to it to LR */
    ORR     LR,LR,#1    /* We must set bit0 to avoid exception triggering */
    BLX     LR  /* Branch -> No exception is triggered !! */
    
m4_scst_branch_test3_ret11:
    ADDW    R5,R5,#0x453    /* MOV PC,LR is correct -> Update result */
    
     /* We need to test that INVSTATE flag is not set by an application */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]
    TST     R4,#(1<<1)      /* Test UFSR[INVSTATE] bit is set or not */
    BNE     m4_scst_branch_test3_end
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_branch_test3_ISR2
    ORR     R4,R4,#1        /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    /* Prepare R0, R2 for exception */
    ADR.W   R0,m4_scst_branch_test3_testlabel1_link
    MOV     R2,#0x6
    /**********************************************************************************************
    * Branch instruction: 
    *   - BLX   (change instruction set)
    *
    * Note: It branches to address in R0 and then M4 core generates exception 
    *       since it supports only Thumb instruction set.
    **********************************************************************************************/
    BLX     R0  /* Branch -> */
    
m4_scst_branch_test3_ret12:
    ADDW    R5,R5,#0x345
    
    /* We need to test that INVSTATE flag is not set by an application */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]
    TST     R4,#(1<<1)      /* Test UFSR[INVSTATE] bit is set or not */
    BNE     m4_scst_branch_test3_end
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_branch_test3_ISR3
    ORR     R4,R4,#1        /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    /* Prepare R0, R2 for exception */
    ADR.W   R0,m4_scst_branch_test3_testlabel2
    MOV     R2,#0x6
    /**********************************************************************************************
    * Branch instruction: 
    *   - BX   (change instruction set)
    *
    * Note: It branches to address in R0 and then M4 core generates exception 
    *       since it supports only Thumb instruction set.
    **********************************************************************************************/
    ADR.W   R7,m4_scst_branch_test3_ret13   /* Load expected address */
    BX      R0  /* Branch -> */
    
m4_scst_branch_test3_ret13:
    ADDW    R5,R5,#0x354
    
m4_scst_branch_test3_end:
    BL      m4_scst_restore_registers_content
    MOV     R0,R5        /* Test result is returned in R0, according to the conventions */
    B       m4_scst_exception_test_tail_end
 
m4_scst_branch_test3_pending_active:
    LDR     R3,=m4_scst_test_was_interrupted
    STR     R3,[R3]
    B       m4_scst_branch_test3_end
    
/*-------------------------------------------------*/
/* This is Test Label                              */
/* ------------------------------------------------*/
  SCST_LABEL
m4_scst_branch_test3_testlabel2:
  SCST_CODE
    /* Trigger exception here !! *
       In case of exception is not triggered destroy R5 */
    MOVW    R5,#0x444
m4_scst_branch_test3_ISR3_ret_addr:
    MOV.N   PC,R7
    
/*-------------------------------------------------*/
/* This is Test Label 1 link                       */
/* ------------------------------------------------*/
  SCST_LABEL
m4_scst_branch_test3_testlabel1_link:
  SCST_CODE
    /**********************************************************************************************
    *   Test time branches:
    *   - LR restoring is not too late to be used in branch decoder 
    **********************************************************************************************/
    /* Trigger exception here !! *
       In case of exception is not triggered destroy R5 */
    MOVW    R5,#0x444
    /* Check LR restoring is not too late to be used in branch decoder */
m4_scst_branch_test3_ISR2_ret_addr:
    BX      LR
    
/*-------------------------------------------------*/
/* This is Test Label 2 link                       */
/* ------------------------------------------------*/
  SCST_LABEL
m4_scst_branch_test3_testlabel2_link:
  SCST_CODE
    /**********************************************************************************************
    * Branch instruction: 
    *   - MOV PC,LR (Time branches)
    **********************************************************************************************/
    /* We need to check LR was updated */
    CMP     LR,R7
    BNE     m4_scst_branch_test3_end
    ADDW    R5,R5,#0x435    /* BLX LR is correct -> Update result */
    MOV.N   PC,LR   /* Branch -> */
    
    
m4_scst_branch_test3_ISR1:
    MOV     R1,#0x0
    MSR     APSR_nzcvq,R1 /* This will clear all flags */
    B       m4_scst_branch_test3_exit_ISR

m4_scst_branch_test3_ISR2_error:
    MOVW    R5,#0x444   /* BLX LR triggered exception -> This is error !! (destroy result) */
    /* This is error. We need to change the return address that 
       is stored in stack. */
    ADR.W   R3,m4_scst_branch_test3_end
    STR     R3,[SP,#24]
    B       m4_scst_branch_test3_exit_ISR
    
m4_scst_branch_test3_ISR2:
    ADDW    R5,R5,#0x345   /* BLX exception was triggered -> Update result */
    
    /* We need to check and clear INVSTATE flag */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]     /* Use halfword access to UFSR */
    TST     R4,#(1<<1)  /* Check UFSR[INVSTATE] bit is set */
    BEQ     m4_scst_branch_test3_exit_ISR
    AND     R4,R4,#(1<<1)   /* Ensure that only INVSTATE flag is cleared */
    STRH    R4,[R3]         /* Clear UFSR[INVSTATE](rc_w1) flag */
    
    /* We need to check LR was updated */
    ADR.W   R1,m4_scst_branch_test3_ret12   /* Load expected address */
    ORR     R1,R1,#1
    LDR     R3,[SP,#20]     /* Load stacked LR address */
    CMP     R3,R1           /* Check link address */
    BNE     m4_scst_branch_test3_exit_ISR   /* Branch to avoid signature update */
    ADDW    R5,R5,#0x345
    /* We need to check exception return address is correct */
    LDR     R3,[SP,#24]     /* Load stacked returned address */
    CMP     R3,R0           /* Check exception return address */
    BNE     m4_scst_branch_test3_exit_ISR   /* Branch to avoid signature update */
    ADDW    R5,R5,#0x345
    /* We need to update ISR return address it points to MOVW R5,#0x444 */
    ADR.W   R3,m4_scst_branch_test3_ISR2_ret_addr
    STR     R3,[SP,#24]
    B       m4_scst_branch_test3_exit_ISR
    
m4_scst_branch_test3_ISR3:
    ADDW    R5,R5,#0x354   /* BX exception was triggered -> Update result */
    
    /* We need to check and clear INVSTATE flag */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]     /* Use halfword access to UFSR */
    TST     R4,#(1<<1)  /* Check UFSR[INVSTATE] bit is set */
    BEQ     m4_scst_branch_test3_exit_ISR
    AND     R4,R4,#(1<<1)   /* Ensure that only INVSTATE flag is cleared */
    STRH    R4,[R3]         /* Clear UFSR[INVSTATE](rc_w1) flag */
    
    /* We need to check exception return address is correct */
    LDR     R3,[SP,#24]     /* Load stacked returned address */
    CMP     R3,R0           /* Check exception return address */
    BNE     m4_scst_branch_test3_exit_ISR   /* Branch to avoid signature update */
    ADDW    R5,R5,#0x354
    /* We need to update ISR return address it points to MOVW R5,#0x444 */
    ADR.W   R3,m4_scst_branch_test3_ISR3_ret_addr
    STR     R3,[SP,#24]
    B       m4_scst_branch_test3_exit_ISR
    
m4_scst_branch_test3_exit_ISR:
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
                   
    SCST_FILE_END
    
