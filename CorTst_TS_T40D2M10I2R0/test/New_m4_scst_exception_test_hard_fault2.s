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
* Tests triggering of Hard fault.
*
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_exception_hard_fault2

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_ISR_address
    SCST_EXTERN m4_scst_scb_registers_dump
    SCST_EXTERN m4_scst_special_condition_flag
    SCST_EXTERN m4_scst_exception_test_tail_end
    SCST_EXTERN m4_scst_store_registers_content
    SCST_EXTERN m4_scst_set_scst_interrupt_vector_table
    SCST_EXTERN m4_scst_restore_registers_content
    SCST_EXTERN m4_scst_test_was_interrupted
    
    /* This address is used to trigger both Precise and Imprecise BusFault exceptions. 
       The address was chosen from device System Memory Map reserved space, see 
       -DM4_DEVICE_RESERVED_ADDR preprocessor macro definition in the SCST User Manual document.
       Note that application must ensure that this memory is not protected e.g by the MPU.
       In case of this address is protected another address from the device Reserved 
       address space has to be chosen. */
SCST_DEFINE(M4_RESERVED_ADDR, M4_DEVICE_RESERVED_ADDR) /*this macro has to be at the beginning of the line*/
    
    /* This address belongs to the region with Execute Never (XN) permissions */
SCST_DEFINE(M4_XN_REGION_ADDR, 0xFFFFFFF0) /*this macro has to be at the beginning of the line*/
    
    
    SCST_SECTION_EXEC(m4_scst_test_code) 
    SCST_THUMB2
    
    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_exception_hard_fault2" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_exception_hard_fault2, function)
m4_scst_exception_hard_fault2:
    
    PUSH.W  {R1-R8,R14}
    
    /* Store registers content */
    BL      m4_scst_store_registers_content
    
    /* Save current content of PRIMASK in R1 and current content of FAULTMASK to R6 */
    /* ! Don't use R1, R6 for any other purpose until PRIMASK, FAULTMASK is restored. */
    MRS     R1,PRIMASK
    MRS     R6,FAULTMASK
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_hard_fault2_ISR1
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
    ADR.W   R0,m4_scst_exception_hard_fault2_ISR_ret_addr1
    
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
    BNE.W   m4_scst_exception_hard_fault2_pending_active
    
    CPSID   i    /* Disable interrupts and configurable fault handlers (Set PRIMASK) */
    CPSIE   f    /* Enable interrupts and fault handlers (clear FAULTMASK) */
    
    /* We need to test that FORCED flag is not set by an application */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set or not */
    BNE.W   m4_scst_exception_hard_fault2_end
    
    MOV     R2, #0x3        /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 3 */
    SVC     0   /* Generate exception ! -> SVCall will be escalated to HardFault (PRIMASK is set) */
m4_scst_exception_hard_fault2_ISR_ret_addr1:
    B       m4_scst_exception_hard_fault2_ISR_ret_addr1
    
    
/*-----------------------------------------------------*/
/* Test Bus faults escalation to HardFault exception   */
/*-----------------------------------------------------*/
m4_scst_hard_fault2_return_address_1:
    /* We need to test that IMPRECISERR flag is not set by an application */
    LDR     R3,=M4_BFSR_REG
    LDRB    R4,[R3]
    TST     R4,#(1<<2)      /* Test BFSR[IMPRECISERR] bit is set or not */
    BNE     m4_scst_exception_hard_fault2_end
    
    /* Disable Unaligned access Usage fault exception */
    LDR     R3,=M4_CCR_REG
    LDR     R4,[R3]
    BFC     R4,#3,#1            /* Clear CCR[UNALIGN_TRP] bit */
    STR     R4,[R3]
    
     /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_hard_fault2_ISR2
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    LDR     R3,=M4_RESERVED_ADDR /* Load R3 with address */
    
    ADR.W   R0,m4_scst_exception_hard_fault2_ISR_ret_addr2
    MOV     R2,#0x3         /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 3 */
    
    STR     R2,[R3]         /* Imprecise data bus error -> Generate exception!! */
m4_scst_exception_hard_fault2_ISR_ret_addr2:
    B       m4_scst_exception_hard_fault2_ISR_ret_addr2
    
m4_scst_hard_fault2_return_address_2:
    /* We need to test that PRECISERR and BFARVALID flags are not set by an application */
    LDR     R3,=M4_BFSR_REG
    LDRB    R4,[R3]
    TST     R4,#(1<<1)      /* Test BFSR[PRECISERR] bit is set or not */
    BNE     m4_scst_exception_hard_fault2_end
    TST     R4,#(1<<7)      /* Test BFSR[BFARVALID] bit is set or not */
    BNE     m4_scst_exception_hard_fault2_end
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_hard_fault2_ISR3
    ORR     R4,R4,#1        /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    LDR     R3,=M4_RESERVED_ADDR /* Load R3 with address */
    
    ADR.W   R0,m4_scst_exception_hard_fault2_ISR_ret_addr3
    MOV     R2,#0x3         /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 3 */
    
m4_scst_exception_hard_fault2_ISR_ret_addr3:
    LDR     R2,[R3]         /* Precise data bus error -> Generate exception!! */
m4_scst_hard_fault2_loop_1:
    B       m4_scst_hard_fault2_loop_1

/*-----------------------------------------------------------------*/
/* Test Memory management faults escalation to HardFault exception */
/*-----------------------------------------------------------------*/
m4_scst_hard_fault2_return_address_3:
    /* We need to test that IACCVIOL flag is not set by an application */
    LDR     R3,=M4_MMFSR_REG
    LDRB    R4,[R3]
    TST     R4,#(1<<0)      /* Test MMFSR[IACCVIOL] bit is set or not */
    BNE     m4_scst_exception_hard_fault2_end
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_hard_fault2_ISR4
    ORR     R4,R4,#1        /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    LDR     R0,=M4_XN_REGION_ADDR  /* Load R0 with (XN) region address */
    ORR     R3,R0,#1  /* Set bit[0] */
    MOV     R2, #0x3        /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 3 */
    
    BX      R3  /* Access (XN) region - generate exception */
m4_scst_hard_fault2_loop_2:
    B       m4_scst_hard_fault2_loop_2
    
    
m4_scst_hard_fault2_error:
    LDR     R3,=m4_scst_special_condition_flag
    MOV     R4,#0
    STR     R4,[R3] /* Clear m4_scst_special_condition_flag */
    
    /* We need to change return address that is stored in stack: */
    ADR.W   R3,m4_scst_exception_hard_fault2_end
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
    
m4_scst_exception_hard_fault2_pending_active:
    LDR     R3,=m4_scst_test_was_interrupted
    STR     R3,[R3]
m4_scst_exception_hard_fault2_end:
    BL      m4_scst_restore_registers_content
    MOV     R0,R5        /* Test result is returned in R0, according to the conventions */
    B       m4_scst_exception_test_tail_end
    
    
m4_scst_exception_hard_fault2_ISR1:
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_hard_fault2_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    LDR     R4,[R3]     /* Load HFSR */
    TST     R4,#(1<<30) /* Check that HFSR[FORCED] flag was cleared */
    BNE     m4_scst_hard_fault2_error
    
    ADD.W   R5,R5,#0x55C
    
    /* We need to change return address that is stored in stack:
       it points again to the undefined instruction */
    ADR.W   R3,m4_scst_hard_fault2_return_address_1
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    CPSIE   i    /* Enable interrupts and configurable fault handlers (clear PRIMASK) */
    
    BX      LR
    
m4_scst_exception_hard_fault2_ISR2:
    /* We need to check the IMPRECISERR flag was set */
    LDR     R3,=M4_BFSR_REG
    LDRB    R4,[R3]     /* Use halfword access to BFSR */
    TST     R4,#(1<<2)  /* Check BFSR[IMPRECISERR] bit is set */
    BEQ     m4_scst_hard_fault2_error
    AND     R4,R4,#(1<<2)   /* Ensure that only IMPRECISERR flag is cleared */
    STRH    R4,[R3]         /* Clear IMPRECISERR(rc_w1) flag */
    
    LDRB    R4,[R3]     /* Use byte access to BFSR */
    TST     R4,#(1<<2)  /* Check that BFSR[IMPRECISERR] flag was cleared */
    BNE     m4_scst_hard_fault2_error
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_hard_fault2_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    LDR     R4,[R3]     /* Load HFSR */
    TST     R4,#(1<<30) /* Check that HFSR[FORCED] flag was cleared */
    BNE     m4_scst_hard_fault2_error
    
    ADD.W   R5,R5,#0x3B8
    
    /* We need to change return address that is stored in stack: */
    ADR.W   R3,m4_scst_hard_fault2_return_address_2
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_hard_fault2_ISR3:
    /* We need to check the BFAR register was loaded by fault address */
    LDR     R3,=M4_BFAR_REG
    LDR     R4,[R3]
    LDR     R3,=M4_RESERVED_ADDR
    CMP     R4,R3
    BNE     m4_scst_hard_fault2_error
    /* We need to check the PRECISERR flag was set */
    LDR     R3,=M4_BFSR_REG
    LDRB    R4,[R3]     /* Use halfword access to BFSR */
    TST     R4,#(1<<1)  /* Check BFSR[PRECISERR] bit is set */
    BEQ     m4_scst_hard_fault2_error
    TST     R4,#(1<<7)  /* Check BFSR[BFARVALID] bit is set */
    BEQ     m4_scst_hard_fault2_error
    AND     R4,R4,#(0x82)   /* Ensure that only PRECISERR and BFARVALID flags are cleared */
    STRH    R4,[R3]         /* Clear BFSR[PRECISERR](rc_w1) and BFSR[BFARVALID] flags */
    
    LDRB    R4,[R3]     /* Use byte access to BFSR */
    TST     R4,#(1<<1)  /* Check that BFSR[PRECISERR] flag was cleared */
    BNE     m4_scst_hard_fault2_error
    TST     R4,#(1<<7)  /* Check that BFSR[BFARVALID] flag was cleared */
    BNE     m4_scst_hard_fault2_error
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_hard_fault2_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    LDR     R4,[R3]     /* Load HFSR */
    TST     R4,#(1<<30) /* Check that HFSR[FORCED] flag was cleared */
    BNE     m4_scst_hard_fault2_error
    
    ADD.W   R5,R5,#0x73A
    
    /* We need to change return address that is stored in stack:
       it points to instruction which causes PRECISERR Bus fault */
    ADR.W   R3,m4_scst_hard_fault2_return_address_3
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_hard_fault2_ISR4:
    /* We need to check the IACCVIOL flag was set */
    LDR     R3,=M4_MMFSR_REG
    LDRB    R4,[R3]     /* Use halfword byte access to MMFSR */
    TST     R4,#(1<<0)  /* Check MMFSR[IACCVIOL] bit is set */
    BEQ     m4_scst_hard_fault2_error
    AND     R4,R4,#(1<<0)   /* Ensure that only IACCVIOL flag is cleared*/
    STRH    R4,[R3]         /* Clear MMFSR[IACCVIOL](rc_w1) flag */
    
    LDRH    R4,[R3]     /* Use halfword access to UFSR */
    TST     R4,#(1<<0)  /* Check that flag was cleared */
    BNE     m4_scst_hard_fault2_error
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_hard_fault2_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    LDR     R4,[R3]     /* Load HFSR */
    TST     R4,#(1<<30) /* Check that HFSR[FORCED] flag was cleared */
    BNE     m4_scst_hard_fault2_error
    
    ADD.W   R5,R5,#0xA1B
    
    /* We need to change return address that is stored in stack:
       it points to (XN) region */
    ADR.W   R4,m4_scst_exception_hard_fault2_end
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
    
