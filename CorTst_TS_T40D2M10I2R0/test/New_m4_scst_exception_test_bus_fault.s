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
* Tests triggering of Bus fault.
*
* 测试总结：
* -------------
*
* 测试总线故障的触发。
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_exception_bus_fault

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_ISR_address
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
SCST_DEFINE(M4_RESERVED_ADDR, M4_DEVICE_RESERVED_ADDR) /* this macro has to be at the beginning of the line */
    
    
    SCST_SECTION_EXEC(m4_scst_test_code)
    SCST_THUMB2
    
    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_exception_bus_fault" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_exception_bus_fault, function)
m4_scst_exception_bus_fault:
    
    PUSH.W  {R1-R8,R14}
    
    /* Store registers content */
    BL      m4_scst_store_registers_content
    
    /* Save current content of PRIMASK in R1 and current content of FAULTMASK to R6 */
    /* ! Don't use R1, R6 for any other purpose until PRIMASK, FAULTMASK is restored. */
    MRS     R1,PRIMASK
    MRS     R6,FAULTMASK
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_bus_fault_ISR1
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
    ADR.W   R0,m4_scst_exception_bus_fault_ISR_ret_addr1
    
    /* R5 is used as a flag indicating correct invocation of the SCST-own ISR. */
    MOV     R5,#0x0
    
    /* Set SCST interrupt vector table */
    BL      m4_scst_set_scst_interrupt_vector_table
    
    /* We need to check Bus fault is not active or pending */
    LDR     R3,=M4_SHCSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<1)          /* Check SHCSR[BUSFAULTACT] bit is not set */
    BNE     m4_scst_exception_bus_fault_pending_active
    TST     R4,#(1<<14)         /* Check SHCSR[BUSFAULTPENDED] bit is not set */
    BNE     m4_scst_exception_bus_fault_pending_active
    
    /* We need to enable Bus fault exception */
    ORR     R4,R4,#(1<<17)      /* Set SHCSR[BUSFAULTENA] bit */
    STR     R4,[R3]             /* Modify SHCSR register */
    
    LDR     R3,=M4_SHPR1_REG
    MOV     R4,#0x0
    STRB    R4,[R3,#1]          /* Clear SHPR1[PRI_5] to enable possibly masked Bus fault exception only */
    
    /* Disable Unaligned access Usage fault exception */
    LDR     R3,=M4_CCR_REG
    LDR     R4,[R3]
    BFC     R4,#3,#1            /* Clear CCR[UNALIGN_TRP] bit */
    STR     R4,[R3]
    
    CPSIE   i    /* Enable interrupts and configurable fault handlers (clear PRIMASK) */
    CPSIE   f    /* Enable interrupts and fault handlers (clear FAULTMASK) */
    
    /* We need to test that PRECISERR and BFARVALID flags are not set by an application */
    LDR     R3,=M4_BFSR_REG
    LDRB    R4,[R3]
    TST     R4,#(1<<1)      /* Test BFSR[PRECISERR] bit is set or not */
    BNE     m4_scst_exception_bus_fault_end
    TST     R4,#(1<<7)      /* Test BFSR[BFARVALID] bit is set or not */
    BNE     m4_scst_exception_bus_fault_end
    
    LDR     R3,=M4_RESERVED_ADDR /* Load R3 with address */
    
    MOV     R2,#0x5         /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 5 */
    
m4_scst_exception_bus_fault_ISR_ret_addr1:
    LDR     R2,[R3]         /* Precise data bus error -> Generate exception!! */
m4_scst_bus_fault_loop_1:
    B       m4_scst_bus_fault_loop_1

m4_scst_bus_fault_return_address_1:
    /* We need to test that IMPRECISERR flag is not set by an application */
    LDR     R3,=M4_BFSR_REG
    LDRB    R4,[R3]
    TST     R4,#(1<<2)      /* Test BFSR[IMPRECISERR] bit is set or not */
    BNE     m4_scst_exception_bus_fault_end
    
    LDR     R3,=M4_RESERVED_ADDR /* Load R3 with address */
    MOV     R2,#0x5         /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 5 */
    
    /*  We have to disable interrupts first to can test IMPRECISE Bus Fault. 
        We will check only pending state to avoid situation that test
        is called from the Thread mode with an active interrupt service routine
        by using the Non-Base-Thread functionality. In such case IMPRECISE
        BusFault exception is not triggered. To cover this situation we have to
        disable all interrupts. */
    CPSID   f   /* Disable interrupts not to generate IMPRECISE BusFault exception */
    
    STR     R2,[R3]         /* Imprecise data bus error -> Generate exception!! */
    
    /* We need to check the IMPRECISERR flag was set */
    LDR     R3,=M4_BFSR_REG
    LDRB    R4,[R3]     /* Use halfword access to BFSR */
    TST     R4,#(1<<2)  /* Check BFSR[IMPRECISERR] bit is set */
    BEQ     m4_scst_exception_bus_fault_end
    
    AND     R4,R4,#(1<<2)   /* Ensure that only IMPRECISERR flag is cleared */
    STRH    R4,[R3]         /* Clear BFSR[IMPRECISERR](rc_w1) flag */
    
    LDRB    R4,[R3]     /* Use byte access to BFSR */
    TST     R4,#(1<<2)  /* Check that BFSR[IMPRECISERR] flag was cleared */
    BNE     m4_scst_exception_bus_fault_end
    
    /* We need to check that BusFault exception is pending */
    LDR     R3,=M4_SHCSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<14)     /* Check BusFault is pending */
    BEQ     m4_scst_exception_bus_fault_end
    
    /* We need to check pending vector is correct */
    LDR     R3,=M4_ICSR_REG
    LDR     R4,[R3]
    UBFX    R4,R4,#12,#10
    CMP     R2,R4
    BNE     m4_scst_exception_bus_fault_end
    
    /* We need to clear pending BusFault */
    LDR     R3,=M4_SHCSR_REG
    LDR     R4,[R3]
    BFC     R4,#14,#1
    STR     R4,[R3]
    LDR     R4,[R3]         /* Load SHCSR again */
    TST     R4,#(1<<14)     /* Check BusFault is pending or not */
    BNE     m4_scst_exception_bus_fault_end
    
    LDR     R3,=M4_ICSR_REG
    LDR     R4,[R3]     /* Load ICSR again */
    UBFX    R4,R4,#12,#10
    CMP     R4,R2       /* Check BusFault is not pending */
    BEQ     m4_scst_exception_bus_fault_end
    
    ADD.W   R5,R5,#0x0A58
    
    
m4_scst_exception_bus_fault_end:
    BL      m4_scst_restore_registers_content
    MOV     R0,R5        /* Test result is returned in R0, according to the conventions */
    B       m4_scst_exception_test_tail_end
    
m4_scst_exception_bus_fault_pending_active:
    LDR     R3,=m4_scst_test_was_interrupted
    STR     R3,[R3]
    B       m4_scst_exception_bus_fault_end
    
    
    
m4_scst_bus_fault_error:
    /* We need to change return address that is stored in stack:
       it points to instruction which causes PRECISERR Bus fault */
    ADR.W   R3,m4_scst_exception_bus_fault_end
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
    
m4_scst_exception_bus_fault_ISR1:
    /* We need to check the BFAR register was loaded by fault address */
    LDR     R3,=M4_BFAR_REG
    LDR     R4,[R3]
    LDR     R3,=M4_RESERVED_ADDR
    CMP     R4,R3
    BNE     m4_scst_bus_fault_error
    /* We need to check the PRECISERR flag was set */
    LDR     R3,=M4_BFSR_REG
    LDRB    R4,[R3]     /* Use halfword access to BFSR */
    TST     R4,#(1<<1)  /* Check BFSR[PRECISERR] bit is set */
    BEQ     m4_scst_bus_fault_error
    TST     R4,#(1<<7)  /* Check BFSR[BFARVALID] bit is set */
    BEQ     m4_scst_bus_fault_error
    AND     R4,R4,#(0x82)   /* Ensure that only PRECISERR and BFARVALID flags are cleared */
    STRH    R4,[R3]         /* Clear BFSR[PRECISERR](rc_w1) and BFSR[BFARVALID](rc_w1) flags */
    
    LDRB    R4,[R3]     /* Use byte access to BFSR */
    TST     R4,#(1<<1)  /* Check that BFSR[PRECISERR] flag was cleared */
    BNE     m4_scst_bus_fault_error
    TST     R4,#(1<<7)  /* Check that BFSR[BFARVALID] flag was cleared */
    BNE     m4_scst_bus_fault_error
    
    ADD.W   R5,R5,#0x058B
    
    /* We need to change return address that is stored in stack:
       it points to instruction which causes PRECISERR Bus fault */
    ADR.W   R3,m4_scst_bus_fault_return_address_1
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
    