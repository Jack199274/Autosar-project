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
* Tests conditional triggering/not-triggering of SVC interrupts.
* Tests N,Z,C,V,Q, GE and IT flags restoring
*
* 测试总结：
* -------------
*
* 测试 SVC 中断的条件触发/不触发。
* 测试 N、Z、C、V、Q、GE 和 IT 标志恢复
*

******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_status_test3
    
    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_store_registers_content
    SCST_EXTERN m4_scst_set_scst_interrupt_vector_table
    SCST_EXTERN m4_scst_restore_registers_content
    SCST_EXTERN m4_scst_exception_test_tail_end
    SCST_EXTERN m4_scst_ISR_address
    SCST_EXTERN m4_scst_test_was_interrupted
    
    
    SCST_SECTION_EXEC(m4_scst_test_code)
    SCST_THUMB2
    
    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_status_test3" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_status_test3, function)
m4_scst_status_test3:

    PUSH.W  {R1-R8,R14}
    
    /* R5 is used as a flag indicating correct invocation of the SCST-own ISR. */
    MOV     R5,#0x0
    
    /* Store register content */
    BL      m4_scst_store_registers_content
    
    /* Save current content of PRIMASK in R1 and current content of FAULTMASK to R6 */
    /* ! Don't use R1, R6 for any other purpose until PRIMASK, FAULTMASK is restored. */
    MRS     R1,PRIMASK
    MRS     R6,FAULTMASK

    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_status_test3_ISR1_error
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
    ADR.W   R0,m4_scst_status_test3_ISR_ret_err
    SUB     R0,R0,#0x8 /* Move address of label back inside the IT block */
    
    /* Set SCST interrupt vector table */
    BL      m4_scst_set_scst_interrupt_vector_table
    
    /* We need to check SVC exception is not active or pending */
    LDR     R3,=M4_SHCSR_REG    
    LDR     R4,[R3]             
    TST     R4,#(1<<7)          /* Check SHCSR[SVCALLACT] bit is not set */
    BNE     m4_scst_status_test3_pending_active
    TST     R4,#(1<<15)         /* Check SHCSR[SVCALLPENDED] bit is not set */
    BNE     m4_scst_status_test3_pending_active
    
    LDR     R3,=M4_SHPR2_REG
    MOV     R4,#0x0
    STRB    R4,[R3,#3]          /* Clear SHPR2[PRI_11] to enable possibly masked SVCcall exception */
    
    CPSIE   i       /* Enable interrupts with configurable priority */
    CPSIE   f       /* Enable all exceptions */
    
    MOV     R2,#0xB     /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0xB */
    
    /* We are ready for interrupt but following interrupt can not be triggered !! */
    MOVS    R3,#0xFFFFFFFF  /* Set N flag */
    ITTE    PL
    SVCPL   0               /* No -> Interrupt is not triggered !!! */
    /* Here is address of the m4_scst_status_test3_ISR_ret_err: label */
    ADDWPL  R5,R5,#0x444    /* No */
    ADDWMI  R5,R5,#0x9AD    /* Yes */
m4_scst_status_test3_ISR_ret_err: /* Move label outside IT block to avoid problems with some compilers */
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_status_test3_ISR1
    ORR     R4,R4,#1    /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    ADR.W   R0,m4_scst_status_test3_ISR_ret_addr
    SUB     R0,R0,#0xC /* Move address of label back inside the IT block */
    
    /* Check that N,Z,C,V,Q and IT and GE flags are restored correctly  */
    LDR     R3,=0xF8000000
    /* Set GE flags */
    LDR     R4,=0x000F0000    
    
    MSR     APSR_nzcvq,R3     /* Set N,Z,C,V,Q flags */
        
    /* opcode for MSR APSR_g, R4 */
    SCST_OPCODE_START
    SCST_OPCODE32_HIGH(0xF384)
    SCST_OPCODE32_LOW(0x8400)
    SCST_OPCODE_END
    ISB
    ITETE   EQ
    SVCEQ   0               /* Yes -> Trigger exception !! */
    /* Here is address of the m4_scst_status_test3_ISR_ret_addr: label */
    /* We need to check that IT flags were restored correctly */
    MOVWNE  R5,#0x444       /* No -> Destroy result !! */
    ADDWEQ  R5,R5,#0x9AD    /* Yes */
    MOVWNE  R5,#0x444       /* No -> Destory result !! */
m4_scst_status_test3_ISR_ret_addr:
    
    /* We need to check that N,Z,C,V flags were restored correctly */
    BPL     m4_scst_status_test3_end   /* Check N flag is set !! */
    BNE     m4_scst_status_test3_end   /* Check Z flag is set !! */
    BCC     m4_scst_status_test3_end   /* Check C flag is set !! */
    BVC     m4_scst_status_test3_end   /* Check V flag is set !! */
    
    ADDW    R5,R5,#0x9AD
    
    /* We need to check that Q flag was restored correctly */
    MRS     R4,APSR
    TST     R4,#(1<<27)
    BEQ     m4_scst_status_test3_end
    
    ADDW    R5,R5,#0x9AD
    
    /* Check that GE flags were restored correctly */
    MRS     R3,APSR     /* Load flags */
    LSL     R3,R3,#12
    LSR     R3,R3,#28
    CMP     R3,#0xF
    BNE     m4_scst_status_test3_end
    
    ADDW    R5,R5,#0x9AD
    
    /* Clear flags */
    LDR     R4,=0x00000000
    MSR     APSR_nzcvq,R4     /* Set N,Z,C,V,Q flags */
    
    /* opcode for MSR APSR_g, R4 */
    SCST_OPCODE_START
    SCST_OPCODE32_HIGH(0xF384)
    SCST_OPCODE32_LOW(0x8400)
    SCST_OPCODE_END
    ISB
m4_scst_status_test3_end:
    BL      m4_scst_restore_registers_content
    MOV     R0,R5        /* Test result is returned in R0, according to the conventions */
    B       m4_scst_exception_test_tail_end
    
m4_scst_status_test3_pending_active:
    LDR     R3,=m4_scst_test_was_interrupted
    STR     R3,[R3]
    B       m4_scst_status_test3_end

m4_scst_status_test3_ISR1_error:
    MOVW    R5,#0x444                       /* Error SVC exception -> destroy result */
    B       m4_scst_status_test3_flag_err   /* Error SVC exception -> exit test */
m4_scst_status_test3_ISR1:

    ADDW    R5,R5,#0x9AD
    
    /* Rewrite stacked R2 value to indicate that SCST does not expect further interrupt */
    MOV     R2,#0
    STR     R2,[SP,#8]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    /* We need to clear all flags */
    MOV     R3,#0x0
    MSR     APSR_nzcvq,R3     /* Set N,Z,C,V,Q flags */
    ISB
    /* Check Q flag was cleared */
    MRS    R4,APSR
    TST    R4,#(1<<27)
    BNE    m4_scst_status_test3_flag_err
    
     /* Clear GE flags */
    LDR     R4,=0x00000000    
    
    /* opcode for MSR APSR_g, R4 */
    SCST_OPCODE_START
    SCST_OPCODE32_HIGH(0xF384)
    SCST_OPCODE32_LOW(0x8400)
    SCST_OPCODE_END
    
    /* We need to check that GE flags were cleared correctly */
    MRS     R3,APSR     /* Load flags */
    LSL     R3,R3,#12
    LSR     R3,R3,#28
    CMP     R3,#0x0
    BNE     m4_scst_status_test3_flag_err
    
    /* Clear again TST sets Z flag */
    MSR     APSR_nzcvq,R3     /* Set N,Z,C,V,Q flags */
    ISB
    /* We need to check that flags were cleared correctly */
    BMI     m4_scst_status_test3_flag_err   /* Check N flag is set !! */
    BEQ     m4_scst_status_test3_flag_err   /* Check Z flag is set !! */
    BCS     m4_scst_status_test3_flag_err   /* Check C flag is set !! */
    BVS     m4_scst_status_test3_flag_err   /* Check V flag is set !! */
    
    BX      LR
    
m4_scst_status_test3_flag_err:
    /* In case of flag clear error we rewrite ISR retutn address */
    ADR.W   R3,m4_scst_status_test3_end
    STR     R3,[SP,#24]
    DSB     /* Ensures that stacked value is updated before exception return */
    
    BX      LR
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
                   
    SCST_FILE_END
