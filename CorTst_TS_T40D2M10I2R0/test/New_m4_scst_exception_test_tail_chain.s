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
* Tests triggering of tail chain interrupts.
*
* 测试总结：
* -------------
*
* 测试触发尾链中断。
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_exception_test_tail_chain

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_store_registers_content
    SCST_EXTERN m4_scst_set_scst_interrupt_vector_table
    SCST_EXTERN m4_scst_restore_registers_content
    SCST_EXTERN m4_scst_exception_test_tail_end
    SCST_EXTERN m4_scst_ISR_address
    SCST_EXTERN m4_scst_test_was_interrupted


    SCST_SECTION_EXEC(m4_scst_test_code)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_exception_test_tail_chain" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_exception_test_tail_chain, function)
m4_scst_exception_test_tail_chain:

    PUSH.W  {R1-R8,R14}
    
    /* Store register content */
    BL      m4_scst_store_registers_content
    
    /* Save current content of PRIMASK in R1 and current content of FAULTMASK to R6 */
    /* ! Don't use R1, R6 for any other purpose until PRIMASK, FAULTMASK is restored. */
    MRS     R1,PRIMASK
    MRS     R6,FAULTMASK
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_tail_chain_ISR1
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
    ADR.W   R0,m4_scst_exception_test_tail_chain_ISR_ret_addr1
    
    /* R5 is used as a flag indicating correct invocation of the SCST-own ISR. */
    MOV     R5,#0x0
    
    /* Set SCST interrupt vector table */
    BL      m4_scst_set_scst_interrupt_vector_table
    
    /* We need to check that PendSV and SysTick are not active */
    LDR     R3,=M4_SHCSR_REG    
    LDR     R4,[R3]             
    TST     R4,#(1<<11)         /* Check SHCSR[SYSTICKACT] bit is not set */
    BNE     m4_scst_exception_test_tail_chain_pending_active
    TST     R4,#(1<<10)         /* Check SHCSR[PENDSVACT] bit is not set */
    BNE     m4_scst_exception_test_tail_chain_pending_active
    
    /* We need to check PendSV and SysTick are not pending */
    LDR     R3,=M4_ICSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<28)         /* Check ICSR[PENDSVSET] bit is not set */
    BNE     m4_scst_exception_test_tail_chain_pending_active
    TST     R4,#(1<<26)         /* Check ICSR[PENDSTSET] bit is not set */
    BNE     m4_scst_exception_test_tail_chain_pending_active
    
    /* We need to set priority for PendSV and Systick */
    LDR     R3,=M4_SHPR3_REG
    MOV     R4,#0x0
    STRB    R4,[R3,#2]  /* Clear SHPR3[PRI_14] register to enable possibly masked PendSV exception */
    STRB    R4,[R3,#3]  /* Clear SHPR3[PRI_15] register enable possibly masked SysTick exception */
    
    CPSIE   i       /* Enable interrupts with configurable priority */
    CPSIE   f       /* Enable all exceptions */
    
    LDR     R14,=M4_ICSR_REG
    LDR     R4,[R14]
    ORR     R4,R4,#(1<<26)      /* Set ICSR[PENDSTSET] bit to initiate SysTick interrupt */
    ORR     R4,R4,#(1<<28)      /* Set ICSR[PENDSVSET] bit to initiate PendSV interrupt */
    MOV     R2,#0xE             /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0xE */
    MOV     R3,#0xF
    STR     R4,[R14]             /* Generate an exception and wait... */
    
m4_scst_exception_test_tail_chain_ISR_ret_addr1:
    B       m4_scst_exception_test_tail_chain_ISR_ret_addr1
    
m4_scst_exception_test_tail_chain_pending_active:
    LDR     R3,=m4_scst_test_was_interrupted
    STR     R3,[R3]
m4_scst_exception_test_tail_chain_end:
    BL      m4_scst_restore_registers_content
    MOV     R0,R5        /* Test result is returned in R0, according to the conventions */
    B       m4_scst_exception_test_tail_end
    
    
m4_scst_exception_test_tail_chain_ISR1:

    CMP     R2,#0xF     /* Check second interrupt was triggered */
    BEQ     m4_scst_exception_tail_chain_stack_check
    
    LDR     R3,=M4_ICSR_REG
    LDR     R4,[R3]
    UBFX    R3,R4,#0,#9     /* Extract ICSR[VECTACTIVE] value */
    
    CMP     R3,#0xE         /* Check ICSR[VECTACTIVE] value */
    BNE     m4_scst_exception_test_tail_chain_ISR1_exit
    ADD.W   R5,R5,#0xA15
    
    UBFX    R3,R4,#12,#7    /* Extract ICSR[VECTPENDING] value */
    
    CMP     R3,#0xF         /* Check ICSR[VECTPENDING] value*/
    BNE     m4_scst_exception_test_tail_chain_ISR1_exit
    ADD.W   R5,R5,#0xE55
    
    /* We need to set R12 to known value */
    /* R1 shall not be overwritten back from stack during interrupt tail-chaining !! */ 
    ADR.W   R12,m4_scst_exception_test_tail_chain_ISR_ret_addr1
    
    /* Set R2 to indicate that next interrupt is tail-chained */
    MOV     R2,#0xF
    /*  Rewrite stacked R2 value to indicate that SCST expect interrupt 0xF 
        In case of tail-chain does not work R2 will be restored to new value */
    STR     R2,[SP,#8]
    B       m4_scst_exception_test_tail_chain_ISR1_exit
    
m4_scst_exception_tail_chain_stack_check:
    ADR.W   R3,m4_scst_exception_test_tail_chain_ISR_ret_addr1
    CMP     R3,R12   /* Check that R12 was not restored from stack !! */
    
    BNE     m4_scst_exception_test_tail_chain_ISR1_exit
    ADD.W   R5,R5,#0xF1A
    
    /*  We need to change the return address that is stored in stack:
        it points to the endless loop instruction */
    ADR.W   R3,m4_scst_exception_test_tail_chain_end
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0x0
    
    /* Rewrite stacked R2 value to indicate that SCST expect interrupt 0xF 
       In case of tail-chain does not work R2 will be restored from stack */
    STR     R2,[SP,#8]

m4_scst_exception_test_tail_chain_ISR1_exit:
    DSB     /* Ensures that stacked value is updated before exception return */
    BX      LR
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                  (containing numeric values for used symbolic names used within LDR instruction).
                  It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    