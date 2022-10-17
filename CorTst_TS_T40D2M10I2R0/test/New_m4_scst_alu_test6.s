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
* Test ALU module.
*
* Overall coverage:
* -----------------
* ALU control bus:
* - ALU operation type:
*   - DIV
*   - CLZ
* 
* 测试总结：
* -------------
* 测试 ALU 模块。
*
* 整体覆盖：
* -----------------
* ALU 控制总线：
* - ALU 操作类型：
* - DIV
* - CLZ
*
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"
   
    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_alu_test6

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    SCST_EXTERN m4_scst_clear_flags
    SCST_EXTERN m4_scst_check_flags_cleared
    SCST_EXTERN m4_scst_check_q_flag
    

    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_alu_test6" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_alu_test6, function) 
m4_scst_alu_test6:

    PUSH.W  {R1-R12,R14}
    
    /* R5 is used as intermediate result */
    MOV     R5,#0x0
    
    /***************************************************************************************************
    * ALU operation type:
    *   - 11000 - DIV
    * 
    * Note: Linked with SDIV, UDIV instructions.
    *
    ***************************************************************************************************/
    /* SDIV */
    LDR     R1,=0xAAAAAAAA
    MOV     R2,#0x1
    SDIV    R3,R1,R2
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x55555555
    SDIV    R3,R1,R2
    CMP     R3,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0xAAAAAAAA
    LDR     R2,=0xAAAAAAAA
    SDIV    R3,R1,R2
    CMP     R3,#0x1
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x55555555
    LDR     R2,=0x55555555
    SDIV    R3,R1,R2
    CMP     R3,#0x1
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0xBE37EE62
    LDR     R2,=0xDF1939B6
    SDIV    R3,R1,R2
    CMP     R3,#0x1
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0xF4E587E7
    LDR     R2,=0x5F051AF2
    SDIV    R3,R1,R2
    CMP     R3,#0x0
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x1DBF35F4
    LDR     R2,=0xC08DAC8E
    SDIV    R3,R1,R2
    CMP     R3,#0x0
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0xCB45830D
    LDR     R2,=0xF15C8298
    SDIV    R3,R1,R2
    CMP     R3,#0x3
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x910EFC27
    LDR     R2,=0xEDA8C7EB
    SDIV    R3,R1,R2
    CMP     R3,#0x6
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x6803E9AB
    LDR     R2,=0x97E1E89C
    SDIV    R3,R1,R2
    CMP     R3,#0x0
    BNE     m4_scst_test_tail_end
    
    ADDW    R5,R5,#0x0E5F
    
    /* UDIV */
    LDR     R1,=0xAAAAAAAA
    MOV     R2,#0x1
    UDIV    R3,R1,R2
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x55555555
    UDIV    R3,R1,R2
    CMP     R3,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0xAAAAAAAA
    LDR     R2,=0xAAAAAAAA
    UDIV    R3,R1,R2
    CMP     R3,#0x1
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x55555555
    LDR     R2,=0x55555555
    UDIV    R3,R1,R2
    CMP     R3,#0x1
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0xBE37EE62
    LDR     R2,=0xDF1939B6
    UDIV    R3,R1,R2
    CMP     R3,#0x0
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0xF4E587E7
    LDR     R2,=0x5F051AF2
    UDIV    R3,R1,R2
    CMP     R3,#0x2
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x1DBF35F4
    LDR     R2,=0xC08DAC8E
    UDIV    R3,R1,R2
    CMP     R3,#0x0
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0xCB45830D
    LDR     R2,=0xF15C8298
    UDIV    R3,R1,R2
    CMP     R3,#0x0
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x910EFC27
    LDR     R2,=0xEDA8C7EB
    UDIV    R3,R1,R2
    CMP     R3,#0x0
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x6803E9AB
    LDR     R2,=0x97E1E89C
    UDIV    R3,R1,R2
    CMP     R3,#0x0
    BNE     m4_scst_test_tail_end
    
    ADDW    R5,R5,#0x0AAF
    
    
    /***************************************************************************************************
    * ALU operation type:
    * - 11111 - CLZ
    *
    * Note: Linked with CLZ
    *
    ***************************************************************************************************/
    MOV     R4,#0x80000000
    CLZ     R3,R4
    CMP     R3,#0x0
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x40000000
    CLZ     R3,R4
    CMP     R3,#0x1
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x20000000
    CLZ     R3,R4
    CMP     R3,#0x2
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x10000000
    CLZ     R3,R4
    CMP     R3,#0x3
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x8000000
    CLZ     R3,R4
    CMP     R3,#0x4
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x4000000
    CLZ     R3,R4
    CMP     R3,#0x5
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x2000000
    CLZ     R3,R4
    CMP     R3,#0x6
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x1000000
    CLZ     R3,R4
    CMP     R3,#0x7
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x800000
    CLZ     R3,R4
    CMP     R3,#0x8
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x400000
    CLZ     R3,R4
    CMP     R3,#0x9
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x200000
    CLZ     R3,R4
    CMP     R3,#0xA
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x100000
    CLZ     R3,R4
    CMP     R3,#0xB
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x80000
    CLZ     R3,R4
    CMP     R3,#0xC
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x40000
    CLZ     R3,R4
    CMP     R3,#0xD
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x20000
    CLZ     R3,R4
    CMP     R3,#0xE
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x10000
    CLZ     R3,R4
    CMP     R3,#0xF
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x8000
    CLZ     R3,R4
    CMP     R3,#0x10
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x4000
    CLZ     R3,R4
    CMP     R3,#0x11
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x2000
    CLZ     R3,R4
    CMP     R3,#0x12
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x1000
    CLZ     R3,R4
    CMP     R3,#0x13
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x800
    CLZ     R3,R4
    CMP     R3,#0x14
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x400
    CLZ     R3,R4
    CMP     R3,#0x15
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x200
    CLZ     R3,R4
    CMP     R3,#0x16
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x100
    CLZ     R3,R4
    CMP     R3,#0x17
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x80
    CLZ     R3,R4
    CMP     R3,#0x18
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x40
    CLZ     R3,R4
    CMP     R3,#0x19
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x20
    CLZ     R3,R4
    CMP     R3,#0x1A
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x10
    CLZ     R3,R4
    CMP     R3,#0x1B
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x8
    CLZ     R3,R4
    CMP     R3,#0x1C
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x4
    CLZ     R3,R4
    CMP     R3,#0x1D
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x2
    CLZ     R3,R4
    CMP     R3,#0x1E
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x1
    CLZ     R3,R4
    CMP     R3,#0x1F
    BNE     m4_scst_test_tail_end
    
    MOV     R4,#0x0
    CLZ     R3,R4
    CMP     R3,#0x20
    BNE     m4_scst_test_tail_end
    
    ADDW    R5,R5,#0x714
    
    
    MOV     R0,R5          /* Test result is returned in R0, according to the conventions */
    
    B       m4_scst_test_tail_end
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    