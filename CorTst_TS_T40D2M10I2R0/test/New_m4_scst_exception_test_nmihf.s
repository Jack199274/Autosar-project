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
*
* Tests triggering of NMI interrupts.
*
* 测试总结：
* -------------
*
* 测试触发 NMI 中断。
*

******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_exception_test_nmihf
    
    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_store_registers_content
    SCST_EXTERN m4_scst_set_scst_interrupt_vector_table
    SCST_EXTERN m4_scst_restore_registers_content
    SCST_EXTERN m4_scst_exception_test_tail_end
    SCST_EXTERN m4_scst_ISR_address
    
    /* This address is used to trigger both Precise and Imprecise BusFault exceptions. 
       The address was chosen from device System Memory Map reserved space, see 
       -DM4_DEVICE_RESERVED_ADDR preprocessor macro definition in the SCST User Manual document.
       Note that application must ensure that this memory is not protected e.g by the MPU.
       In case of this address is protected another address from the device Reserved 
       address space has to be chosen. */
SCST_DEFINE(M4_RESERVED_ADDR, M4_DEVICE_RESERVED_ADDR) /* this macro has to be at the beginning of the line */
    
    
    SCST_SECTION_EXEC(m4_scst_test_code)
    SCST_THUMB2
    
    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_exception_test_nmihf" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_exception_test_nmihf, function)
m4_scst_exception_test_nmihf:

    PUSH.W  {R1-R8,R14}
    
    /* Store register content */
    BL      m4_scst_store_registers_content
    
    /* Save current content of PRIMASK in R1 and current content of FAULTMASK to R6 */
    /* ! Don't use R1, R6 for any other purpose until PRIMASK, FAULTMASK is restored. */
    MRS     R1,PRIMASK
    MRS     R6,FAULTMASK
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_nmihf_ISR1
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
    ADR.W   R0,m4_scst_exception_test_nmihf_ISR_ret_addr1
    
    /* R5 is used as a flag indicating correct invocation of the SCST-own ISR. */
    MOV     R5,#0x0
    
    /* Set SCST interrupt vector table */
    BL      m4_scst_set_scst_interrupt_vector_table
    
    CPSIE   i       /* Enable interrupts with configurable priority */
    CPSIE   f       /* Enable all exceptions */
    
    LDR     R3,=M4_CCR_REG
    LDR     R4,[R3]
    ORR     R4,R4,#(1<<9)       /* Set CCR[STKALIGN] bit to ensure SP 8-byte alignment */
    STR     R4,[R3]
    LDR     R4,[R3]
    TST     R4,#(1<<9)          /* Check CCR[STKALIGN] bit is set */
    BEQ     m4_scst_exception_test_nmihf_end
    
    
    /* Ensure SP is not 8-byte aligned */
    MOV     R3,SP               /* Store SP to R3 register */
    MOV     R4,SP
    AND     R4,R4,#0xFFFFFFF0
    SUB     R4,R4,#0xC
    MOV     SP,R4
    MOV     R8,SP               /* Store new SP */
    
    LDR     R4,=M4_ICSR_REG
    LDR     R7,[R4]
    ORR     R7,R7,#(1<<31)      /* Set ICSR[NMIPENDSET] bit to initiate a NMI interrupt */
    
    MOV     R2,#0x2             /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0x2 */
    
    STR     R7,[R4]             /* Generate NMI exception ! */
    
m4_scst_exception_test_nmihf_ISR_ret_addr1:
    B       m4_scst_exception_test_nmihf_ISR_ret_addr1
    
m4_scst_nmihf_return_address_1:
    /* We need to check stack was correctly restored based on stacked xPSR bit[9] */
    CMP     SP,R8
    BNE     m4_scst_exception_test_nmihf_end
    ADD.W   R5,R5,#0x99E
    
    MOV     SP,R3   /* Restore SP value */
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_nmihf_ISR2
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    LDR     R3,=M4_CCR_REG
    LDR     R4,[R3]
    BIC     R4,R4,#(1<<9)       /* Clear CCR[STKALIGN] to ensure 4-byte alignment */
    STR     R4,[R3]
    LDR     R4,[R3]
    TST     R4,#(1<<9)          /* Check CCR[STKALIGN] bit is not set */
    BNE     m4_scst_exception_test_nmihf_end
    
    ADR.W   R0,m4_scst_exception_test_nmihf_ISR_ret_addr2
    MOV     R2,#0x2    /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0x2 */
    
    /* Ensure SP is 4-byte aligned */
    MOV     R3,SP               /* Store SP to R3 register */
    MOV     R4,SP
    AND     R4,R4,#0xFFFFFFF0
    SUB     R4,R4,#0xC
    MOV     SP,R4
    MOV     R8,SP               /* Store new SP */
    
    LDR     R4,=M4_ICSR_REG
    LDR     R7,[R4]
    ORR     R7,R7,#(1<<31)      /* Set ICSR[NMIPENDSET] bit to initiate a NMI interrupt */
    
    STR     R7,[R4]             /* Generate an exception and wait... */

m4_scst_exception_test_nmihf_ISR_ret_addr2:
    B       m4_scst_exception_test_nmihf_ISR_ret_addr2

m4_scst_nmihf_return_address_2:
    MOV     SP,R3   /* Restore SP value */
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_nmihf_ISR3
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    LDR     R3,=M4_CCR_REG
    LDR     R4,[R3]
    ORR     R4,R4,#(1<<9)       /* Set CCR[STKALIGN] bit to ensure SP 8-byte alignment */
    ORR     R4,R4,#(1<<8)       /* Set CCR[BFHFNMIGN] bit to ignore precise data access faults */
    STR     R4,[R3]
    LDR     R4,[R3]
    TST     R4,#(1<<8)          /* Check CCR[BFHFNMIGN] bit is set */
    BEQ     m4_scst_exception_test_nmihf_end
    
    /* We need to test that PRECISERR,BFARVALID and flags are not set by an application */
    LDR     R3,=M4_BFSR_REG
    LDRB    R4,[R3]
    TST     R4,#(1<<1)      /* Test BFSR[PRECISERR] bit is set or not */
    BNE     m4_scst_exception_test_nmihf_end
    TST     R4,#(1<<7)      /* Test BFSR[BFARVALID] bit is set or not */
    BNE     m4_scst_exception_test_nmihf_end
    
    ADR.W   R0,m4_scst_exception_test_nmihf_ISR_ret_addr3
    MOV     R2,#0x2    /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0x2 */
    
    LDR     R4,=M4_ICSR_REG
    LDR     R7,[R4]
    ORR     R7,R7,#(1<<31)      /* Set ICSR[NMIPENDSET] bit to initiate a NMI interrupt */
    
    STR     R7,[R4]             /* Generate an exception and wait... */
    
m4_scst_exception_test_nmihf_ISR_ret_addr3:
    B       m4_scst_exception_test_nmihf_ISR_ret_addr3

m4_scst_nmihf_return_address_3:
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_exception_test_nmihf_ISR4
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    ADR.W   R0,m4_scst_exception_test_nmihf_ISR_ret_addr4
    MOV     R2,#0x3    /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0x3 */
    
    CPSID   i       /* Set PRIMASK to escalate SVCall to Hard fault */
    SVC     0       /* Generate exception !!! */
    
m4_scst_exception_test_nmihf_ISR_ret_addr4:
    B       m4_scst_exception_test_nmihf_ISR_ret_addr4
    
m4_scst_test_nmihf_error:
    /* We need to change the return address that is stored in stack */
    ADR.W   R3,m4_scst_exception_test_nmihf_end
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_test_nmihf_end:
    BL      m4_scst_restore_registers_content
    MOV     R0,R5        /* Test result is returned in R0, according to the conventions */
    B       m4_scst_exception_test_tail_end
    
    
m4_scst_exception_test_nmihf_ISR1:

    MOV     R3,SP
    SUB     R4,R8,R3    /* Subtract R8(SP before exception) and current SP */
    CMP     R4,#0x24    /* 36(0x24) = 8 registers * 4bytes + 4bytes alignment  */
    BNE     m4_scst_test_nmihf_error
    
    /* We need to check that stack was realigned which signals bit[9] in stacked xPSR */
    LDR     R4,[SP,#28]
    TST     R4,#(1<<9)   /* Check bit[9] is set */
    BEQ     m4_scst_test_nmihf_error
    
    ADD.W   R5,R5,#0x55A
    
    /* We need to change the return address that is stored in stack:
    it points to the endless loop instruction */
    ADR.W   R3,m4_scst_nmihf_return_address_1
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_test_nmihf_ISR2:

    MOV     R3,SP
    SUB     R4,R8,R3    /* Subtract R8(SP before exception) and current SP */
    CMP     R4,#0x20    /* 32(0x20) = 8 registers * 4bytes + 0bytes alignment */
    BNE     m4_scst_test_nmihf_error
    
    /* We need to check that stack was not realigned which signals bit[9] in stacked xPSR */
    LDR     R4,[SP,#28]
    TST     R4,#(1<<9)   /* Check bit[9] is not set */
    BNE     m4_scst_test_nmihf_error
    
    ADD.W   R5,R5,#0x66B
    
    /* We need to change the return address that is stored in stack:
    it points to the endless loop instruction */
    ADR.W   R3,m4_scst_nmihf_return_address_2
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_test_nmihf_ISR3:
    
    LDR     R3,=M4_RESERVED_ADDR    /* Load R3 with address */
    LDR     R2,[R3]                 /* Precise Bus fault must be ignored !!! */
    
    /* We need to check the BFAR register was loaded by fault address */
    LDR     R3,=M4_BFAR_REG
    LDR     R4,[R3]
    LDR     R3,=M4_RESERVED_ADDR
    CMP     R4,R3
    BNE     m4_scst_test_nmihf_error
    
    /* We need to check the PRECISERR flag was set */
    LDR     R3,=M4_BFSR_REG
    LDRB    R4,[R3]     /* Use halfword access to BFSR */
    TST     R4,#(1<<1)  /* Check BFSR[PRECISERR] bit is set */
    BEQ     m4_scst_test_nmihf_error
    TST     R4,#(1<<7)  /* Check BFSR[BFARVALID] bit is set */
    BEQ     m4_scst_test_nmihf_error
    AND     R4,R4,#(0x82)   /* Ensure that only PRECISERR and BFARVALID flags are cleared */
    STRH    R4,[R3]         /* Clear BFSR[PRECISERR](rc_w1) and BFSR[BFARVALID] flags */
    
    ADD.W   R5,R5,#0x77C
    
    /* We need to change the return address that is stored in stack:
    it points to the endless loop instruction */
    ADR.W   R3,m4_scst_nmihf_return_address_3
    STR     R3,[SP,#24]
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
m4_scst_exception_test_nmihf_ISR4:
    
    LDR     R3,=M4_RESERVED_ADDR    /* Load R3 with address */
    LDR     R2,[R3]                 /* Precise Bus fault must be ignored !!! */
    
    /* We need to check the BFAR register was loaded by fault address */
    LDR     R3,=M4_BFAR_REG
    LDR     R4,[R3]
    LDR     R3,=M4_RESERVED_ADDR
    CMP     R4,R3
    BNE     m4_scst_test_nmihf_error
    
    /* We need to check the PRECISERR flag was set */
    LDR     R3,=M4_BFSR_REG
    LDRB    R4,[R3]     /* Use halfword access to BFSR */
    TST     R4,#(1<<1)  /* Check BFSR[PRECISERR] bit is set */
    BEQ     m4_scst_test_nmihf_error
    TST     R4,#(1<<7)  /* Check BFSR[BFARVALID] bit is set */
    BEQ     m4_scst_test_nmihf_error
    AND     R4,R4,#(0x82)   /* Ensure that only PRECISERR and BFARVALID flags are cleared */
    STRH    R4,[R3]         /* Clear BFSR[PRECISERR](rc_w1) and BFSR[BFARVALID] flags */
    
    /* We need to check that FORCED flag was set */
    LDR     R3,=M4_HFSR_REG
    LDR     R4,[R3]
    TST     R4,#(1<<30)     /* Check HFSR[FORCED] bit is set */
    BEQ     m4_scst_test_nmihf_error
    AND     R4,R4,#(1<<30)  /* Ensure that only FORCED bit is cleared */
    STR     R4,[R3]
    
    LDR     R4,[R3]     /* Load HFSR */
    TST     R4,#(1<<30) /* Check that HFSR[FORCED] flag was cleared */
    BNE     m4_scst_test_nmihf_error
    
    ADD.W   R5,R5,#0x88D
    
    /* We need to change the return address that is stored in stack:
    it points to the endless loop instruction */
    ADR.W   R3,m4_scst_exception_test_nmihf_end
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
    
