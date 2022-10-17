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
* Tests double and SIMD saturation commands with all possible saturation conditions 
* (size, saturation takes place / no saturation) as well as their decoding.
* Where applicable, condition flag (Q) is set and checked explicitly.
*
* Overall coverage:
* -----------------
* SIMDSAT:
* - Logic which doubles, and if required, saturates the input operand
*                - QDADD, QDSUB
* - QADD, QADD16, QADD8, QDADD, QSUB, QSUB16, QSUB8, QDSUB, 
*                  QASX, QSAX
*                - UQADD16, UQASX, UQSAX, UQSUB16, UQADD8, UQSUB8
* DECODER:
* Thumb (32-bit)
*   - Encoding of "Data processing (register)" instructions
* 测试总结：
* -------------
* 在所有可能的饱和条件下测试 double 和 SIMD 饱和命令
*（大小，发生饱和/不饱和）以及它们的解码。
* 在适用的情况下，明确设置和检查条件标志 (Q)。
*
* 整体覆盖：
* -----------------
* SIMDSAT：
* - 加倍的逻辑，如果需要，使输入操作数饱和
* - QDADD, QDSUB
* - QADD, QADD16, QADD8, QDADD, QSUB, QSUB16, QSUB8, QDSUB,
* QASX, QSAX
* - UQADD16、UQASX、UQSAX、UQSUB16、UQADD8、UQSUB8
* 解码器：
* 拇指（32 位）
* - “数据处理（寄存器）”指令的编码
******************************************************************************/

#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_simdsat_test1
    
    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    SCST_EXTERN m4_scst_clear_flags
    SCST_EXTERN m4_scst_check_q_flag

    /* Local defines */    
SCST_SET(PRESIGNATURE,0x1C463D44) /* this macro has to be at the beginning of the line */


    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_simdsat_test1" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_simdsat_test1, function)
m4_scst_simdsat_test1:

    PUSH.W  {R1-R12,R14}
    
    LDR     R8,=PRESIGNATURE
        
    /*--------------------------------------------------------------------*/
    /* QDADD - without saturation                                         */
    /*--------------------------------------------------------------------*/
    BL      m4_scst_clear_flags    
    LDR     R5,=0x00000001
    LDR     R10,=0x2AAAAAAA    
    QDADD   R3,R5,R10
    LDR     R4,=0x55555555
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0x00000000
    LDR     R5,=0xD5555555    
    QDADD   R12,R10,R5
    LDR     R4,=0xAAAAAAAA
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0x55555555
    LDR     R12,=0x00000000    
    QDADD   R5,R3,R12
    LDR     R4,=0x55555555
    CMP     R5,R4
    BNE     m4_scst_test_tail_end
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
       
    LDR     R12,=0xAAAAAAAA
    LDR     R3,=0x00000000    
    QDADD   R10,R12,R3
    LDR     R4,=0xAAAAAAAA
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0xFFFFFFFF
    LDR     R2,=0xFFFFFFFF    
    QDADD   R3,R1,R2
    LDR     R4,=0xFFFFFFFD
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    LDR     R2,=0x00000001
    LDR     R1,=0x3FFFFFFF    
    QDADD   R3,R2,R1
    LDR     R4,=0x7FFFFFFF
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    ADDW    R8,R8,#0x123
    
    /*--------------------------------------------------------------------*/
    /* QDADD - with saturation                                            */
    /*--------------------------------------------------------------------*/
    BL      m4_scst_clear_flags
    LDR     R1,=0x00000000
    LDR     R2,=0x40000000    
    QDADD   R3,R1,R2
    LDR     R4,=0x7FFFFFFF
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation expected */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    LDR     R1,=0x00000000
    LDR     R2,=0xBFFFFFFF    
    QDADD   R3,R1,R2
    LDR     R4,=0x80000000
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation expected */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    LDR     R1,=0x40000000
    LDR     R2,=0x20000000    
    QDADD   R3,R1,R2
    LDR     R4,=0x7FFFFFFF
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation expected */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    LDR     R1,=0xBFFFFFFF
    LDR     R2,=0xDFFFFFFF    
    QDADD   R3,R1,R2
    LDR     R4,=0x80000000
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation expected */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    ADDW    R8,R8,#0x123 
    
    /*--------------------------------------------------------------------*/
    /* QDSUB - without saturation                                         */
    /*--------------------------------------------------------------------*/
    BL      m4_scst_clear_flags  
    LDR     R5,=0xFFFFFFFE
    LDR     R10,=0x2AAAAAAA    
    QDSUB   R3,R5,R10
    LDR     R4,=0xAAAAAAAA
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0xFFFFFFFF
    LDR     R5,=0xD5555555    
    QDSUB   R12,R10,R5
    LDR     R4,=0x55555555
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xAAAAAAAA
    LDR     R12,=0x00000000    
    QDSUB   R5,R3,R12
    LDR     R4,=0xAAAAAAAA
    CMP     R5,R4
    BNE     m4_scst_test_tail_end
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0x55555555
    LDR     R3,=0x00000000    
    QDSUB   R10,R12,R3
    LDR     R4,=0x55555555
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0xFFFFFFFF
    LDR     R2,=0xFFFFFFFF    
    QDSUB   R3,R1,R2
    LDR     R4,=0x00000001
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x00000001
    LDR     R2,=0x3FFFFFFF    
    QDSUB   R3,R1,R2
    LDR     R4,=0x80000003
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    ADDW    R8,R8,#0x123
    
    /*--------------------------------------------------------------------*/
    /* QDSUB - with saturation                                            */
    /*--------------------------------------------------------------------*/
    /* Q flag is expected not to be set by the previous check */
    BL      m4_scst_clear_flags    
    LDR     R1,=0x00000000
    LDR     R2,=0x40000000    
    QDSUB   R3,R1,R2
    LDR     R4,=0x80000001
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation expected */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    LDR     R1,=0x00000000
    LDR     R2,=0x80000000    
    QDSUB   R3,R1,R2
    LDR     R4,=0x7FFFFFFF
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation expected */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    LDR     R1,=0x40000000
    LDR     R2,=0xE0000000    
    QDSUB   R3,R1,R2
    LDR     R4,=0x7FFFFFFF
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation expected */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    LDR     R1,=0x80000000
    LDR     R2,=0x00000001    
    QDSUB   R3,R1,R2
    LDR     R4,=0x80000000
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation expected */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    ADDW    R8,R8,#0x123 
    
    /*--------------------------------------------------------------------*/
    /* QADD, QADD16, QADD8, UQADD16, UQADD8 - without saturation          */
    /*--------------------------------------------------------------------*/
    /* Q flag is expected to be set by the previous check */
    LDR     R5,=0xAAAAAAAA
    LDR     R10,=0x00000000    
    QADD    R3,R5,R10
    QADD16  R12,R5,R10
    QADD8   R7,R5,R10
    /* Check that the above QADDs does not clear Q flag */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    QADD    R3,R5,R10
    QADD16  R12,R5,R10
    QADD8   R7,R5,R10
    LDR     R4,=0xAAAAAAAA
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    CMP     R7,R4
    BNE     m4_scst_test_tail_end
    UQADD16 R3,R5,R10
    UQADD8  R12,R5,R10
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0x00000000
    LDR     R5,=0x55555555    
    QADD    R3,R10,R5
    QADD16  R12,R10,R5
    QADD8   R7,R10,R5    
    LDR     R4,=0x55555555
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    CMP     R7,R4
    BNE     m4_scst_test_tail_end
    UQADD16 R3,R10,R5
    UQADD8  R12,R10,R5
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0x00000000
    LDR     R12,=0xAAAAAAAA    
    QADD    R1,R3,R12
    QADD16  R10,R3,R12
    QADD8   R2,R3,R12    
    LDR     R4,=0xAAAAAAAA
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    UQADD16 R1,R3,R12
    UQADD8  R10,R3,R12
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0x55555555
    LDR     R3,=0x00000000    
    QADD    R1,R12,R3
    QADD16  R10,R12,R3
    QADD8   R2,R12,R3    
    LDR     R4,=0x55555555
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    UQADD16 R1,R12,R3
    UQADD8  R10,R12,R3
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    ADDW    R8,R8,#0x123
    
    /*--------------------------------------------------------------------*/
    /* QADD - with saturation                                             */
    /*--------------------------------------------------------------------*/ 
    BL      m4_scst_clear_flags    
    LDR     R1,=0xBFFFFFFF
    LDR     R2,=0xBFFFFFFF    
    QADD    R3,R1,R2
    LDR     R4,=0x80000000
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation expected */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    LDR     R1,=0x40000000
    LDR     R2,=0x40000000    
    QADD    R3,R1,R2
    LDR     R4,=0x7FFFFFFF
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation expected */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    ADDW    R8,R8,#0x123 
    
    /*--------------------------------------------------------------------*/
    /* QSUB, QSUB16, QSUB8, UQSUB16, UQSUB8 - without saturation          */
    /*--------------------------------------------------------------------*/
    /* Q flag is expected to be set by the previous check */
    LDR     R5,=0xAAAAAAAA
    LDR     R10,=0x00000000    
    QSUB    R3,R5,R10
    QSUB16  R12,R5,R10
    QSUB8   R7,R5,R10
    /* Check that the above QSUBs does not clear Q flag */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end   
    
    B m4_scst_simdsat_test1_ltorg_jump_1 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_simdsat_test1_ltorg_jump_1:
    
    BL      m4_scst_clear_flags
    QSUB    R3,R5,R10
    QSUB16  R12,R5,R10
    QSUB8   R7,R5,R10
    LDR     R4,=0xAAAAAAAA
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    CMP     R7,R4
    BNE     m4_scst_test_tail_end    
    UQSUB16 R3,R5,R10
    UQSUB8  R12,R5,R10
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0xFFFFFFFF
    LDR     R5,=0xAAAAAAAA    
    QSUB    R3,R10,R5
    QSUB16  R12,R10,R5
    QSUB8   R7,R10,R5    
    LDR     R4,=0x55555555
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    CMP     R7,R4
    BNE     m4_scst_test_tail_end
    UQSUB16 R3,R10,R5
    UQSUB8  R12,R10,R5
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xFFFFFFFF
    LDR     R12,=0x55555555    
    QSUB    R1,R3,R12
    QSUB16  R10,R3,R12
    QSUB8   R2,R3,R12    
    LDR     R4,=0xAAAAAAAA
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    UQSUB16 R1,R3,R12
    UQSUB8  R10,R3,R12
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0x55555555
    LDR     R3,=0x00000000    
    QSUB    R1,R12,R3
    QSUB16  R10,R12,R3
    QSUB8   R2,R12,R3    
    LDR     R4,=0x55555555
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    UQSUB16 R1,R12,R3
    UQSUB8  R10,R12,R3
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    CMP     R10,R4
    BNE     m4_scst_test_tail_end    
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    ADDW    R8,R8,#0x123
    
    /*--------------------------------------------------------------------*/
    /* QADD16, UQADD16 - with saturation                                  */
    /*--------------------------------------------------------------------*/
    BL      m4_scst_clear_flags    
    LDR     R1,=0xBFFFBFFF
    LDR     R2,=0xBFFFBFFF    
    QADD16  R3,R1,R2
    LDR     R4,=0x80008000
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    UQADD16 R3,R1,R2
    LDR     R4,=0xFFFFFFFF
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    LDR     R1,=0x40004000
    LDR     R2,=0x40004000    
    QADD16  R3,R1,R2
    LDR     R4,=0x7FFF7FFF
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* NOTE: unlike QADD, QADD16 does not set Q flag when saturated */
    BL      m4_scst_check_q_flag 
    BNE     m4_scst_test_tail_end
    
    ADDW    R8,R8,#0x123
    
    /*--------------------------------------------------------------------*/
    /* QADD8, UQADD8 - with saturation                                    */
    /*--------------------------------------------------------------------*/
    BL      m4_scst_clear_flags    
    LDR     R1,=0xBFBFBFBF
    LDR     R2,=0xBFBFBFBF    
    QADD8   R3,R1,R2
    LDR     R4,=0x80808080
    CMP     R3,R4
    BNE     m4_scst_test_tail_end    
    UQADD8  R3,R1,R2
    LDR     R4,=0xFFFFFFFF
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x40404040
    LDR     R2,=0x40404040    
    QADD8   R3,R1,R2
    LDR     R4,=0x7F7F7F7F
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* NOTE: unlike QADD, QADD8 does not set Q flag when saturated */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    ADDW    R8,R8,#0x123
    
    /*--------------------------------------------------------------------*/
    /* QSUB - with saturation                                             */
    /*--------------------------------------------------------------------*/
    BL      m4_scst_clear_flags    
    LDR     R1,=0xBFFFFFFF
    LDR     R2,=0x40000000    
    QSUB    R3,R1,R2
    LDR     R4,=0x80000000
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation expected */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    LDR     R1,=0x40000000
    LDR     R2,=0xBFFFFFFF    
    QSUB    R3,R1,R2
    LDR     R4,=0x7FFFFFFF
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    /* Saturation expected */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end    
    
    ADDW    R8,R8,#0x123
       
    /*--------------------------------------------------------------------*/
    /* QSUB16, UQSUB16 - with saturation                                  */
    /*--------------------------------------------------------------------*/
    BL      m4_scst_clear_flags    
    LDR     R1,=0xBFFFBFFF
    LDR     R2,=0x40004000    
    QSUB16  R3,R1,R2
    LDR     R4,=0x80008000
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x40004000
    LDR     R2,=0xBFFFBFFF    
    QSUB16  R3,R1,R2
    LDR     R4,=0x7FFF7FFF
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x80008000
    LDR     R2,=0x7FFF8FFF    
    UQSUB16 R3,R1,R2
    LDR     R4,=0x00010000
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x80008000
    LDR     R2,=0x8FFF7FFF    
    UQSUB16 R3,R1,R2
    LDR     R4,=0x00000001
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    /* NOTE: unlike QSUB, QSUB16 does not set Q flag when saturated */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end    
    
    ADDW    R8,R8,#0x123
    
    /*--------------------------------------------------------------------*/
    /* QSUB8, UQSUB8 - with saturation                                    */
    /*--------------------------------------------------------------------*/
    BL      m4_scst_clear_flags    
    LDR     R1,=0xBFBFBFBF
    LDR     R2,=0x40404040    
    QSUB8   R3,R1,R2
    LDR     R4,=0x80808080
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x40404040
    LDR     R2,=0xBFBFBFBF    
    QSUB8   R3,R1,R2
    LDR     R4,=0x7F7F7F7F
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x80808080
    LDR     R2,=0x7F817F81    
    UQSUB8  R3,R1,R2
    LDR     R4,=0x01000100
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x80808080
    LDR     R2,=0x817F817F    
    UQSUB8  R3,R1,R2
    LDR     R4,=0x00010001
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    /* NOTE: unlike QSUB, QSUB8 does not set Q flag when saturated */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end  
    
    ADDW    R8,R8,#0x123
    
    /*--------------------------------------------------------------------*/
    /* QASX, UQASX without saturation                                     */
    /*--------------------------------------------------------------------*/
    /* Set Q flag */
    LDR     R4,=0x08000000
    MSR     APSR_nzcvq,R4     /* Load flags */
            
    LDR     R5,=0xAAAAAAAA
    LDR     R10,=0x00000000    
    QASX    R3,R5,R10
    UQASX   R12,R5,R10
    /* Check that the above QADDs does not clear Q flag */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    QASX    R3,R5,R10
    UQASX   R12,R5,R10
    LDR     R4,=0xAAAAAAAA
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
        
    LDR     R10,=0x0000FFFF
    LDR     R5,=0x55555555    
    QASX    R3,R10,R5
    UQASX   R12,R10,R5
    LDR     R4,=0x5555AAAA
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0x0000FFFF
    LDR     R12,=0xAAAAAAAA    
    QASX    R5,R3,R12
    UQASX   R10,R3,R12
    LDR     R4,=0xAAAA5555
    CMP     R5,R4
    BNE     m4_scst_test_tail_end
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0x55555555
    LDR     R3,=0x00000000    
    QASX    R5,R12,R3
    UQASX   R10,R12,R3
    LDR     R4,=0x55555555
    CMP     R5,R4
    BNE     m4_scst_test_tail_end
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    ADDW    R8,R8,#0x123 
    
    /*--------------------------------------------------------------------*/
    /* QSAX, UQSAX without saturation                                     */
    /*--------------------------------------------------------------------*/
    /* Set Q flag */
    LDR     R4,=0x08000000
    MSR     APSR_nzcvq,R4     /* Load flags */
           
    LDR     R1,=0xAAAAAAAA
    LDR     R2,=0x00000000    
    QSAX    R3,R1,R2
    UQSAX   R5,R1,R2
    /* Check that the above QADDs does not clear Q flag */
    BL      m4_scst_check_q_flag
    BEQ     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    QSAX    R3,R1,R2
    UQSAX   R5,R1,R2
    LDR     R4,=0xAAAAAAAA
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    CMP     R3,R5
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0xFFFF0000
    LDR     R2,=0x55555555    
    QSAX    R3,R1,R2
    UQSAX   R5,R1,R2
    LDR     R4,=0xAAAA5555
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    CMP     R3,R5
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0xFFFF0000
    LDR     R2,=0xAAAAAAAA    
    QSAX    R3,R1,R2
    UQSAX   R5,R1,R2
    LDR     R4,=0x5555AAAA
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    CMP     R3,R5
    BNE     m4_scst_test_tail_end
       
    LDR     R1,=0x55555555
    LDR     R2,=0x00000000    
    QSAX    R3,R1,R2
    UQSAX   R5,R1,R2
    LDR     R4,=0x55555555
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    CMP     R3,R5
    BNE     m4_scst_test_tail_end
    
    /* Saturation not expected */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    ADDW    R8,R8,#0x123
    
    /*--------------------------------------------------------------------*/
    /* QASX, UQASX with saturation                                        */
    /*--------------------------------------------------------------------*/
    BL      m4_scst_clear_flags    
    LDR     R1,=0xBFFFBFFF
    LDR     R2,=0x4000BFFF    
    QASX    R3,R1,R2
    LDR     R4,=0x80008000
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x40004000
    LDR     R2,=0xBFFF4000    
    QASX    R3,R1,R2
    LDR     R4,=0x7FFF7FFF
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x80008000
    LDR     R2,=0x8FFF8001    
    UQASX   R3,R1,R2
    LDR     R4,=0xFFFF0000
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    /* NOTE: unlike QADD, QASX does not set Q flag when saturated */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end
    
    ADDW    R8,R8,#0x123
    
    /*--------------------------------------------------------------------*/
    /* QSAX, UQSAX with saturation                                        */
    /*--------------------------------------------------------------------*/
    BL      m4_scst_clear_flags    
    LDR     R1,=0xBFFFBFFF
    LDR     R2,=0xBFFF4000    
    QSAX    R3,R1,R2
    LDR     R4,=0x80008000
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x40004000
    LDR     R2,=0x4000BFFF    
    QSAX    R3,R1,R2
    LDR     R4,=0x7FFF7FFF
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x80008000
    LDR     R2,=0x80018FFF    
    UQSAX   R3,R1,R2
    LDR     R4,=0x0000FFFF
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    /* NOTE: unlike QADD, QSAX does not set Q flag when saturated */
    BL      m4_scst_check_q_flag
    BNE     m4_scst_test_tail_end    
    
    ADDW    R8,R8,#0x123
    
    
    MOV     R0,R8       /* Test result is returned in R0 */
    
    B       m4_scst_test_tail_end
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */

    SCST_FILE_END
    