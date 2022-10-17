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
* Load/store instruction is used to propagate into the cm4_dpu_lsu module 
* two addresses to be added from:
* - read port A (de stage)
* - read port B (de stage)
* of the regbank module.
*
*
* Overall coverage:
* -----------------
*
* 
* 测试总结：
* -------------
* 加载/存储指令用于传播到 cm4_dpu_lsu 模块
* 要添加的两个地址：
* - 读取端口 A (de stage)
* - 读取端口 B（de stage）
* regbank 模块。
*
*
* 整体覆盖：
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"
    
    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_regbank_test5

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    SCST_EXTERN SCST_RAM_TARGET0
    SCST_EXTERN SCST_RAM_TARGET1
    SCST_EXTERN VAL1
    SCST_EXTERN VAL2

SCST_SET(SCST_RAM_OFFSET, 0x10) /* this macro has to be at the beginning of the line */


    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_regbank_test5" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_regbank_test5, function)
m4_scst_regbank_test5:

    PUSH.W  {R1-R12,R14}
    
    /* R5 is used as intermediate result */
    MOV     R5,#0x0
    
    LDR     R1,=SCST_RAM_TARGET0    /* Load SCST_RAM_TARGET0 address */
    LDR     R2,=SCST_RAM_OFFSET
    LDR     R0,=VAL1
    
    ISB
    STR     R0,[R1,R2]
    DSB
    LDR     R3,[R1,R2]
    
    CMP     R0,R3   /* Check that loaded value is same as stored value */
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x012E
    
    LDR     R0,=VAL2
    ISB
    STR     R0,[R1,R2]
    DSB
    LDR     R3,[R2,R1]
    
    CMP     R0,R3   /* Check that loaded value is same as stored value */
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0D2F
    
    
    LDR     R1,=SCST_RAM_TARGET1    /* Load SCST_RAM_TARGET1 address */
    LDR     R0,=VAL1
    
    ISB
    STR     R0,[R1,R2]
    DSB
    LDR     R3,[R1,R2]
    
    CMP     R0,R3   /* Check that loaded value is same as stored value */
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x03AE
    
    LDR     R0,=VAL2
    
    ISB
    STR     R0,[R1,R2]
    DSB
    LDR     R3,[R2,R1]
    
    CMP     R0,R3   /* Check that loaded value is same as stored value */
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x08BC
    
    MOV     R0,R5        /* Test result is returned in R0, according to the conventions */
    
    B       m4_scst_test_tail_end
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    