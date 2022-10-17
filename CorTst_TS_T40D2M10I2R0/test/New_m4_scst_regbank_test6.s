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
* This test focuses on SP(R13) and LR(R14) registers.
*
* DECODER:
* Thumb (32-bit) 
*   - Encoding of "Long multiply, long multiply accumulate, and divide" instructions

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
* 此测试侧重于 SP(R13) 和 LR(R14) 寄存器。
*
* 解码器：
* 拇指（32 位）
* - “长乘、长乘累加和除法”指令的编码* 
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_regbank_test6

    /* Symbols defined outside but used within current module */
    SCST_EXTERN m4_scst_test_tail_end
    SCST_EXTERN VAL1
    SCST_EXTERN VAL2
    SCST_EXTERN VAL5
    SCST_EXTERN VAL6
    SCST_EXTERN VAL9
    SCST_EXTERN VAL10

SCST_SET(PRESIGNATURE,0xB91A8625) /* this macro has to be at the beginning of the line */


    SCST_SECTION_EXEC(m4_scst_test_code)
    SCST_THUMB2 

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_regbank_test6" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_regbank_test6, function)
m4_scst_regbank_test6:

    PUSH.W  {R1-R12,R14}
    
    LDR     R9,=PRESIGNATURE
    
    /* Store PRIMASK value */
    MRS     R3,PRIMASK  /* Do not use R3 !! */
    
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
    *   RdLo -  0x55555555(LR) 0x55555554(SP)
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL1   /* <Rn> */
    MOV     R1,#1       /* Rm */        
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLA RdLo, RdHi, Rn=R13, Rm */
    SCST_OPCODE32_HIGH(0xFBED)  /* UMLAL   R5,R4,R13,R1 */
    SCST_OPCODE32_LOW(0x5401)    
    SCST_OPCODE_END
    
    ISB
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    LDR     R8,=0x55555554     /* Stack is always aligned !!! */
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL1   /* <Rn> */
    MOV     R0,#1       /* Rm */   
    ISB
    UMLAL   R5,R4,R14,R0     /* UMLA RdLo, RdHi, Rn=R14, Rm */
    ISB
    MOV     R14,R6  /* Restore LR register */
    CMP     R5,#0x55555555
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
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
    *   RdLo -  0xAAAAAAAA(LR) 0xAAAAAAA8(SP)
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL2   /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R5,R4,R13,R1 */
    SCST_OPCODE32_HIGH(0xFBED)  /* UMLA RdLo, RdHi, Rn=R13, Rm */
    SCST_OPCODE32_LOW(0x5401)    
    SCST_OPCODE_END
    
    ISB
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */    
    LDR     R8,=0xAAAAAAA8     /* Stack is always aligned !!! */
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL2   /* <Rn> */
    MOV     R0,#1       /* Rm */    
    ISB
    UMLAL   R5,R4,R14,R0     /* UMLA RdLo, RdHi, <Rn=R14>, Rm */
    ISB
    MOV     R14,R6  /* Restore LR register */    
    CMP     R5,#0xAAAAAAAA
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0x1
    *   Rm   -  0x55555555
    *
    *   0x000000000 00000000 + 0x1*0x55555555 
    *
    *   Output:
    *   ------
    *   RdLo - 0x55555555(LR) 0x55555554(SP) 
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R1,#1       /* Rn */
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL1    /* <Rm> */    
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R5,R4,R1,R13 */
    SCST_OPCODE32_HIGH(0xFBE1)  /* UMLA RdLo, RdHi, Rn, <Rm=R13> */
    SCST_OPCODE32_LOW( 0x540D)    
    SCST_OPCODE_END
    
    ISB
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    LDR     R8,=0x55555554     /* Stack is always aligned !!! */
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R0,#1       /* Rn */
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL1    /* <Rm> */   
    ISB
    UMLAL   R5,R4,R0,R14     /* UMLA RdLo, RdHi, Rn, <Rm=R14> */
    ISB
    MOV     R14,R6  /* Restore LR register */    
    CMP     R5,#0x55555555
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
   /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0x1
    *   Rm   -  0xAAAAAAAA
    *
    *   0x000000000 00000000 + 0x1*0xAAAAAAAA 
    *
    *   Output:
    *   ------
    *   RdLo - 0xAAAAAAAA(LR) 0xAAAAAAA8(SP) 
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R1,#1       /* Rn */
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL2    /* <Rm> */    
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R5,R4,R1,R13 */     
    SCST_OPCODE32_HIGH(0xFBE1)  /* UMLA RdLo, RdHi, Rn, <Rm=R13> */
    SCST_OPCODE32_LOW(0x540D)    
    SCST_OPCODE_END
    
    ISB
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */    
    LDR     R8,=0xAAAAAAA8     /* Stack is always aligned !!! */
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R0,#1       /* Rn */
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL2    /* <Rm> */   
    ISB
    UMLAL   R5,R4,R0,R14     /* UMLA RdLo, RdHi, Rn, <Rm=R14> */
    ISB    
    MOV     R14,R6  /* Restore LR register */
    CMP     R5,#0xAAAAAAAA
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
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
    *   RdLo = 0x55555555(LR) 0x55555554(SP)
    *****************************************************/ 
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL1    /* RdLo */    
    ISB    
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R13,R5,R4,R1 */
    SCST_OPCODE32_HIGH(0xFBE4)  /* UMLA <RdLo=R13>, RdHi, Rn, Rm */
    SCST_OPCODE32_LOW( 0xD501)    
    SCST_OPCODE_END
    
    ISB
    LDR     R8,=0x55555554     /* Stack is always aligned !!! */
    CMP     R13,R8
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */  
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL1    /* RdLo */    
    ISB
    UMLAL   R14,R5,R4,R0    /* UMLA <RdLo=R14>, RdHi, Rn, Rm */
    ISB    
    CMP     R14,#0x55555555
    MOV     R14,R6  /* Restore LR register */
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
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
    *   RdLo = 0xAAAAAAAA(LR) 0xAAAAAAA8(SP)
    *****************************************************/ 
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL2    /* RdLo */   
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R13,R5,R4,R1 */
    SCST_OPCODE32_HIGH(0xFBE4)  /* UMLA <RdLo=R13>, RdHi, Rn, Rm */
    SCST_OPCODE32_LOW(0xD501)    
    SCST_OPCODE_END
    
    ISB
    LDR     R8,=0xAAAAAAA8     /* Stack is always aligned !!! */
    CMP     R13,R8
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL2    /* RdLo */   
    ISB
    UMLAL   R14,R5,R4,R0    /* UMLA <RdLo=R14>, RdHi, Rn, Rm */
    ISB    
    CMP     R14,#0xAAAAAAAA
    MOV     R14,R6  /* Restore LR register */
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
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
    *   RdHi - 0x55555555(LR) 0x55555554(SP)
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL1    /* <RdHi> */    
    ISB
        
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R4,R13,R5,R1 */
    SCST_OPCODE32_HIGH(0xFBE5)  /* UMLA RdLo, <RdHi=R13>, Rn, Rm */
    SCST_OPCODE32_LOW(0x4D01)    
    SCST_OPCODE_END
    
    ISB
    LDR     R8,=0x55555554     /* Stack is always aligned !!! */
    CMP     R13,R8
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL1    /* <RdHi> */    
    ISB
    UMLAL   R4,R14,R5,R0    /* UMLA RdLo, <RdHi=R14>, Rn, Rm */
    ISB    
    CMP     R14,#0x55555555
    MOV     R14,R6  /* Restore LR register */
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
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
    *   RdHi - 0xAAAAAAAA(LR) 0xAAAAAAA8(SP)
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL2    /* <RdHi> */    
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R4,R13,R5,R1 */
    SCST_OPCODE32_HIGH(0xFBE5)  /* UMLA RdLo, <RdHi=R13>, Rn, Rm */
    SCST_OPCODE32_LOW(0x4D01)    
    SCST_OPCODE_END
    
    ISB
    LDR     R8,=0xAAAAAAA8     /* Stack is always aligned !!! */
    CMP     R13,R8
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL2    /* <RdHi> */    
    ISB
    UMLAL   R4,R14,R5,R0    /* UMLA RdLo, <RdHi=R14>, Rn, Rm */
    ISB    
    CMP     R14,#0xAAAAAAAA
    MOV     R14,R6  /* Restore LR register */
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0x99999999
    *   Rm   -  0x1
    *
    *   0x00000000 00000000 + 0x99999999*0x1 
    *
    *   Output:
    *   ------
    *   RdLo -  0x99999999(LR) 0x99999998(SP)
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL5   /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R5,R4,R13,R1 */
    SCST_OPCODE32_HIGH(0xFBED)  /* UMLA RdLo, RdHi, Rn=R13, Rm */
    SCST_OPCODE32_LOW(0x5401)    
    SCST_OPCODE_END
    
    ISB
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    LDR     R8,=0x99999998     /* Stack is always aligned !!! */
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL5   /* <Rn> */
    MOV     R0,#1       /* Rm */   
    ISB
    UMLAL   R5,R4,R14,R0     /* UMLA RdLo, RdHi, Rn=R14, Rm */
    ISB
    MOV     R14,R6  /* Restore LR register */
    CMP     R5,#0x99999999
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0x66666666
    *   Rm   -  0x1
    *
    *   0x000000000 00000000 + 0x66666666*0x1 
    *
    *   Output:
    *   ------
    *   RdLo -  0x66666666(LR) 0x66666664(SP)
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL6   /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R5,R4,R13,R1 */
    SCST_OPCODE32_HIGH(0xFBED)  /* UMLA RdLo, RdHi, Rn=R13, Rm */
    SCST_OPCODE32_LOW(0x5401)    
    SCST_OPCODE_END
    
    ISB
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */    
    LDR     R8,=0x66666664     /* Stack is always aligned !!! */
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL6   /* <Rn> */
    MOV     R0,#1       /* Rm */    
    ISB
    UMLAL   R5,R4,R14,R0     /* UMLA RdLo, RdHi, <Rn=R14>, Rm */
    ISB
    MOV     R14,R6  /* Restore LR register */    
    CMP     R5,#0x66666666
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0x1
    *   Rm   -  0x99999999
    *
    *   0x000000000 00000000 + 0x1*0x99999999 
    *
    *   Output:
    *   ------
    *   RdLo - 0x99999999(LR) 0x99999998(SP) 
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R1,#1       /* Rn */
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL5    /* <Rm> */    
    ISB
        
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R5,R4,R1,R13 */
    SCST_OPCODE32_HIGH(0xFBE1)  /* UMLA RdLo, RdHi, Rn, <Rm=R13> */
    SCST_OPCODE32_LOW(0x540D)    
    SCST_OPCODE_END
    
    ISB
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    LDR     R8,=0x99999998     /* Stack is always aligned !!! */
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R0,#1       /* Rn */
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL5    /* <Rm> */   
    ISB
    UMLAL   R5,R4,R0,R14     /* UMLA RdLo, RdHi, Rn, <Rm=R14> */
    ISB
    MOV     R14,R6  /* Restore LR register */    
    CMP     R5,#0x99999999
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
   /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0x1
    *   Rm   -  0x66666666
    *
    *   0x000000000 00000000 + 0x1*0x66666666 
    *
    *   Output:
    *   ------
    *   RdLo - 0x66666666(LR) 0x66666664(SP) 
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R1,#1       /* Rn */
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL6    /* <Rm> */    
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R5,R4,R1,R13 */
    SCST_OPCODE32_HIGH(0xFBE1)  /* UMLA RdLo, RdHi, Rn, <Rm=R13> */
    SCST_OPCODE32_LOW(0x540D)    
    SCST_OPCODE_END
    
    ISB
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */    
    LDR     R8,=0x66666664     /* Stack is always aligned !!! */
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R0,#1       /* Rn */
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL6    /* <Rm> */   
    ISB
    UMLAL   R5,R4,R0,R14     /* UMLA RdLo, RdHi, Rn, <Rm=R14> */
    ISB    
    MOV     R14,R6  /* Restore LR register */
    CMP     R5,#0x66666666
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x99999999
    *   RdHi -  0x0
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0x00000000 55555555 + 0*0 
    *
    *   Output:
    *   ------
    *   RdLo = 0x99999999(LR) 0x99999998(SP)
    *****************************************************/ 
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL5    /* RdLo */    
    ISB    
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R13,R5,R4,R1 */
    SCST_OPCODE32_HIGH(0xFBE4)  /* UMLA <RdLo=R13>, RdHi, Rn, Rm */
    SCST_OPCODE32_LOW(0xD501)    
    SCST_OPCODE_END
    
    ISB
    LDR     R8,=0x99999998     /* Stack is always aligned !!! */
    CMP     R13,R8
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */  
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL5    /* RdLo */    
    ISB
    UMLAL   R14,R5,R4,R0    /* UMLA <RdLo=R14>, RdHi, Rn, Rm */
    ISB    
    CMP     R14,#0x99999999
    MOV     R14,R6  /* Restore LR register */
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x66666666
    *   RdHi -  0x0
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0x00000000 AAAAAAAA + 0*0 
    *
    *   Output:
    *   ------
    *   RdLo = 0x66666666(LR) 0x66666664(SP)
    *****************************************************/ 
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL6    /* RdLo */   
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R13,R5,R4,R1 */
    SCST_OPCODE32_HIGH(0xFBE4)  /* UMLA <RdLo=R13>, RdHi, Rn, Rm */
    SCST_OPCODE32_LOW(0xD501)    
    SCST_OPCODE_END
    
    ISB
    LDR     R8,=0x66666664     /* Stack is always aligned !!! */
    CMP     R13,R8
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL6    /* RdLo */   
    ISB
    UMLAL   R14,R5,R4,R0    /* UMLA <RdLo=R14>, RdHi, Rn, Rm */
    ISB    
    CMP     R14,#0x66666666
    MOV     R14,R6  /* Restore LR register */
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x99999999
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0x99999999 00000000 + 0*0 
    *
    *   Output:
    *   ------
    *   RdHi - 0x99999999(LR) 0x99999998(SP)
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL5    /* <RdHi> */    
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R4,R13,R5,R1 */
    SCST_OPCODE32_HIGH(0xFBE5)  /* UMLA RdLo, <RdHi=R13>, Rn, Rm */
    SCST_OPCODE32_LOW(0x4D01)    
    SCST_OPCODE_END
    
    ISB
    LDR     R8,=0x99999998     /* Stack is always aligned !!! */
    CMP     R13,R8
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL5    /* <RdHi> */    
    ISB
    UMLAL   R4,R14,R5,R0    /* UMLA RdLo, <RdHi=R14>, Rn, Rm */
    ISB    
    CMP     R14,#0x99999999
    MOV     R14,R6  /* Restore LR register */
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
   /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x66666666
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0x66666666 00000000 + 0*0 
    *
    *   Output:
    *   ------
    *   RdHi - 0x66666666(LR) 0x66666664(SP)
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL6    /* <RdHi> */    
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R4,R13,R5,R1 */    
    SCST_OPCODE32_HIGH(0xFBE5)  /* UMLA RdLo, <RdHi=R13>, Rn, Rm */
    SCST_OPCODE32_LOW(0x4D01)    
    SCST_OPCODE_END
    
    ISB
    LDR     R8,=0x66666664     /* Stack is always aligned !!! */
    CMP     R13,R8
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL6    /* <RdHi> */    
    ISB
    UMLAL   R4,R14,R5,R0    /* UMLA RdLo, <RdHi=R14>, Rn, Rm */
    ISB    
    CMP     R14,#0x66666666
    MOV     R14,R6  /* Restore LR register */
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
    
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
    *   RdLo -  0x13579BDF(LR) 0x13579BDC(SP)
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL9   /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
        
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R5,R4,R13,R1 */
    SCST_OPCODE32_HIGH(0xFBED)  /* UMLA RdLo, RdHi, Rn=R13, Rm */
    SCST_OPCODE32_LOW(0x5401)    
    SCST_OPCODE_END
    
    ISB
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    LDR     R8,=0x13579BDC     /* Stack is always aligned !!! */
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL9   /* <Rn> */
    MOV     R0,#1       /* Rm */   
    ISB
    UMLAL   R5,R4,R14,R0     /* UMLA RdLo, RdHi, Rn=R14, Rm */
    ISB
    MOV     R14,R6  /* Restore LR register */
    LDR     R8,=VAL9
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0xFDB97531
    *   Rm   -  0x1
    *
    *   0x000000000 00000000 + 0xFDB97531*0x1 
    *
    *   Output:
    *   ------
    *   RdLo -  0xFDB97531(LR) 0xFDB97530(SP)
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL10   /* <Rn> */
    MOV     R1,#1       /* Rm */    
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R5,R4,R13,R1 */
    SCST_OPCODE32_HIGH(0xFBED)  /* UMLA RdLo, RdHi, Rn=R13, Rm */
    SCST_OPCODE32_LOW(0x5401)    
    SCST_OPCODE_END
    
    ISB
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */    
    LDR     R8,=0xFDB97530    /* Stack is always aligned !!! */
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL10   /* <Rn> */
    MOV     R0,#1       /* Rm */    
    ISB
    UMLAL   R5,R4,R14,R0     /* UMLA RdLo, RdHi, <Rn=R14>, Rm */
    ISB
    MOV     R14,R6  /* Restore LR register */    
    LDR     R8,=VAL10
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0x1
    *   Rm   -  0x13579BDF
    *
    *   0x000000000 00000000 + 0x1*0x13579BDF 
    *
    *   Output:
    *   ------
    *   RdLo - 0x13579BDF(LR) 0x13579BDC(SP) 
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R1,#1       /* Rn */
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL9    /* <Rm> */    
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R5,R4,R1,R13 */
    SCST_OPCODE32_HIGH(0xFBE1)  /* UMLA RdLo, RdHi, Rn, <Rm=R13> */
    SCST_OPCODE32_LOW( 0x540D)    
    SCST_OPCODE_END
    
    ISB
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    LDR     R8,=0x13579BDC     /* Stack is always aligned !!! */
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R0,#1       /* Rn */
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL9    /* <Rm> */   
    ISB
    UMLAL   R5,R4,R0,R14     /* UMLA RdLo, RdHi, Rn, <Rm=R14> */
    ISB
    MOV     R14,R6  /* Restore LR register */    
    LDR     R8,=VAL9
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
   /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0x0
    *   Rn   -  0x1
    *   Rm   -  0xFDB97531
    *
    *   0x000000000 00000000 + 0x1*0xFDB97531 
    *
    *   Output:
    *   ------
    *   RdLo - 0xFDB97531(LR) 0xFDB97530(SP) 
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R1,#1       /* Rn */
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL10    /* <Rm> */    
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R5,R4,R1,R13 */
    SCST_OPCODE32_HIGH(0xFBE1)  /* UMLA RdLo, RdHi, Rn, <Rm=R13> */
    SCST_OPCODE32_LOW(0x540D)    
    SCST_OPCODE_END
    
    ISB
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */    
    LDR     R8,=0xFDB97530    /* Stack is always aligned !!! */
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R0,#1       /* Rn */
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL10    /* <Rm> */   
    ISB
    UMLAL   R5,R4,R0,R14     /* UMLA RdLo, RdHi, Rn, <Rm=R14> */
    ISB    
    MOV     R14,R6  /* Restore LR register */
    LDR     R8,=VAL10
    CMP     R5,R8
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x13579BDF
    *   RdHi -  0x0
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0x00000000 55555555 + 0*0 
    *
    *   Output:
    *   ------
    *   RdLo = 0x13579BDF(LR) 0x13579BDC(SP)
    *****************************************************/ 
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL9    /* RdLo */    
    ISB    
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R13,R5,R4,R1 */
    SCST_OPCODE32_HIGH(0xFBE4)  /* UMLA <RdLo=R13>, RdHi, Rn, Rm */
    SCST_OPCODE32_LOW(0xD501)    
    SCST_OPCODE_END
    
    ISB
    LDR     R8,=0x13579BDC     /* Stack is always aligned !!! */
    CMP     R13,R8
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */  
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL9    /* RdLo */    
    ISB
    UMLAL   R14,R5,R4,R0    /* UMLA <RdLo=R14>, RdHi, Rn, Rm */
    ISB    
    LDR     R8,=VAL9
    CMP     R14,R8
    MOV     R14,R6  /* Restore LR register */
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
    /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0xFDB97531
    *   RdHi -  0x0
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0x00000000 AAAAAAAA + 0*0 
    *
    *   Output:
    *   ------
    *   RdLo = 0xFDB97531(LR) 0xFDB97530(SP)
    *****************************************************/ 
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL10    /* RdLo */   
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R13,R5,R4,R1 */
    SCST_OPCODE32_HIGH(0xFBE4)  /* UMLA <RdLo=R13>, RdHi, Rn, Rm */
    SCST_OPCODE32_LOW(0xD501)    
    SCST_OPCODE_END
    
    ISB
    LDR     R8,=0xFDB97530    /* Stack is always aligned !!! */
    CMP     R13,R8
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL10    /* RdLo */   
    ISB
    UMLAL   R14,R5,R4,R0    /* UMLA <RdLo=R14>, RdHi, Rn, Rm */
    ISB    
    LDR     R8,=VAL10
    CMP     R14,R8
    MOV     R14,R6  /* Restore LR register */
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
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
    *   RdHi - 0x13579BDF(LR) 0x13579BDC(SP)
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL9    /* <RdHi> */    
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R4,R13,R5,R1 */
    SCST_OPCODE32_HIGH(0xFBE5)  /* UMLA RdLo, <RdHi=R13>, Rn, Rm */
    SCST_OPCODE32_LOW(0x4D01)    
    SCST_OPCODE_END
    
    ISB
    LDR     R8,=0x13579BDC     /* Stack is always aligned !!! */
    CMP     R13,R8
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL9    /* <RdHi> */    
    ISB
    UMLAL   R4,R14,R5,R0    /* UMLA RdLo, <RdHi=R14>, Rn, Rm */
    ISB    
    LDR     R8,=VAL9
    CMP     R14,R8
    MOV     R14,R6  /* Restore LR register */
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
   /***************************************************
    *   Input:
    *   -----
    *   RdLo -  0x0
    *   RdHi -  0xFDB97531
    *   Rn   -  0x0
    *   Rm   -  0x0
    *
    *   0xFDB97531 00000000 + 0*0 
    *
    *   Output:
    *   ------
    *   RdHi - 0xFDB97531(LR) 0xFDB97530(SP)
    *****************************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R2,R13  /* Store SP register */
    CPSID   i   /* Disable interrupts !! */
    LDR     R13,=VAL10    /* <RdHi> */    
    ISB
    
    /* Use opcode to avoid problems with GCC compiler */
    SCST_OPCODE_START   /* UMLAL   R4,R13,R5,R1 */
    SCST_OPCODE32_HIGH(0xFBE5)  /* UMLA RdLo, <RdHi=R13>, Rn, Rm */
    SCST_OPCODE32_LOW( 0x4D01)    
    SCST_OPCODE_END
    
    ISB
    LDR     R8,=0xFDB97530     /* Stack is always aligned !!! */
    CMP     R13,R8
    MOV     R13,R2  /* Restore SP register */
    MSR     PRIMASK,R3  /* Restore PRIMASK */
    BNE.W   m4_scst_regbank_test6_error
    
    /************************************/
    BL      m4_scst_regbank_test6_clear_registers
    MOV     R6,R14  /* Store LR */
    LDR     R14,=VAL10    /* <RdHi> */    
    ISB
    UMLAL   R4,R14,R5,R0    /* UMLA RdLo, <RdHi=R14>, Rn, Rm */
    ISB
    LDR     R8,=VAL10
    CMP     R14,R8
    MOV     R14,R6  /* Restore LR register */
    BNE.W   m4_scst_regbank_test6_error
    
    ADDW    R9,R9,#0xE5A
    
    
    MOV     R0,R9       /* Test result is returned in R0 */
    
    B       m4_scst_test_tail_end
    
m4_scst_regbank_test6_clear_registers:
    MOV     R0,#0
    MOV     R1,#0
    MOV     R4,#0
    MOV     R5,#0
    BX      LR

/* We branch here first - conditional branches supports max. -1048576 to 1048574 bytes */
m4_scst_regbank_test6_error:
    B       m4_scst_test_tail_end

    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
                   
    SCST_FILE_END
