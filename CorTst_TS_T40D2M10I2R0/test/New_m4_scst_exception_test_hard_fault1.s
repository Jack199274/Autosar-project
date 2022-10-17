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
* Tests triggering of Hard fault.
* Test summary:
* -------------
* 测试总结：
* -------------
*
* 测试硬故障的触发。

******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_exception_hard_fault1

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_ISR_address
    SCST_EXTERN m4_scst_scb_registers_dump
    SCST_EXTERN m4_scst_special_condition_flag
    SCST_EXTERN m4_scst_exception_test_tail_end
    SCST_EXTERN m4_scst_store_registers_content
    SCST_EXTERN m4_scst_set_scst_interrupt_vector_table
    SCST_EXTERN m4_scst_restore_registers_content
    SCST_EXTERN m4_scst_test_was_interrupted
    
    
    SCST_SECTION_EXEC(m4_scst_test_code) 
    SCST_THUMB2
    
    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_exception_hard_fault1" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_exception_hard_fault1, function)
m4_scst_exception_hard_fault1:
    
    PUSH.W  {R1-R8,R14}
    
    /* Store registers content */
    BL      m4_scst_store_registers_content
    
    /* Save current content of PRIMASK in R1 and current content of FAULTMASK to R6 */
    /* ! Don't use R1, R6 for any other purpose until PRIMASK, FAULTMASK is restored. */
    MRS     R1,PRIMASK
    MRS     R6,FAULTMASK
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_hard_fault1_ISR1
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
    ADR.W   R0,m4_scst_exception_hard_fault1_ISR_ret_addr1
    
    /* R5 is used as a flag indicating correct invocation of the SCST-own ISR. */
    MOV     R5,#0x0
    
    /* Set SCST interrupt vector table */
    BL      m4_scst_set_scst_interrupt_vector_table
    
    /* Disable all configurable exceptions */
    LDR     R3,=M4_SHCSR_REG    /* Load SHCSR(SCB) register address */
    LDR     R4,[R3]             /* Load current SHCSR register value */
    AND     R4,R4,#0xFFF8FFFF   /* Clear SHCSR[USGFAULTENA,BUSFAULTENA,MEMFAULTENA] bits */
    STR     R4,[R3]             /* Modify SHCSR register */
    
    LDR     R4,[R3]
    CMP     R4,#0               /* Check that SHCSR[USGFAULTENA,BUSFAULTENA,MEMFAULTENA] were cleared */
                                /* and there is no active SHCSR[ACT,PEND] bits set */
    BNE.W   m4_scst_exception_hard_fault1_pending_active
    
    /* We need to test that FORCED flag is not set by an application */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set or not */
    BNE.W   m4_scst_exception_hard_fault1_end

/*-----------------------------------------------------*/
/* Test Usage faults escalation to HardFault exception */
/*-----------------------------------------------------*/
    /* We need to test that UNDEFINSTR flag is not set by an application */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]
    TST     R4,#(1<<0)      /* Test UFSR[UNDEFINSTR] bit is set or not */
    BNE.W   m4_scst_exception_hard_fault1_end
    
    CPSIE   i       /* Enable interrupts with configurable priority */
    CPSIE   f       /* Enable all exceptions */
    
    MOV     R2, #0x3        /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 3 */
    
m4_scst_exception_hard_fault1_ISR_ret_addr1:
    UDF.W   #0xFFFF  /* Undefined instruction - generate exception */
m4_scst_hard_fault1_loop_1:
    B       m4_scst_hard_fault1_loop_1
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                  (containing numeric values for used symbolic names used within LDR instruction).
                  It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
m4_scst_hard_fault1_return_address_1: 
    /* We need to test that DIVBYZERO flag is not set by an application */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]
    TST     R4,#(1<<9)      /* Test UFSR[DIVBYZERO] bit is set or not */
    BNE.W   m4_scst_exception_hard_fault1_end
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_hard_fault1_ISR2
    ORR     R4,R4,#1        /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    /* Enable Division by zero and Unaligned access Usage fault exception -> Escalation to Hard fault */
    LDR     R3,=M4_CCR_REG
    LDR     R4,[R3]
    ORR     R4,R4,#0x00000018   /* Set CCR[DIV_0_TRP,UNALIGN_TRP] bits */
    STR     R4,[R3]             /* Write bits to the CCR register */
    
    LDR     R4,[R3]
    AND     R4,R4,#0x00000018
    CMP     R4,#0x00000018      /* Check that bits were set */
    BNE.W   m4_scst_exception_hard_fault1_end
    
    MOV     R4, #0      /* Set R4 to 0 to prepare division by zero */
    
    ADR.W   R0, m4_scst_exception_hard_fault1_ISR_ret_addr2
    MOV     R2, #0x3    /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 3 */
    
m4_scst_exception_hard_fault1_ISR_ret_addr2:
    UDIV    R3,R3,R4    /* Division by zero - generate exception !*/
m4_scst_hard_fault1_loop_2:
    B       m4_scst_hard_fault1_loop_2
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                  (containing numeric values for used symbolic names used within LDR instruction).
                  It is 4-byte aligned, as 2-byte alignment causes incorrect work. */

m4_scst_hard_fault1_return_address_2:
    /* We need to test that UNALIGNED flag is not set by an application */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]
    TST     R4,#(1<<8)      /* Test UFSR[UNALIGNED] bit is set or not */
    BNE     m4_scst_exception_hard_fault1_end
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_hard_fault1_ISR3
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    LDR     R4,=m4_scst_scb_registers_dump /* Load to R4 address from SRAM memory */
    ADD     R4,R4,#1    /* Increment by 1 to have unaligned address */
    
    ADR.W   R0, m4_scst_exception_hard_fault1_ISR_ret_addr3
    MOV     R2, #0x3    /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 3 */
    
m4_scst_exception_hard_fault1_ISR_ret_addr3:
    LDR     R3,[R4]     /* First run: Unaligned access  - generate exception ! */
m4_scst_hard_fault1_loop_3:
    B       m4_scst_hard_fault1_loop_3
    
m4_scst_hard_fault1_return_address_3:
    /* We need to test that INVSTATE flag is not set by an application */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]
    TST     R4,#(1<<1)      /* Test UFSR[INVSTATE] bit is set or not */
    BNE     m4_scst_exception_hard_fault1_end
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_hard_fault1_ISR4
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    ADR.W   R0, m4_scst_exception_hard_fault1_ISR_ret_addr4
    MOV     R2, #0x3    /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 3 */

    SCST_LABEL
m4_scst_exception_hard_fault1_ISR_ret_addr4:
    SCST_CODE

    BX      R0          /* This will clear EPSR.T bit - Generate exception! */
m4_scst_hard_fault1_loop_4:
    B       m4_scst_hard_fault1_loop_4

m4_scst_hard_fault1_return_address_4:
    /* We need to test that INVPC flag is not set by an application */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]
    TST     R4,#(1<<2)      /* Test UFSR[INVPC] bit is set or not */
    BNE     m4_scst_exception_hard_fault1_end
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_hard_fault1_ISR5_1
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    ADR.W   R0, m4_scst_exception_hard_fault1_end
    MOV     R2,#0xB      /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0xB */
    
    LDR     R3,=M4_SHPR2_REG
    MOV     R4,#0x0
    STRB    R4,[R3,#3]  /* Clear SHPR2[PRI_11] to enable possibly masked SVC exception only */
    
    SVC     0           /* Generate exception ! */
    
    
m4_scst_hard_fault1_error:
    LDR     R3,=m4_scst_special_condition_flag
    MOV     R4,#0
    STR     R4,[R3] /* Clear m4_scst_special_condition_flag */
    
    /* We need to change return address that is stored in stack: */
    ADR.W   R3,m4_scst_exception_hard_fault1_end
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
    
m4_scst_exception_hard_fault1_pending_active:
    LDR     R3,=m4_scst_test_was_interrupted
    STR     R3,[R3]
m4_scst_exception_hard_fault1_end:
    BL      m4_scst_restore_registers_content
    MOV     R0,R5        /* Test result is returned in R0, according to the conventions */
    B       m4_scst_exception_test_tail_end
    
    
m4_scst_exception_hard_fault1_ISR1:
    /* We need to check that UNDEFINSTR flag was set */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]     /* Use halfword access to UFSR */
    TST     R4,#(1<<0)  /* Check UFSR[UNDEFINSTR] */
    BEQ     m4_scst_hard_fault1_error
    AND     R4,R4,#(1<<0)   /* Ensure that only UNDEFINSTR flag is cleared */
    STRH    R4,[R3]         /* Clear UFSR[UNDEFINSTR](rc_w1) flag */
    
    LDRH    R4,[R3]     /* Use halfword access to UFSR */
    TST     R4,#(1<<0)  /* Check that flag was cleared */
    BNE     m4_scst_hard_fault1_error
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_hard_fault1_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    LDR     R4,[R3]     /* Load HFSR */
    TST     R4,#(1<<30) /* Check that HFSR[FORCED] flag was cleared */
    BNE     m4_scst_hard_fault1_error
    
    ADD.W   R5,R5,#0x18B
    
    /* We need to change return address that is stored in stack:
       it points again to the undefined instruction */
    ADR.W   R3,m4_scst_hard_fault1_return_address_1
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_hard_fault1_ISR2:
    /* We need to check that DIVBYZERO flag was set */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]     /* Use halfword access to UFSR */
    TST     R4,#(1<<9)  /* Check UFSR[DIVBYZERO] bit is set */
    BEQ     m4_scst_hard_fault1_error
    AND     R4,R4,#(1<<9)   /* Ensure that only DIVBYZERO flag is cleared */
    STRH    R4,[R3]         /* Clear UFSR[DIVBYZERO](rc_w1) flag */
    
    LDRH    R4,[R3]     /* Use halfword access to UFSR */
    TST     R4,#(1<<9)  /* Check that flag was cleared */
    BNE     m4_scst_hard_fault1_error
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_hard_fault1_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    LDR     R4,[R3]     /* Load HFSR */
    TST     R4,#(1<<30) /* Check that HFSR[FORCED] flag was cleared */
    BNE     m4_scst_hard_fault1_error
    
    ADD.W   R5,R5,#0x182
    
    /* We need to change return address that is stored in stack:
       it points again to div-by-zero instruction */
    ADR.W   R3,m4_scst_hard_fault1_return_address_2
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_hard_fault1_ISR3:
    /* We need to check that UNALIGNED flag was set */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]     /* Use halfword access to UFSR */
    TST     R4,#(1<<8)  /* Check UFSR[UNALIGNED] bit is set */
    BEQ     m4_scst_hard_fault1_error
    AND     R4,R4,#(1<<8)   /* Ensure that only UNALIGNED flag is cleared */
    STRH    R4,[R3]         /* Clear UFSR[UNALIGNED](rc_w1) flag */
    
    LDRH    R4,[R3]     /* Use halfword access to UFSR */
    TST     R4,#(1<<8)  /* Check that flag was cleared */
    BNE     m4_scst_hard_fault1_error
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_hard_fault1_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    LDR     R4,[R3]     /* Load HFSR */
    TST     R4,#(1<<30) /* Check that HFSR[FORCED] flag was cleared */
    BNE     m4_scst_hard_fault1_error
    
    ADD.W   R5,R5,#0x47E
    
    /* We need to change return address that is stored in stack:
       it points again to unaligned access instruction */
    ADR.W   R3,m4_scst_hard_fault1_return_address_3
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_hard_fault1_ISR4:
    /* We need to check that INVSTATE flag was set */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]     /* Use halfword access to UFSR */
    TST     R4,#(1<<1)  /* Check UFSR[INVSTATE] bit is set */
    BEQ     m4_scst_hard_fault1_error
    AND     R4,R4,#(1<<1)   /* Ensure that only INVSTATE flag is cleared */
    STRH    R4,[R3]         /* Clear UFSR[INVSTATE](rc_w1) flag */
    
    LDRH    R4,[R3]     /* Use halfword access to UFSR */
    TST     R4,#(1<<1)  /* Check that flag was cleared */
    BNE     m4_scst_hard_fault1_error
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_hard_fault1_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    LDR     R4,[R3]     /* Load HFSR */
    TST     R4,#(1<<30) /* Check that HFSR[FORCED] flag was cleared */
    BNE     m4_scst_hard_fault1_error
    
    ADD.W   R5,R5,#0x35D
    
    /* We need to change return address that is stored in stack: */
    ADR.W   R3,m4_scst_hard_fault1_return_address_4
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_hard_fault1_ISR5_1:
    LDR     R3,=m4_scst_special_condition_flag  /* Set global variable - Special Condition !!!! */
    LDR     R4,=0x19761231    /* Random value to indicate special conditions */
    STR     R4,[R3]     /* Write random value to special condition variable */
    MOV     R2,#0x3     /* Set R2 to 3 to indicate that SCST expects further interrupt with IRQ number 3 */
    STR     R2,[SP,#8]  /* Rewrite stacked R2 value */
    
    TST     LR,#1       /* Checks that EXC_RETURN value has bit[0] set */
    BEQ     m4_scst_hard_fault1_error
    SUB     LR,LR,#1    /* Change EXC_RETURN value - delete bit[0] */
    
    ADR.W   R4,m4_scst_exception_hard_fault1_ISR5_2
    ORR     R4,R4,#1
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    DSB     /* Ensures memory is updated before exception */
    
    BX      LR          /* Generate exception */
m4_scst_hard_fault1_loop_5:
    B       m4_scst_hard_fault1_loop_5
    
m4_scst_exception_hard_fault1_ISR5_2: 
    /* We need to check that INVPC flag was set */
    LDR     R3,=M4_UFSR_REG
    LDRH    R4,[R3]     /* Use halfword access to UFSR */
    TST     R4,#(1<<2)  /* Check UFSR[INVPC] bit is set */
    BEQ     m4_scst_hard_fault1_error
    AND     R4,R4,#(1<<2)   /* Ensure that only INVPC flag is cleared */
    STRH    R4,[R3]         /* Clear UFSR[INVPC](rc_w1) flag */
    
    LDRH    R4,[R3]     /* Use halfword access to UFSR */
    TST     R4,#(1<<2)  /* Check that flag was cleared */
    BNE     m4_scst_hard_fault1_error
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_hard_fault1_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    LDR     R4,[R3]     /* Load HFSR */
    TST     R4,#(1<<30) /* Check that HFSR[FORCED] flag was cleared */
    BNE     m4_scst_hard_fault1_error
    
    ADD.W   R5,R5,#0x2A1
    
    LDR     R3,=m4_scst_special_condition_flag 
    MOV     R4,#0
    STR     R4,[R3] /* Clear m4_scst_special_condition_flag */
    
    /* We need to change return address that is stored in stack: */
    ADR.W   R3,m4_scst_exception_hard_fault1_end
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
    
