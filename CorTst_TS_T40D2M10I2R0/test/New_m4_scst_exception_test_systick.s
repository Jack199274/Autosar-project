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
*
* Tests triggering of SysTick interrupts.
*
* ÊµãËØïÊÄªÁªìÔºö
* -------------
*
* ÊµãËØï SysTick ‰∏≠Êñ≠ÁöÑËß¶Âèë„ÄÇ
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_exception_test_systick

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_store_registers_content
    SCST_EXTERN m4_scst_set_scst_interrupt_vector_table
    SCST_EXTERN m4_scst_restore_registers_content
    SCST_EXTERN m4_scst_exception_test_tail_end
    SCST_EXTERN m4_scst_ISR_address
    SCST_EXTERN m4_scst_test_was_interrupted


    SCST_SECTION_EXEC(m4_scst_test_code) //÷∏∂®∂Œ
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_exception_test_systick" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_exception_test_systick, function) //±Ì æm4_scst_exception_test_systickŒ™∫Ø ˝
m4_scst_exception_test_systick:

    PUSH.W  {R1-R8,R14}
    
    /* Store register content */
    BL      m4_scst_store_registers_content
    
    /* Save current content of PRIMASK in R1 and current content of FAULTMASK to R6 */
    /* ! Don't use R1, R6 for any other purpose until PRIMASK, FAULTMASK is restored. */
    MRS     R1,PRIMASK
    MRS     R6,FAULTMASK
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_systick_ISR1
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
    ADR.W   R0,m4_scst_exception_test_systick_ISR_ret_addr1
    
    /* R5 is used as a flag indicating correct invocation of the SCST-own ISR. */
    MOV     R5,#0x0
    
    /* Set SCST interrupt vector table */
    BL      m4_scst_set_scst_interrupt_vector_table
    
    /* We need to check SysTick is not active */
    LDR     R3,=M4_SHCSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<11)         /* Check SHCSR[SYSTICKACT] bit is not set */
    BNE     m4_scst_exception_test_systick_pending_active
    
    /* We need to check SysTick is not pending */
    LDR     R3,=M4_ICSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<26)         /* Check ICSR[PENDSTSET] bit is not set */
    BNE     m4_scst_exception_test_systick_pending_active
    
    LDR     R3,=M4_SHPR3_REG
    MOV     R4,#0x0
    STRB    R4,[R3,#3]  /* Clear SHPR3[PRI_15] to enable possibly masked SysTick exception */
    
    CPSIE   i       /* Enable interrupts with configurable priority */
    CPSIE   f       /* Enable all exceptions */
    
    LDR     R3,=M4_ICSR_REG
    LDR     R4,[R3]
    ORR     R4,R4,#(1<<26)      /* Set ICSR[PENDSTSET] bit to initiate SysTick interrupt */
    MOV     R2,#0xF             /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0xF */
    STR     R4,[R3]             /* Generate an exception and wait... */
    
m4_scst_exception_test_systick_ISR_ret_addr1:
    B       m4_scst_exception_test_systick_ISR_ret_addr1
    
m4_scst_exception_test_systick_pending_active:
    LDR     R3,=m4_scst_test_was_interrupted
    STR     R3,[R3]
m4_scst_exception_test_systick_end:
    BL      m4_scst_restore_registers_content
    MOV     R0,R5        /* Test result is returned in R0, according to the conventions */
    B       m4_scst_exception_test_tail_end
    
    
m4_scst_exception_test_systick_ISR1:

    ADD.W   R5,R5,#0x6EA
    
    /* This is an ISR for SysTick exception which is asynchronous.
    We need to change the return address that is stored in stack:
    it points to the endless loop instruction */
    ADR.W   R3,m4_scst_exception_test_systick_end
    STR     R3,[SP,#24]
    
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
    