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
* Tests triggering of Memory management fault.
*
* 测试总结：
* -------------
*
* 测试触发内存管理故障。
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_exception_mem_fault

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_ISR_address
    SCST_EXTERN m4_scst_exception_test_tail_end
    SCST_EXTERN m4_scst_store_registers_content
    SCST_EXTERN m4_scst_set_scst_interrupt_vector_table
    SCST_EXTERN m4_scst_restore_registers_content
    SCST_EXTERN m4_scst_test_was_interrupted
    
SCST_DEFINE(M4_XN_REGION_ADDR, 0xFFFFFFF0) /*this macro has to be at the beginning of the line*/
    
    
    SCST_SECTION_EXEC(m4_scst_test_code)
    SCST_THUMB2
    
    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_exception_mem_fault" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_exception_mem_fault,function)
m4_scst_exception_mem_fault:
    
    PUSH.W  {R1-R8,R14}
    
    /* Store registers content */
    BL      m4_scst_store_registers_content
    
    /* Save current content of PRIMASK in R1 and current content of FAULTMASK to R6 */
    /* ! Don't use R1, R6 for any other purpose until PRIMASK, FAULTMASK is restored. */
    MRS     R1,PRIMASK
    MRS     R6,FAULTMASK
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_mem_fault_ISR1
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
    LDR     R0,=M4_XN_REGION_ADDR  /* Load R0 with (XN) region address */
    
    /* R5 is used as a flag indicating correct invocation of the SCST-own ISR. */
    MOV     R5,#0x0
    
    /* Set SCST interrupt vector table */
    BL      m4_scst_set_scst_interrupt_vector_table
    
    /* We need to check Memory management fault is not active or pending */
    LDR     R3,=M4_SHCSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<0)          /* Check SHCSR[MEMFAULTACT] bit is not set */
    BNE     m4_scst_exception_mem_fault_pending_active
    TST     R4,#(1<<13)         /* Check SHCSR[MEMFAULTPENDED] bit is not set */
    BNE     m4_scst_exception_mem_fault_pending_active
    
    /* We need to enable Memory management fault exception */
    ORR     R4,R4,#(1<<16)      /* Set SHCSR[MEMFAULTENA] bit */
    STR     R4,[R3]             /* Modify SHCSR register */
    
    LDR     R3,=M4_SHPR1_REG
    MOV     R4,#0x0
    STRB    R4,[R3,#0]          /* Clear SHPR1[PRI_4] to enable possibly masked Memory management exception only */
    
    CPSIE   i    /* Enable interrupts and configurable fault handlers (clear PRIMASK) */
    CPSIE   f    /* Enable interrupts and fault handlers (clear FAULTMASK) */
    
    /* We need to test that IACCVIOL flag is not set by an application */
    LDR     R3,=M4_MMFSR_REG
    LDRB    R4,[R3]
    TST     R4,#(1<<0)      /* Test MMFSR[IACCVIOL] bit is set or not */
    BNE     m4_scst_exception_mem_fault_end
    
    ORR     R3,R0,#1  /* Set bit[0] */
    
    MOV     R2, #0x4        /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 4 */
    
    BX      R3  /* Access (XN) region - generate exception */
m4_scst_mem_fault_loop_1:
    B       m4_scst_mem_fault_loop_1
    
m4_scst_mem_fault_error:
    /* We need to change return address that is stored in stack:
       it points to (XN) region */
    ADR.W   R4,m4_scst_exception_mem_fault_end
    STR     R4,[SP,#24] /* Store new return address from the ISR... */
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_mem_fault_pending_active:
    LDR     R3,=m4_scst_test_was_interrupted
    STR     R3,[R3]
m4_scst_exception_mem_fault_end:
    BL      m4_scst_restore_registers_content
    MOV     R0,R5        /* Test result is returned in R0, according to the conventions */
    B       m4_scst_exception_test_tail_end
    
    
m4_scst_exception_mem_fault_ISR1:
    /* We need to check the IACCVIOL flag was set */
    LDR     R3,=M4_MMFSR_REG
    LDRB    R4,[R3]     /* Use halfword byte access to MMFSR */
    TST     R4,#(1<<0)  /* Check MMFSR[IACCVIOL] bit is set */
    BEQ     m4_scst_mem_fault_error
    AND     R4,R4,#(1<<0)   /* Ensure that only IACCVIOL flag is cleared*/
    STRH    R4,[R3]         /* Clear MMFSR[IACCVIOL](rc_w1) flag */
    
    LDRH    R4,[R3]     /* Use halfword access to UFSR */
    TST     R4,#(1<<0)  /* Check that MMFSR[IACCVIOL] flag was cleared */
    BNE     m4_scst_mem_fault_error
    
    ADD.W   R5,R5,#0xC3B
    
    /* We need to change return address that is stored in stack:
       it points to (XN) region */
    ADR.W   R4,m4_scst_exception_mem_fault_end
    STR     R4,[SP,#24] /* Store new return address from the ISR... */
    
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
    