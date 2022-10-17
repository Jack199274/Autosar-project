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
    SCST_EXPORT m4_scst_regbank_test1

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    SCST_EXTERN VAL1
    SCST_EXTERN VAL2

SCST_SET(PRESIGNATURE, 0xE35DF821) /* this macro has to be at the beginning of the line */


    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_regbank_test1" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_regbank_test1, function)
m4_scst_regbank_test1:

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
    *   Rn   -  0x55555555
    *   Rm   -  0x1
    *
    *   0x00000000 00000000 + 0x55555555*0x1 
    *
    *   Output:
    *   ------
    *   RdLo -  0x55555555
    *****************************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R0,=VAL1    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R0,R1     /* UMLA RdLo, RdHi, Rn=R0, Rm */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R1,=VAL1    /* <Rn> */
    MOV     R0,#1       /* Rm */   
    ISB
    UMLAL   R2,R3,R1,R0     /* UMLA RdLo, RdHi, Rn=R1, Rm */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R2,=VAL1      /* <Rn> */
    MOV     R1,#1         /* Rm */    
    ISB
    UMLAL   R0,R3,R2,R1     /* UMLA RdLo, RdHi, Rn=R2, Rm */
    ISB    
    CMP     R0,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R3,=VAL1    /* <Rn> */
    MOV     R1,#1       /* Rm */   
    ISB
    UMLAL   R2,R0,R3,R1     /* UMLA RdLo, RdHi, Rn=R3, Rm */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R4,=VAL1    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R4,R1     /* UMLA RdLo, RdHi, Rn=R4, Rm */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R5,=VAL1    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R5,R1     /* UMLA RdLo, RdHi, Rn=R5, Rm */
    ISB   
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R6,=VAL1    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R6,R1     /* UMLA RdLo, RdHi, Rn=R6, Rm */
    ISB   
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end

    /************************************/ 
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R7,=VAL1    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R7,R1     /* UMLA RdLo, RdHi, Rn=R7, Rm */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R8,=VAL1    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R8,R1     /* UMLA RdLo, RdHi, Rn=R8, Rm */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R9,=VAL1    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R9,R1     /* UMLA RdLo, RdHi, Rn=R9, Rm */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R10,=VAL1   /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R10,R1    /* UMLA RdLo, RdHi, Rn=R10, Rm */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R11,=VAL1   /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R11,R1    /* UMLA RdLo, RdHi, Rn=R11, Rm */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R12,=VAL1   /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R12,R1    /* UMLA RdLo, RdHi, Rn=R12, Rm */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0xAAAAAAAA
    *   Rm   -  0x1
    *
    *   0x000000000 00000000 + 0xAAAAAAAA*0x1 
    *
    *   Output:
    *   ------
    *   RdLo -  0xAAAAAAAA
    *****************************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R0,=VAL2    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R0,R1     /* UMLA RdLo, RdHi, Rn=R0, Rm */
    ISB   
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R1,=VAL2    /* <Rn> */
    MOV     R0,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R1,R0     /* UMLA RdLo, RdHi, <Rn=R1>, Rm */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R2,=VAL2    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R0,R3,R2,R1     /* UMLA RdLo, RdHi, <Rn=R2>, Rm */
    ISB    
    CMP     R0,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R3,=VAL2    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R0,R3,R1     /* UMLA RdLo, RdHi, <Rn=R3>, Rm */
    ISB   
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R4,=VAL2    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R4,R1     /* UMLA RdLo, RdHi, <Rn=R4>, Rm */
    ISB   
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R5,=VAL2    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R5,R1     /* UMLA RdLo, RdHi, <Rn=R5>, Rm */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R6,=VAL2    /* <Rn> */
    MOV     R1,#1       /* Rm */   
    ISB
    UMLAL   R2,R3,R6,R1     /* UMLA RdLo, RdHi, <Rn=R6>, Rm */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end

    /************************************/ 
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R7,=VAL2    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R7,R1     /* UMLA RdLo, RdHi, <Rn=R7>, Rm */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R8,=VAL2    /* <Rn> */
    MOV     R1,#1       /* Rm */   
    ISB
    UMLAL   R2,R3,R8,R1     /* UMLA RdLo, RdHi, <Rn=R8>, Rm */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R9,=VAL2    /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R9,R1     /* UMLA RdLo, RdHi, Rn=R9, Rm */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R10,=VAL2   /* <Rn> */
    MOV     R1,#1       /* Rm */   
    ISB
    UMLAL   R2,R3,R10,R1    /* UMLA RdLo, RdHi, <Rn=R10>, Rm */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R11,=VAL2   /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R11,R1    /* UMLA RdLo, RdHi, <Rn=R11>, Rm */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R12,=VAL2   /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    UMLAL   R2,R3,R12,R1    /* UMLA RdLo, RdHi, Rn=R12, Rm */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0x1
    *   Rm   -  0x55555555
    *
    *   0x000000000 00000000 + 0x55555555*0x1 
    *
    *   Output:
    *   ------
    *   RdLo - 0x55555555 
    *****************************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R1,#1       /* Rn */
    LDR     R0,=VAL1    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R1,R0     /* UMLA RdLo, RdHi, Rn, <Rm=R0> */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R1,=VAL1    /* <Rm> */   
    ISB
    UMLAL   R2,R3,R0,R1     /* UMLA RdLo, RdHi, Rn, <Rm=R1> */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R2,=VAL1    /* <Rm> */    
    ISB
    UMLAL   R1,R3,R0,R2     /* UMLA RdLo, RdHi, Rn, <Rm=R2> */
    ISB   
    CMP     R1,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R3,=VAL1    /* <Rm> */    
    ISB
    UMLAL   R2,R1,R0,R3     /* UMLA RdLo, RdHi, Rn, <Rm=R3> */
    ISB   
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R4,=VAL1    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R4     /* UMLA RdLo, RdHi, Rn, <Rm=R4> */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R5,=VAL1    /* <Rm> */   
    ISB
    UMLAL   R2,R3,R0,R5     /* UMLA RdLo, RdHi, Rn, <Rm=R5> */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R6,=VAL1    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R6     /* UMLA RdLo, RdHi, Rn, <Rm=R6> */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end


    B m4_scst_regbank_test1_ltorg_jump_1 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_regbank_test1_ltorg_jump_1:

    /************************************/ 
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R7,=VAL1    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R7     /* UMLA RdLo, RdHi, Rn, <Rm=R7> */
    ISB   
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end
        
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R8,=VAL1    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R8     /* UMLA RdLo, RdHi, Rn, <Rm=R8> */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* <Rn> */
    LDR     R9,=VAL1    /* Rm */    
    ISB
    UMLAL   R2,R3,R0,R9     /* UMLA RdLo, RdHi, Rn, <Rm=R9> */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R10,=VAL1   /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R10    /* UMLA RdLo, RdHi, Rn, <Rm=R10> */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R11,=VAL1   /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R11    /* UMLA RdLo, RdHi, Rn, <Rm=R11> */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R12,=VAL1   /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R12    /* UMLA RdLo, RdHi, Rn, <Rm=R12> */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end
    
   /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0x1
    *   Rm   -  0xAAAAAAAA
    *
    *   0x000000000 00000000 + 0xAAAAAAAA*0x1 
    *
    *   Output:
    *   ------
    *   RdLo - 0xAAAAAAAA 
    *****************************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R1,#1       /* Rn */
    LDR     R0,=VAL2    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R1,R0     /* UMLA RdLo, RdHi, Rn, <Rm=R0> */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R1,=VAL2    /* <Rm> */   
    ISB
    UMLAL   R2,R3,R0,R1     /* UMLA RdLo, RdHi, Rn, <Rm=R1> */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R2,=VAL2    /* <Rm> */    
    ISB
    UMLAL   R1,R3,R0,R2     /* UMLA RdLo, RdHi, Rn, <Rm=R2> */
    ISB    
    CMP     R1,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R3,=VAL2    /* <Rm> */    
    ISB
    UMLAL   R2,R1,R0,R3     /* UMLA RdLo, RdHi, Rn, <Rm=R3> */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R4,=VAL2    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R4     /* UMLA RdLo, RdHi, Rn, <Rm=R4> */
    ISB   
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R5,=VAL2    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R5     /* UMLA RdLo, RdHi, Rn, <Rm=R5> */
    ISB   
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R6,=VAL2    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R6     /* UMLA RdLo, RdHi, Rn, <Rm=R6> */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end

    /************************************/ 
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R7,=VAL2    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R7     /* UMLA RdLo, RdHi, Rn, <Rm=R7> */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R8,=VAL2    /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R8     /* UMLA RdLo, RdHi, Rn, <Rm=R8> */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* <Rn> */
    LDR     R9,=VAL2    /* Rm */    
    ISB
    UMLAL   R2,R3,R0,R9     /* UMLA RdLo, RdHi, Rn, <Rm=R9> */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R10,=VAL2   /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R10    /* UMLA RdLo, RdHi, Rn, <Rm=R10> */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end

    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R11,=VAL2   /* <Rm> */    
    ISB
    UMLAL   R2,R3,R0,R11    /* UMLA RdLo, RdHi, Rn, <Rm=R11> */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test1_clear_registers
    MOV     R0,#1       /* Rn */
    LDR     R12,=VAL2   /* <Rm> */   
    ISB
    UMLAL   R2,R3,R0,R12    /* UMLA RdLo, RdHi, Rn, <Rm=R12> */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x55555555
    *   RdHi -  0x0
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0x00000000 55555555 + 0*0 
    *
    *   Output:
    *   ------
    *   RdLo = 0x55555555
    *****************************************************/ 
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R0,=VAL1    /* RdLo */    
    ISB
    UMLAL   R0,R2,R3,R1    /* UMLA <RdLo=R0>, RdHi, Rn, Rm */
    ISB   
    CMP     R0,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R1,=VAL1    /* RdLo */    
    ISB
    UMLAL   R1,R2,R3,R0    /* UMLA <RdLo=R1>, RdHi, Rn, Rm */
    ISB    
    CMP     R1,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R2,=VAL1    /* RdLo */    
    ISB
    UMLAL   R2,R1,R3,R0    /* UMLA <RdLo=R2>, RdHi, Rn, Rm */
    ISB    
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R3,=VAL1    /* RdLo */   
    ISB
    UMLAL   R3,R1,R2,R0    /* UMLA <RdLo=R3>, RdHi, Rn, Rm */
    ISB   
    CMP     R3,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R4,=VAL1    /* RdLo */   
    ISB
    UMLAL   R4,R1,R3,R0    /* UMLA <RdLo=R4>, RdHi, Rn, Rm */
    ISB   
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R5,=VAL1    /* RdLo */    
    ISB
    UMLAL   R5,R1,R3,R0    /* UMLA <RdLo=R5>, RdHi, Rn, Rm */
    ISB    
    CMP     R5,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R6,=VAL1    /* RdLo */   
    ISB
    UMLAL   R6,R1,R3,R0    /* UMLA <RdLo=R6>, RdHi, Rn, Rm */
    ISB    
    CMP     R6,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R7,=VAL1    /* RdLo */   
    ISB
    UMLAL   R7,R1,R3,R0    /* UMLA <RdLo=R7>, RdHi, Rn, Rm */
    ISB    
    CMP     R7,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R8,=VAL1    /* RdLo */   
    ISB
    UMLAL   R8,R1,R3,R0    /* UMLA <RdLo=R8>, RdHi, Rn, Rm */
    ISB    
    CMP     R8,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R9,=VAL1    /* RdLo */    
    ISB
    UMLAL   R9,R1,R3,R0    /* UMLA <RdLo=R9>, RdHi, Rn, Rm */
    ISB    
    CMP     R9,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R10,=VAL1   /* RdLo */   
    ISB
    UMLAL   R10,R1,R3,R0    /* UMLA <RdLo=R10>, RdHi, Rn, Rm */
    ISB    
    CMP     R10,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R11,=VAL1   /* RdLo */    
    ISB
    UMLAL   R11,R1,R3,R0    /* UMLA <RdLo=R11>, RdHi, Rn, Rm */
    ISB    
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R12,=VAL1   /* RdLo */    
    ISB
    UMLAL   R12,R1,R3,R0    /* UMLA <RdLo=R12>, RdHi, Rn, Rm */
    ISB    
    CMP     R12,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0xAAAAAAAA
    *   RdHi -  0x0
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0x00000000 AAAAAAAA + 0*0 
    *
    *   Output:
    *   ------
    *   RdLo = 0xAAAAAAAA
    *****************************************************/ 
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R0,=VAL2    /* RdLo */   
    ISB
    UMLAL   R0,R2,R3,R1    /* UMLA <RdLo=R0>, RdHi, Rn, Rm */
    ISB    
    CMP     R0,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R1,=VAL2    /* RdLo */   
    ISB
    UMLAL   R1,R2,R3,R0    /* UMLA <RdLo=R1>, RdHi, Rn, Rm */
    ISB    
    CMP     R1,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R2,=VAL2    /* RdLo */    
    ISB
    UMLAL   R2,R1,R3,R0    /* UMLA <RdLo=R2>, RdHi, Rn, Rm */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    B m4_scst_regbank_test1_ltorg_jump_2 /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_regbank_test1_ltorg_jump_2:
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R3,=VAL2    /* RdLo */    
    ISB
    UMLAL   R3,R1,R2,R0    /* UMLA <RdLo=R3>, RdHi, Rn, Rm */
    ISB    
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end    
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R4,=VAL2    /* RdLo */    
    ISB
    UMLAL   R4,R1,R3,R0    /* UMLA <RdLo=R4>, RdHi, Rn, Rm */
    ISB    
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R5,=VAL2    /* RdLo */   
    ISB
    UMLAL   R5,R1,R3,R0    /* UMLA <RdLo=R5>, RdHi, Rn, Rm */
    ISB    
    CMP     R5,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R6,=VAL2    /* RdLo */    
    ISB
    UMLAL   R6,R1,R3,R0    /* UMLA <RdLo=R6>, RdHi, Rn, Rm */
    ISB   
    CMP     R6,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R7,=VAL2    /* RdLo */    
    ISB
    UMLAL   R7,R1,R3,R0    /* UMLA <RdLo=R7>, RdHi, Rn, Rm */
    ISB    
    CMP     R7,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R8,=VAL2    /* RdLo */    
    ISB
    UMLAL   R8,R1,R3,R0    /* UMLA <RdLo=R8>, RdHi, Rn, Rm */
    ISB    
    CMP     R8,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R9,=VAL2    /* RdLo */    
    ISB
    UMLAL   R9,R1,R3,R0    /* UMLA <RdLo=R9>, RdHi, Rn, Rm */
    ISB
    CMP     R9,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R10,=VAL2   /* RdLo */    
    ISB
    UMLAL   R10,R1,R3,R0    /* UMLA <RdLo=R10>, RdHi, Rn, Rm */
    ISB   
    CMP     R10,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R11,=VAL2   /* RdLo */    
    ISB
    UMLAL   R11,R1,R3,R0    /* UMLA <RdLo=R11>, RdHi, Rn, Rm */
    ISB    
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/ 
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R12,=VAL2   /* RdLo */    
    ISB
    UMLAL   R12,R1,R3,R0    /* UMLA <RdLo=R12>, RdHi, Rn, Rm */
    ISB    
    CMP     R12,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x55555555
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0x55555555 00000000 + 0*0 
    *
    *   Output:
    *   ------
    *   RdHi - 0x55555555
    *****************************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R0,=VAL1    /* <RdHi> */    
    ISB
    UMLAL   R3,R0,R2,R1    /* UMLA RdLo, <RdHi=R0>, Rn, Rm */
    ISB    
    CMP     R0,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R1,=VAL1    /* <RdHi> */    
    ISB
    UMLAL   R3,R1,R2,R0    /* UMLA RdLo, <RdHi=R1>, Rn, Rm */
    ISB    
    CMP     R1,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R2,=VAL1    /* <RdHi> */   
    ISB
    UMLAL   R3,R2,R1,R0    /* UMLA RdLo, <RdHi=R2>, Rn, Rm */
    ISB   
    CMP     R2,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R3,=VAL1    /* <RdHi> */    
    ISB
    UMLAL   R1,R3,R2,R0    /* UMLA RdLo, <RdHi=R3>, Rn, Rm */
    ISB    
    CMP     R3,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R4,=VAL1    /* <RdHi> */    
    ISB
    UMLAL   R3,R4,R1,R0    /* UMLA RdLo, <RdHi=R4>, Rn, Rm */
    ISB    
    CMP     R4,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R5,=VAL1    /* <RdHi> */    
    ISB
    UMLAL   R3,R5,R1,R0    /* UMLA RdLo, <RdHi=R5>, Rn, Rm */
    ISB    
    CMP     R5,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R6,=VAL1    /* <RdHi> */    
    ISB
    UMLAL   R3,R6,R1,R0    /* UMLA RdLo, <RdHi=R6>, Rn, Rm */
    ISB    
    CMP     R6,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R7,=VAL1    /* <RdHi> */    
    ISB
    UMLAL   R3,R7,R1,R0    /* UMLA RdLo, <RdHi=R7>, Rn, Rm */
    ISB    
    CMP     R7,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R8,=VAL1    /* <RdHi> */    
    ISB
    UMLAL   R3,R8,R1,R0    /* UMLA RdLo, <RdHi=R8>, Rn, Rm */
    ISB    
    CMP     R8,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R9,=VAL1    /* <RdHi> */    
    ISB
    UMLAL   R3,R9,R1,R0    /* UMLA RdLo, <RdHi=R9>, Rn, Rm */
    ISB    
    CMP     R9,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R10,=VAL1   /* <RdHi> */    
    ISB
    UMLAL   R3,R10,R1,R0    /* UMLA RdLo, <RdHi=R10>, Rn, Rm */
    ISB    
    CMP     R10,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R11,=VAL1   /* <RdHi> */    
    ISB
    UMLAL   R3,R11,R1,R0    /* UMLA RdLo, <RdHi=R11>, Rn, Rm */
    ISB    
    CMP     R11,#0x55555555
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R12,=VAL1   /* <RdHi> */    
    ISB
    UMLAL   R3,R12,R1,R0    /* UMLA RdLo, <RdHi=R12>, Rn, Rm */
    ISB    
    CMP     R12,#0x55555555
    BNE     m4_scst_test_tail_end
    
   /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0xAAAAAAAA
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0xAAAAAAAA 00000000 + 0*0 
    *
    *   Output:
    *   ------
    *   RdHi - 0xAAAAAAAA
    *****************************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R0,=VAL2    /* <RdHi> */    
    ISB
    UMLAL   R3,R0,R2,R1    /* UMLA RdLo, <RdHi=R0>, Rn, Rm */
    ISB
    CMP     R0,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R1,=VAL2    /* <RdHi> */    
    ISB
    UMLAL   R3,R1,R2,R0    /* UMLA RdLo, <RdHi=R1>, Rn, Rm */
    ISB    
    CMP     R1,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R2,=VAL2    /* <RdHi> */    
    ISB
    UMLAL   R3,R2,R1,R0    /* UMLA RdLo, <RdHi=R2>, Rn, Rm */
    ISB    
    CMP     R2,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R3,=VAL2    /* <RdHi> */   
    ISB
    UMLAL   R1,R3,R2,R0    /* UMLA RdLo, <RdHi=R3>, Rn, Rm */
    ISB    
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R4,=VAL2    /* <RdHi> */    
    ISB
    UMLAL   R3,R4,R1,R0    /* UMLA RdLo, <RdHi=R4>, Rn, Rm */
    ISB    
    CMP     R4,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R5,=VAL2    /* <RdHi> */    
    ISB
    UMLAL   R3,R5,R1,R0    /* UMLA RdLo, <RdHi=R5>, Rn, Rm */
    ISB    
    CMP     R5,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R6,=VAL2    /* <RdHi> */   
    ISB
    UMLAL   R3,R6,R1,R0    /* UMLA RdLo, <RdHi=R6>, Rn, Rm */
    ISB    
    CMP     R6,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R7,=VAL2    /* <RdHi> */   
    ISB
    UMLAL   R3,R7,R1,R0    /* UMLA RdLo, <RdHi=R7>, Rn, Rm */
    ISB    
    CMP     R7,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R8,=VAL2    /* <RdHi> */    
    ISB
    UMLAL   R3,R8,R1,R0    /* UMLA RdLo, <RdHi=R8>, Rn, Rm */
    ISB    
    CMP     R8,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R9,=VAL2    /* <RdHi> */    
    ISB
    UMLAL   R3,R9,R1,R0    /* UMLA RdLo, <RdHi=R9>, Rn, Rm */
    ISB    
    CMP     R9,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R10,=VAL2   /* <RdHi> */    
    ISB
    UMLAL   R3,R10,R1,R0    /* UMLA RdLo, <RdHi=R10>, Rn, Rm */
    ISB   
    CMP     R10,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R11,=VAL2   /* <RdHi> */    
    ISB
    UMLAL   R3,R11,R1,R0    /* UMLA RdLo, <RdHi=R11>, Rn, Rm */
    ISB    
    CMP     R11,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /************************************/
    BL      m4_scst_regbank_test1_clear_registers
    LDR     R12,=VAL2   /* <RdHi> */    
    ISB
    UMLAL   R3,R12,R1,R0    /* UMLA RdLo, <RdHi=R12>, Rn, Rm */
    ISB    
    CMP     R12,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /* Write result */
    LDR R0,=PRESIGNATURE
    
    B       m4_scst_test_tail_end
    
m4_scst_regbank_test1_clear_registers:
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
    