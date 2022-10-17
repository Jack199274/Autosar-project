/******************************************************************************
*
* Copyright 2015-2016 Freescale
* Copyright 2016-2017, 2019-2020 NXP
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
*
* Testing of interrupt masking (FAULTMASK,PRIMASK,BASEPRI)
* 
*
* 测试总结：
* -------------
*
* 中断屏蔽测试（FAULTMASK、PRIMASK、BASEPRI）
*
*
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_exception_test_masking
    
    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_store_registers_content
    SCST_EXTERN m4_scst_set_scst_interrupt_vector_table
    SCST_EXTERN m4_scst_restore_registers_content
    SCST_EXTERN m4_scst_exception_test_tail_end
    SCST_EXTERN m4_scst_ISR_address
    SCST_EXTERN m4_scst_test_was_interrupted
    
    
    SCST_SECTION_EXEC(m4_scst_test_code)  
    SCST_THUMB2
    
    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_exception_test_masking" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_exception_test_masking, function)
m4_scst_exception_test_masking:

    PUSH.W  {R1-R8,R14}
    
    /* Store register content */
    BL      m4_scst_store_registers_content
    
    /* Save current content of PRIMASK in R1 and current content of FAULTMASK to R6 */
    /* ! Don't use R1, R6 for any other purpose until PRIMASK, FAULTMASK is restored. */
    MRS     R1,PRIMASK
    MRS     R6,FAULTMASK
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_masking_ISR1
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    /* Before vector table is changed to the SCST-own one, clear R2.
    If any interrupt occurs after table is switched but before R2 is set to a pre-defined value.

    Also before table is switched, set R0 to the return address from the ISR. Content of R0 and R2
    will allow determining whether interrupt was triggered by SCST library or by alien SW.

    ! Don't use R0 for any other purpose until vector table is changed to a user one.
    ! Don't use R2 for any other purpose until vector table is changed to a user one. */
    
    MOV     R2,#0x0
    ADR.W   R0,m4_scst_exception_test_masking_ISR_ret_addr1
    
    /* R5 is used as a flag indicating correct invocation of the SCST-own ISR. */
    MOV     R5,#0x0
    
    /* Set SCST interrupt vector table */
    BL      m4_scst_set_scst_interrupt_vector_table
    
    /* We need to check PendSV is not active */
    LDR     R3,=M4_SHCSR_REG    /* Load SHCSR(SCB) register address */
    LDR     R4,[R3]             /* Load current SHCSR register value */
    TST     R4,#(1<<10)         /* Check PendSV is not active */
    BNE.W   m4_scst_exception_test_masking_pending_active
    
    /* We need to check PendSV is not pending */
    LDR     R3,=M4_ICSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<28)
    BNE     m4_scst_exception_test_masking_pending_active
    
    LDR     R3,=M4_SHPR3_REG
    MOV     R4,#0x0
    STRB    R4,[R3,#2]  /* Clear SHPR3[PRI_14] to enable possibly masked PendSV exception */
    
    CPSIE   i       /* Enable interrupts with configurable priority */
    CPSIE   f       /* Enable all exceptions */
    
    MRS     R3,PRIMASK
    CMP     R3,#0   /* Check PRIMASK was cleared */
    BNE     m4_scst_exception_test_masking_end
    
    MRS     R3,FAULTMASK
    CMP     R3,#0   /* Check FAULTMASK was cleared */
    BNE     m4_scst_exception_test_masking_end
    
    LDR     R3,=M4_ICSR_REG
    LDR     R4,[R3]
    ORR     R4,R4,#(1<<28)      /* Set ICSR[PENDSVSET] bit to initiate a PendSV interrupt */
    MOV     R2,#0xE             /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0xE */
    STR     R4,[R3]             /* Generate an exception and wait... */
    
m4_scst_exception_test_masking_ISR_ret_addr1:
    B       m4_scst_exception_test_masking_ISR_ret_addr1

m4_scst_masking_return_address_1:
    MRS     R3,FAULTMASK    /* Load FAULTMASK register */
    
    CMP     R3,#0           /* Check FAULTMASK was cleared */
    BNE     m4_scst_exception_test_masking_end
    
    ADD.W   R5,R5,#0xA46
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_masking_ISR2
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    CPSID   f       /* Set FAULTMASK to 1 to prevent exception */
    
    MRS     R3,FAULTMASK
    CMP     R3,#1   /* Check FAULTMASK was set */
    BNE     m4_scst_exception_test_masking_end
    
    LDR     R3,=M4_ICSR_REG
    LDR     R4,[R3]
    ORR     R4,R4,#(1<<28)      /* Set ICSR[PENDSVSET] bit to initiate a PendSV interrupt */
    
    /*  We need to recognize SCST exception in case of FAULTMASK is not working.
        R0 will be loaded by the error address */
    ADR.W   R0,m4_scst_exception_test_masking_ISR_ret_addr2_error
    MOV     R2,#0xE             /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0xE */
    
    STR     R4,[R3]             /* Generate an exception and wait... */
    
m4_scst_exception_test_masking_ISR_ret_addr2_error:
    DSB
    
    /* We need to check that FAULTMASK prevents exception triggering */
    LDR     R4,[R3]
    TST     R4,#(1<<28)         /* Check that exception is pending */
    BEQ     m4_scst_exception_test_masking_end
    
    ADR.W   R0,m4_scst_exception_test_masking_ISR_ret_addr2  /* Load R0 by correct address */
    
    CPSIE   f   /* Enable all exceptions -> This will trigger an exception */
    
m4_scst_exception_test_masking_ISR_ret_addr2:
    B       m4_scst_exception_test_masking_ISR_ret_addr2
    
m4_scst_masking_return_address_2:
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_masking_ISR3
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    CPSID   i
    
    MRS     R3,PRIMASK
    CMP     R3,#1   /* Check PRIMASK was set */
    BNE     m4_scst_exception_test_masking_end
    
    LDR     R3,=M4_ICSR_REG
    LDR     R4,[R3]
    ORR     R4,R4,#(1<<28)      /* Set ICSR[PENDSVSET] bit to initiate a PendSV interrupt */
    
    /*  We need to recognize SCST exception in case of PRIMASK is not working.
        R0 will be loaded by the error address */
    ADR.W   R0,m4_scst_exception_test_masking_ISR_ret_addr3_error
    MOV     R2,#0xE             /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0xE */
    
    STR     R4,[R3]             /* Generate an exception and wait... */
    
m4_scst_exception_test_masking_ISR_ret_addr3_error:
    DSB
    
    /* We need to check that FAULTMASK prevents exception triggering */
    LDR     R4,[R3]
    TST     R4,#(1<<28)         /* Check that exception is pending */
    BEQ     m4_scst_exception_test_masking_end
    
    ADR.W   R0,m4_scst_exception_test_masking_ISR_ret_addr3  /* Load R0 by correct address */
    
    CPSIE   i   /* Enable interrupts -> This will trigger an exception */
    
m4_scst_exception_test_masking_ISR_ret_addr3:
    B       m4_scst_exception_test_masking_ISR_ret_addr3
    
m4_scst_masking_return_address_3:
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_masking_ISR4
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    LDR     R3,=M4_SHPR2_REG  
    MOV     R4,#0x10          
    STRB    R4,[R3,#3]        /* Set SHPR2[PRI_11] to set SVC exception priority */
    
    MOV     R3,#0x10
    MSR     BASEPRI,R3        /* Set BASEPRI to mask SVC exception */
    
    MRS     R4,BASEPRI
    CMP     R4,#0x10    /* Check BASERPRI was set */
    BNE     m4_scst_exception_test_masking_end
    
    /*  We need to recognize SCST exception in case of BASEPRI is not working.
        R0 will be loaded by the error address */
    ADR.W   R0,m4_scst_exception_test_masking_ISR_ret_addr4
    MOV     R2,#0x3             /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0x3 */
    
    SVC     0   /* BASEPRI Masks SVSC call -> Escalation to HardFault*/
    
m4_scst_exception_test_masking_ISR_ret_addr4:
    B       m4_scst_exception_test_masking_ISR_ret_addr4
    
    
m4_scst_exception_test_masking_pending_active:
    LDR     R3,=m4_scst_test_was_interrupted
    STR     R3,[R3]
m4_scst_exception_test_masking_end:
    BL      m4_scst_restore_registers_content
    MOV     R0,R5        /* Test result is returned in R0, according to the conventions */
    B       m4_scst_exception_test_tail_end
    
m4_scst_exception_test_masking_error:
    /* We need to change return address that is stored in stack: */
    ADR.W   R3, m4_scst_exception_test_masking_end
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R3,#0
    STR     R3,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
    
m4_scst_exception_test_masking_ISR1:
    ADD.W   R5,R5,#0xE7C
    
    CPSID   f       /* Set FAULTMASK to 1 */
    MRS     R3,FAULTMASK
    
    CMP     R3,#1   /* Check FAULTMASK is set */
    BNE     m4_scst_exception_test_masking_error
    
    /* This is an ISR for PendSV exception which is asynchronous.
    We need to change the return address that is stored in stack:
    it points to the endless loop instruction */
    ADR.W   R3, m4_scst_masking_return_address_1
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R3,#0
    STR     R3,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_test_masking_ISR2:
    /* We need to check address of exception */
    ADR.W   R3,m4_scst_exception_test_masking_ISR_ret_addr2  /* Load correct address */
    
    CMP     R3,R0   /* Compare R0 with correct exception address */
    
    BNE     m4_scst_exception_test_masking_error
    
    ADD.W   R5,R5,#0x3D2
    
    /* This is an ISR for PendSV exception which is asynchronous.
    We need to change the return address that is stored in stack:
    it points to the endless loop instruction */
    ADR.W   R3, m4_scst_masking_return_address_2
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R3,#0
    STR     R3,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_test_masking_ISR3:
    /* We need to check address of exception */
    ADR.W   R3,m4_scst_exception_test_masking_ISR_ret_addr3  /* Load correct address */
    
    CMP     R3,R0   /* Compare R0 with correct exception address */
    
    BNE     m4_scst_exception_test_masking_error
    
    ADD.W   R5,R5,#0x20A
    
    /* This is an ISR for PendSV exception which is asynchronous.
    We need to change the return address that is stored in stack:
    it points to the endless loop instruction */
    ADR.W   R3, m4_scst_masking_return_address_3
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R3,#0
    STR     R3,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_test_masking_ISR4:
    /* We need to check address of exception */
    ADR.W   R3,m4_scst_exception_test_masking_ISR_ret_addr4  /* Load correct address */
    
    CMP     R3,R0   /* Compare R0 with correct exception address */
    
    BNE     m4_scst_exception_test_masking_error
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_exception_test_masking_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    LDR     R4,[R3]     /* Load HFSR */
    TST     R4,#(1<<30) /* Check that HFSR[FORCED] flag was cleared */
    BNE     m4_scst_exception_test_masking_error
    
    ADD.W   R5,R5,#0xCEA
    
    /* This is an ISR for HardFault exception which is synchronous.
    We need to change the return address that is stored in stack:
    it points to the endless loop instruction */
    ADR.W   R3, m4_scst_exception_test_masking_end
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R3,#0
    STR     R3,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                  (containing numeric values for used symbolic names used within LDR instruction).
                  It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    