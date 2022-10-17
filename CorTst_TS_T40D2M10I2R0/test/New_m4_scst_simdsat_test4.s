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
* Tests the Extend instructions with at least two sets of inverted input 
* operands, causing also all bits in the result be '1' and '0':
*   UXTB, UXTH, UXTB16, UXTAB, UXTAH, UXTAB16
*   SXTB, SXTH, SXTB16, SXTAB, SXTAH, SXTAB16  
*   PKHBT, PKHTB, SEL as well as their decoding.
*
* Overall coverage:
* -----------------
* DECODER:
* Thumb (16-bit) 
*   - Encoding of "Miscellaneous 16-bit instructions"
* 测试总结：
* -------------
* 使用至少两组反相输入测试扩展指令
* 操作数，导致结果中的所有位也为“1”和“0”：
* UXTB、UXTH、UXTB16、UXTAB、UXTAH、UXTAB16
* SXTB、SXTH、SXTB16、SXTAB、SXTAH、SXTAB16
* PKHBT、PKHTB、SEL 以及它们的解码。
*
* 整体覆盖：
* -----------------
* 解码器：
* 拇指（16 位）
* - “杂项 16 位指令”的编码

******************************************************************************/

#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside    */
    SCST_EXPORT m4_scst_simdsat_test4
    
    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end

    /* Local defines */    
SCST_SET(PRESIGNATURE,0xC451C546) /* this macro has to be at the beginning of the line */


    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_simdsat_test4" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_simdsat_test4, function)                   
m4_scst_simdsat_test4:

    PUSH.W  {R1-R12,R14}
    
    LDR     R9,=PRESIGNATURE
    
    /*--------------------------------------------------------------------*/
    /* UXTB.N - no rotation                                               */
    /*--------------------------------------------------------------------*/
    LDR     R1,=0x00000055
    LDR     R6,=0x000000AA
    
    LDR     R5,=0xAAAAAA55
    UXTB.N  R2,R5
    CMP     R2,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R2,=0x555555AA   
    UXTB.N  R5,R2
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R0,=0x00000033
    LDR     R2,=0x000000CC
    
    LDR     R3,=0xCCCCCC33
    UXTB.N  R4,R3
    CMP     R4,R0
    BNE     m4_scst_test_tail_end
    
    LDR     R4,=0x333333CC   
    UXTB.N  R3,R4
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* UXTB.W - with rotation                                             */
    /*--------------------------------------------------------------------*/
    LDR     R5,=0xAAAA55AA
    UXTB.W  R10,R5,ROR #8
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0x5555AA55
    UXTB.W  R5,R10,ROR #8
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xCC33CCCC
    UXTB.W  R12,R3,ROR #16
    CMP     R12,R0
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0x33CC3333
    UXTB.W  R3,R12,ROR #16
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0x55AAAAAA
    UXTB.W  R8,R7,ROR #24
    CMP     R8,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0xAA555555
    UXTB.W  R7,R8,ROR #24
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    B m4_scst_simdsat_test4_ltorg_jump_1 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_simdsat_test4_ltorg_jump_1:
    
    /*--------------------------------------------------------------------*/
    /* UXTH.N - no rotation                                               */
    /*--------------------------------------------------------------------*/
    LDR     R1,=0x00005555
    LDR     R6,=0x0000AAAA
    
    LDR     R2,=0xAAAA5555
    UXTH.N  R5,R2
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R5,=0x5555AAAA
    UXTH.N  R2,R5
    CMP     R2,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R0,=0x00003333
    LDR     R2,=0x0000CCCC
    
    LDR     R3,=0xCCCC3333
    UXTH.N  R4,R3
    CMP     R4,R0
    BNE     m4_scst_test_tail_end
    
    LDR     R4,=0x3333CCCC
    UXTH.N  R3,R4
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* UXTH.W - with rotation                                             */
    /*--------------------------------------------------------------------*/
    LDR     R5,=0xAA5555AA   
    UXTH.W  R10,R5,ROR #8
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0x55AAAA55
    UXTH.W  R5,R10,ROR #8
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0x3333CCCC   
    UXTH.W  R12,R3,ROR #16
    CMP     R12,R0
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0xCCCC3333
    UXTH.W  R3,R12,ROR #16
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0x55AAAA55   
    UXTH.W  R8,R7,ROR #24
    CMP     R8,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0xAA5555AA
    UXTH.W  R7,R8,ROR #24
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673    
    
    /*--------------------------------------------------------------------*/
    /* UXTB16 - no rotation                                               */
    /*--------------------------------------------------------------------*/
    LDR     R1,=0x00550055
    LDR     R2,=0x00AA00AA    
    
    LDR     R4,=0xAA55AA55    
    UXTB16  R5,R4
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R5,=0x55AA55AA   
    UXTB16  R4,R5
    CMP     R4,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x00330033
    LDR     R2,=0x00CC00CC    
    
    LDR     R4,=0xCC33CC33    
    UXTB16  R5,R4
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R5,=0x33CC33CC   
    UXTB16  R4,R5
    CMP     R4,R2
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* UXTB16 - with rotation                                             */
    /*--------------------------------------------------------------------*/
    LDR     R11,=0x01234567
    LDR     R1,= 0x00010045   
    UXTB16  R10,R11,ROR #8
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R4,=0xFEDCBA98
    LDR     R2,=0x00FE00BA
    UXTB16  R10,R4,ROR #8
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x00670023
    UXTB16  R10,R11,ROR #16    
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R2,=0x009800DC
    UXTB16  R10,R4,ROR #16
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x00450001   
    UXTB16  R10,R11,ROR #24
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R2,=0x00BA00FE
    UXTB16  R10,R4,ROR #24
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* UXTAB - no rotation                                                */
    /*                                                                    */
    /* Note - Uses the same decoding as UXTB. For decoder purposes we need*/
    /*        to test different values of 'Rn' only.                      */
    /*--------------------------------------------------------------------*/
    LDR     R5,=0x55555555
    LDR     R7,=0x00000000    
    
    LDR     R1,=0x55555555    
    UXTAB   R10,R5,R7    
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0xAAAAAAAA
    LDR     R7,=0x00000000    
    
    LDR     R1,=0xAAAAAAAA    
    UXTAB   R5,R10,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0x00000000
    LDR     R7,=0xAAAAAA55    
    
    LDR     R1,=0x00000055    
    UXTAB   R5,R3,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0x00000000
    LDR     R7,=0x555555AA    
    
    LDR     R1,=0x000000AA    
    UXTAB   R5,R12,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* UXTAB - with rotation + addition                                   */
    /*--------------------------------------------------------------------*/
    LDR     R7,=0x01234567
    LDR     R1,=0xAAAAAAAA
    LDR     R2,=0x55555555
    
    LDR     R6,=0xAAAAAA65
    UXTAB   R5,R6,R7,ROR #8
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0x55555532
    UXTAB   R5,R8,R7,ROR #16
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R4,=0xAAAAAAA9
    UXTAB   R5,R4,R7,ROR #24
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* UXTAH - no rotation                                                */
    /*                                                                    */
    /* Note - Uses the same decoding as UXTH. For decoder purposes we need*/
    /*        to test different values of 'Rn' only.                      */
    /*--------------------------------------------------------------------*/
    LDR     R10,=0x55555555
    LDR     R7,=0x00000000
    
    LDR     R1,=0x55555555
    UXTAH   R5,R10,R7    
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R5,=0xAAAAAAAA
    LDR     R7,=0x00000000
    
    LDR     R1,=0xAAAAAAAA
    UXTAH   R10,R5,R7
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0x00000000
    LDR     R7,=0xAAAA5555
    
    LDR     R1,=0x00005555
    UXTAH   R5,R3,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0x00000000
    LDR     R7,=0x5555AAAA
    
    LDR     R1,=0x0000AAAA    
    UXTAH   R5,R12,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* UXTAH - with rotation + addition                                   */
    /*--------------------------------------------------------------------*/
    LDR     R7,=0x01234567
    LDR     R1,=0xAAAAAAAA
    LDR     R2,=0x55555555
    
    LDR     R11,=0xAAAA8765                   
    UXTAH   R5,R11,R7,ROR #8
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0x55555432        
    UXTAH   R5,R6,R7,ROR #16
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0xAAAA43A9        
    UXTAH   R5,R12,R7,ROR #24
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* SXTB.N - no rotation                                               */
    /*--------------------------------------------------------------------*/
    LDR     R1,=0x00000055
    LDR     R6,=0xFFFFFFAA    
    
    LDR     R2,=0xAAAAAA55    
    SXTB.N  R5,R2
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R5,=0x555555AA   
    SXTB.N  R2,R5
    CMP     R2,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R0,=0x00000033
    LDR     R2,=0xFFFFFFCC    
    
    LDR     R3,=0xCCCCCC33    
    SXTB.N  R4,R3
    CMP     R4,R0
    BNE     m4_scst_test_tail_end
    
    LDR     R4,=0x333333CC   
    SXTB.N  R3,R4
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* SXTB.W - with rotation                                             */
    /*--------------------------------------------------------------------*/
    LDR     R5,=0xAAAA55AA   
    SXTB.W  R10,R5,ROR #8
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0x5555AA55
    SXTB.W  R5,R10,ROR #8
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xCC33CCCC   
    SXTB.W  R12,R3,ROR #16
    CMP     R12,R0
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0x33CC3333
    SXTB.W  R3,R12,ROR #16
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0x55AAAAAA   
    SXTB.W  R8,R7,ROR #24
    CMP     R8,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0xAA555555
    SXTB.W  R7,R8,ROR #24
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* SXTH.N - no rotation                                               */
    /*--------------------------------------------------------------------*/
    LDR     R1,=0x00005555
    LDR     R6,=0xFFFFAAAA
    
    LDR     R2,=0xAAAA5555
    SXTH.N  R5,R2
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R5,=0x5555AAAA
    SXTH.N  R2,R5
    CMP     R2,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R0,=0x00003333
    LDR     R2,=0xFFFFCCCC
    
    LDR     R3,=0xCCCC3333
    SXTH.N  R4,R3
    CMP     R4,R0
    BNE     m4_scst_test_tail_end
    
    LDR     R4,=0x3333CCCC
    SXTH.N  R3,R4
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* SXTH.W - with rotation                                             */
    /*--------------------------------------------------------------------*/
    LDR     R5,=0xAA5555AA   
    SXTH.W  R10,R5,ROR #8
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0x55AAAA55
    SXTH.W  R5,R10,ROR #8
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0x3333CCCC   
    SXTH.W  R12,R3,ROR #16
    CMP     R12,R0
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0xCCCC3333
    SXTH.W  R3,R12,ROR #16
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0x55AAAA55   
    SXTH.W  R8,R7,ROR #24
    CMP     R8,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0xAA5555AA
    SXTH.W  R7,R8,ROR #24
    CMP     R7,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673 
    
    /*--------------------------------------------------------------------*/
    /* SXTB16 - no rotation                                               */
    /*--------------------------------------------------------------------*/
    LDR     R1,=0x00550055
    LDR     R2,=0xFFAAFFAA    
    
    LDR     R4,=0xAA55AA55    
    SXTB16  R5,R4
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R4,=0x55AA55AA   
    SXTB16  R5,R4
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x00330033
    LDR     R2,=0xFFCCFFCC    
    
    LDR     R4,=0xCC33CC33    
    SXTB16  R5,R4
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R4,=0x33CC33CC   
    SXTB16  R5,R4
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* SXTB16 - with rotation                                             */
    /*--------------------------------------------------------------------*/
    LDR     R11,=0x01234567
    LDR     R1,=0x00010045   
    SXTB16  R10,R11,ROR #8
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R4,=0xFEDCBA98
    LDR     R2,=0xFFFEFFBA
    SXTB16  R10,R4,ROR #8
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x00670023
    SXTB16  R10,R11,ROR #16    
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R2,=0xFF98FFDC
    SXTB16  R10,R4,ROR #16
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0x00450001   
    SXTB16  R10,R11,ROR #24
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R2,=0xFFBAFFFE
    SXTB16  R10,R4,ROR #24
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    B m4_scst_simdsat_test4_ltorg_jump_2 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_simdsat_test4_ltorg_jump_2:
    
    /*--------------------------------------------------------------------*/
    /* SXTAB - no rotation                                                */
    /*                                                                    */
    /* Note - Uses the same decoding as SXTB. For decoder purposes we need*/
    /*        to test different values of 'Rn' only.                      */
    /*--------------------------------------------------------------------*/
    LDR     R6,=0x55555555
    LDR     R7,=0x00000000    
    
    LDR     R1,=0x55555555    
    SXTAB   R5,R6,R7    
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R11,=0xAAAAAAAA
    LDR     R7,=0x00000000    
    
    LDR     R1,=0xAAAAAAAA    
    SXTAB   R5,R11,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R2,=0x00000000
    LDR     R7,=0xAAAAAA55    
    
    LDR     R1,=0x00000055    
    SXTAB   R5,R2,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0x00000000
    LDR     R7,=0x555555AA    
    
    LDR     R1,=0xFFFFFFAA    
    SXTAB   R5,R8,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* SXTAB - with rotation + addition                                   */
    /*--------------------------------------------------------------------*/
    LDR     R7,=0xFEDC4567
    LDR     R1,=0xAAAAAAAA
    LDR     R2,=0x55555555
    
    LDR     R6,=0xAAAAAA65                   
    SXTAB   R5,R6,R7,ROR #8
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0x55555579        
    SXTAB   R5,R6,R7,ROR #16
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0xAAAAAAAC        
    SXTAB   R5,R6,R7,ROR #24
    CMP     R5,R1
    BNE     m4_scst_test_tail_end   
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* SXTAH - no rotation                                                */
    /*                                                                    */
    /* Note - Uses the same decoding as SXTH. For decoder purposes we need*/
    /*        to test different values of 'Rn' only.                      */
    /*--------------------------------------------------------------------*/
    LDR     R0,=0x55555555
    LDR     R7,=0x00000000    
    
    LDR     R1,=0x55555555    
    SXTAH   R5,R0,R7    
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0xAAAAAAAA
    LDR     R7,=0x00000000    
    
    LDR     R1,=0xAAAAAAAA    
    SXTAH   R5,R6,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0x00000000
    LDR     R7,=0xAAAA5555    
    
    LDR     R1,=0x00005555    
    SXTAH   R5,R10,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R2,=0x00000000
    LDR     R7,=0x5555AAAA    
    
    LDR     R1,=0xFFFFAAAA    
    SXTAH   R5,R2,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* SXTAH - with rotation + addition                                   */
    /*--------------------------------------------------------------------*/
    LDR     R7,=0xFE2345DC
    LDR     R1,=0xAAAAAAAA
    LDR     R2,=0x55555555
    
    LDR     R6,=0xAAAA8765
    SXTAH   R5,R6,R7,ROR #8
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0x55555732
    SXTAH   R5,R6,R7,ROR #16
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0xAAAACDAC        
    SXTAH   R5,R6,R7,ROR #24
    CMP     R5,R1
    BNE     m4_scst_test_tail_end   
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* UXTAB16 - no rotation                                              */
    /*                                                                    */
    /* Note - Uses the same decoding as UXTB16. For decoder purposes we   */
    /*        need to test different values of 'Rn' only.                 */
    /*--------------------------------------------------------------------*/
    LDR     R1,=0x55555555
    LDR     R7,=0x00000000
    
    LDR     R3,=0x55555555
    UXTAB16 R5,R1,R7    
    CMP     R5,R3
    BNE     m4_scst_test_tail_end
    
    LDR     R5,=0xAAAAAAAA
    LDR     R7,=0x00000000
    
    LDR     R1,=0xAAAAAAAA
    UXTAB16 R10,R5,R7
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0x00000000
    LDR     R7,=0xAA55AA55
    
    LDR     R1,=0x00550055
    UXTAB16 R5,R6,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0x00000000
    LDR     R7,=0x55AA55AA
    
    LDR     R1,=0x00AA00AA
    UXTAB16 R5,R8,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* UXTAB16 - with rotation + addition                                 */
    /*--------------------------------------------------------------------*/
    LDR     R7,=0x01234567
    LDR     R1,=0xAAAAAAAA
    LDR     R2,=0x55555555
    
    LDR     R6,=0xAAA9AA65
    UXTAB16 R5,R6,R7,ROR #8
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0x54EE5532
    UXTAB16 R5,R6,R7,ROR #16
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0xAA65AAA9
    UXTAB16 R5,R6,R7,ROR #24
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* SXTAB16 - no rotation                                              */
    /*                                                                    */
    /* Note - Uses the same decoding as SXTB16. For decoder purposes we   */
    /*        need to test different values of 'Rn' only.                 */
    /*--------------------------------------------------------------------*/
    LDR     R5,=0x55555555
    LDR     R7,=0x00000000
    
    LDR     R1,=0x55555555
    SXTAB16 R10,R5,R7
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0xAAAAAAAA
    LDR     R7,=0x00000000
    
    LDR     R1,=0xAAAAAAAA
    SXTAB16 R5,R10,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0x00000000
    LDR     R7,=0xAA55AA55
    
    LDR     R1,=0x00550055
    SXTAB16 R5,R3,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0x00000000
    LDR     R7,=0x55AA55AA
    
    LDR     R1,=0xFFAAFFAA
    SXTAB16 R5,R12,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* SXTAB16 - with rotation + addition                                 */
    /*--------------------------------------------------------------------*/
    LDR     R7,=0xFE2345CD
    LDR     R1,=0xAAAAAAAA
    LDR     R2,=0x55555555
    
    LDR     R6,=0xAAACAA65
    SXTAB16 R5,R6,R7,ROR #8
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0x55885532
    SXTAB16 R5,R6,R7,ROR #16
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0xAA65AAAC
    SXTAB16 R5,R6,R7,ROR #24
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* PKHTB                                                              */
    /*--------------------------------------------------------------------*/
    LDR     R6,=0xAAAA0000
    LDR     R7,=0x00015555
    LDR     R1,=0xAAAAAAAA
    PKHTB   R10,R6,R7,ASR #1
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0x55550000
    LDR     R6,=0x000AAAA0
    LDR     R1,=0x55555555
    PKHTB   R5,R7,R6,ASR #5
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0xCCCC0000
    LDR     R7,=0x00033330
    LDR     R1,=0xCCCCCCCC
    PKHTB   R10,R6,R7,ASR #2
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0x33330000
    LDR     R7,=0x00CCCC00
    LDR     R1,=0x33333333
    PKHTB   R10,R6,R7,ASR #10
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0x1234FFFF
    LDR     R7,=0x5678FFFF
    LDR     R1,=0x12345678
    PKHTB   R5,R6,R7,ASR #16
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0x0000FFFF
    LDR     R7,=0xFFFF0000
    LDR     R1,=0x00000000
    PKHTB   R5,R6,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* PKHBT                                                              */
    /*--------------------------------------------------------------------*/
    LDR     R6,=0x0000AAAA
    LDR     R7,=0x05555000
    LDR     R1,=0xAAAAAAAA
    PKHBT   R5,R6,R7,LSL #5
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0x00005555
    LDR     R6,=0xAAAA8000
    LDR     R1,=0x55555555
    PKHBT   R10,R7,R6,LSL #1
    CMP     R10,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0x0000CCCC
    LDR     R7,=0x00333300
    LDR     R1,=0xCCCCCCCC
    PKHBT   R5,R6,R7,LSL #10
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0x00003333
    LDR     R7,=0xCCCCC000
    LDR     R1,=0x33333333
    PKHBT   R5,R6,R7,LSL #2
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0x00005678
    LDR     R7,=0xFFFF1234
    LDR     R1,=0x12345678
    PKHBT   R5,R6,R7,LSL #16
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    LDR     R6,=0xFFFF0000
    LDR     R7,=0x0000FFFF
    LDR     R1,=0x00000000
    PKHBT   R5,R6,R7
    CMP     R5,R1
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    /*--------------------------------------------------------------------*/
    /* SEL                                                                */
    /*--------------------------------------------------------------------*/
    /* CPSR[GE] bits*/
    LDR     R4,=0x000F0000
    /* Used opcode due to compiler problem */
    SCST_OPCODE_START
    SCST_OPCODE32_HIGH(0xF384)  /* opcode for MSR APSR_g, R4 */
    SCST_OPCODE32_LOW(0x8400)
    SCST_OPCODE_END
    
    LDR     R10,=0xAAAAAAAA
    LDR     R5,=0x55555555
    
    /* initialize the output with the inverted value */
    SEL     R3,R5,R10
    ISB
    SEL     R3,R10,R5      
    LDR     R4,=0xAAAAAAAA
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    SEL     R12,R5,R10
    LDR     R4,=0x55555555
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    
    /* CPSR[GE] bits*/
    LDR     R4,=0x00000000 
    /* Used opcode due to compiler problem */
    SCST_OPCODE_START
    SCST_OPCODE32_HIGH(0xF384)  /* opcode for MSR APSR_g, R4 */
    SCST_OPCODE32_LOW(0x8400)
    SCST_OPCODE_END
    ISB     /* Fix problem with ETM-Trace on S32K14x, see CSTL-587 */
    SEL     R7,R5,R10      
    LDR     R4,=0xAAAAAAAA
    CMP     R7,R4
    BNE     m4_scst_test_tail_end
    
    SEL     R8,R10,R5      
    LDR     R4,=0x55555555
    CMP     R8,R4
    BNE     m4_scst_test_tail_end
   
    /* CPSR[GE] bits*/
    LDR     R4,=0x000A0000    
    /* Used opcode due to compiler problem */
    SCST_OPCODE_START
    SCST_OPCODE32_HIGH(0xF384)  /* opcode for MSR APSR_g, R4 */
    SCST_OPCODE32_LOW(0x8400)
    SCST_OPCODE_END
    
    LDR     R12,=0xCCCCCCCC
    LDR     R3,=0x33333333
    
    /* initialize the output with the inverted value */
    SEL     R5,R3,R12 
    ISB
    SEL     R5,R12,R3      
    LDR     R4,=0xCC33CC33
    CMP     R5,R4
    BNE     m4_scst_test_tail_end
    
    SEL     R10,R3,R12      
    LDR     R4,=0x33CC33CC
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
   
     /* CPSR[GE] bits*/
    LDR     R4,=0x00050000    
    /* Used opcode due to compiler problem */
    SCST_OPCODE_START
    SCST_OPCODE32_HIGH(0xF384)  /* opcode for MSR APSR_g, R4 */
    SCST_OPCODE32_LOW(0x8400)
    SCST_OPCODE_END
    ISB     /* Fix problem with ETM-Trace on S32K14x, see CSTL-587 */
    SEL     R6,R3,R12      
    LDR     R4,=0xCC33CC33
    CMP     R6,R4
    BNE     m4_scst_test_tail_end   
    
    SEL     R1,R12,R3      
    LDR     R4,=0x33CC33CC
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x673
    
    
    MOV     R0,R9       /* Test result is returned in R0 */
    
    B       m4_scst_test_tail_end
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
