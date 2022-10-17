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
*  Test summary:
* -------------
* Test that input/output signals from/to Regbank module ports are functional.
*
* Overall coverage:
* -----------------
* REGBANK:
* Test that Register Bank output/input ports are functional. This is tested
* by UMLAL instruction which has two input (Regbank output ports) ports and
* two output (Regbank input ports) ports.
*
* DECODER:
* Thumb (32-bit) 
*   - Encoding of "Long multiply, long multiply accumulate, and divide" instructions
* 
* 测试总结：
* -------------
* 测试来自/到 Regbank 模块端口的输入/输出信号是否正常工作。
*
* 整体覆盖：
* -----------------
* 银行：
* 测试寄存器组输出/输入端口是否正常工作。 这是经过测试的
* 通过具有两个输入（Regbank 输出端口）端口的 UMLAL 指令和
* 两个输出（Regbank 输入端口）端口。
*
* 解码器：
* 拇指（32 位）
* - “长乘、长乘累加和除法”指令的编码
*

******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"
    
    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_regbank_test3

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    SCST_EXTERN VAL9
    SCST_EXTERN VAL10

SCST_SET(PRESIGNATURE, 0xC726A3D2) /* this macro has to be at the beginning of the line */


    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_regbank_test3" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_regbank_test3, function)
m4_scst_regbank_test3:

    PUSH.W  {R1-R12,R14}
    
    /************************************/
    /* UMLA RdLo, RdHi, Rn, Rm          */
    /* RdHi,RdLo = RdHi, RdLo + Rn*Rm   */
    /************************************/
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0x13579BDF
    *   Rm   -  0x1
    *
    *   0x00000000 00000000 + 0x13579BDF*0x1 
    *
    *   Output:
    *   ------
    *   RdLo -  0x13579BDF
    *****************************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R0,=VAL9    /* <Rn> */
    MOV     R1,#1               /* Rm */    
    ISB
    UMLAL   R2,R3,R0,R1     /* UMLA RdLo, RdHi, Rn=R0, Rm */
    ISB   
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R1,=VAL9    /* <Rn> */
    MOV     R0,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R1,R0     /* UMLA RdLo, RdHi, Rn=R1, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R2,=VAL9    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R0,R3,R2,R1     /* UMLA RdLo, RdHi, Rn=R2, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R0,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R3,=VAL9    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R0,R3,R1     /* UMLA RdLo, RdHi, Rn=R3, Rm */
    ISB   
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R4,=VAL9    /* <Rn> */
    MOV     R1,#1       /* Rm */   
    ISB
    UMLAL   R2,R3,R4,R1     /* UMLA RdLo, RdHi, Rn=R4, Rm */
    ISB    
    LDR     R5,=VAL9
    CMP     R2,R5
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R5,=VAL9    /* <Rn> */
    MOV     R1,#1       /* Rm */   
    ISB
    UMLAL   R2,R3,R5,R1     /* UMLA RdLo, RdHi, Rn=R5, Rm */
    ISB   
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R6,=VAL9    /* <Rn> */
    MOV     R1,#1       /* Rm */   
    ISB
    UMLAL   R2,R3,R6,R1     /* UMLA RdLo, RdHi, Rn=R6, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/ 
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R7,=VAL9    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R7,R1     /* UMLA RdLo, RdHi, Rn=R7, Rm */
    ISB   
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R8,=VAL9    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R8,R1     /* UMLA RdLo, RdHi, Rn=R8, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R9,=VAL9    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R9,R1     /* UMLA RdLo, RdHi, Rn=R9, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R10,=VAL9   /* <Rn> */
    MOV     R1,#1       /* Rm */   
    ISB
    UMLAL   R2,R3,R10,R1    /* UMLA RdLo, RdHi, Rn=R10, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R11,=VAL9   /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R11,R1    /* UMLA RdLo, RdHi, Rn=R11, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R12,=VAL9   /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R12,R1    /* UMLA RdLo, RdHi, Rn=R12, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0x1
    *   Rm   -  0x13579BDF
    *
    *   0x000000000 00000000 + 0x13579BDF*0x1 
    *
    *   Output:
    *   ------
    *   RdLo - 0x13579BDF 
    *****************************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R1,#1       /* Rn */
    LDR     R0,=VAL9    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R1,R0     /* UMLA RdLo, RdHi, Rn, <Rm=R0> */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R1,=VAL9    /* <Rm> */   
    ISB
    UMLAL   R2,R3,R0,R1     /* UMLA RdLo, RdHi, Rn, <Rm=R1> */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R2,=VAL9    /* <Rm> */    
    ISB
    UMLAL   R1,R3,R0,R2     /* UMLA RdLo, RdHi, Rn, <Rm=R2> */
    ISB    
    LDR     R4,=VAL9
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R3,=VAL9    /* <Rm> */   
    ISB
    UMLAL   R2,R1,R0,R3     /* UMLA RdLo, RdHi, Rn, <Rm=R3> */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R4,=VAL9    /* <Rm> */   
    ISB
    UMLAL   R2,R3,R0,R4     /* UMLA RdLo, RdHi, Rn, <Rm=R4> */
    ISB    
    LDR     R5,=VAL9
    CMP     R2,R5
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R5,=VAL9    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R5     /* UMLA RdLo, RdHi, Rn, <Rm=R5> */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R6,=VAL9    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R6     /* UMLA RdLo, RdHi, Rn, <Rm=R6> */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/ 
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R7,=VAL9    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R7     /* UMLA RdLo, RdHi, Rn, <Rm=R7> */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R8,=VAL9    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R8     /* UMLA RdLo, RdHi, Rn, <Rm=R8> */
    ISB   
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* <Rn> */
    LDR     R9,=VAL9    /* Rm */    
    ISB
    UMLAL   R2,R3,R0,R9     /* UMLA RdLo, RdHi, Rn, <Rm=R9> */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R10,=VAL9   /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R10    /* UMLA RdLo, RdHi, Rn, <Rm=R10> */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R11,=VAL9   /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R11    /* UMLA RdLo, RdHi, Rn, <Rm=R11> */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R12,=VAL9   /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R12    /* UMLA RdLo, RdHi, Rn, <Rm=R12> */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x13579BDF
    *   RdHi -  0x0
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0x00000000 0x13579BDF + 0*0 
    *
    *   Output:
    *   ------
    *   RdLo = 0x13579BDF
    *****************************************************/ 
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R0,=VAL9    /* RdLo */    
    ISB
    UMLAL   R0,R2,R3,R1    /* UMLA <RdLo=R0>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R0,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R1,=VAL9    /* RdLo */    
    ISB
    UMLAL   R1,R2,R3,R0    /* UMLA <RdLo=R1>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R2,=VAL9    /* RdLo */    
    ISB
    UMLAL   R2,R1,R3,R0    /* UMLA <RdLo=R2>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R3,=VAL9    /* RdLo */    
    ISB
    UMLAL   R3,R1,R2,R0    /* UMLA <RdLo=R3>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R4,=VAL9    /* RdLo */    
    ISB
    UMLAL   R4,R1,R3,R0    /* UMLA <RdLo=R4>, RdHi, Rn, Rm */
    ISB    
    LDR     R5,=VAL9
    CMP     R4,R5
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R5,=VAL9    /* RdLo */    
    ISB
    UMLAL   R5,R1,R3,R0    /* UMLA <RdLo=R5>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R5,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R6,=VAL9    /* RdLo */    
    ISB
    UMLAL   R6,R1,R3,R0    /* UMLA <RdLo=R6>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R6,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R7,=VAL9    /* RdLo */    
    ISB
    UMLAL   R7,R1,R3,R0    /* UMLA <RdLo=R7>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R7,R4
    BNE     m4_scst_test_tail_end
    
    B m4_scst_regbank_test3_ltorg_jump_1 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG
m4_scst_regbank_test3_ltorg_jump_1:
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R8,=VAL9    /* RdLo */    
    ISB
    UMLAL   R8,R1,R3,R0    /* UMLA <RdLo=R8>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R8,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R9,=VAL9    /* RdLo */    
    ISB
    UMLAL   R9,R1,R3,R0    /* UMLA <RdLo=R9>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R9,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R10,=VAL9   /* RdLo */    
    ISB
    UMLAL   R10,R1,R3,R0    /* UMLA <RdLo=R10>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R11,=VAL9   /* RdLo */    
    ISB
    UMLAL   R11,R1,R3,R0    /* UMLA <RdLo=R11>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R11,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R12,=VAL9   /* RdLo */    
    ISB
    UMLAL   R12,R1,R3,R0    /* UMLA <RdLo=R12>, RdHi, Rn, Rm */
    ISB   
    LDR     R4,=VAL9
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x13579BDF
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0x13579BDF 00000000 + 0*0 
    *
    *   Output:
    *   ------
    *   RdHi - 0x13579BDF
    *****************************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R0,=VAL9    /* <RdHi> */    
    ISB
    UMLAL   R3,R0,R2,R1    /* UMLA RdLo, <RdHi=R0>, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R0,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R1,=VAL9    /* <RdHi> */    
    ISB
    UMLAL   R3,R1,R2,R0    /* UMLA RdLo, <RdHi=R1>, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R2,=VAL9    /* <RdHi> */    
    ISB
    UMLAL   R3,R2,R1,R0    /* UMLA RdLo, <RdHi=R2>, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R3,=VAL9    /* <RdHi> */    
    ISB
    UMLAL   R1,R3,R2,R0    /* UMLA RdLo, <RdHi=R3>, Rn, Rm */
    ISB   
    LDR     R4,=VAL9
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R4,=VAL9    /* <RdHi> */    
    ISB
    UMLAL   R3,R4,R1,R0    /* UMLA RdLo, <RdHi=R4>, Rn, Rm */
    ISB   
    LDR     R5,=VAL9
    CMP     R4,R5
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R5,=VAL9    /* <RdHi> */    
    ISB
    UMLAL   R3,R5,R1,R0    /* UMLA RdLo, <RdHi=R5>, Rn, Rm */
    ISB   
    LDR     R4,=VAL9
    CMP     R5,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R6,=VAL9    /* <RdHi> */    
    ISB
    UMLAL   R3,R6,R1,R0    /* UMLA RdLo, <RdHi=R6>, Rn, Rm */
    ISB   
    LDR     R4,=VAL9
    CMP     R6,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R7,=VAL9    /* <RdHi> */   
    ISB
    UMLAL   R3,R7,R1,R0    /* UMLA RdLo, <RdHi=R7>, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R7,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R8,=VAL9    /* <RdHi> */    
    ISB
    UMLAL   R3,R8,R1,R0    /* UMLA RdLo, <RdHi=R8>, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R8,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R9,=VAL9    /* <RdHi> */    
    ISB
    UMLAL   R3,R9,R1,R0    /* UMLA RdLo, <RdHi=R9>, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R9,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R10,=VAL9   /* <RdHi> */   
    ISB
    UMLAL   R3,R10,R1,R0    /* UMLA RdLo, <RdHi=R10>, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R11,=VAL9   /* <RdHi> */    
    ISB
    UMLAL   R3,R11,R1,R0    /* UMLA RdLo, <RdHi=R11>, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R11,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R12,=VAL9   /* <RdHi> */    
    ISB
    UMLAL   R3,R12,R1,R0    /* UMLA RdLo, <RdHi=R12>, Rn, Rm */
    ISB    
    LDR     R4,=VAL9
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0xFDB97531 
    *   Rm   -  0x1
    *
    *   0x00000000 00000000 + 0xFDB97531 *0x1 
    *
    *   Output:
    *   ------
    *   RdLo -  0xFDB97531 
    *****************************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R0,=VAL10    /* <Rn> */
    MOV     R1,#1               /* Rm */    
    ISB
    UMLAL   R2,R3,R0,R1     /* UMLA RdLo, RdHi, Rn=R0, Rm */
    ISB   
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R1,=VAL10    /* <Rn> */
    MOV     R0,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R1,R0     /* UMLA RdLo, RdHi, Rn=R1, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R2,=VAL10    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R0,R3,R2,R1     /* UMLA RdLo, RdHi, Rn=R2, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R0,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R3,=VAL10    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R0,R3,R1     /* UMLA RdLo, RdHi, Rn=R3, Rm */
    ISB   
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R4,=VAL10    /* <Rn> */
    MOV     R1,#1       /* Rm */   
    ISB
    UMLAL   R2,R3,R4,R1     /* UMLA RdLo, RdHi, Rn=R4, Rm */
    ISB    
    LDR     R5,=VAL10
    CMP     R2,R5
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R5,=VAL10    /* <Rn> */
    MOV     R1,#1       /* Rm */   
    ISB
    UMLAL   R2,R3,R5,R1     /* UMLA RdLo, RdHi, Rn=R5, Rm */
    ISB   
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R6,=VAL10    /* <Rn> */
    MOV     R1,#1       /* Rm */   
    ISB
    UMLAL   R2,R3,R6,R1     /* UMLA RdLo, RdHi, Rn=R6, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/ 
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R7,=VAL10    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R7,R1     /* UMLA RdLo, RdHi, Rn=R7, Rm */
    ISB   
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R8,=VAL10    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R8,R1     /* UMLA RdLo, RdHi, Rn=R8, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R9,=VAL10    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R9,R1     /* UMLA RdLo, RdHi, Rn=R9, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R10,=VAL10   /* <Rn> */
    MOV     R1,#1       /* Rm */   
    ISB
    UMLAL   R2,R3,R10,R1    /* UMLA RdLo, RdHi, Rn=R10, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R11,=VAL10   /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R11,R1    /* UMLA RdLo, RdHi, Rn=R11, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R12,=VAL10   /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R12,R1    /* UMLA RdLo, RdHi, Rn=R12, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0x1
    *   Rm   -  0xFDB97531 
    *
    *   0x000000000 00000000 + 0xFDB97531 *0x1 
    *
    *   Output:
    *   ------
    *   RdLo - 0xFDB97531  
    *****************************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R1,#1       /* Rn */
    LDR     R0,=VAL10    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R1,R0     /* UMLA RdLo, RdHi, Rn, <Rm=R0> */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R1,=VAL10    /* <Rm> */   
    ISB
    UMLAL   R2,R3,R0,R1     /* UMLA RdLo, RdHi, Rn, <Rm=R1> */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R2,=VAL10    /* <Rm> */    
    ISB
    UMLAL   R1,R3,R0,R2     /* UMLA RdLo, RdHi, Rn, <Rm=R2> */
    ISB    
    LDR     R4,=VAL10
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R3,=VAL10    /* <Rm> */   
    ISB
    UMLAL   R2,R1,R0,R3     /* UMLA RdLo, RdHi, Rn, <Rm=R3> */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R4,=VAL10    /* <Rm> */   
    ISB
    UMLAL   R2,R3,R0,R4     /* UMLA RdLo, RdHi, Rn, <Rm=R4> */
    ISB    
    LDR     R5,=VAL10
    CMP     R2,R5
    BNE     m4_scst_test_tail_end
    
    B m4_scst_regbank_test3_ltorg_jump_2 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG
m4_scst_regbank_test3_ltorg_jump_2:
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R5,=VAL10    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R5     /* UMLA RdLo, RdHi, Rn, <Rm=R5> */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R6,=VAL10    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R6     /* UMLA RdLo, RdHi, Rn, <Rm=R6> */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/ 
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R7,=VAL10    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R7     /* UMLA RdLo, RdHi, Rn, <Rm=R7> */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R8,=VAL10    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R8     /* UMLA RdLo, RdHi, Rn, <Rm=R8> */
    ISB   
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* <Rn> */
    LDR     R9,=VAL10    /* Rm */    
    ISB
    UMLAL   R2,R3,R0,R9     /* UMLA RdLo, RdHi, Rn, <Rm=R9> */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R10,=VAL10   /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R10    /* UMLA RdLo, RdHi, Rn, <Rm=R10> */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R11,=VAL10   /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R11    /* UMLA RdLo, RdHi, Rn, <Rm=R11> */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test3_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R12,=VAL10   /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R12    /* UMLA RdLo, RdHi, Rn, <Rm=R12> */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0xFDB97531 
    *   RdHi -  0x0
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0x00000000 0xFDB97531  + 0*0 
    *
    *   Output:
    *   ------
    *   RdLo = 0xFDB97531 
    *****************************************************/ 
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R0,=VAL10    /* RdLo */    
    ISB
    UMLAL   R0,R2,R3,R1    /* UMLA <RdLo=R0>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R0,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R1,=VAL10    /* RdLo */    
    ISB
    UMLAL   R1,R2,R3,R0    /* UMLA <RdLo=R1>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R2,=VAL10    /* RdLo */    
    ISB
    UMLAL   R2,R1,R3,R0    /* UMLA <RdLo=R2>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R3,=VAL10    /* RdLo */    
    ISB
    UMLAL   R3,R1,R2,R0    /* UMLA <RdLo=R3>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R4,=VAL10    /* RdLo */    
    ISB
    UMLAL   R4,R1,R3,R0    /* UMLA <RdLo=R4>, RdHi, Rn, Rm */
    ISB    
    LDR     R5,=VAL10
    CMP     R4,R5
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R5,=VAL10    /* RdLo */    
    ISB
    UMLAL   R5,R1,R3,R0    /* UMLA <RdLo=R5>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R5,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R6,=VAL10    /* RdLo */    
    ISB
    UMLAL   R6,R1,R3,R0    /* UMLA <RdLo=R6>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R6,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R7,=VAL10    /* RdLo */    
    ISB
    UMLAL   R7,R1,R3,R0    /* UMLA <RdLo=R7>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R7,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R8,=VAL10    /* RdLo */    
    ISB
    UMLAL   R8,R1,R3,R0    /* UMLA <RdLo=R8>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R8,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R9,=VAL10    /* RdLo */    
    ISB
    UMLAL   R9,R1,R3,R0    /* UMLA <RdLo=R9>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R9,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R10,=VAL10   /* RdLo */    
    ISB
    UMLAL   R10,R1,R3,R0    /* UMLA <RdLo=R10>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R11,=VAL10   /* RdLo */    
    ISB
    UMLAL   R11,R1,R3,R0    /* UMLA <RdLo=R11>, RdHi, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R11,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R12,=VAL10   /* RdLo */    
    ISB
    UMLAL   R12,R1,R3,R0    /* UMLA <RdLo=R12>, RdHi, Rn, Rm */
    ISB   
    LDR     R4,=VAL10
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0xFDB97531 
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0xFDB97531  00000000 + 0*0 
    *
    *   Output:
    *   ------
    *   RdHi - 0xFDB97531 
    *****************************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R0,=VAL10    /* <RdHi> */    
    ISB
    UMLAL   R3,R0,R2,R1    /* UMLA RdLo, <RdHi=R0>, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R0,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R1,=VAL10    /* <RdHi> */    
    ISB
    UMLAL   R3,R1,R2,R0    /* UMLA RdLo, <RdHi=R1>, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R1,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R2,=VAL10    /* <RdHi> */    
    ISB
    UMLAL   R3,R2,R1,R0    /* UMLA RdLo, <RdHi=R2>, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R2,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R3,=VAL10    /* <RdHi> */    
    ISB
    UMLAL   R1,R3,R2,R0    /* UMLA RdLo, <RdHi=R3>, Rn, Rm */
    ISB   
    LDR     R4,=VAL10
    CMP     R3,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R4,=VAL10    /* <RdHi> */    
    ISB
    UMLAL   R3,R4,R1,R0    /* UMLA RdLo, <RdHi=R4>, Rn, Rm */
    ISB   
    LDR     R5,=VAL10
    CMP     R4,R5
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R5,=VAL10    /* <RdHi> */    
    ISB
    UMLAL   R3,R5,R1,R0    /* UMLA RdLo, <RdHi=R5>, Rn, Rm */
    ISB   
    LDR     R4,=VAL10
    CMP     R5,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R6,=VAL10    /* <RdHi> */    
    ISB
    UMLAL   R3,R6,R1,R0    /* UMLA RdLo, <RdHi=R6>, Rn, Rm */
    ISB   
    LDR     R4,=VAL10
    CMP     R6,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R7,=VAL10    /* <RdHi> */   
    ISB
    UMLAL   R3,R7,R1,R0    /* UMLA RdLo, <RdHi=R7>, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R7,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R8,=VAL10    /* <RdHi> */    
    ISB
    UMLAL   R3,R8,R1,R0    /* UMLA RdLo, <RdHi=R8>, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R8,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R9,=VAL10    /* <RdHi> */    
    ISB
    UMLAL   R3,R9,R1,R0    /* UMLA RdLo, <RdHi=R9>, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R9,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R10,=VAL10   /* <RdHi> */   
    ISB
    UMLAL   R3,R10,R1,R0    /* UMLA RdLo, <RdHi=R10>, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R10,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R11,=VAL10   /* <RdHi> */    
    ISB
    UMLAL   R3,R11,R1,R0    /* UMLA RdLo, <RdHi=R11>, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R11,R4
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test3_clear_registers
    LDR     R12,=VAL10   /* <RdHi> */    
    ISB
    UMLAL   R3,R12,R1,R0    /* UMLA RdLo, <RdHi=R12>, Rn, Rm */
    ISB    
    LDR     R4,=VAL10
    CMP     R12,R4
    BNE     m4_scst_test_tail_end
    
    
    /* Write result */
    LDR R0,=PRESIGNATURE
    
    B       m4_scst_test_tail_end
    
m4_scst_regbank_test3_clear_registers:
    MOV     R0,#0
    MOV     R1,#0
    MOV     R2,#0
    MOV     R3,#0
    MOV     R4,#0
    MOV     R5,#0
    MOV     R6,#0
    MOV     R7,#0
    MOV     R8,#0
    MOV     R9,#0
    MOV     R10,#0
    MOV     R11,#0
    MOV     R12,#0
    BX      LR
    

    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */

    SCST_FILE_END
