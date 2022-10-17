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
* Test MAC module.
*
* Overall coverage:
* -----------------
* Find errors in the multiplier array
* 
* 测试总结：
* -------------
* 测试MAC模块。
*
* 整体覆盖：
* -----------------
* 查找乘数数组中的错误
*

******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    
    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_mac_test2

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    

    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_mac_test2" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_mac_test2, function)
m4_scst_mac_test2:

    PUSH.W  {R1-R12,R14}
    
    /* R5 is used as intermediate result */
    MOV     R5,#0x0
    
    /***************************************************************************************************
    * Unsigned Long Multiply
    *   - Multiplies the two unsigned 32 bits integers in the first and second operands.
    *   - Writes the least significant 32 bits of the result in RdLo.
    *   - Writes the most significant 32 bits of the result in RdHi.
    *
    *   UMULL RdLo, RdHi, Rn, Rm
    *   RdHi,RdLo:=unsigned(Rn*Rm)
    *
    ***************************************************************************************************/
    LDR     R1,=0xBE37EE62
    LDR     R2,=0xDF1939B6
    
    UMULL   R3,R4,R1,R2 /* 0xA5C576FF 55694BAC */
    
    LDR     R6,=0x55694BAC
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0xA5C576FF
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0346
    
    LDR     R1,=0xF4E587E7
    LDR     R2,=0x5F051AF2
    
    UMULL   R3,R4,R1,R2 /* 0x5AE60FB1 314AEE5E */
    
    LDR     R6,=0x314AEE5E
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x5AE60FB1
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x02D5
    
    LDR     R1,=0x1DBF35F4
    LDR     R2,=0xC08DAC8E
    
    UMULL   R3,R4,R1,R2 /* 0x165FDED4 AFB3DD58 */
    
    LDR     R6,=0xAFB3DD58
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x165FDED4
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0719
    
    LDR     R1,=0xCB45830D
    LDR     R2,=0xF15C8298
    
    UMULL   R3,R4,R1,R2 /* 0xBFA5E50C 537E69B8 */
    
    LDR     R6,=0x537E69B8
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0xBFA5E50C
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0311
    
    LDR     R1,=0x910EFC27
    LDR     R2,=0xEDA8C7EB
    
    UMULL   R3,R4,R1,R2 /* 0x86AA828D 635BC8CD */
    
    LDR     R6,=0x635BC8CD
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x86AA828D
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0EE3
    
    LDR     R1,=0x6803E9AB
    LDR     R2,=0x97E1E89C
    
    UMULL   R3,R4,R1,R2 /* 0x3DB618C7 2A705C34 */
    
    LDR     R6,=0x2A705C34
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x3DB618C7
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x082E
    
    LDR     R1,=0x5736C6B3
    LDR     R2,=0x0985429D
    
    UMULL   R3,R4,R1,R2 /* 0x33E5323 21D101C7 */
    
    LDR     R6,=0x21D101C7
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x033E5323
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x01E3
    
    LDR     R1,=0xC4979B9E
    LDR     R2,=0x80A0523E
    
    UMULL   R3,R4,R1,R2 /* 0x62C6EBB8 6F504C44 */
    
    LDR     R6,=0x6F504C44
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x62C6EBB8
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0B44
    
    LDR     R1,=0xC2B789EC
    LDR     R2,=0x65E49B56
    
    UMULL   R3,R4,R1,R2 /* 0x4D804B07 7C5A3948 */
    
    LDR     R6,=0x7C5A3948
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x4D804B07
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0572
    
    LDR     R1,=0x2C55DF27
    LDR     R2,=0xB58B10DA
    
    UMULL   R3,R4,R1,R2 /* 0x1F70CC51 DC3F7736 */
    
    LDR     R6,=0xDC3F7736
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x1F70CC51
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x010C
    
    LDR     R1,=0x993E1572
    LDR     R2,=0x143B2335
    
    UMULL   R3,R4,R1,R2 /* 0xC1C400F 100F069A */
    
    LDR     R6,=0x100F069A
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x0C1C400F
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x07E8
    
    LDR     R1,=0xF97085FC
    LDR     R2,=0xEFA96066
    
    UMULL   R3,R4,R1,R2 /* 0xE985164C 4C6FE268 */
    
    LDR     R6,=0x4C6FE268
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0xE985164C
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0F74
    
    LDR     R1,=0x6A6F7053
    LDR     R2,=0xB0C997D9
    
    UMULL   R3,R4,R1,R2 /* 0x49806DDA 34E22B5B */
    
    LDR     R6,=0x34E22B5B
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x49806DDA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x04D7
    
    LDR     R1,=0x108381EC
    LDR     R2,=0x771614C4
    
    UMULL   R3,R4,R1,R2 /* 0x7AE8E08 C91DE8B0 */
    
    LDR     R6,=0xC91DE8B0
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x07AE8E08
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0750
    
    LDR     R1,=0x22466C3A
    LDR     R2,=0xBCB2A5D3
    
    UMULL   R3,R4,R1,R2 /* 0x1943A2A5 7C2095CE */
    
    LDR     R6,=0x7C2095CE
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x1943A2A5
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x01C9
    
    LDR     R1,=0x84054D79
    LDR     R2,=0x7A064516
    
    UMULL   R3,R4,R1,R2 /* 0x3EEDC2AC 412C4566 */
    
    LDR     R6,=0x412C4566
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x3EEDC2AC
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x03A1
    
    LDR     R1,=0x7896EDD4
    LDR     R2,=0x67B38A33
    
    UMULL   R3,R4,R1,R2 /* 0x30D94C51 F981A93C */
    
    LDR     R6,=0xF981A93C
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x30D94C51
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0A94
    
    LDR     R1,=0x62052392
    LDR     R2,=0xC1F8BA2A
    
    UMULL   R3,R4,R1,R2 /* 0x4A451C13 581FE9F4 */
    
    LDR     R6,=0x581FE9F4
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x4A451C13
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0369
    
    LDR     R1,=0x754CED98
    LDR     R2,=0x209531A3
    
    UMULL   R3,R4,R1,R2 /* 0xEEDFA37 B2ED5FC8 */
    
    LDR     R6,=0xB2ED5FC8
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x0EEDFA37
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x057B
    
    LDR     R1,=0x5E729598
    LDR     R2,=0xD551ED15
    
    UMULL   R3,R4,R1,R2 /* 0x4EB39030 A0FBFD78 */
    
    LDR     R6,=0xA0FBFD78
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x4EB39030
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0F5B
    
    LDR     R1,=0x3B8DC438
    LDR     R2,=0xE2159004
    
    UMULL   R3,R4,R1,R2 /* 0x34982B5B 352E90E0 */
    
    LDR     R6,=0x352E90E0
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x34982B5B
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0165
    
    LDR     R1,=0x8FD86DE1
    LDR     R2,=0x763F774E
    
    UMULL   R3,R4,R1,R2 /* 0x42716BF2 2F64118E */
    
    LDR     R6,=0x2F64118E
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x42716BF2
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0D1C
    
    LDR     R1,=0x44A46438
    LDR     R2,=0xE88A7CD7
    
    UMULL   R3,R4,R1,R2 /* 0x3E5A1CEA 0CCB4B08 */
    
    LDR     R6,=0x0CCB4B08
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x3E5A1CEA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0E51
    
    LDR     R1,=0xB7BFFE6C
    LDR     R2,=0xD78E426F
    
    UMULL   R3,R4,R1,R2 /* 0x9AB85ADA FFBF28D4 */
    
    LDR     R6,=0xFFBF28D4
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x9AB85ADA
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0438
    
    LDR     R1,=0x0FC60405
    LDR     R2,=0xCF9B458F
    
    UMULL   R3,R4,R1,R2 /* 0xCCAAE6D A8B897CB */
    
    LDR     R6,=0xA8B897CB
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x0CCAAE6D
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x03F8
    
    LDR     R1,=0xBFED6E1F
    LDR     R2,=0x2040FAD0
    
    UMULL   R3,R4,R1,R2 /* 0x182E6529 3633BF30 */
    
    LDR     R6,=0x3633BF30
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x182E6529
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0CE6
    
    LDR     R1,=0xF5CD08C3
    LDR     R2,=0xFEC52DB4
    
    UMULL   R3,R4,R1,R2 /* 0xF49EC15B 16C3701C */
    
    LDR     R6,=0x16C3701C
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0xF49EC15B
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0B03
    
    LDR     R1,=0xBD0FE61F
    LDR     R2,=0xA610DF3C
    
    UMULL   R3,R4,R1,R2 /* 0x7AA4C513 A51EF044 */
    
    LDR     R6,=0xA51EF044
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x7AA4C513
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
   
    ADD.W   R5,R5,#0x0F05
    
    LDR     R1,=0xC48D9CA1
    LDR     R2,=0xCE8F0EE6
    
    UMULL   R3,R4,R1,R2 /* 0x9E97CA94 61BA86A6 */
    
    LDR     R6,=0x61BA86A6
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x9E97CA94
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0954
    
    LDR     R1,=0xE0AA5076
    LDR     R2,=0x8B154916
    
    UMULL   R3,R4,R1,R2 /* 0x7A0F27CC 8B429024 */
    
    LDR     R6,=0x8B429024
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x7A0F27CC
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0BAF
    
    LDR     R1,=0x1CBE5162
    LDR     R2,=0x3E20C622
    
    UMULL   R3,R4,R1,R2 /* 0x6F9C5BE EC789B04 */
    
    LDR     R6,=0xEC789B04
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x06F9C5BE
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0910
    
    LDR     R1,=0x24D8F7BB
    LDR     R2,=0x54050217
    
    UMULL   R3,R4,R1,R2 /* 0xC17E9D3 3414B7CD */
    
    LDR     R6,=0x3414B7CD
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x0C17E9D3
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0AF8
    
    LDR     R1,=0xD89029E8
    LDR     R2,=0x07C201A9
    
    UMULL   R3,R4,R1,R2 /* 0x6900FCC A1259228 */
    
    LDR     R6,=0xA1259228
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x06900FCC
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0939
    
    LDR     R1,=0x415BC3BF
    LDR     R2,=0x4CA834FB
    
    UMULL   R3,R4,R1,R2 /* 0x13922FDB E213B845 */
    
    LDR     R6,=0xE213B845
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x13922FDB
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x0CD3
    
    LDR     R1,=0x39A3AD7C
    LDR     R2,=0x9F5C7975
    
    UMULL   R3,R4,R1,R2 /* 0x23E17AEB 115DE5AC */
    
    LDR     R6,=0x115DE5AC
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    LDR     R6,=0x23E17AEB
    CMP     R4,R6
    BNE     m4_scst_test_tail_end
    
    ADD.W   R5,R5,#0x094F
    
    MOV     R0,R5          /* Test result is returned in R0, according to the conventions */
    
    B       m4_scst_test_tail_end
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */

    SCST_FILE_END
