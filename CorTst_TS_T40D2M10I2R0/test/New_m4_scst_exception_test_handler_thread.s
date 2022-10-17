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
* Tests entering thread mode from any level of handler.
*
* 测试总结：
* -------------
*
* 测试从任何级别的处理程序进入线程模式。
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_exception_test_handler_thread

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_store_registers_content
    SCST_EXTERN m4_scst_set_scst_interrupt_vector_table
    SCST_EXTERN m4_scst_restore_registers_content
    SCST_EXTERN m4_scst_exception_test_tail_end
    SCST_EXTERN m4_scst_ISR_address
    SCST_EXTERN m4_scst_spr_registers_dump
    SCST_EXTERN m4_scst_test_was_interrupted


    SCST_SECTION_EXEC(m4_scst_test_code)
    SCST_THUMB2
    
    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_exception_test_handler_thread" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_exception_test_handler_thread, function)
m4_scst_exception_test_handler_thread:

    PUSH.W  {R1-R8,R14}
    
    /* Store register content */
    BL      m4_scst_store_registers_content
    
    /* Save current content of PRIMASK in R1 and current content of FAULTMASK to R6 */
    /* ! Don't use R1, R6 for any other purpose until PRIMASK, FAULTMASK is restored. */
    MRS     R1,PRIMASK
    MRS     R6,FAULTMASK
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_handler_thread_ISR1_1
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
    ADR.W   R0,m4_scst_exception_test_handler_thread_ISR_ret_addr1
    
    /* R5 is used as a flag indicating correct invocation of the SCST-own ISR. */
    MOV     R5,#0x0
    
    /* Set SCST interrupt vector table */
    BL      m4_scst_set_scst_interrupt_vector_table
    
    /* We need to check PendSV is not active */
    LDR     R3,=M4_SHCSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<10)        /* Check SHCSR[PENDSVACT] bit is not set */
    BNE     m4_scst_exception_test_handler_thread_pending_active
    
    /* We need to check PendSV is not pending */
    LDR     R3,=M4_ICSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<28)         /* Check ICSR[PENDSVSET] bit is not set */
    BNE     m4_scst_exception_test_handler_thread_pending_active
    
    /* We need to configure how processor enters Thread mode */
    LDR     R3,=M4_CCR_REG
    LDR     R4,[R3]
    ORR     R4,R4,#(1<<0)       /* Set CCR[NONBASETHRDENA] bit */
    STR     R4,[R3]
    LDR     R4,[R3]
    TST     R4,#(1<<0)          /* Check CCR[NONBASETHRDENA] bit was set */
    BEQ     m4_scst_exception_test_handler_thread_end
    
    LDR     R3,=M4_SHPR3_REG
    MOV     R4,#0x0
    STRB    R4,[R3,#2]  /* Clear SHPR3[PRI_14] to enable possibly masked PendSV exception */
    
    CPSIE   i       /* Enable interrupts with configurable priority */
    CPSIE   f       /* Enable all exceptions */
    
    LDR     R3,=M4_ICSR_REG
    LDR     R4,[R3]
    ORR     R4,R4,#(1<<28)      /* Set ICSR[PENDSVSET] bit to initiate PendSV interrupt */
    MOV     R2,#0xE             /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0xF */
    
    STR     R4,[R3]             /* Generate an exception and wait... */
    
m4_scst_exception_test_handler_thread_ISR_ret_addr1:
    B       m4_scst_exception_test_handler_thread_ISR_ret_addr1
    
m4_scst_handler_thread_return_address_1:
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_handler_thread_ISR2_1
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    /*  We need to disable Usage fault exception to avoid problem that Usage fault is
        escalated to Hard fault even if Usage fault is enabled. */
    LDR     R3,=M4_SHCSR_REG
    LDR     R4,[R3]
    BIC     R4,R4,#(1<<18)      /* Clear SHCSR[USGFAULTENA] bit */
    STR     R4,[R3]             /* Modify SHCSR register */
    LDR     R4,[R3]
    TST     R4,#(1<<18)         /* Check SHCSR[USGFAULTENA] bit is not set */
    BNE     m4_scst_exception_test_handler_thread_end
    
    LDR     R3,=M4_SHPR3_REG
    MOV     R4,#0x0
    STRB    R4,[R3,#2]  /* Clear SHPR3[PRI_14] to enable possibly masked PendSV exception */
    
    /* We need to configure how processor enters Thread mode */
    LDR     R3,=M4_CCR_REG
    LDR     R4,[R3]
    BIC     R4,R4,#(1<<0)       /* Clear CCR[NONBASETHRDENA] bit */
    STR     R4,[R3]
    LDR     R4,[R3]
    TST     R4,#(1<<0)          /* Check CCR[NONBASETHRDENA] bit was cleared */
    BNE     m4_scst_exception_test_handler_thread_end
    
    MOV     R2,#0xE             /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0xE */
    ADR.W   R0,m4_scst_exception_test_handler_thread_ISR_ret_addr2
    
    LDR     R3,=M4_ICSR_REG
    LDR     R4,[R3]
    ORR     R4,R4,#(1<<28)      /* Set ICSR[PENDSVSET] bit to initiate PendSV interrupt */
    
    STR     R4,[R3]             /* Generate an exception and wait... */

m4_scst_exception_test_handler_thread_ISR_ret_addr2:
    B       m4_scst_exception_test_handler_thread_ISR_ret_addr2
    
m4_scst_handler_thread_return_address_2:
    CPSIE   i       /* Enable all interrupts */
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_handler_thread_ISR4_1
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    LDR     R3,=M4_SHPR3_REG
    MOV     R4,#0x0
    STRB    R4,[R3,#2]  /* Clear SHPR3[PRI_14] to enable possibly masked PendSV exception */
    
    MOV     R2,#0xE             /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0xE */
    ADR.W   R0,m4_scst_exception_test_handler_thread_ISR_ret_addr3
    
    LDR     R3,=M4_ICSR_REG
    LDR     R4,[R3]
    ORR     R4,R4,#(1<<28)      /* Set ICSR[PENDSVSET] bit to initiate PendSV interrupt */
    
    STR     R4,[R3]             /* Generate an exception and wait... */

m4_scst_exception_test_handler_thread_ISR_ret_addr3:
    B       m4_scst_exception_test_handler_thread_ISR_ret_addr3
    
m4_scst_handler_thread_return_address_3:
    /* We need to check IPSR[ISR_NUMBER] was restored correctly */
    MRS     R3,IPSR
    CMP     R4,R3
    BNE     m4_scst_exception_test_handler_thread_end
    
    ADD.W   R5,R5,#0xC15
    
    
m4_scst_exception_test_handler_thread_end:
    BL      m4_scst_restore_registers_content
    MOV     R0,R5        /* Test result is returned in R0, according to the conventions */
    B       m4_scst_exception_test_tail_end
    
m4_scst_exception_test_handler_thread_pending_active:
    LDR     R3,=m4_scst_test_was_interrupted
    STR     R3,[R3]
    B       m4_scst_exception_test_handler_thread_end
    
m4_scst_exception_handler_thread_error:
    /* We need to change return address that is stored in stack */
    ADR.W   R3,m4_scst_exception_test_handler_thread_end
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_test_handler_thread_ISR1_1:

    LDR     R3,=M4_SHPR2_REG
    MOV     R4,#0x0
    STRB    R4,[R3,#3]  /* Clear SHPR2[PRI_11] to enable possibly masked SVCcall exception */
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_handler_thread_ISR1_2
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    /* Rewrite stacked R2 value to indicate that SCST expect further interrupt */
    MOV     R2,#0x3
    STR     R2,[SP,#8]
    
    /* Rewrite stacked R0 value to indicate that SCST expect further interrupt */
    ADR.W   R0,m4_scst_exception_test_handler_thread_ISR1_ret_addr
    STR     R0,[SP,#24]
    
    SVC     0           /* Generate exception!!! */
    
m4_scst_exception_test_handler_thread_ISR1_ret_addr:
    B       m4_scst_exception_test_handler_thread_ISR1_ret_addr

m4_scst_handler_thread_return_address_ISR1_2:
    /* We need to check Thread mode */
    MRS     R3,IPSR
    CMP     R3,#0x0     /* Check IPSR[ISR_NUMBER] is 0:Thread mode */
    BNE     m4_scst_exception_test_handler_thread_end
    
    ADD.W   R5,R5,#0xEED
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_exception_handler_thread_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    /* We neeed to restore stacked registers */
    POP     {R0,R1} /* Restore R1 because it holds the PRIMASK value */
    /* We need to restore SP value */
    LDR     R3,=m4_scst_spr_registers_dump
    LDR     SP,[R3,#20]
    
    /* We need to clear SHCSR[PENDSVACT] bit */
    LDR     R3,=M4_SHCSR_REG
    LDR     R4,[R3]
    BIC     R4,R4,#(1<<10)  /* Clear SHCSR[PENDSVACT] bit */
    STR     R4,[R3]
    LDR     R4,[R3]
    TST     R4,#(1<<10)     /* Check SHCSR[PENDSVACT] bit is not set */
    BNE     m4_scst_exception_test_handler_thread_end
    
    CPSIE   i       /* Enable all interrupts */
    /* Jump back to test code */
    B       m4_scst_handler_thread_return_address_1
    
m4_scst_exception_test_handler_thread_ISR1_2:
    /* We need to disable all exceptions */
    CPSID   i   /* Disable all interrupts */
    /* We need to change stacked xPSR register */
    LDR     R1,[SP,#28]
    BFC     R1,#0,#9    /* Clear IPSR[ISR_NUMBER] */
    STR     R1,[SP,#28]
    
    /* We need to change EXC_RETURN value to can enter Thread mode */
    MOV     LR,#0xFFFFFFF9  
    
    /*  We need to change the return address that is stored in stack:
        it points to the endless loop instruction */
    ADR.W   R3,m4_scst_handler_thread_return_address_ISR1_2
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_test_handler_thread_ISR2_1:
    
    LDR     R3,=M4_SHPR2_REG
    MOV     R4,#0x0
    STRB    R4,[R3,#3]  /* Clear SHPR2[PRI_11] to enable possibly masked SVCcall exception */
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_handler_thread_ISR2_2
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    /* Rewrite stacked R2 value to indicate that SCST expect further interrupt */
    MOV     R2,#0x3
    STR     R2,[SP,#8]
    
    /* Rewrite stacked R0 value to indicate that SCST expect further interrupt */
    ADR.W   R0,m4_scst_exception_test_handler_thread_ISR2_ret_addr
    STR     R0,[SP,#24]
    
    SVC     0           /* Generate exception!!! */
    
m4_scst_exception_test_handler_thread_ISR2_ret_addr:
    B       m4_scst_exception_test_handler_thread_ISR2_ret_addr
    
m4_scst_handler_thread_return_address_ISR3:
    /* We neeed to restore stacked registers */
    POP     {R0,R1} /* Restore R1 because it holds the PRIMASK value */
    /* We need to restore SP value */
    LDR     R3,=m4_scst_spr_registers_dump
    LDR     SP,[R3,#20]
    
    B       m4_scst_handler_thread_return_address_2
    
m4_scst_exception_test_handler_thread_ISR2_2:
    CPSID   i       /* Disable all interrupts */
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_exception_handler_thread_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    /* We need to change IPSR register */
    LDR     R1,[SP,#28]
    BFC     R1,#0,#9    /* Clear IPSR[ISR_NUMBER] */
    STR     R1,[SP,#28]
    
    /* We need to change EXC_RETURN value */
    MOV     LR,#0xFFFFFFF9
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_handler_thread_ISR3
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    /* Rewrite stacked R2 value to indicate that SCST expects further interrupt */
    MOV     R2,#0x3
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_test_handler_thread_ISR3:
    /*  We need to clear SHCSR[PENDSVACT] bit 
        In case of flag is not cleared the Hard fault exception will be triggered again */
    LDR     R3,=M4_SHCSR_REG
    LDR     R4,[R3]
    BIC     R4,R4,#(1<<10)  /* Clear SHCSR[PENDSVACT] bit */
    STR     R4,[R3]
    LDR     R4,[R3]
    TST     R4,#(1<<10)     /* Check SHCSR[PENDSVACT] bit is not set */
    BNE     m4_handler_thread_active_flag_error
    
    /* We need to check that INVPC flag was set */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]        /* Use halfword access to UFSR */
    TST     R4,#(1<<2)     /* Check UFSR[INVPC] bit is set */
    BEQ     m4_scst_exception_handler_thread_error
    AND     R4,R4,#(1<<2)   /* Ensure that only INVPC flag is cleared */
    STRH    R4,[R3]         /* Clear UFSR[INVPC](rc_w1) flag */
    
    LDRH    R4,[R3]    /* Use halfword access to UFSR */
    TST     R4,#(1<<2) /* Check that UFSR[INVPC] flag was cleared */
    BNE     m4_scst_exception_handler_thread_error
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_exception_handler_thread_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    LDR     R4,[R3]     /* Load HFSR */
    TST     R4,#(1<<30) /* Check that HFSR[FORCED] flag was cleared */
    BNE     m4_scst_exception_handler_thread_error
    
    ADD.W   R5,R5,#0xA16
    
    /* We need to change the return address that is stored in stack:
    it points to the endless loop instruction */
    ADR.W   R3,m4_scst_handler_thread_return_address_ISR3
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0x0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
m4_handler_thread_active_flag_error:
    BX      LR
    
m4_scst_exception_test_handler_thread_ISR4_1:
    
    LDR     R3,=M4_SHPR2_REG
    MOV     R4,#0x0
    STRB    R4,[R3,#3]  /* Clear SHPR2[PRI_11] to enable possibly masked SVCcall exception */
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_handler_thread_ISR4_2
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    /* Rewrite stacked R2 value to indicate that SCST expect further interrupt */
    MOV     R2,#0x3
    STR     R2,[SP,#8]
    
    /* Rewrite stacked R0 value to indicate that SCST expect further interrupt */
    ADR.W   R0,m4_scst_exception_test_handler_thread_ISR4_ret_addr
    STR     R0,[SP,#24]
    
    SVC     0           /* Generate exception!!! */
    
 m4_scst_exception_test_handler_thread_ISR4_ret_addr:
    B       m4_scst_exception_test_handler_thread_ISR4_ret_addr

m4_scst_handler_thread_return_address_ISR4:
    /* We need to check IPSR[ISR_NUMBER] was restored correctly */
    MRS     R3,IPSR
    CMP     R3,R4
    BNE     m4_handler_thread_isr_number_error
    
    ADD.W   R5,R5,#0xB17
    
    /* Load R4 with stacked xPSR */
    LDR     R4,[SP,#28]
    UBFX    R4,R4,#0,#9     /*  Extract ISR_NUMBER */
    
    /* We need to change the return address that is stored in stack:
    it points to the endless loop instruction */
    ADR.W   R3,m4_scst_handler_thread_return_address_3
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0x0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
m4_handler_thread_isr_number_error:
    BX      LR
    
m4_scst_exception_test_handler_thread_ISR4_2:
    /* We need to change the return address that is stored in stack:
    it points to the endless loop instruction */
    ADR.W   R3,m4_scst_handler_thread_return_address_ISR4
    STR     R3,[SP,#24]
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_exception_handler_thread_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0x0   
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    /* Load R4 with stacked xPSR */
    LDR     R4,[SP,#28]
    UBFX    R4,R4,#0,#9     /*  Extract ISR_NUMBER */
    
    BX      LR
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                  (containing numeric values for used symbolic names used within LDR instruction).
                  It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    