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
* Test ALU module - Logical bit-wise operation and their encoding
*
* Overall coverage:
* -----------------
* ALU control bus:
* - ALU operation type:
*   - Bitwise AND
*   - Bitwise OR
*   - BitWise EOR
*
* DECODER:
* Thumb (32-bit)
*   - Encoding of "Data processing (shifted register)" instructions
*   - Encoding of "Data processing (modified immediate)" instructions
* 测试总结：
* -------------
* 测试 ALU 模块 - 逻辑按位运算及其编码
*
* 整体覆盖：
* -----------------
* ALU 控制总线：
* - ALU 操作类型：
* - 按位与
* - 按位或
* - 按位 EOR
*
* 解码器：
* 拇指（32 位）
* - “数据处理（移位寄存器）”指令的编码
* - “数据处理（修改立即数）”指令的编码
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    
    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_alu_test3

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    
    
    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_alu_test3" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_alu_test3, function)
m4_scst_alu_test3:

    PUSH.W  {R1-R12,R14}
    
    /* R9 is used as intermediate result */
    MOV     R9,#0x0
    
    /***************************************************************************************************
    * ALU operation type:
    *   - 00001 - Bitwise AND
    *
    * Note: Bitwise AND is linked with AND, BIC, TST instructions
    *       BIC - inverts ALU input2
    *       TST - tested separately together with flags
    *              
    ***************************************************************************************************/
    /**************************************************************************************************
    * AND (immediate) Encoding T1 32bit
    ***************************************************************************************************/
    LDR     R5,=0xFFFFFFFF
    AND     R10,R5,#0x55555555   /* Use immediate value */
    CMP     R10,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0xFFFFFFFF
    AND     R5,R10,#0xAAAAAAAA   /* Use immediate value */
    CMP     R5,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xFFFFFFFF
    AND     R12,R3,#0x33003300   /* Use immediate value */
    CMP     R12,#0x33003300
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0xFFFFFFFF
    AND     R3,R12,#0x00CC00CC   /* Use immediate value */
    CMP     R3,#0x00CC00CC
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0xFFFFFFFF
    AND     R7,R8,#0x000001FE   /* Use immediate value */
    CMP     R7,#0x000001FE
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0xFFFFFFFF
    AND     R8,R7,#0x00000007   /* Use immediate value */
    CMP     R8,#0x00000007
    BNE     m4_scst_test_tail_end
    
    B m4_scst_alu_test3_ltorg_jump_1 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_alu_test3_ltorg_jump_1:
    
    /**************************************************************************************************
    * AND (register) Encoding T2 32bit
    ***************************************************************************************************/
    LDR     R5,=0x55555555
    LDR     R10,=0xFFFFFC00    /* Will be shifted to 0xFFFFFFFF */
    AND.W   R3,R5,R10,ASR #10
    CMP     R3,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0xAAAAAAAA
    LDR     R5,=0xFFE00000     /* Will be shifted to 0xFFFFFFFF */
    AND.W   R12,R10,R5,ASR #21
    CMP     R12,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xFFFFFFFF
    LDR     R12,=0x55555555
    AND.W   R5,R3,R12
    CMP     R5,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0xFFFFFFFF
    LDR     R3,=0xAAAAAAAA
    AND.W   R10,R12,R3
    CMP     R10,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0xFFFFFFFF
    LDR     R8,=0x33333333     /* Will be shifted to 0xCCCCCCCC */
    AND.W   R7,R7,R8,LSL #2
    CMP     R7,#0xCCCCCCCC
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0xFFFFFFFF
    LDR     R7,=0xCCCCCCCC     /* Will be shifted to 0x33333333 */
    AND.W   R8,R8,R7,LSR #2
    CMP     R8,#0x33333333
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0FED
    
    /**************************************************************************************************
    * BIC (immediate) Encoding T1 32bit
    ***************************************************************************************************/
    LDR     R5,=0xFFFFFFFF
    BIC     R10,R5,#0xAAAAAAAA   /* Use immediate value */
    CMP     R10,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0xFFFFFFFF
    BIC     R5,R10,#0x55555555   /* Use immediate value */
    CMP     R5,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xFFFFFFFF
    BIC     R12,R3,#0x33333333   /* Use immediate value */
    CMP     R12,#0xCCCCCCCC
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0xFFFFFFFF
    BIC     R3,R12,#0xCCCCCCCC   /* Use immediate value */
    CMP     R3,#0x33333333
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0xFFFFFFFF
    BIC     R8,R7,#0x77777777   /* Use immediate value */
    CMP     R8,#0x88888888
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0xFFFFFFFF
    BIC     R7,R8,#0x88888888   /* Use immediate value */
    CMP     R7,#0x77777777
    BNE     m4_scst_test_tail_end
    
    /**************************************************************************************************
    * BIC (register) Encoding T2 32bit
    ***************************************************************************************************/
    LDR     R5,=0x55555555
    LDR     R10,=0xFFFFF800    /* Will be shifted to 0x00000000 */
    BIC.W   R3,R5,R10,LSL #21   
    CMP     R3,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0xAAAAAAAA
    LDR     R5,=0xFFC00000     /* Will be shifted to 0x00000000 */
    BIC.W   R12,R10,R5,LSL #10
    CMP     R12,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xFFFFFFFF
    LDR     R12,=0xAAAAAAAA
    BIC.W   R5,R3,R12
    CMP     R5,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0xFFFFFFFF
    LDR     R3,=0x55555555
    BIC.W   R10,R12,R3
    CMP     R10,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0x66666666
    LDR     R8,=0x0FFFFFFF    /* Will be shifted to 0x00000000 */
    BIC.W    R8,R7,R8,LSR #28
    CMP     R8,#0x66666666
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0x99999999
    LDR     R7,=0x0000007F     /* Will be shifted to 0x00000000 */
    BIC.W   R7,R8,R7,LSR #7
    CMP     R7,#0x99999999
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x079E
    
    
    /***************************************************************************************************
    * ALU operation type:
    *   - 00010 - Bitwise ORR
    *
    * Note: Bitwise ORR is linked with ORR, ORN instructions
    *       ORN - inverts ALU input2
    *
    ***************************************************************************************************/
    /**************************************************************************************************
    * ORR (immediate) Encoding T1 32bit
    ***************************************************************************************************/
    MOV     R5,#0x0
    ORR     R10,R5,#0xAAAAAAAA   /* Use immediate value */
    CMP     R10,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    MOV     R10,#0x0
    ORR     R5,R10,#0x55555555   /* Use immediate value */
    CMP     R5,#0x55555555
    BNE     m4_scst_test_tail_end
    
    MOV     R3,#0x0
    ORR     R12,R3,#0x66006600   /* Use immediate value */
    CMP     R12,#0x66006600
    BNE     m4_scst_test_tail_end
    
    MOV     R12,#0x0
    ORR     R3,R12,#0x00990099   /* Use immediate value */
    CMP     R3,#0x00990099
    BNE     m4_scst_test_tail_end
    
    MOV     R7,#0x0
    ORR     R8,R7,#0x00000330   /* Use immediate value */
    CMP     R8,#0x00000330
    BNE     m4_scst_test_tail_end
    
    MOV     R8,#0x0
    ORR     R7,R8,#0x3FC00000   /* Use immediate value */
    CMP     R7,#0x3FC00000
    BNE     m4_scst_test_tail_end
    
    /**************************************************************************************************
    * ORR (register) Encoding T2 32bit
    ***************************************************************************************************/
    LDR     R5,=0xAAAAAAAA
    LDR     R10,=0x0000003F /* Will be shifted to 0x00000000 */
    ORR.W   R3,R5,R10,LSR #6
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0x55555555
    LDR     R5,=0xFFFFFF80 /* Will be shifted to 0x00000000 */
    ORR.W   R12,R10,R5,LSL #25
    CMP     R12,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0x0
    LDR     R12,=0x55555555    /* Will be rotated to 0xAAAAAAAA */
    ORR.W   R5,R3,R12,ROR #1
    CMP     R5,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0x0
    LDR     R3,=0x55555555
    ORR.W   R10,R12,R3
    CMP     R10,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0x0
    LDR     R8,=0x33333333     /* Will be shifted to 0xCCCCCCCC */
    ORR.W   R7,R7,R8,LSL #2
    CMP     R7,#0xCCCCCCCC
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0xEEEEEEEE
    LDR     R7,=0x0
    ORR.W   R8,R8,R7
    CMP     R8,#0xEEEEEEEE
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0BEF
    
    /**************************************************************************************************
    * ORN (immediate) Encoding T1 32bit
    ***************************************************************************************************/
    MOV     R5,#0x0
    ORN     R10,R5,#0x55555555   /* Use immediate value */
    CMP     R10,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    MOV     R10,#0x0
    ORN     R5,R10,#0xAAAAAAAA   /* Use immediate value */
    CMP     R5,#0x55555555
    BNE     m4_scst_test_tail_end
    
    MOV     R3,#0x0
    ORN     R12,R3,#0x66666666   /* Use immediate value */
    CMP     R12,#0x99999999
    BNE     m4_scst_test_tail_end
    
    MOV     R12,#0x0
    ORN     R3,R12,#0x99999999   /* Use immediate value */
    CMP     R3,#0x66666666
    BNE     m4_scst_test_tail_end
    
    MOV     R7,#0x0
    ORN     R8,R7,#0x11111111   /* Use immediate value */
    CMP     R8,#0xEEEEEEEE
    BNE     m4_scst_test_tail_end
    
    MOV     R8,#0x0
    ORN     R7,R8,#0xEEEEEEEE   /* Use immediate value */
    CMP     R7,#0x11111111
    BNE     m4_scst_test_tail_end
    
    
    /**************************************************************************************************
    * ORN (register) Encoding T2 32bit
    ***************************************************************************************************/
    LDR     R5,=0xAAAAAAAA
    LDR     R10,=0xFFFF0000     /* Will be shifted t0 0xFFFFFFFF */
    ORN.W   R3,R5,R10,ASR #16
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0x55555555
    LDR     R5,=0xFFFFFFFF
    ORN.W   R12,R10,R5
    CMP     R12,#0x55555555
    BNE     m4_scst_test_tail_end
    
    MOV     R3,#0x0
    LDR     R12,=0x55555555
    ORN.W   R5,R3,R12
    CMP     R5,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    MOV     R12,#0x0
    LDR     R3,=0xAAAAAAAA
    ORN.W   R10,R12,R3
    CMP     R10,#0x55555555
    BNE     m4_scst_test_tail_end
    
    MOV     R7,#0x0
    LDR     R8,=0xEEEEEEEE     /* Will be shifted to 0x77777777 */
    ORN.W   R8,R7,R8,LSR #1
    CMP     R8,#0x88888888
    BNE     m4_scst_test_tail_end
    
    MOV     R8,#0x0
    LDR     R7,=0x66666666
    ORN.W   R7,R8,R7,LSL #1     /* Will be shifted to 0xCCCCCCCC */
    CMP     R7,#0x33333333
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0CEA
    
    
    /***************************************************************************************************
    * ALU operation type:
    *   - 00010 - Bitwise EOR
    * 
    * Note: Bitwise EOR is linked with EOR, TEQ instructions
    *       TEQ - tested separately together with flags
    *
    ***************************************************************************************************/
    /**************************************************************************************************
    * EOR (immediate) Encoding T1 32bit
    ***************************************************************************************************/
    LDR     R5,=0xFFFFFFFF
    EOR     R10,R5,#0x55555555   /* Use immediate value */
    CMP     R10,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0xFFFFFFFF
    EOR     R5,R10,#0xAAAAAAAA   /* Use immediate value */
    CMP     R5,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xFF00FF00
    EOR     R12,R3,#0xEE00EE00   /* Use immediate value */
    CMP     R12,#0x11001100
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0x00FF00FF
    EOR     R3,R12,#0x00110011   /* Use immediate value */
    CMP     R3,#0x00EE00EE
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0x00000FF0
    EOR     R8,R7,#0x00000770   /* Use immediate value */
    CMP     R8,#0x00000880
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0x0FF00000
    EOR     R7,R8,#0x07700000   /* Use immediate value */
    CMP     R7,#0x08800000
    BNE     m4_scst_test_tail_end
    
    /**************************************************************************************************
    * EOR (register) Encoding T2
    ***************************************************************************************************/
    LDR     R5,=0x55555555
    LDR     R10,=0x80000000    /* Will be shifted to 0xFFFFFFFF */
    EOR.W   R3,R5,R10,ASR #31
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0xAAAAAAAA
    LDR     R5,=0xFFFFFFFF
    EOR.W   R12,R10,R5
    CMP     R12,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xFFFFFFFF
    LDR     R12,=0x55555555
    EOR.W   R5,R3,R12
    CMP     R5,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0xFFFFFFFF
    LDR     R3,=0xAAAAAAAA
    EOR.W   R10,R12,R3
    CMP     R10,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0xFFFFFFFF
    LDR     R8,=0xFF99FF99
    EOR.W   R7,R7,R8
    CMP     R7,#0x00660066
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0xFFFFFFFF
    LDR     R7,=0xEEFFEEFF
    EOR.W   R8,R8,R7
    CMP     R8,#0x11001100
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0EED
    
    
    MOV     R0,R9          /* Test result is returned in R0, according to the conventions */
    
    B       m4_scst_test_tail_end
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    