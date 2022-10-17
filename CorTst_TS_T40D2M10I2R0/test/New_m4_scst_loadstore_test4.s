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
*
* Covers LSU operation type:
*   - load/store single
*
* Overall coverage:
* -----------------
* Covers LDR.N, STR.N, LDRB.N, STRB.N, LDRH.N, STRH.N, LDRSB.N, STRSB.N, LDRSH.N, STRSH.N 
* instructions as well as logic processing its various encoding types:
* - '<Rn>','<Rt>' and #<imm5> as well as as well as  <data_to_store> and <data_to_load>
* - '<Rt>' and '#<imm8>' as well <data_to_store> and <data_to_load>
* - '<Rm>','<Rn>','<Rt>' as well <data_to_store> and <data_to_load>
* - '<Rt>',<label> as well as <data_to_load> 
* 
* DECODER:
* Thumb (16-bit)
*   - Encoding of "Load/store single data item" instructions
* 测试总结：
* -------------
*
* 涵盖 LSU 操作类型：
* - 加载/存储单个
*
* 整体覆盖：
* -----------------
* 涵盖 LDR.N、STR.N、LDRB.N、STRB.N、LDRH.N、STRH.N、LDRSB.N、STRSB.N、LDRB.N、STRSH.N
* 指令以及逻辑处理其各种编码类型：
* - '<Rn>'、'<Rt>' 和 #<imm5> 以及 <data_to_store> 和 <data_to_load>
* - '<Rt>' 和 '#<imm8>' 以及 <data_to_store> 和 <data_to_load>
* - '<Rm>','<Rn>','<Rt>' 以及 <data_to_store> 和 <data_to_load>
* - '<Rt>',<label> 以及 <data_to_load>
*
* 解码器：
* 拇指（16 位）
* - “加载/存储单个数据项”指令的编码
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_loadstore_test4

    /* Symbols defined outside but used within current module */
    SCST_EXTERN SCST_RAM_TARGET0
    SCST_EXTERN SCST_RAM_TARGET1
    SCST_EXTERN m4_scst_test_tail_end

    SCST_EXTERN VAL1
    SCST_EXTERN VAL2
    SCST_EXTERN VAL3
    SCST_EXTERN VAL4
    SCST_EXTERN VAL5
    SCST_EXTERN VAL6
    SCST_EXTERN VAL7
    SCST_EXTERN VAL8
    SCST_EXTERN VAL9
    SCST_EXTERN VAL10

SCST_SET(PRESIGNATURE, 0x72D5EA31) /* this macro has to be at the beginning of the line */
    
    
    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2
    
    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_loadstore_test4" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_loadstore_test4, function)
m4_scst_loadstore_test4:

    PUSH.W  {R1-R12,R14}

    LDR     R8,=SCST_RAM_TARGET0
    BL      m4_scst_loadstore_test4_common
    LDR     R8,=SCST_RAM_TARGET1
    BL      m4_scst_loadstore_test4_common
    
    /* Test passed -> store result */
    LDR     R0,=VAL9
    EORS    R0,R1

m4_scst_loadstore_test4_end:
    B       m4_scst_test_tail_end

m4_scst_loadstore_test4_failed:

    POP.W   {R1,R14}    /* We just need to pop two words from stack */
    MOVW    R0,#0x444
    B       m4_scst_loadstore_test4_end

m4_scst_loadstore_test4_common:

    /* Load pre-signature */ 
    LDR     R1,=PRESIGNATURE

    PUSH    {R1,R14}    /* We need to store R1 and R14. */
    
    /*************************************************************************************************
    * Instructions: 
    *   - STR (immediate)   Encoding T1 (16-bit)
    *   - LDR (immediate)   Encoding T1 (16-bit)
    *
    **************************************************************************************************/   
    BL      m4_scst_loadstore_test4_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    SUB     R2,R8,#0x54     /* Decrement address 0x15*(4-bytes)=0x54 */    
    /* <Rn[5:3]>:R2
       <Rt[2:0]>:R0(STR) R1(LDR)
       <imm5[10:6]>:0x15=0b10101 */
    STR.N   R0,[R2,#0x54]   /* <data_to_store>:R0=0x55555555 */
    DSB
    LDR.N   R1,[R2,#0x54]   /* <data_to_load>:R1=0x55555555 */
    /* We need to check data */
    CMP     R0,R1
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    SUB     R2,R8,#0x28     /* Decrement address 0xA*(4-bytes)=0x28 */ 
    /* <Rn[5:3]>:R2
       <Rt[2:0]>:R1(STR) R0(LDR)
       <imm5[10:6]>:0xA=0b01010 */
    STR.N   R1,[R2,#0x28]   /* <data_to_store>:R1=0xAAAAAAAA */
    DSB
    LDR.N   R0,[R2,#0x28]   /* <data_to_load>:R0=0xAAAAAAAA */
    /* We need to check data */
    CMP     R1,R0
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    ADD     R8,R8,#4
    SUB     R5,R8,#0x4C     /* Decrement address 0x1B*(4-bytes)=0x6C */
    /* <Rn[5:3]>:R5
       <Rt[2:0]>:R2(STR) R3(LDR)
       <imm5[10:6]>:0x13=0b10011 */
    STR.N   R2,[R5,#0x4C]   /* <data_to_store>:R2=0xCCCCCCCC */
    DSB
    LDR.N   R3,[R5,#0x4C]   /* <data_to_load>:R3=0xCCCCCCCC */
    /* We need to check data */
    CMP     R2,R3
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    SUB     R5,R8,#0x30     /* Decrement address 0xC*(4-bytes)=0x30 */
    /* <Rn[5:3]>:R5
       <Rt[2:0]>:R3(STR) R2(LDR)
       <imm5[10:6]>:0x6=0b01100 */
    STR.N   R3,[R5,#0x30]   /* <data_to_store>:R3=0x33333333 */
    DSB
    LDR.N   R2,[R5,#0x30]   /* <data_to_load>:R2=0x33333333 */
    /* We need to check data */
    CMP     R3,R2
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    ADD     R8,R8,#4
    SUB     R7,R8,#0x1C     /* Decrement address 0x7*(4-bytes)=0x1C */
    /* <Rn[5:3]>:R7
       <Rt[2:0]>:R4(STR) R5(LDR)
       <imm5[10:6]>:0x7=0b00111 */
    STR.N   R4,[R7,#0x1C]   /* <data_to_store>:R4=0x99999999 */
    DSB
    LDR.N   R5,[R7,#0x1C]   /* <data_to_load>:R5=0x99999999 */
    /* We need to check data */
    CMP     R4,R5
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    SUB     R7,R8,#0x70     /* Decrement address 0x1C*(4-bytes)=0x70 */
    /* <Rn[5:3]>:R7
       <Rt[2:0]>:R5(STR) R4(LDR)
       <imm5[10:6]>:0x1C=0b11100 */
    STR.N   R5,[R7,#0x70]   /* <data_to_store>:R5=0x66666666 */
    DSB
    LDR.N   R4,[R7,#0x70]   /* <data_to_load>:R4=0x66666666 */
    /* We need to check data */
    CMP     R5,R4
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    ADD     R8,R8,#4
    SUB     R3,R8,#0x7C     /* Decrement address 0x1F*(4-bytes)=0x7C */
    /* <Rn[5:3]>:R3
       <Rt[2:0]>:R6(STR) R7(LDR)
       <imm5[10:6]>:0x1F=0b11111 */
    STR.N   R6,[R3,#0x7C]   /* <data_to_store>:R6=0x77777777 */
    DSB
    LDR.N   R7,[R3,#0x7C]   /* <data_to_load>:R7=0x77777777 */
    /* We need to check data */
    CMP     R6,R7
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    MOV     R3,R8
    /* <Rn[5:3]>:R3
       <Rt[2:0]:R7(STR) R6(LDR)
       <imm5[10:6]>:0x0=0b00000 */
    STR.N   R7,[R3,#0x0]    /* <data_to_store>:R5=0xEEEEEEEE */
    DSB
    LDR.N   R6,[R3,#0x0]    /* <data_to_load>:R6=0xEEEEEEEE */
    /* We need to check data */
    CMP     R7,R6
    BNE     m4_scst_loadstore_test4_failed
    
    
    /*************************************************************************************************
    * Instructions: 
    *   - STRB (immediate)  Encoding T1 (16-bit)
    *   - LDRB (immediate)  Encoding T1 (16-bit)
    *
    * Note: Formats of these instructions are identical to T1 encoding of the STR (immediate) 
    *       and LDR (immediate) ones.
    *       Testing only of "byte" operations are performed.
    **************************************************************************************************/
    ADD     R8,R8,#4
    /* --- Prepare data to be stored and loaded ---  */
    LDR     R0,=VAL9
    SUB     R2,R8,#0x15     /* Decrement address 0x15 */    
    /* <Rn[5:3]>:R2
       <Rt[2:0]>:R0(STRB) R1(LDRB)
       <imm5[10:6]>:0x15=0b10101 */
    STRB.N  R0,[R2,#0x15]   /* <data_to_store>:R0=0x13579BDF (0xDF) */
    DSB
    LDRB.N  R1,[R2,#0x15]   /* <data_to_load>:R1=0xDF*/
    /* We need to check data */
    LDR     R0,[R2,#0x15]
    LDR     R9,=0xFFFFFF00
    EOR     R0,R0,R9
    CMP     R1,R0
    BNE     m4_scst_loadstore_test4_failed
   
    /* --- Prepare data to be stored and loaded ---  */
    LDR     R1,=VAL10
    SUB     R2,R8,#0xA      /* Decrement address 0xA */
    /* <Rn[5:3]>:R2
       <Rt[2:0]>:R1(STRB) R0(LDRB)
       <imm5[10:6]>:0xA=0b01010 */
    STRB.N  R1,[R2,#0xA]    /* <data_to_store>:R1=0xFDB97531 (0x31) */
    DSB
    LDRB.N  R0,[R2,#0xA]    /* <data_to_load>:R0=0x31 */
    /* We need to check data */
    LDR     R1,[R2,#0xA] 
    LDR     R9,=0xFFFFFF00
    EOR     R1,R1,R9
    CMP     R0,R1
    BNE     m4_scst_loadstore_test4_failed
    
    
    /*************************************************************************************************
    * Instructions: 
    *   - STRH (immediate)  Encoding T1 (16-bit)
    *   - LDRH (immediate)  Encoding T1 (16-bit)
    *
    * Note: Formats of these instructions are identical to T1 encoding of the STR (immediate)
    *       and LDR (immediate) ones.
    *       Testing only of "halfword" operations are performed.
    **************************************************************************************************/
    /* --- Prepare data to be stored and loaded ---  */
    LDR     R2,=VAL9
    SUB     R5,R8,#0x36     /* Decrement address 0x1B*(2-bytes)=0x36 */
    /* <Rn[5:3]>:R5
       <Rt[2:0]>:R2(STRH) R3(LDRH)
       <imm5[10:6]>:0x13=0b10011 */
    STRH.N  R2,[R5,#0x36]   /* <data_to_store>:R2=0x13579BDF (0x9BDF) */
    DSB
    LDRH.N  R3,[R5,#0x36]   /* <data_to_load>:R3=0x9BDF */
    /* We need to check data */
    LDR     R2,[R5,#0x36]
    LDR     R9,=0xFFFF0000
    EOR     R2,R2,R9
    CMP     R3,R2
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    LDR     R3,=VAL10
    SUB     R5,R8,#0x18      /* Decrement address 0xC*(2-bytes)=0x18 */
    /* <Rn[5:3]>:R5
       <Rt[2:0]>:R3(STRH) R2(LDRH)
       <imm5[10:6]>:0x6=0b01100 */
    STRH.N  R3,[R5,#0x18]    /* <data_to_store>:R3=0xFDB97531 (0x7531) */
    DSB
    LDRH.N  R2,[R5,#0x18]    /* <data_to_load>:R2=0x7531 */
    /* We need to check data */
    LDR     R3,[R5,#0x18]
    LDR     R9,=0xFFFF0000
    EOR     R3,R3,R9
    CMP     R2,R3
    BNE     m4_scst_loadstore_test4_failed
    
    
    /*************************************************************************************************
    * Instructions: 
    *   - STR (immediate)   Encoding T2 (16-bit)
    *   - LDR (immediate)   Encoding T2 (16-bit)
    **************************************************************************************************/
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    PUSH    {R0-R7}
    /* <Rt[10:8]:R1(STR) R0(LDR)
       <imm8[7:0]>:0x00 */
    STR.N   R1,[SP,#0x0]
    LDR.N   R0,[SP,#0x0]
    /* We need to check data */
    CMP     R0,R1
    POP     {R0-R7}
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    /* <Rt[10:8]:R0(STR) R1(LDR)
       <imm8[7:0]>:0x04 */
    PUSH    {R0-R7}
    STR.N   R0,[SP,#0x4]
    LDR.N   R1,[SP,#0x4]
    /* We need to check data */
    CMP     R1,R0
    POP     {R0-R7}
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    /* <Rt[10:8]:R3(STR) R2(LDR)
       <imm8[7:0]>:0x08 */
    PUSH    {R0-R7}
    STR     R3,[SP,#0x8]
    LDR     R2,[SP,#0x8] 
    /* We need to check data */
    CMP     R2,R3
    POP     {R0-R7}
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
     /* <Rt[10:8]:R3(STR) R2(LDR)
       <imm8[7:0]>:0x0C */
    PUSH    {R0-R7}
    STR     R2,[SP,#0xC]
    LDR     R3,[SP,#0xC]
    /* We need to check data */
    CMP     R3,R2
    POP     {R0-R7}
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    /* <Rt[10:8]:R5(STR) R4(LDR)
       <imm8[7:0]>: 0x10 */
    PUSH    {R0-R7}
    STR     R5,[SP,#0x10]
    LDR     R4,[SP,#0x10] 
    /* We need to check data */
    CMP     R4,R5
    POP     {R0-R7}
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
     /* <Rt[10:8]:R4(STR) R5(LDR)
       <imm8[7:0]>:0x14 */
    PUSH    {R0-R7}
    STR     R4,[SP,#0x14]
    LDR     R5,[SP,#0x14]
    /* We need to check data */
    CMP     R5,R4
    POP     {R0-R7}
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    /* <Rt[10:8]:R7(STR) R6(LDR)
       <imm8[7:0]>: 0x18 */
    PUSH    {R0-R7}
    STR     R7,[SP,#0x18]
    LDR     R6,[SP,#0x18] 
    /* We need to check data */
    CMP     R6,R7
    POP     {R0-R7}
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    /* <Rt[10:8]:R4(STR) R5(LDR)
       <imm8[7:0]>:0x1C */
    PUSH    {R0-R7}
    STR     R6,[SP,#0x1C]
    LDR     R7,[SP,#0x1C]
    /* We need to check data */
    CMP     R7,R6
    POP     {R0-R7}
    BNE     m4_scst_loadstore_test4_failed
    
    
    /*************************************************************************************************
    * Instructions: 
    *   - STR (register)    Encoding T1 (16-bit)
    *   - LDR (register)    Encoding T1 (16-bit)
    **************************************************************************************************/
    SUB     R8,R8,#16
    BL     m4_scst_loadstore_test4_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    MOV     R2,R8       /* Load address to R2 */
    MOV     R3,#0x0     /* Add offset to R3 */ 
    /* <Rm[8:6]>:R3
       <Rn[5:3]>:R2
       <Rt[2:0]>:R0(STR) R1(LDR) */
    STR.N   R0,[R2,R3]      /* <data_to_store>:R0=0x55555555 */
    DSB
    LDR.N   R1,[R2,R3]      /* <data_to_load>:R1=0x55555555 */
    /* We need to check data */
    CMP     R0,R1
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    MOV     R3,#0x0     /* Load address to R3 */ 
    MOV     R2,R8       /* Add offset to R2 */
    /* <Rm[8:6]>:R2
       <Rn[5:3]>:R3
       <Rt[2:0]>:R1(STR) R0(LDR) */
    STR.N   R1,[R3,R2]      /* <data_to_store>:R1=0xAAAAAAAA */
    DSB
    LDR.N   R0,[R3,R2]      /* <data_to_load>:R0=0xAAAAAAAA */
    /* We need to check data */
    CMP     R1,R0
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    MOV     R0,R8       /* Load address to R0 */
    MOV     R1,#0x4     /* Add offset to R1 */
    /* <Rm[8:6]>:R1
       <Rn[5:3]>:R0
       <Rt[2:0]>:R2(STR) R3(LDR) */
    STR.N   R2,[R0,R1]      /* <data_to_store>:R2=0xCCCCCCCC */
    DSB
    LDR.N   R3,[R0,R1]      /* <data_to_load>:R3=0xCCCCCCCC */
    /* We need to check data */
    CMP     R2,R3
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    MOV     R1,#0x4     /* Load address to R1 */
    MOV     R0,R8       /* Add offset to R0 */
    /* <Rm[8:6]>:R0
       <Rn[5:3]>:R1
       <Rt[2:0]>:R3(STR) R2(LDR)*/
    STR.N   R3,[R1,R0]      /* <data_to_store>:R3=0x33333333 */
    DSB
    LDR.N   R2,[R1,R0]      /* <data_to_load>:R2=0x33333333 */
    /* We need to check data */
    CMP     R3,R2
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    MOV     R7,R8       /* Load address to R7 */
    MOV     R6,#0x8     /* Add offset to R6 */
    /* <Rm[8:6]>:R6
       <Rn[5:3]>:R7
       <Rt[2:0]>:R4(STR) R5(LDR) */
    STR.N   R4,[R7,R6]      /* <data_to_store>:R4=0x99999999 */
    DSB
    LDR.N   R5,[R7,R6]      /* <data_to_load>:R5=0x99999999 */
    /* We need to check data */
    CMP     R4,R5
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init    
    MOV     R6,#0x8     /* Load address to R6 */
    MOV     R7,R8       /* Add offset to R7 */
    /* <Rm[8:6]>:R7
       <Rn[5:3]>:R6
       <Rt[2:0]>:R5(STR) R4(LDR) */
    STR.N   R5,[R6,R7]      /* <data_to_store>:R5=0x66666666 */
    DSB
    LDR.N   R4,[R6,R7]      /* <data_to_load>:R4=0x66666666 */
    /* We need to check data */
    CMP     R5,R4
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    MOV     R4,R8       /* Load address to R4 */
    MOV     R5,#0xC     /* Add offset to R5 */
    /* <Rm[8:6]>:R5
       <Rn[5:3]>:R4
       <Rt[2:0]>:R6(STR) R7(LDR) */
    STR.N   R6,[R4,R5]      /* <data_to_store>:R6=0x77777777 */
    DSB
    LDR.N   R7,[R4,R5]      /* <data_to_load>:R7=0x77777777 */
    /* We need to check data */
    CMP     R6,R7
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test4_init
    MOV     R5,#0xC     /* Load address to R5 */
    MOV     R4,R8       /* Add offset to R4 */       
    /* <Rm[8:6]>:R4
       <Rn[5:3]>:R5
       <Rt[2:0]:R7(STR) R6(LDR) */
    STR.N   R7,[R5,R4]      /* <data_to_store>:R5=0xEEEEEEEE */
    DSB
    LDR.N   R6,[R5,R4]      /* <data_to_load>:R6=0xEEEEEEEE */
    /* We need to check data */
    CMP     R7,R6
    BNE     m4_scst_loadstore_test4_failed
    
    
    /*************************************************************************************************
    * Instructions: 
    *   - STRB (register)   Encoding T1 (16-bit)
    *   - LDRB (register)   Encoding T1 (16-bit)
    *
    * Note: Formats of these instructions are identical to T1 encoding of the STR (register)
    *       and LDR (register) ones.
    *       Testing only of "byte" operations are performed.
    **************************************************************************************************/
    /* --- Prepare data to be stored and loaded ---  */
    LDR     R0,=VAL9
    MOV     R2,R8       /* Load address to R2 */
    MOV     R3,#0x10    /* Add offset to R3 */ 
    /* <Rm[8:6]>:R3
       <Rn[5:3]>:R2
       <Rt[2:0]>:R0(STRB) R1(LDRB) */
    STRB.N  R0,[R2,R3]      /* <data_to_store>:R0=0x13579BDF (0xDF) */
    DSB
    LDRB.N  R1,[R2,R3]      /* <data_to_load>:R1=0xDF */
    /* We need to check data */
    LDR     R0,[R2,R3]
    LDR     R9,=0xFFFFFF00
    EOR     R0,R0,R9  
    CMP     R1,R0
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    LDR     R1,=VAL10
    MOV     R3,#0x10    /* Load address to R3 */ 
    MOV     R2,R8       /* Add offset to R2 */
    /* <Rm[8:6]>:R2
       <Rn[5:3]>:R3
       <Rt[2:0]>:R1(STRB) R0(LDRB) */
    STRB.N  R1,[R3,R2]      /* <data_to_store>:R1=0xFDB97531 */
    DSB
    LDRB.N  R0,[R3,R2]      /* <data_to_load>:R0=0x31 */
    /* We need to check data */
    LDR     R1,[R3,R2]
    LDR     R9,=0xFFFFFF00
    EOR     R1,R1,R9  
    CMP     R0,R1
    BNE     m4_scst_loadstore_test4_failed
    
    
    /*************************************************************************************************
    * Instruction: 
    * - LDRSB.N (register)  Encoding T1 (16-bit)
    *
    * Note: Format of this instruction is identical to T1 encoding of the LDR (register)
    *       Testing only of "signed-byte" operation is performed.
    **************************************************************************************************/
    /* --- Prepare data to be stored and loaded ---  */
    LDR     R6,=VAL9
    MOV     R4,R8       /* Load address to R4 */
    MOV     R5,#0x10    /* Add offset to R5 */
    /* <Rm[8:6]>:R5
       <Rn[5:3]>:R4
       <Rt[2:0]>:R6(STR) R7(LDRSB) */
    STR.N   R6,[R4,R5]      /* <data_to_store>:R6=0x13579BDF*/
    DSB
    LDRSB.N R7,[R4,R5]      /* <data_to_load>:R7=0xFFFFFFDF */
    /* We need to check data */
    SBFX    R3,R6,#0,#8
    CMP     R7,R3
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    LDR     R7,=VAL10
    MOV     R5,#0x10    /* Load address to R5 */
    MOV     R4,R8       /* Add offset to R4 */       
    /* <Rm[8:6]>:R4
       <Rn[5:3]>:R5
       <Rt[2:0]:R7(STR) R6(LDRSB) */
    STR.N   R7,[R5,R4]      /* <data_to_store>:R5=0xFDB97531 */
    DSB
    LDRSB.N R6,[R5,R4]      /* <data_to_load>:R6=0x00000031 */
    /* We need to check data */
    SBFX    R3,R7,#0,#8
    CMP     R6,R3
    BNE     m4_scst_loadstore_test4_failed
    
    
    /*************************************************************************************************
    * Instructions: 
    *   - STRH (register)   Encoding T1 (16-bit)
    *   - LDRH (register)   Encoding T1 (16-bit)
    *
    * Note: Formats of these instructions are identical to T1 encoding of the STR.N (register)
    *       and LDR.N (register) ones.
    *       Testing only of "halfword" operations are performed.
    **************************************************************************************************/
    /* --- Prepare data to be stored and loaded ---  */
    LDR     R2,=VAL9
    MOV     R0,R8       /* Load address to R0 */
    MOV     R1,#0x14    /* Add offset to R1 */
    /* <Rm[8:6]>:R1
       <Rn[5:3]>:R0
       <Rt[2:0]>:R2(STRH) R3(LDRH) */
    STRH.N  R2,[R0,R1]      /* <data_to_store>:R2=0x13579BDF */
    DSB
    LDRH.N  R3,[R0,R1]      /* <data_to_load>:R3=0x00009BDF */
    /* We need to check data */
    LDR     R2,[R0,R1]
    LDR     R9,=0xFFFF0000
    EOR     R2,R2,R9    
    CMP     R3,R2
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    LDR     R3,=VAL10
    MOV     R1,#0x14    /* Load address to R1 */
    MOV     R0,R8       /* Add offset to R0 */
    /* <Rm[8:6]>:R0
       <Rn[5:3]>:R1
       <Rt[2:0]>:R3(STRH) R2(LDRH)*/
    STRH.N  R3,[R1,R0]      /* <data_to_store>:R3=0xFDB97531 */
    DSB
    LDRH.N  R2,[R1,R0]      /* <data_to_load>:R2=0x00007531 */
    /* We need to check data */
    LDR     R3,[R1,R0]
    LDR     R9,=0xFFFF0000
    EOR     R3,R3,R9  
    CMP     R2,R3
    BNE     m4_scst_loadstore_test4_failed
    
    
    /*************************************************************************************************
    * Instruction: 
    * - LDRSH.N (register)  Encoding T1 (16-bit)
    *
    * Note: Format of this instruction is identical to T1 encoding of the LDR (register)
    *       Testing only of "signed-halfword" operation is performed.
    **************************************************************************************************/
    /* --- Prepare data to be stored and loaded ---  */
    LDR     R4,=VAL9
    MOV     R7,R8       /* Load address to R7 */
    MOV     R6,#0x14     /* Add offset to R6 */
    /* <Rm[8:6]>:R6
       <Rn[5:3]>:R7
       <Rt[2:0]>:R4(STR) R5(LDRSH) */
    STR.N   R4,[R7,R6]      /* <data_to_store>:R4=0x13579BDF */
    DSB
    LDRSH.N R5,[R7,R6]      /* <data_to_load>:R5=0xFFFF9BDF */
    /* We need to check data */
    SBFX    R3,R4,#0,#16
    CMP     R5,R3
    BNE     m4_scst_loadstore_test4_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    LDR     R5,=VAL10
    MOV     R6,#0x14    /* Load address to R6 */
    MOV     R7,R8       /* Add offset to R7 */
    /* <Rm[8:6]>:R7
       <Rn[5:3]>:R6
       <Rt[2:0]>:R5(STR) R4(LDRSH) */
    STR.N   R5,[R6,R7]      /* <data_to_store>:R5=0xFDB97531 */
    DSB
    LDRSH.N R4,[R6,R7]      /* <data_to_load>:R4=0x00007531 */
    /* We need to check data */
    SBFX    R3,R5,#0,#16
    CMP     R4,R3
    BNE     m4_scst_loadstore_test4_failed
    
    POP.W   {R1,R14}    /* We need to restore R1 and R14. */
    BX      LR

    
m4_scst_loadstore_test4_init:

    /*************************************************************************************************
    * Instruction: 
    * - LDR (literal)   Encoding T1 (16-bit)
    *
    * Note: Tested indirectly 
    **************************************************************************************************/
    LDR.N   R0,=VAL1
    LDR.N   R1,=VAL2
    LDR.N   R2,=VAL3
    LDR.N   R3,=VAL4
    LDR.N   R4,=VAL5
    LDR.N   R5,=VAL6
    LDR.N   R6,=VAL7
    LDR.N   R7,=VAL8

    BX  LR
    
    
m4_scst_loadstore_test4_clear_target_memory:
    
    EORS    R1,R1   /* Clear R1 */
    MVN     R1,R1
    
    /* Clear memory */
    STR     R1,[R8]
    STR     R1,[R8,#4]
    STR     R1,[R8,#8]
    STR     R1,[R8,#12]
    STR     R1,[R8,#16]
    STR     R1,[R8,#20]
    
    BX      LR
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    