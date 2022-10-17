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
*   Tests forwarding logic functionality. 
*   - Verifies that results from one instruction can be used immediately 
*     as inputs in next instructions. Values are not taken from register file 
*     but they must be forwarded.
* 
* 测试总结：
* -------------
* 测试转发逻辑功能。
* - 验证可以立即使用一条指令的结果
* 作为下一个指令的输入。 值不是从寄存器文件中获取的
* 但它们必须被转发。
*
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_regbank_test4

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_store_registers_content
    SCST_EXTERN m4_scst_set_scst_interrupt_vector_table
    SCST_EXTERN m4_scst_restore_registers_content
    SCST_EXTERN m4_scst_exception_test_tail_end

    
    SCST_SECTION_EXEC(m4_scst_test_code)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_regbank_test4" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_regbank_test4, function)
m4_scst_regbank_test4:

    PUSH.W  {R1-R8,R14}
    
    /* Store registers content */
    BL      m4_scst_store_registers_content
    
    /* Save current content of PRIMASK in R1 and current content of FAULTMASK to R6 */
    /* ! Don't use R1, R6 for any other purpose until PRIMASK, FAULTMASK is restored. */
    MRS     R1,PRIMASK
    MRS     R6,FAULTMASK
    
    MOV     R2,#0x0     /* SCST does not expect any interrupt */
    
    /* Set SCST interrupt vector table */
    BL      m4_scst_set_scst_interrupt_vector_table
    
    /* R5 is used as intermediate result */
    MOV     R5,#0x0
    
    /************************************************
    UMULL sets REGBANK ports as follows:
        RdLo R4 = 0xAAAAAAAA(Input Port1)
        RdHi R3 = 0x55555555(Input Port2)
    Test forwarding logic for two following instructions:
        R4 UMULL(OutputPort1) -> R4 SUB (InputPort1)
        R3 UMULL(OutputPort2) -> R3 SUB (InputPort2)
    *************************************************/
    LDR     R7,=0x55555556
    MOV     R8,#0xFFFFFFFF
    MOV     R3,#0x11111111  /* Load R4 with default value */
    MOV     R4,#0x22222222  /* Load R3 with default value */
    
    ISB
    UMULL   R4,R3,R7,R8 /* Set R3, R4 register values */
    SUB     R7,R4,R3    /* R3, R4, register values are taken from forwarding logic */
    SUB     R8,R4,R3    /* R3, R4, register values are taken from forwarding logic */
    
    /* We need to check that R3, R4 values were taken from forwarding logic */
    CMP     R7,#0x55555555  /* Check R7 value where R3,R4 were taken from forwarding logic */
    BNE.W   m4_scst_regbank_test4_end
    CMP     R8,#0x55555555  /* Check R8 value where R3,R4 were taken from forwarding logic */
    BNE.W   m4_scst_regbank_test4_end
    
    ADD.W   R5,R5,#0x0C53
    
    /************************************************
    UMULL sets REGBANK ports as follows:
        RdLo R4 = 0x55555555(Input Port1)
        RdHi R3 = 0xAAAAAAAA(Input Port2)
    Test forwarding logic for two following instructions:
        R4 UMULL(OutputPort1) -> R4 SUB (InputPort1)
        R3 UMULL(OutputPort2) -> R3 SUB (InputPort2)
    *************************************************/
    LDR     R7,=0xAAAAAAAB
    MOV     R8,#0xFFFFFFFF
    MOV     R3,#0x11111111  /* Load R3 with default value */
    MOV     R4,#0x22222222  /* Load R4 with default value */
    
    ISB
    UMULL   R4,R3,R7,R8 /* Set R3, R4 register values */
    ADD     R7,R4,R3    /* R3, R4, register values are taken from forwarding logic */
    ADD     R8,R4,R3    /* R3, R4, register values are taken from forwarding logic */
    
    /* We need to check that R3, R4 values were taken from forwarding logic */
    CMP     R7,#0xFFFFFFFF  /* Check R7 value where R3,R4 were taken from forwarding logic */
    BNE.W   m4_scst_regbank_test4_end
    CMP     R8,#0xFFFFFFFF  /* Check R8 value where R3,R4 were taken from forwarding logic */
    BNE.W   m4_scst_regbank_test4_end
    
    ADD.W   R5,R5,#0x02A3
    
    /************************************************
    UMULL sets REGBANK ports as follows:
        RdLo R3 = 0x55555555(Input Port1)
        RdHi R4 = 0xAAAAAAAA(Input Port2)
    Test forwarding logic for two following instructions:
        R3 UMULL(OutputPort1) -> R3 SUB (InputPort2)
        R4 UMULL(OutputPort2) -> R4 SUB (InputPort1)
    *************************************************/
    LDR     R7,=0xAAAAAAAB
    MOV     R8,#0xFFFFFFFF
    MOV     R3,#0x11111111  /* Load R3 with default value */
    MOV     R4,#0x22222222  /* Load R4 with default value */
    
    ISB
    UMULL   R3,R4,R7,R8 /* Set R3, R4 register values */
    SUB     R7,R4,R3    /* R3, R4, register values are taken from forwarding logic */
    SUB     R8,R4,R3    /* R3, R4, register values are taken from forwarding logic */
    
    /* We need to check that R3, R4 values were taken from forwarding logic */
    CMP     R7,#0x55555555  /* Check R7 value where R3,R4 were taken from forwarding logic */
    BNE.W   m4_scst_regbank_test4_end
    CMP     R8,#0x55555555  /* Check R8 value where R3,R4 were taken from forwarding logic */
    BNE     m4_scst_regbank_test4_end
    
    ADD.W   R5,R5,#0x0DF3
    
    /************************************************
    UMULL sets REGBANK ports as follows:
        RdLo R3 = 0xAAAAAAAA(Input Port1)
        RdHi R4 = 0x55555555(Input Port2)
    Test forwarding logic for two following instructions:
        R3 UMULL(OutputPort1) -> R3 SUB (InputPort2)
        R4 UMULL(OutputPort2) -> R4 SUB (InputPort1)
    *************************************************/
    LDR     R7,=0x55555556
    MOV     R8,#0xFFFFFFFF
    MOV     R3,#0x11111111  /* Load R3 with default value */
    MOV     R4,#0x22222222  /* Load R4 with default value */
    
    ISB
    UMULL   R3,R4,R7,R8 /* Set R3, R4 register values */
    ADD     R7,R4,R3    /* R3, R4, register values are taken from forwarding logic */
    ADD     R8,R4,R3    /* R3, R4, register values are taken from forwarding logic */
    
    /* We need to check that R3, R4 values were taken from forwarding logic */
    CMP     R7,#0xFFFFFFFF  /* Check R7 value where R3,R4 were taken from forwarding logic */
    BNE     m4_scst_regbank_test4_end
    CMP     R8,#0xFFFFFFFF  /* Check R8 value where R3,R4 were taken from forwarding logic */
    BNE     m4_scst_regbank_test4_end
    
    ADD.W   R5,R5,#0x0E5D
    
    /************************************************
    UMULL sets REGBANK ports as follows:
        RdLo R4 = 0xAAAAAAAA(Input Port1)
        RdHi R3 = 0x55555555(Input Port2)
    Test forwarding logic for second following instruction only:
        R4 UMULL(OutputPort1) -> R4 SUB (InputPort1)
        R3 UMULL(OutputPort2) -> R3 SUB (InputPort2)
    *************************************************/
    LDR     R7,=0x55555556
    MOV     R8,#0xFFFFFFFF
    MOV     R0,#0x99999999  /* Set R0 value which will not be changed */
    MOV     R3,#0x11111111  /* Load R3 with default value */
    MOV     R4,#0x22222222  /* Load R4 with default value */
    
    ISB
    TEQ     R8,#0xFFFFFFFF  /* Set flag */
    ITE     EQ
    UMULLEQ R4,R3,R7,R8 /* Set R3, R4 register values */
    SUBNE   R0,R4,R3    /* This instruction is not processed */
    SUB     R8,R4,R3    /* R3, R4, register values are taken from forwarding logic */
    
    /* We need to check that R3, R4 values were taken from forwarding logic */
    CMP     R0,#0x99999999  /* Check R7 value where R3,R4 were taken from forwarding logic */
    BNE     m4_scst_regbank_test4_end
    CMP     R8,#0x55555555  /* Check R8 value where R3,R4 were taken from forwarding logic */
    BNE     m4_scst_regbank_test4_end
    
    ADD.W   R5,R5,#0x08A3
    
    /************************************************
    UMULL sets REGBANK ports as follows:
        RdLo R4 = 0x55555555(Input Port1)
        RdHi R3 = 0xAAAAAAAA(Input Port2)
    Test forwarding logic for second following instruction only:
        R4 UMULL(OutputPort1) -> R4 SUB (InputPort1)
        R3 UMULL(OutputPort2) -> R3 SUB (InputPort2)
    *************************************************/
    LDR     R7,=0xAAAAAAAB
    MOV     R8,#0xFFFFFFFF
    MOV     R3,#0x11111111  /* Load R3 with default value */
    MOV     R4,#0x22222222  /* Load R4 with default value */
    
    ISB
    TEQ     R8,#0xFFFFFFFF  /* Set flag */
    ITE     EQ
    UMULLEQ R4,R3,R7,R8 /* Set R3, R4 register values */
    ADDNE   R0,R4,R3    /* This instruction is not processed */
    ADD     R8,R4,R3    /* R3, R4, register values are taken from forwarding logic */
    
    /* We need to check that R3, R4 values were taken from forwarding logic */
    CMP     R0,#0x99999999  /* Check R7 value where R3,R4 were taken from forwarding logic */
    BNE     m4_scst_regbank_test4_end
    CMP     R8,#0xFFFFFFFF  /* Check R8 value where R3,R4 were taken from forwarding logic */
    BNE     m4_scst_regbank_test4_end
    
    ADD.W   R5,R5,#0x025D
    
    /************************************************
    UMULL sets REGBANK ports as follows:
        RdLo R3 = 0x55555555(Input Port1)
        RdHi R4 = 0xAAAAAAAA(Input Port2)
    Test forwarding logic for second following instruction only:
        R3 UMULL(OutputPort1) -> R3 SUB (InputPort2)
        R4 UMULL(OutputPort2) -> R4 SUB (InputPort1)
    *************************************************/
    LDR     R7,=0xAAAAAAAB
    MOV     R8,#0xFFFFFFFF
    MOV     R3,#0x11111111  /* Load R3 with default value */
    MOV     R4,#0x22222222  /* Load R4 with default value */
    
    ISB
    TEQ     R8,#0xFFFFFFFF  /* Set flag */
    ITE     EQ
    UMULLEQ R3,R4,R7,R8 /* Set R3, R4 register values */
    SUBNE   R0,R4,R3    /* This instruction is not processed */
    SUB     R8,R4,R3    /* R3, R4, register values are taken from forwarding logic */
    
    /* We need to check that R3, R4 values were taken from forwarding logic */
    CMP     R0,#0x99999999  /* Check R7 value where R3,R4 were taken from forwarding logic */
    BNE     m4_scst_regbank_test4_end
    CMP     R8,#0x55555555  /* Check R8 value where R3,R4 were taken from forwarding logic */
    BNE     m4_scst_regbank_test4_end
    
    ADD.W   R5,R5,#0x0FEE
    
    /************************************************
    UMULL sets REGBANK ports as follows:
        RdLo R3 = 0xAAAAAAAA(Input Port1)
        RdHi R4 = 0x55555555(Input Port2)
    Test forwarding logic for second following instruction only:
        R3 UMULL(OutputPort1) -> R3 SUB (InputPort2)
        R4 UMULL(OutputPort2) -> R4 SUB (InputPort1)
    *************************************************/
    LDR     R7,=0x55555556
    MOV     R8,#0xFFFFFFFF
    MOV     R3,#0x11111111  /* Load R3 with default value */
    MOV     R4,#0x22222222  /* Load R4 with default value */
    
    ISB
    TEQ     R8,#0xFFFFFFFF  /* Set flag */
    ITE     EQ
    UMULLEQ R3,R4,R7,R8 /* Set R3, R4 register values */
    ADDNE   R0,R4,R3    /* This instruction is not processed */
    ADD     R8,R4,R3    /* R3, R4, register values are taken from forwarding logic */
    
    /* We need to check that R3, R4 values were taken from forwarding logic */
    CMP     R0,#0x99999999  /* Check R7 value where R3,R4 were taken from forwarding logic */
    BNE     m4_scst_regbank_test4_end
    CMP     R8,#0xFFFFFFFF  /* Check R8 value where R3,R4 were taken from forwarding logic */
    BNE     m4_scst_regbank_test4_end
    
    ADD.W   R5,R5,#0x01A7
    
m4_scst_regbank_test4_end:
    BL      m4_scst_restore_registers_content
    MOV     R0,R5        /* Test result is returned in R0, according to the conventions */
    B       m4_scst_exception_test_tail_end
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
                   
    SCST_FILE_END
    