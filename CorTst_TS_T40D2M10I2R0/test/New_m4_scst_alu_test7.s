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
* Test ALU module - ALU MRS control
*
* Overall coverage:
* -----------------
* ALU control bus:
* - ALU operation type:
*   - MOV (MRS PriMask)
*   - MOV (MRS FaultMask)
*   - MOV (MRS BasePri)
*   - MOV (MRS control)
* 
* 测试总结：
* -------------
* 测试 ALU 模块 - ALU MRS 控制
*
* 整体覆盖：
* -----------------
* ALU 控制总线：
* - ALU 操作类型：
* - MOV（MRS PriMask）
* - MOV（MRS FaultMask）
* - MOV（MRS BasePri）
* - MOV（MRS 控制）
*
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"
 
    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_alu_test7

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_store_registers_content
    SCST_EXTERN m4_scst_set_scst_interrupt_vector_table
    SCST_EXTERN m4_scst_restore_registers_content
    SCST_EXTERN m4_scst_exception_test_tail_end
    SCST_EXTERN m4_scst_ISR_address
    
    
    SCST_SECTION_EXEC(m4_scst_test_code)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_alu_test7" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_alu_test7, function)
m4_scst_alu_test7:

    PUSH.W  {R1-R8,R14}
    
    /* R5 is used as intermediate result */
    MOV     R5,#0x0
    
    /* Store registers content */
    BL      m4_scst_store_registers_content
    
    /* Store address of the SCST-own ISR into the m4_scst_ISR_address pointer */
    ADR.W   R4,m4_scst_alu_mrs_svc_ISR
    ORR     R4,R4,#1        /* Set bit [0] as this address will be used within BX command and should indicate the Thumb code */
    LDR     R3,=m4_scst_ISR_address
    STR     R4,[R3]
    
    /* Save current content of PRIMASK in R1 and current content of FAULTMASK to R6 */
    /* ! Don't use R1, R6 for any other purpose until PRIMASK, FAULTMASK is restored. */
    MRS     R1,PRIMASK
    MRS     R6,FAULTMASK
    
    
    /* Before vector table is changed to the SCST-own one, clear R2.
    If any interrupt occurs after table is switched but before R2 is set to a pre-defined value.

    Also before table is switched, set R0 to the return address from the ISR. Content of R0 and R2
    will allow determining whether interrupt was triggered by SCST library or by alien SW.

    ! Don't use R0 for any other purpose until vector table is changed to a user one.
    ! Don't use R2 for any other purpose until vector table is changed to a user one. */
    
    MOV     R2,#0x0
    ADR.W   R0,m4_scst_alu_test7_end
    
    /* Set SCST interrupt vector table */
    BL      m4_scst_set_scst_interrupt_vector_table
    
    /***************************************************************************************************
    * ALU control bus
    * - MOV (MRS PriMask)
    *
    * Note: Linked with MRS instruction and PRIMASK parameter.
    *
    ***************************************************************************************************/
    MOV     R3,#0xFFFFFFFE /* Load inverted expected value */
    CPSID   i
    MRS     R3,PRIMASK
    TEQ     R3,#0x1
    BNE     m4_scst_alu_test7_end
    
    MOV     R3,#0xFFFFFFFF /* Load inverted expected value */
    CPSIE   i       /* Enable interrupts with configurable priority */
    ISB
    MRS     R3,PRIMASK
    TEQ     R3,#0x0
    BNE     m4_scst_alu_test7_end
    
    ADDW    R5,R5,#0x074D
    
    /***************************************************************************************************
    * ALU control bus
    * - MOV (MRS FaultMask)
    *
    * Note: Linked with MRS instruction and FAULTMASK parameter.
    *
    ***************************************************************************************************/
    MOV     R3,#0xFFFFFFFE /* Load inverted expected value */
    CPSID   f
    MRS     R3,FAULTMASK
    TEQ     R3,#0x1
    BNE     m4_scst_alu_test7_end
    
    MOV     R3,#0xFFFFFFFF /* Load inverted expected value */
    CPSIE   f       /* Enable interrupts with configurable priority */
    ISB
    MRS     R3,FAULTMASK
    TEQ     R3,#0x0
    BNE     m4_scst_alu_test7_end
    
    ADDW    R5,R5,#0x0B53
    
    
    /***************************************************************************************************
    * ALU control bus
    * - MOV (MRS BasePri)
    *
    * Note: Linked with MRS instruction and BASEPRI parameter.
    *
    ***************************************************************************************************/
    MRS     R3,BASEPRI  /* Store BASEPRI to R3 */
    
    UBFX    R4,R3,#0,#4 /* Extract Bits 0-3 */
    CMP     R4,#0x0     /* Check Bits 0-3 are read to zero */
    BNE     m4_scst_alu_test7_end
    
    /* We need to verify that non-implemented low-order Bits are read as zero and write is ignored */
    MVN     R4,R3       /* Invert BASEPRI and set Bits 0-3 which were read as zeros */
    UBFX    R4,R4,#0,#8 /* Extract Bits 0-7 */
    MSR     BASEPRI,R4  /* Write BASEPRI register - ignores writes of bits Bits 0-3 */
    
    MRS     R4,BASEPRI  /* Read BASEPRI */
    MVN     R4,R4       /* Invert BASEPRI and set Bits 0-3 which were read as zeros */
    UBFX    R4,R4,#0,#8 /* Extract eight bits */
    
    MSR     BASEPRI,R4  /* Write BASEPRI register - ignores writes of bits Bits 0-3 */
    MRS     R4,BASEPRI  /* Store current BASEPPRI value */
    
    /* Check BASEPRI was restored correctly */
    CMP     R4,R3
    BNE     m4_scst_alu_test7_end
    
    ADDW    R5,R5,#0x03EA
    
    
    /* We have to generate SVCall exception to can continue with test */
m4_scst_alu_test_svc_exception:
    MOV     R2,#0xB     /* R2 indicates that SCST library will explicitly initiate an exception with IRQ number 0xB */
    
    SVC     0           /* Generate exception and wait */
    
m4_scst_alu_msr_svc_loop_1:
    B       m4_scst_alu_msr_svc_loop_1
    
    
m4_scst_alu_test7_end:
    BL      m4_scst_restore_registers_content
    MOV     R0,R5        /* Test result is returned in R0, according to the conventions */
    B       m4_scst_exception_test_tail_end
    
m4_scst_alu_mrs_svc_ISR:
    /***************************************************************************************************
    * ALU control bus
    * - MOV (MRS control)
    *
    * Note: Linked with MRS instruction and CONTROL parameter.
    *
    ***************************************************************************************************/
    MOV     R4,#0x1
    MSR     CONTROL,R4  /* Write CONTROL register - switch to the unprivileged mode */
    
    LDR     R3,=0xFFFFFFFE /* Load inverted expected value */
    MRS     R3,CONTROL      /* Read CONTROL register */
    TEQ     R3,#0x1     /* Check unprivileged mode */
    BNE     m4_scst_alu_svc_isr_end
    
    /* We need to switch back to the privileged mode */
    MOV     R4,#0x0
    MSR     CONTROL,R4  /* Write CONTROL register - switch back to privileged mode */
    
    LDR     R3,=0xFFFFFFFF /* Load inverted expected value */
    MRS     R3,CONTROL  /* Read CONTROL register */
    TEQ     R3,#0x0     /* Verify CPU is in the privileged mode */
    BNE     m4_scst_alu_svc_isr_end
    
    ADDW    R5,R5,#0x0597
    
m4_scst_alu_svc_isr_end:
    /* This is an ISR for SVC exception which is synchronous.
    We need to change the return address that is stored in stack:
    it points to the endless loop instruction */
    ADR.W   R3,m4_scst_alu_test7_end
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
    