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
* Tests SIMDSAT module Parallel addition and subtraction instructions 
* as well as their decoding:
*              SADD16   SHADD16     UADD16      UHADD16
*              SASX     SHASX       UASX        UHASX
*              SSAX     SHSAX       USAX        UHSAX
*              SSUB16   SHSUB16     USUB16      UHSUB16
*              SADD8    SHADD8      UADD8       UHADD8
*              SSUB8    SHSUB8      USUB8       UHSUB8
*    
* Overall coverage:
* -----------------
* SIMDSAT:
* - GE flag generation and setting logic, parallel addition 
*   and subtraction 
*
* DECODER:
* Thumb (32-bit)
*   - Encoding of "Data processing (register)" instructions
测试总结：
* -------------
* 测试 SIMDSAT 模块并行加减指令
* 以及它们的解码：
* SADD16 SHADD16 UADD16 UHADD16
* SASX SHASX UASX UHASX
* SSAX SHSAX USAX UHSAX
* SSUB16 SHSUB16 USUB16 UHSUB16
* SADD8 SHADD8 UADD8 UHADD8
* SSUB8 SHSUB8 USUB8 UHSUB8
*
* 整体覆盖：
* -----------------
* SIMDSAT：
* - GE标志生成和设置逻辑，并行添加
* 和减法
*
* 解码器：
* 拇指（32 位）
* - “数据处理（寄存器）”指令的编码

* 
******************************************************************************/

#include "m4_scst_compiler.h"
    
    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_simdsat_test2

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    SCST_EXTERN m4_scst_clear_flags
    

    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_simdsat_test2" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_simdsat_test2, function)
m4_scst_simdsat_test2:

    PUSH.W  {R1-R12,R14}
    
    /* R6 is used as intermediate result */
    LDR     R6,=0x78C5C584
    
    /*--------------------------------------------------------------------*/
    /* SADD16, UADD16                                                     */
    /*--------------------------------------------------------------------*/
    LDR     R10,=0x55555555
    LDR     R5,=0xAAAAAAAA
    LDR     R4,=0x00000000
    
    LDR     R2,=0x55545554
    SADD16  R3,R5,R5
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge
    UADD16  R12,R5,R5
    CMP     R12,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    
    SADD16  R3,R10,R10
    CMP     R3,R5
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    UADD16  R12,R10,R10
    CMP     R12,R5
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge
    
    LDR     R2,=0x55555555
    SADD16  R7,R4,R10
    CMP     R7,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    UADD16  R8,R4,R10
    CMP     R8,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge
    
    ADDW    R6,R6,#0x789
    
    /*--------------------------------------------------------------------*/
    /* SHADD16, UHADD16                                                   */
    /*--------------------------------------------------------------------*/
    LDR     R12,=0x55555555
    LDR     R3,=0xAAAAAAAA
    LDR     R4,=0x00000000
    
    LDR     R2,=0xAAAAAAAA
    SHADD16 R5,R3,R3
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    UHADD16 R10,R3,R3
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R2,=0x55555555
    SHADD16 R10,R12,R12
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    UHADD16 R5,R12,R12
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R1,=0xFE01CD23
    LDR     R2,=0xFF00E691
    SHADD16 R5,R4,R1
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    LDR     R2,=0x7F006691 
    UHADD16 R10,R4,R1
    CMP     R10,R2
    BNE     m4_scst_test_tail_end 
    
    ADDW    R6,R6,#0x789
    
    /*--------------------------------------------------------------------*/
    /* SHADD8, UHADD8                                                     */
    /*--------------------------------------------------------------------*/
    LDR     R8,=0x55555555
    LDR     R7,=0xAAAAAAAA
    LDR     R4,=0x00000000
    
    LDR     R2,=0xAAAAAAAA
    SHADD8  R3,R7,R7
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    UHADD8  R12,R7,R7
    CMP     R12,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R2,=0x55555555
    SHADD8  R12,R8,R8
    CMP     R12,R2
    BNE     m4_scst_test_tail_end
    UHADD8  R3,R8,R8
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0x04F3CD45
    LDR     R2,=0x02F9E622
    SHADD8  R3,R4,R8
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    LDR     R2,=0x02796622
    UHADD8  R12,R4,R8
    CMP     R12,R2
    BNE     m4_scst_test_tail_end 
    
    ADDW    R6,R6,#0x789
    
    /*--------------------------------------------------------------------*/
    /* SADD8, UADD8                                                       */
    /*--------------------------------------------------------------------*/
    LDR     R8,=0x55555555
    LDR     R7,=0xAAAAAAAA
    LDR     R4,=0x00000000
    
    LDR     R2,=0x54545454
    SADD8   R9,R7,R7
    CMP     R9,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge
    UADD8   R11,R7,R7
    CMP     R11,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    
    B m4_scst_simdsat_test2_ltorg_jump_1 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_simdsat_test2_ltorg_jump_1:
    
    SADD8   R9,R8,R8
    CMP     R9,R7
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    UADD8   R11,R8,R8
    CMP     R11,R7
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge
    
    LDR     R2,=0x55555555
    SADD8   R9,R4,R8
    CMP     R9,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    UADD8   R11,R4,R8
    CMP     R11,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge
    
    LDR     R2,=0x12345678
    SADD8   R11,R4,R2
    CMP     R11,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    UADD8   R9,R4,R2
    CMP     R9,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge
    
    ADDW    R6,R6,#0x789
    
    /*--------------------------------------------------------------------*/
    /* SASX, UASX                                                         */
    /*--------------------------------------------------------------------*/
    LDR     R11,=0x55555555
    LDR     R9,=0x5556AAAA
    LDR     R4,=0x00000000
    
    LDR     R2,=0xFFFFFFFF
    SASX    R7,R11,R9
    CMP     R7,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge
    UASX    R7,R11,R9
    CMP     R7,R2
    BNE     m4_scst_test_tail_end
    BL      m4_scst_simdsat_test2_check_ge
    
    LDR     R9,=0xAAAAAAAA
    LDR     R11,=0xAAAA5556        
    LDR     R4,=0x00000000
    SASX    R8,R9,R11
    CMP     R8,R4
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    UASX    R8,R9,R11
    CMP     R8,R4
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    
    LDR     R9,=0x00050005
    LDR     R2,=0x0005FFFB
    SASX    R7,R4,R9
    CMP     R7,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000C
    BL      m4_scst_simdsat_test2_check_ge
    UASX    R8,R4,R9
    CMP     R8,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge 
    
    ADDW    R6,R6,#0x789  
    
    /*--------------------------------------------------------------------*/
    /* SHASX, UHASX                                                       */
    /*--------------------------------------------------------------------*/
    LDR     R8,=0x55555555
    LDR     R7,=0x5556AAAA
    LDR     R4,=0x00000000
    
    LDR     R2,=0xFFFFFFFF
    SHASX   R5,R8,R7
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    LDR     R2,=0x7FFFFFFF    
    UHASX   R5,R8,R7
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0xAAAAAAAA
    LDR     R8,=0xAAAA5556        
    LDR     R2,=0x00000000
    SHASX   R5,R7,R8
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    LDR     R2,=0x80000000    
    UHASX   R5,R7,R8
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0x00050005
    LDR     R2,=0x0002FFFD
    SHASX   R10,R4,R7
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    UHASX   R10,R4,R7
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    
    ADDW    R6,R6,#0x789    
    
    /*--------------------------------------------------------------------*/
    /* SSAX                                                               */
    /*--------------------------------------------------------------------*/
    LDR     R12,=0x55555555
    LDR     R3,=0xAAAA5556
    
    LDR     R2,=0xFFFFFFFF
    SSAX    R10,R12,R3
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge
    
    LDR     R3,=0xAAAAAAAA
    LDR     R12,=0x5556AAAA        
    LDR     R4,=0x00000000
    SSAX    R5,R3,R12
    CMP     R5,R4
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    
    LDR     R3,=0x00050005
    LDR     R2,=0xFFFB0005
    SSAX    R5,R4,R3
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000003
    BL      m4_scst_simdsat_test2_check_ge
    
    ADDW    R6,R6,#0x789  
    
    /*--------------------------------------------------------------------*/
    /* SHSAX, UHSAX                                                       */
    /*--------------------------------------------------------------------*/ 
    LDR     R10,=0x55555555
    LDR     R5,=0xAAAA5556
    
    LDR     R2,=0xFFFFFFFF
    SHSAX   R3,R10,R5
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    LDR     R2,=0xFFFF7FFF    
    UHSAX   R12,R10,R5
    CMP     R12,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R5,=0xAAAAAAAA
    LDR     R10,=0x5556AAAA        
    LDR     R2,=0x00000000
    SHSAX   R12,R5,R10
    CMP     R12,R2
    BNE     m4_scst_test_tail_end
    LDR     R2,=0x00008000    
    UHSAX   R3,R5,R10
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R5,=0x00050005
    LDR     R2,=0xFFFD0002
    SHSAX   R3,R4,R5
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    UHSAX   R12,R4,R5
    CMP     R12,R2
    BNE     m4_scst_test_tail_end
    
    ADDW    R6,R6,#0x789
    
    /*--------------------------------------------------------------------*/
    /* SSUB16, USUB16                                                     */
    /*--------------------------------------------------------------------*/
    LDR     R8,=0x55555555
    LDR     R7,=0xAAAAAAAA
    LDR     R4,=0x00000000
    
    LDR     R2,=0x00000000
    SSUB16  R10,R8,R8
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    USUB16  R5,R8,R8
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
               
    LDR     R8,=0x00010001
    LDR     R3,=0xFFFFFFFF
    SSUB16  R5,R4,R8
    CMP     R5,R3
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge
    USUB16  R10,R4,R8
    CMP     R10,R3
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge
    
    SSUB16  R5,R7,R7
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    USUB16  R10,R7,R7
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    
    LDR     R8,=0x5555AAAA
    LDR     R2,=0xAAAB5556
    SSUB16  R5,R4,R8
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000003
    BL      m4_scst_simdsat_test2_check_ge
    USUB16  R10,R4,R8
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge
    
    ADDW    R6,R6,#0x789
    
    /*--------------------------------------------------------------------*/
    /* SHSUB16, UHSUB16                                                   */
    /*--------------------------------------------------------------------*/
    LDR     R11,=0x55555555
    LDR     R9,=0xAAAAAAAA
    LDR     R4,=0x00000000
    
    LDR     R2,=0x00000000
    SHSUB16 R10,R11,R11
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    UHSUB16 R5,R11,R11
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
           
    LDR     R11,=0x00010001
    LDR     R3,=0xFFFFFFFF
    SHSUB16 R5,R4,R11
    CMP     R5,R3
    BNE     m4_scst_test_tail_end
    UHSUB16 R10,R4,R11
    CMP     R10,R3
    BNE     m4_scst_test_tail_end
    
    SHSUB16 R5,R9,R9
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    UHSUB16 R10,R9,R9
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R11,=0x5555AAAA
    LDR     R2,=0xD5552AAB
    SHSUB16 R10,R4,R11
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    LDR     R2,=0xD555AAAB
    UHSUB16 R5,R4,R11
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    
    ADDW    R6,R6,#0x789
    
    /*--------------------------------------------------------------------*/
    /* SHSUB8, UHSUB8                                                     */
    /*--------------------------------------------------------------------*/
    LDR     R8,=0x55555555
    LDR     R7,=0xAAAAAAAA
    LDR     R4,=0x00000000
    
    LDR     R2,=0x00000000
    SHSUB8  R12,R8,R8
    CMP     R12,R2
    BNE     m4_scst_test_tail_end
    UHSUB8  R3,R8,R8
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
           
    LDR     R8,=0x01010101
    LDR     R3,=0xFFFFFFFF
    SHSUB8  R12,R4,R8
    CMP     R12,R3
    BNE     m4_scst_test_tail_end
    UHSUB8  R3,R4,R8
    CMP     R3,R3
    BNE     m4_scst_test_tail_end
    
    SHSUB8  R3,R7,R7
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    UHSUB8  R12,R7,R7
    CMP     R12,R2
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0x55AA55AA
    LDR     R2,=0xD52BD52B
    SHSUB8  R12,R4,R8
    CMP     R12,R2
    BNE     m4_scst_test_tail_end
    LDR     R2,=0xD5ABD5AB    
    UHSUB8  R3,R4,R8
    CMP     R3,R2
    BNE     m4_scst_test_tail_end
    
    ADDW    R6,R6,#0x789    
    
    /*--------------------------------------------------------------------*/
    /* SSUB8, USUB8                                                       */
    /*--------------------------------------------------------------------*/
    LDR     R8,=0x55555555
    LDR     R7,=0xAAAAAAAA
    LDR     R4,=0x00000000
    
    LDR     R2,=0x55555555
    SSUB8   R5,R8,R8
    CMP     R5,R4
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    USUB8   R10,R8,R8
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    BL      m4_scst_simdsat_test2_check_ge
           
    LDR     R2,=0xAAAAAAAA
    SSUB8   R10,R7,R7
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x0000000F
    BL      m4_scst_simdsat_test2_check_ge
    USUB8   R10,R7,R7
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    BL      m4_scst_simdsat_test2_check_ge
    
    LDR     R8,=0x01010101
    LDR     R2,=0xFFFFFFFF
    SSUB8   R5,R4,R8
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge 
    USUB8   R10,R4,R8
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    BL      m4_scst_simdsat_test2_check_ge 
    
    LDR     R8,=0x1DD54734
    LDR     R2,=0xE32BB9CC
    SSUB8   R10,R4,R8
    CMP     R10,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000004
    BL      m4_scst_simdsat_test2_check_ge 
    USUB8   R5,R4,R8
    CMP     R5,R2
    BNE     m4_scst_test_tail_end
    LDR     R0,=0x00000000
    BL      m4_scst_simdsat_test2_check_ge
    
    ADDW    R6,R6,#0x789 
    
    
    MOV     R0,R6       /* Test result is returned in R0 */
    
    B       m4_scst_test_tail_end
    
    
m4_scst_simdsat_test2_check_ge:
    /* Expected APSR[GE] content passed in R0 */
    MRS     R1,APSR     /* Load flags */
    LSL     R1,R1,#12
    LSR     R1,R1,#28
    CMP     R0,R1
    BNE     m4_scst_test_tail_end
    BX      LR
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */

    SCST_FILE_END
