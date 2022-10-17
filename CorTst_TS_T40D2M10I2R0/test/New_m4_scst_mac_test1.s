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
* Test MAC module as well as decoding of multiply instructions
*
* Overall coverage:
* -----------------
* Use different types of MAC commands to cover the following functionality:
*   - use 32 bits into 32x32 multiplier for rd_a
*   - use higher 16 bits into 32x32 multiplier for rd_a
*   - use 32 bits into 32x32 multiplier for rd_b
*   - use lower 16 bits into 32x32 multiplier for rd_b
*   - use higher 16 bits into 32x32 multiplier for rd_b
*   - use lower 16 bits into 16x16 multiplier for rd_ a
*   - use higher 16 bits into 16x16 multiplier for rd_a
*   - use lower 16 bits into 16x16 multiplier for rd_b
*   - use higher 16 bits into 16x16 multiplier for rd_b
*   - Negate 32 bit multiply multiply result
*   - rd_x into lower word of accumulator
*   - rd_y into lower word of accumulator
*   - rd_y into higher word of accumulator
*   - Sign extend rd_x in lower accumulator word
*   - Fix32 into higher word of accumulator
*   - Rounding
*   - 16 bit rotation on accumulator for 32x16 shifts
*   - 16 bit rotation on result for 32x16 shifts
*   - USAD
* 
* DECODER:
* Thumb (32-bit)
*   - Encoding of "Multiply, multiply accumulate, and absolute difference" instructions
*   - Encoding of "Long multiply, long multiply accumulate, and divide" instructions
* 测试总结：
* -------------
* 测试MAC模块以及乘法指令的解码
*
* 整体覆盖：
* -----------------
* 使用不同类型的 MAC 命令来覆盖以下功能：
* - 将 32 位用于 rd_a 的 32x32 乘法器
* - 将较高的 16 位用于 rd_a 的 32x32 乘法器
* - 为 rd_b 使用 32 位到 32x32 乘法器
* - 将低 16 位用于 rd_b 的 32x32 乘法器
* - 将较高的 16 位用于 rd_b 的 32x32 乘法器
* - 将低 16 位用于 rd_a 的 16x16 乘法器
* - 将较高的 16 位用于 rd_a 的 16x16 乘法器
* - 将低 16 位用于 rd_b 的 16x16 乘法器
* - 将较高的 16 位用于 rd_b 的 16x16 乘法器
* - 否定 32 位乘法结果
* - rd_x 到累加器的低位字
* - rd_y 到累加器的低位字
* - rd_y 到累加器的高位字
* - 在较低的累加器字中对 rd_x 进行符号扩展
* - 将 32 修正为累加器的更高字
* - 舍入
* - 累加器上的 16 位旋转，用于 32x16 移位
* - 32x16 移位的 16 位旋转结果
* - 美国农业部
*
* 解码器：
* 拇指（32 位）
* - “乘法、乘法累加和绝对差”指令的编码
* - “长乘、长乘累加和除法”指令的编码

******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"
    
    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_mac_test1

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    

    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2 

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_mac_test1" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_mac_test1, function)
m4_scst_mac_test1:

    PUSH.W  {R1-R12,R14}
    
    /* R9 is used as intermediate result */
    MOV     R9,#0x0
    
    /***************************************************************************************************
    * Multiply
    *   - Multiplies 32 bits operands.
    *   - Places the least significant 32 bits of the result in Rd.
    *
    *   MUL Rd, Rn, Rm
    *   Rd:=(Rn*Rm)[31:0]
    *   
    * Covers:
    *   - use 32 bits into 32x32 multiplier for rd_a
    *   - use 32 bits into 32x32 multiplier for rd_b
    ***************************************************************************************************/
    LDR     R5,=0x55555556
    LDR     R10,=0xFFFFFFFF
    /* MUL Encoding T2 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    MUL     R5,R5,R10    /* R5*R10 = 0x55555555 AAAAAAAA[31:0] = 0xAAAAAAAA */
    LDR     R6,=0xAAAAAAAA
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0xAAAAAAAB
    LDR     R5,=0xFFFFFFFF
    /* MUL Encoding T2 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    MUL     R10,R10,R5    /* R10*R5 = 0xAAAAAAAA 55555555[31:0] = 0x55555555 */
    LDR     R6,=0x55555555
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    
    /* We need to check that MUL instruction updates N,Z flags */
    LDR     R4,=0x0
    MSR     APSR_nzcvq,R4 /* Clear flags */
    
    MOV     R1,#0
    LDR     R2,=0xFFFFFFFF
    /* MUL Encoding T1 16bit */
    MULS.N  R1,R2   /* Set Z flag */
    BNE     m4_scst_test_tail_end   /* Check Z flag was set */
    
    MOV     R1,#0x80000000
    /* MUL Encoding T1 16bit */
    MULS.N  R2,R1   /* Set N flag */
    BGT     m4_scst_test_tail_end  /* Check N flag was set */
    BEQ     m4_scst_test_tail_end   /* Check Z flag was cleared */
    
    MOV     R1,#1
    MOV     R2,#1
    /* MUL Encoding T1 16bit */
    MULS.N  R2,R1   /* Set N flag */
    BLT     m4_scst_test_tail_end  /* Check N flag was cleared */
    
    ADDW    R9,R9,#0x02A2
    
    
    /***************************************************************************************************
    * Multiply with Accumulate
    *   - Multiplies 32 bits operands.
    *   - Adds the value from Ra.
    *   - Places the least significant 32 bits of the result in Rd.
    *
    *   MLA Rd, Rn, Rm, Ra
    *   Rd:=(Ra+(Rn*Rm))[31:0] 
    *
    * Covers:
    *   - use 32 bits into 32x32 multiplier for rd_a
    *   - use 32 bits into 32x32 multiplier for rd_b
    *   - rd_x into lower word of accumulator
    ***************************************************************************************************/
    LDR     R5,=0x55555556
    LDR     R10,=0xFFFFFFFF
    LDR     R12,=0x66666666
    /* MLA Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    MLA     R12,R5,R10,R12 /* R12 + R5*R10 = 0x55555556 11111110[31:0] = 0x11111110 */
    LDR     R6,=0x11111110
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0xAAAAAAAB
    LDR     R5,=0xFFFFFFFF
    LDR     R3,=0x11111111
    /* MLA Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    MLA     R3,R10,R5,R3 /* R3 + R10*R5 = 0xAAAAAAAA 66666666[31:0] = 0x66666666 */
    LDR     R6,=0x66666666
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x03AF
    
    
    /***************************************************************************************************
    * Multiply with Subtract
    *   - Multiplies 32 bits operands.
    *   - Subtracts the product from the value from Ra.
    *   - Places the least significant 32 bits of the result in Rd.
    *
    *   MLS Rd, Rn, Rm    
    *   Rd:=(Ra-(Rn*Rm))[31:0]
    *
    * Covers:
    *   - use 32 bits into 32x32 multiplier for rd_a
    *   - use 32 bits into 32x32 multiplier for rd_b
    *   - negate 32 bit multiply multiply result
    *   - rd_x into lower word of accumulator
    ***************************************************************************************************/
    LDR     R12,=0x55555556
    LDR     R3,=0xFFFFFFFF
    LDR     R10,=0x44444444
    /* MLS Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    MLS     R5,R3,R12,R10 /* R10 - R12*R3 = 0xAAAAAAAA9999999A[31:0] = 0x9999999A */
    LDR     R6,=0x9999999A
    CMP     R5,R6
    BNE     m4_scst_test_tail_end
  
    LDR     R3,=0xAAAAAAAB
    LDR     R12,=0xFFFFFFFF
    LDR     R5,=0xBBBBBBBB
    /* MLS Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    MLS     R10,R12,R3,R5 /* R5 - R3*R12 = 0x5555555566666666[31:0] = 0x66666666 */
    LDR     R6,=0x66666666
    CMP     R10,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x067E
    
    B m4_scst_mac_test1_ltorg_jump_1
    SCST_ALIGN_BYTES_4
    SCST_LTORG
m4_scst_mac_test1_ltorg_jump_1:
    /***************************************************************************************************
    * Unsigned Long Multiply
    *   - Multiplies the two unsigned 32 bits integers in the first and second operands.
    *   - Writes the least significant 32 bits of the result in RdLo.
    *   - Writes the most significant 32 bits of the result in RdHi.
    *
    *   UMULL RdLo, RdHi, Rn, Rm
    *   RdHi,RdLo:=unsigned(Rn*Rm)
    *
    * Covers:
    *   - use 32 bits into 32x32 multiplier for rd_a
    *   - use 32 bits into 32x32 multiplier for rd_b
    ***************************************************************************************************/
    LDR     R11,=0x55555556
    LDR     R4,=0xFFFFFFFF
    /* UMULL Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    UMULL   R7,R8,R11,R4
    CMP     R7,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    CMP     R8,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R4,=0xAAAAAAAB
    LDR     R11,=0xFFFFFFFF
    /* UMULL Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    UMULL   R8,R7,R4,R11
    CMP     R8,#0x55555555
    BNE     m4_scst_test_tail_end
    CMP     R7,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x01E1
    
    
    /***************************************************************************************************
    * Unsigned Long Multiply, with Accumulate
    *   - Multiplies the two unsigned 32 bits integers in the first and second operands.
    *   - Adds the 64 bits result to the 64 bits unsigned integer contained in RdHi and RdLo.
    *   - Writes the result back to RdHi and RdLo.
    *
    *   UMLAL RdLo, RdHi, Rn, Rm
    *   RdHi,RdLo:=unsigned(RdHi,RdLo + Rn*Rm)
    *
    * Covers:
    *   - use 32 bits into 32x32 multiplier for rd_a
    *   - use 32 bits into 32x32 multiplier for rd_b
    *   - rd_x into lower word of accumulator
    *   - rd_y into higher word of accumulator
    ***************************************************************************************************/
    LDR     R7,=0x55555556
    LDR     R8,=0xFFFFFFFF
    LDR     R11,=0x11111111
    LDR     R4,=0x55555555
    /* UMLAL Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    UMLAL   R11,R4,R7,R8 /* R11,R4 + 0x55555556 * 0xFFFFFFFF = 0xAAAAAAAA BBBBBBBB */
    CMP     R11,#0xBBBBBBBB
    BNE     m4_scst_test_tail_end
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
     
    LDR     R8,=0xAAAAAAAA
    LDR     R7,=0x80000000
    LDR     R4,=0x55555555
    LDR     R11,=0x11111111
    /* UMLAL Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    UMLAL   R4,R11,R8,R7 /* R4,R11 + 0xAAAAAAAA *0x80000000 = 0x66666666 55555555 */
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    CMP     R11,#0x66666666
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0BEA
    
    
    /***************************************************************************************************
    * Unsigned Long Multiply with Accumulate Accumulate
    *   - Multiplies the two unsigned 32-bit integers in the first and second operands.
    *   - Adds the unsigned 32-bit integer in RdHi to the 64-bit result of the multiplication.
    *   - Adds the unsigned 32-bit integer in RdLo to the 64-bit result of the addition.
    *   - Writes the top 32-bits of the result to RdHi.
    *   - Writes the lower 32-bits of the result to RdLo.
    *
    *   UMAAL RdLo, RdHi, Rn, Rm
    *   RdHi,RdLo:=unsigned(RdHi + RdLo + Rn*Rm)
    *
    * Covers:
    *   - use 32 bits into 32x32 multiplier for rd_a
    *   - use 32 bits into 32x32 multiplier for rd_b
    ***************************************************************************************************/
    LDR     R5,=0xAAAAAAAB
    LDR     R10,=0xFFFFFFFF
    LDR     R12,=0x22222222
    LDR     R3,=0x33333333
    /* UMAAL Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    UMAAL   R3,R12,R5,R10
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    CMP     R12,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R10,=0xAAAAAAAA
    LDR     R5,=0x80000000
    LDR     R12,=0x22222222
    LDR     R3,=0x33333333
    /* UMAAL Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    UMAAL   R12,R3,R10,R5
    CMP     R12,#0x55555555
    BNE     m4_scst_test_tail_end
    CMP     R3,#0x55555555
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x041F
    
    
    /***************************************************************************************************
    * Signed Long Multiply
    *   - Interprets the values from Rn and Rm as 2s complement 32-bit signed integers.
    *   - It multiplies Rn and Rm
    *   - Writes the least significant 32 bits of the result in RdLo. 
    *   - Writes the most significant 32 bits of the result in RdHi.
    *
    *   SMULL RdLo, RdHi, Rn, Rm
    *   RdHi,RdLo:=signed(Rn*Rm)
    *
    * Covers:
    *   - use 32 bits into 32x32 multiplier for rd_a
    *   - use 32 bits into 32x32 multiplier for rd_b
    ***************************************************************************************************/
    LDR     R3,=0xAAAAAAAB /* -0x55555555)*/
    LDR     R12,=0xFFFFFFFF /* -1 */
    /* SMULL Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    SMULL   R5,R10,R3,R12
    CMP     R5,#0x55555555
    BNE     m4_scst_test_tail_end
    CMP     R10,#0x0
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0x55555555 /* 0x55555555 */
    LDR     R3,=0xFFFFFFFF /* -1 */
    /* SMULL Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    SMULL   R10,R5,R12,R3
    CMP     R10,#0xAAAAAAAB
    BNE     m4_scst_test_tail_end
    CMP     R5,#0xFFFFFFFF
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0F62
    
    
    /***************************************************************************************************
    * Signed Long Multiply, with Accumulate
    *   - Interprets the values from Rn and Rm as 2s complement 32bit signed integers.
    *   - It multiplies Rn and Rm.
    *   - Adds the 64-bit result to the 64-bit signed integer contained in RdHi and RdLo,
    *   - Writes the least significant 32 bits of the result in RdLo. 
    *   - Writes the most significant 32 bits of the result in RdHi.
    *
    *   SMLAL RdLo, RdHi, Rn, Rm
    *   RdHi,RdLo:=signed(RdHi,RdLo + Rn*Rm)
    *
    * Covers:
    *   - use 32 bits into 32x32 multiplier for rd_a
    *   - use 32 bits into 32x32 multiplier for rd_b
    *   - rd_x into lower word of accumulator
    *   - rd_y into higher word of accumulator
    ***************************************************************************************************/
    LDR     R0,=0xAAAAAAAB /* -0x55555555 */
    LDR     R7,=0x1
    LDR     R3,=0xAAAAAAAA
    LDR     R4,=0x55555555
    /* SMLAL Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    SMLAL   R3,R4,R0,R7
    CMP     R3,#0x55555555
    BNE     m4_scst_test_tail_end
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0xAAAAAAAB /* -0x55555555 */
    LDR     R0,=0xFFFFFFFF /* -1 */
    LDR     R4,=0x55555555
    LDR     R3,=0xAAAAAAAA
    /* SMLAL Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    SMLAL   R4,R3,R7,R0
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0876
    
    
    /***************************************************************************************************
    * Signed Multiply (halfwords)
    *   - Interprets the values from Rn and Rm as four signed 16-bit integers
    *   - Multiplies the specified signed halfword, Top or Bottom, values from Rn and Rm.
    *   - Writes the 32-bit result of the multiplication in Rd.
    *
    *   SMULxy Rd, Rn, Rm
    *   Rd:=Rn[x]*Rm[y]
    *
    * Covers:
    *   - use lower 16 bits into 16x16 multiplier for rd_a
    *   - use higher 16 bits into 16x16 multiplier for rd_a
    *   - use lower 16 bits into 16x16 multiplier for rd_b
    *   - use higher 16 bits into 16x16 multiplier for rd_b
    ***************************************************************************************************/
    LDR     R1,=0xAAAB5555 /* -0x5555, 0x5555 */
    LDR     R2,=0x0001FFFF /* 1, -1 */
    /* SMULBB Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMULBB  R3,R1,R2    /* 0x5555*(-1) = -0x5555 (0xFFFFAAAB) */
    LDR     R4,=0xFFFFAAAB
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    /* SMULBT Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMULBT  R12,R1,R2    /* 0x5555*1 = 0x00005555 */
    LDR     R4,=0x00005555
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    
    /* SMULTT Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMULTT  R5,R1,R2    /* -0x5555*1 = -0x5555 (0xFFFFAAAB) */
    LDR     R4,=0xFFFFAAAB
    CMP     R5,R4
    BNE     m4_scst_test_tail_end
    
    /* SMULTB Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMULTB  R10,R1,R2    /* - 0x5555*(-1) = 0x00005555 */
    LDR     R4,=0x00005555
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x05AF
    
    
    /***************************************************************************************************
    * Signed Multiply (word by halfword)
    *   - Interprets the values from Rn as a 32-bit signed integer and Rm as two halfword 16-bit signed integers.
    *   - Multiplies the first operand and the top, T suffix, or the bottom, B suffix, halfword of the second operand.
    *   - Writes the signed most significant 32 bits of the 48-bit result in the destination register.
    *
    *   SMULWy Rd, Rn, Rm
    *   Rd:=Rn*Rm[y][47:16]
    *
    * Covers:
    *   - use 32 bits into 32x32 multiplier for rd_a
    *   - use lower 16 bits into 32x32 multiplier for rd_b
    *   - use higher 16 bits into 32x32 multiplier for rd_b
    ***************************************************************************************************/
    LDR     R2,=0x55555555
    LDR     R1,=0x0001FFFF /* 1, -1 */
    /* SMULWB Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMULWB  R7,R2,R1    /* 0x55555555 * (-1) = -0x55555555 (0xFFFF AAAA AAAB)[47:16] = 0xFFFFAAAA */
    LDR     R4,=0xFFFFAAAA     /* check [47:16] bits */
    CMP     R7,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0xAAAAAAAB /* - 0x55555555 */
    LDR     R2,=0xFFFF0001 /* -1, 1 */
    /* SMULWT Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMULWT  R8,R1,R2    /* - 0x55555555 * (-1) = 0x55555555 (0x0000 5555 5555) */
    LDR     R4,=0x00005555     /* check [47:16] bits */
    CMP     R8,R4
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0341
    
    
    /***************************************************************************************************
    * Signed Multiply Accumulate Long (halfwords)
    *   - Interprets the values from Rn and Rm as four signed 16-bit integers
    *   - Multiplies the specified signed halfword, Top or Bottom, values from Rn and Rm.
    *   - Adds the value in Ra to the resulting 32-bit product.
    *   - Writes the result of the multiplication and addition in Rd.
    *
    *   SMLAxy Rd, Rn, Rm, Ra
    *   Rd:=Ra + Rn[x]*Rm[y]
    *
    * Covers:
    *   - use lower 16 bits into 16x16 multiplier for rd_a
    *   - use higher 16 bits into 16x16 multiplier for rd_a
    *   - use lower 16 bits into 16x16 multiplier for rd_b
    *   - use higher 16 bits into 16x16 multiplier for rd_b
    *   - sign extend rd_x in lower accumulator word
    ***************************************************************************************************/
    LDR     R1,=0xAAAB5555 /* -0x5555, 0x5555 */
    LDR     R2,=0x0001FFFF /* 1, -1 */
    LDR     R4,=0x0
    /* SMLABB Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMLABB  R11,R1,R2,R4    /* 0x00000000 + 0x5555 * (-1) = 0xAAAA5555 */
    LDR     R4,=0xFFFFAAAB     
    CMP     R11,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R11,=0xAAAA5555
    /* SMLABT Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMLABT  R4,R1,R2,R11    /* 0xAAAA5555 + 0x5555 * 1 = 0xAAAAAAAA */
    LDR     R3,=0xAAAAAAAA     
    CMP     R4,R3
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0x55550000
    /* SMLATB Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMLATB  R3,R1,R2,R12    /* 0x55550000 + (-0x5555) * (-1) = 0x55555555 */
    LDR     R4,=0x55555555
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xAAAAAAAA
    /* SMLATT Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMLATT  R12,R1,R2,R3    /* 0xAAAAAAAA + (-0x5555) * 1 = 0xAAAA5555 */
    LDR     R4,=0xAAAA5555     
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x07F1
    
    
    /***************************************************************************************************
    * Signed Multiply Accumulate (word by halfword)
    *   - Interprets the values from Rn as a 32-bit signed integer and Rm as two halfword 16-bit signed integers.
    *   - Multiply the 32-bit signed values in Rn the top or bottom signed halfword of Rm.
    *   - Add the 32-bit signed value in Ra to the top 32 bits of the 48-bit product
    *   - Writes the result of the multiplication and addition in Rd.
    *    
    *   SMLAWy Rd, Rn, Rm, Ra
    *   Rd:=Ra + (Rn*Rm[y])[47:16]
    *
    * Covers:
    *   - use 32 bits into 32x32 multiplier for rd_a
    *   - use lower 16 bits into 32x32 multiplier for rd_b
    *   - use higher 16 bits into 32x32 multiplier for rd_b
    ***************************************************************************************************/
    LDR     R2,=0xAAAAAAAB /* -0x55555555 */
    LDR     R1,=0x7FFFFFFF /* 0x7FFF, -1 */
    LDR     R5,=0xAAAA5555
    /* SMLAWB Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMLAWB  R10,R2,R1,R5    /* 0xAAAA5555 + [(-0x55555555) * (-1)][47:16] = 0xAAAAAAAA */
    LDR     R4,=0xAAAAAAAA
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R2,=0x55555556
    LDR     R10,=0x2AAB0000
    /* SMLAWT Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMLAWT  R5,R2,R1,R10     /* 0x2AAB0000 + [0x55555556 * 0x7fff][47:16] = 0x55555555 */
    LDR     R4,=0x55555555
    CMP     R5,R4
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x08E5
    
    
    /***************************************************************************************************
    * Signed Multiply Accumulate Long (halfwords)
    *   - Interprets the values from Rn and Rm as four halfword 2s complement signed 16-bit integers.
    *   - Multiplies Rn and Rm.
    *   - Adds the 64-bit value in RdLo and RdHi to the resulting 64-bit product.
    *   - Writes the 64-bit result of the multiplication and addition in RdLo and RdHi.
    *
    *   SMLALxy RdLo, RdHi, Rn, Rm
    *   RdHi,RdLo:=RdHi,RdLo + Rn[x]*Rm[y]
    *
    * Covers:
    *   - use lower 16 bits into 16x16 multiplier for rd_a
    *   - use higher 16 bits into 16x16 multiplier for rd_a
    *   - use lower 16 bits into 16x16 multiplier for rd_b
    *   - use higher 16 bits into 16x16 multiplier for rd_b
    *   - rd_x into lower word of accumulator
    *   - rd_y into higher word of accumulator
    ****************************************************************************************************/
    LDR     R7,=0x5555AAAB /* 0x5555, -0x5555 */
    LDR     R8,=0x7FFF8001 /* 0x7FFF, -0x7FFF */
    LDR     R3,=0x2AAB2AAA
    LDR     R4,=0x0
    /* SMLALTT Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    SMLALTT R3,R4,R7,R8     /* 0x2AAB2AAA + 0x5555 * 0x7FFF = 0x55555555 */
    CMP     R3,#0x55555555
    BNE     m4_scst_test_tail_end
    CMP     R4,#0x0
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xD554D555 /* FFFFFFFF D554D555 = -0x2AABSAAB */
    LDR     R4,=0xFFFFFFFF
    /* SMLALTB Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    SMLALTB R3,R4,R7,R8     /* -2AAB2AAB + 0x5555 * (-0x7FFF) = -0x55555556 = FFFFFFFF AAAAAAAA */
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    CMP     R4,#0xFFFFFFFF
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xD554D555
    LDR     R4,=0x0
    /* SMLALBT Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    SMLALBT R3,R4,R7,R8     /* 0xD554D55 + (-0x5555) * 0x7FFF = 0xAAAAAAAA */
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    CMP     R4,#0x0
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0x2AAB2AAA /* FFFFFFFF 2AAB2AAA = 0xD554D556 */
    LDR     R4,=0xFFFFFFFF
    /* SMLALBB Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    SMLALBB R3,R4,R7,R8     /* -0xD554D556 + (-0x5555)*(-0x7FFF) = -0xAAAAAAAB = FFFFFFFF 55555555 */
    CMP     R3,#0x55555555
    BNE     m4_scst_test_tail_end
    CMP     R4,#0xFFFFFFFF
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0C15
    
    
    /***************************************************************************************************
    * Signed Dual Multiply Add (Reversed)
    *   - Interprets the values from Rn and Rm as four halfword 2s complement signed 16-bit integers.
    *   - Optionally rotates the halfwords of the Rm. X
    *   - Performs two signed 16 x 16-bit multiplications.
    *   - Adds the two multiplication results together.
    *   - Writes the result of the addition to the destination register.
    *    
    *   SMUAD(X) Rd, Rn, Rm
    *   Rd:=Rn[15:0]*RmX[15:0] + Rn[31:16]*RmX[31:16]
    *
    * Covers:
    *   - use lower 16 bits into 16x16 multiplier for rd_a
    *   - use higher 16 bits into 16x16 multiplier for rd_a
    *   - use lower 16 bits into 16x16 multiplier for rd_b
    *   - use higher 16 bits into 16x16 multiplier for rd_b
    ***************************************************************************************************/
    LDR     R1,=0x5555AAAB /* 0x5555, -0x5555 */
    LDR     R2,=0x0001FFFF /* 1, -1 */
    /* SMUAD Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMUAD   R3,R1,R2    /* (-0x5555)*(-1) + 0x5555*1 = 0xAAAA */
    LDR     R4,=0x0000AAAA
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    /* SMUADX Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMUADX  R6,R1,R2    /* (-0x5555)*1 + 0x5555*(-1) = -0xAAAA = 0xFFFF5556 */
    LDR     R4,=0xFFFF5556
    CMP     R6,R4
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x03FA
    
    
    /***************************************************************************************************
    * Signed Multiply Accumulate Long Dual (Reversed)
    *   - Interprets the values from Rn and Rm as four halfword 2s complement signed 16-bit integers
    *   - Optionally rotates the halfwords of the Rm. (X)
    *   - Performs two signed 16 x 16-bit multiplications.
    *   - Adds both multiplication results to the signed 32-bit value in Ra.
    *   - Writes the result of the addition to the destination register.
    *
    *   SMLAD(X) Rd, Rn, Rm, Ra
    *   Rd:=Ra + Rn[15:0]*RmX[15:0] + Rn[31:16]*RmX[31:16]
    *
    * Covers:
    *   - use lower 16 bits into 16x16 multiplier for rd_a
    *   - use higher 16 bits into 16x16 multiplier for rd_a
    *   - use lower 16 bits into 16x16 multiplier for rd_b
    *   - use higher 16 bits into 16x16 multiplier for rd_b
    *   - sign extend rd_x in lower accumulator word
    ***************************************************************************************************/
    LDR     R5,=0x5555AAAB /* 0x5555, -0x5555 */
    LDR     R6,=0x0001FFFF /* 1, -1 */
    LDR     R4,=0x55550000
    /* SMLAD Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMLAD   R3,R5,R6,R4     /* 0x55550000 + (-0x5555)*(-1) + 0x5555*1 = 0x5555AAAA */
    LDR     R4,=0x5555AAAA
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R11,=0xAAAAFFFF
    /* SMLADX Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMLADX  R3,R5,R6,R11     /* 0xAAAAFFFF + (-0x5555)*1 + 0x5555*(-1) = 0xAAAA5555 */ 
    LDR     R4,=0xAAAA5555
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x068B
    
    
    /***************************************************************************************************
    * Signed Multiply Accumulate Long Dual (Reversed)
    *   - Interprets the values from Rn and Rm as four halfword 2s complement signed 16-bit integers
    *   - Optionally rotates the halfwords of the second operand.(X)
    *   - Performs two signed 16 x 16-bit multiplications.
    *   - Adds the two multiplication results to the signed 64-bit value in RdLo and RdHi.
    *   - Writes the 64-bit product in RdLo and RdHi.
    *    
    *   SMLALD(X) RdLo, RdHi, Rn, Rm
    *   RdHi,RdLo:=RdHi,RdLo + Rn[15:0]*RmX[15:0] + Rn[31:16]*RmX[31:16]
    *
    * Covers:
    *   - use lower 16 bits into 16x16 multiplier for rd_a
    *   - use higher 16 bits into 16x16 multiplier for rd_a
    *   - use lower 16 bits into 16x16 multiplier for rd_b
    *   - use higher 16 bits into 16x16 multiplier for rd_b
    *   - rd_x into lower word of accumulator
    *   - rd_y into higher word of accumulator
    ***************************************************************************************************/
    LDR     R1,=0x5555AAAB /* 0x5555, -0x5555 */
    LDR     R2,=0x0001FFFF /* 1, -1 */
    LDR     R3,=0xFFFF5556
    LDR     R4,=0xFFFFFFFF
    /* SMLALD Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    SMLALD  R3,R4,R1,R2     /* -0xAAAA + (-0x5555)*(-1) + 0x5555*1 = 0x0 */
    CMP     R3,#0x0
    BNE     m4_scst_test_tail_end
    CMP     R4,#0x0
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xAAA9
    LDR     R4,=0x0
    /* SMLALX Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    SMLALDX R3,R4,R1,R2     /* 0xAAAA9 + (-0x5555)*1 + 0x5555*(-1) = -1 = FFFFFFFF FFFFFFFF */
    CMP     R3,#0xFFFFFFFF
    BNE     m4_scst_test_tail_end
    CMP     R4,#0xFFFFFFFF
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x09AE
    
    
    /***************************************************************************************************
    * Signed Dual Multiply Subtract (Reversed)
    *   - Interprets the values from the first and second operands as 2s complement signed 16-bit integers.
    *   - Optionally rotates the halfwords of the second operand.(X)
    *   - Performs two signed 16 x 16-bit multiplications.
    *   - Subtracts the result of the top halfword multiplication from the result of the bottom halfword multiplication.
    *   - Writes the result of the subtraction to the destination register.
    *
    *   SMUSD(X) Rd, Rn, Rm
    *   Rd:=Rn[15:0]*RmX[15:0] - Rn[31:16]*RmX[31:16]
    *
    * Covers:
    *   - use lower 16 bits into 16x16 multiplier for rd_a
    *   - use higher 16 bits into 16x16 multiplier for rd_a
    *   - use lower 16 bits into 16x16 multiplier for rd_b
    *   - use higher 16 bits into 16x16 multiplier for rd_b
    ***************************************************************************************************/
    LDR     R7,=0x55555555 /* 0x5555, 0x5555 */
    LDR     R8,=0xFFFF0001 /* -1, 1 */
    /* SMUSD Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMUSD   R6,R7,R8    /* 0x5555*1 - 0x5555*(-1) = 0xAAAA */
    LDR     R4,=0x0000AAAA
    CMP     R6,R4
    BNE     m4_scst_test_tail_end
    
    /* SMUSDX Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMUSDX  R1,R7,R8    /* 0x5555*(-1) - 0x5555*(1) = -0xAAAA = 0xFFFF5556 */
    LDR     R4,=0xFFFF5556
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0E7B
    
    
    /***************************************************************************************************
    * Signed Multiply Subtract Dual (Reversed)
    *   - Interprets the values from the first and second operands as 2s complement signed 16-bit integers.
    *   - Optionally rotates the halfwords of the second operand.
    *   - Performs two signed 16 x 16-bit halfword multiplications.
    *   - Subtracts the result of the top halfword multiplication from the result of the bottom halfword multiplication.
    *   - Adds the signed accumulate value to the result of the subtraction.
    *   - Writes the result of the addition to the destination register.
    *
    *   SMLSD(X) Rd, Rn, Rm, Ra
    *   Rd:=Ra + Rn[15:0]*RmX[15:0] - Rn[31:16]*RmX[31:16]
    *
    * Covers:
    *   - use lower 16 bits into 16x16 multiplier for rd_a
    *   - use higher 16 bits into 16x16 multiplier for rd_a
    *   - use lower 16 bits into 16x16 multiplier for rd_b
    *   - use higher 16 bits into 16x16 multiplier for rd_b
    *   - sign extend rd_x in lower accumulator word
    ***************************************************************************************************/
    LDR     R1,=0x55555555 /* 0x5555, 0x5555 */
    LDR     R2,=0xFFFF0001 /* -1, 1 */
    LDR     R8,=0x55550000
    /* SMLSD Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMLSD   R3,R1,R2,R8     /* 0x55550000 + 0x5555*1 - 0x5555*(-1) = 0x5555AAAA */
    LDR     R4,=0x5555AAAA
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0xAAAAFFFF
    /* SMLSDX Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMLSDX  R3,R1,R2,R7     /* 0xAAAAFFFF + 0x5555*(-1) - 0x5555*1 = 0xAAAA5555 */
    LDR     R4,=0xAAAA5555
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x05F2
    
    
    /***************************************************************************************************
    * Signed Multiply Subtract Long Dual (Reversed)
    *   - Interprets the values from the first and second operands as 2s complement signed 16-bit integers.
    *   - Optionally rotates the halfwords of the second operand.
    *   - Performs two signed 16 x 16-bit halfword multiplications.
    *   - Subtracts the result of the upper halfword multiplication from the result of the lower halfword multiplication.
    *   - Adds the 64-bit value in RdHi and RdLo to the result of the subtraction.
    *   - Writes the 64-bit result of the addition to the RdHi and RdLo.
    *
    *   SMLSLD(X) RdHi, RdLo, Rn, Rm
    *   RdHi,RdLo:=RdHi,RdLo + Rn[15:0]*RmX[15:0] - Rn[31:16]*RmX[31:16]
    *
    * Covers:
    *   - use lower 16 bits into 16x16 multiplier for rd_a
    *   - use higher 16 bits into 16x16 multiplier for rd_a
    *   - use lower 16 bits into 16x16 multiplier for rd_b
    *   - use higher 16 bits into 16x16 multiplier for rd_b
    *   - rd_x into lower word of accumulator
    *   - rd_y into higher word of accumulator
    ***************************************************************************************************/
    LDR     R1,=0x55555555 /* 0x5555, 0x5555 */
    LDR     R2,=0xFFFF0001 /* -1, 1 */
    LDR     R3,=0xFFFF5556
    LDR     R12,=0xFFFFFFFF
    /* SMLSLD Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    SMLSLD  R3,R12,R1,R2     /* -0xAAAA + 0x5555*1 - 0x5555*(-1) = 0 */
    CMP     R3,#0x0
    BNE     m4_scst_test_tail_end
    CMP     R12,#0x0
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0xAAA9
    LDR     R3,=0x0
    /* SMLSLDX Encoding T1 32bit - "Long multiply, long multiply accumulate, and divide" instruction */
    SMLSLDX R12,R3,R1,R2     /* 0xAAA9 + 0x5555*(-1) - 0x5555*1 = -1 = 0xFFFFFFFF FFFFFFFF */
    CMP     R12,#0xFFFFFFFF
    BNE     m4_scst_test_tail_end
    CMP     R3,#0xFFFFFFFF
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x04EA
    
    
    /***************************************************************************************************
    * Signed Most Significant Word Multiply
    *   - Interprets the values from Rn and Rm as 2s complement 32-bit signed integers.
    *   - Multiplies the values from Rn and Rm.
    *   - Optionally rounds the result by adding 0x80000000.(R)
    *   - Writes the most significant signed 32 bits of the result in Rd.
    *   
    *   SMMUL(R) Rd, Rn, Rm
    *   Rd:=(Rn*Rm)[63:32]
    *
    * Covers:
    *   - use 32 bits into 32x32 multiplier for rd_a
    *   - use 32 bits into 32x32 multiplier for rd_b
    *   - rounding
    ***************************************************************************************************/
    LDR     R2,=0x6AAAAAAB
    LDR     R1,=0x80000001 /* - 0x7FFFFFFF */
    /* SMMUL Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMMUL   R5,R2,R1    /* 0x6AAAAAAB * (-0x7FFFFFFF) = 0xCAAAAAAA[63:32] EAAAAAAB */
    LDR     R4,=0xCAAAAAAA /* 0xCAAAAAAA */
    CMP     R5,R4
    BNE     m4_scst_test_tail_end
    
    /* SMMULR Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMMULR  R10,R2,R1    /* 0xCAAAAAAA EAAAAAAB + 0x80000000 = 0xCAAAAAAB[63:32] EAAAAAAB*/
    LDR     R4,=0xCAAAAAAB
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0B23
    
    
    /***************************************************************************************************
    * Signed Most Significant Word Multiply Accumulate
    *   - Interprets the values from Rn and Rm as 2s complement 32-bit signed integers.
    *   - Multiplies the values in Rn and Rm.
    *   - Optionally rounds the result by adding 0x80000000.(R)
    *   - Extracts the most significant 32 bits of the result.
    *   - Adds the value of Ra to the signed extracted value.
    *   - Writes the result of the addition in Rd.
    *
    *   SMMLA(R) Rd, Rn, Rm, Ra
    *   Rd:=Ra + (Rn*Rm)[63:32]
    *
    * Covers:
    *   - use 32 bits into 32x32 multiplier for rd_a
    *   - use 32 bits into 32x32 multiplier for rd_b
    *   - rounding
    *   - sign extend rd_x in lower accumulator word
    ***************************************************************************************************/
    LDR     R5,=0x6AAAAAAB
    LDR     R10,=0x80000001 /* -0x7FFFFFFF */
    LDR     R4,=0xE0000000 /* -0x20000000 */
    /* SMMLA Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMMLA   R3,R5,R10,R4     /* R4 + 0x6AAAAAAB * (-0x7FFFFFFF) = R4 + 0xCAAAAAAA[63:32] EAAAAAAB
                             (-0x20000000) + 0xCAAAAAAA = 0xAAAAAAAA */
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0x8AAAAAAA /* -0x75555556 */
    /* SMMLAR Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMMLAR  R4,R5,R10,R3     /*  0x6AAAAAAB * (-0x7FFFFFFF) + 0x80000000 = R4 + 0xCAAAAAAB[63:32] EAAAAAAB
                              (-0x75555556) + 0xCAAAAAAB = 0x55555555 */
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0E42
    
    
    /***************************************************************************************************
    * Signed Most Significant Word Multiply Subtract
    *   - Interprets the values from Rn and Rm as 2s complement 32-bit signed integers.
    *   - Multiplies the values in Rn and Rm.
    *   - Optionally rounds the result by adding 0x80000000.
    *   - Extracts the most significant 32 bits of the result.
    *   - Subtracts the extracted value of the result from the value in Ra.
    *   - Writes the result of the subtraction in Rd.
    *
    *   SMMLS(R) Rd, Rn, Rm, Ra
    *   Rd:= Ra - (Rn*Rm)[63:32]
    *
    * Covers:
    *   - use 32 bits into 32x32 multiplier for rd_a
    *   - use 32 bits into 32x32 multiplier for rd_b
    *   - rounding
    *   - negate 32 bit multiply multiply result
    *   - sign extend rd_x in lower accumulator word
    *******************************************************************/
    LDR     R10,=0x6AAAAAAB
    LDR     R5,=0x7FFFFFFF 
    LDR     R4,=0xE0000000 /* -0x20000000 */
    /* SMMLS Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMMLS   R7,R10,R5,R4     /* R4 - 0x6AAAAAAB * 0x7FFFFFFF = R4 + 0xCAAAAAAA[63:32] EAAAAAAB
                            (-0x20000000) + 0xCAAAAAAA = 0xAAAAAAAA */
    CMP     R7,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R4,=0x8AAAAAAA /* -0x75555556 */
    /* SMMLSR Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    SMMLSR  R8,R10,R5,R4     /* R4 - 0x6AAAAAAB * 0x7FFFFFFF +0x80000000 = R4 + 0xCAAAAAAB[63:32] EAAAAAAB
                            (-0x75555556) + 0xCAAAAAAB = 0x55555555 */                             
    CMP     R8,#0x55555555
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x03BC
    
    
    /***************************************************************************************************
    * Unsigned Sum of Absolute Differences and Accumulate.
    *   - Subtracts each byte of the second operand register from the corresponding byte of the first operand register.
    *   - Adds the unsigned absolute differences together.
    *   - Adds the accumulation value to the sum of the absolute differences.
    *   - Writes the result to the destination register.
    *
    * Covers:
    *   - USAD
    *******************************************************************/
    LDR     R1,=0xAAAAAAAA
    LDR     R2,=0x55555555
    LDR     R0,=0x11111111
    /* USADA8 Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    USADA8  R3,R1,R2,R0
    LDR     R4,=0x11111265
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    /* USAD8 Encoding T1 32bit - "Multiply, multiply accumulate, and absolute difference" instruction */
    USAD8   R0,R1,R2
    MOV     R4,#0x00000154
    CMP     R0,R4
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0111
    
    
    MOV     R0,R9          /* Test result is returned in R0, according to the conventions */
    
    B       m4_scst_test_tail_end

    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */    
    
    SCST_FILE_END
