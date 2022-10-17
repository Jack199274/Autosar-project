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
*   - load/store double
*   - write back control
*
* Overall coverage:
* -----------------
* Covers LDRD.W, STRD.W instructions as well as logic processing its
* '<Rt>','<Rt2>','<Rn>' and '#<imm8>' as well as <data_to_store> and <data_to_load>.
*
* DECODER:
* Thumb (32-bit)
*   - Encoding of "Load/store dual or exclusive, table branch" instructions - Load/store dual
* 测试总结：
* -------------
*
* 涵盖 LSU 操作类型：
* - 加载/存储双倍
* - 写回控制
*
* 整体覆盖：
* -----------------
* 涵盖 LDRD.W、STRD.W 指令及其逻辑处理
* '<Rt>'、'<Rt2>'、'<Rn>' 和 '#<imm8>' 以及 <data_to_store> 和 <data_to_load>。
*
* 解码器：
* 拇指（32 位）
* - “加载/存储双重或独占，表分支”指令的编码 - 加载/存储双重
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_loadstore_test3

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
    SCST_EXTERN VAL11
    SCST_EXTERN VAL12

SCST_SET(PRESIGNATURE, 0x48D7E3A1) /*this macro has to be at the beginning of the line*/
    
    
    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_loadstore_test3" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_loadstore_test3, function)
m4_scst_loadstore_test3:

    PUSH.W  {R1-R12,R14}

    LDR     R0,=SCST_RAM_TARGET0
    BL      m4_scst_loadstore_test3_common
    LDR     R0,=SCST_RAM_TARGET1
    BL      m4_scst_loadstore_test3_common
    
    /* Test passed -> store result */
    LDR     R0,=VAL9
    EORS    R0,R1
    
m4_scst_loadstore_test3_end:
    B      m4_scst_test_tail_end
    

m4_scst_loadstore_test3_failed:
    POP.W   {R1,R14}    /* We just need to pop two words from stack */
    MOVW    R0,#0x444
    B       m4_scst_loadstore_test3_end

    
m4_scst_loadstore_test3_common:

    /* Load pre-signature */ 
    LDR     R1,=PRESIGNATURE

    PUSH    {R1,R14}    /* We need to store R1 and R14. */
    
    /**********************************************************************************************
    * Instructions:
    *   - STRD (immediate)      - LDRD (immediate)
    *
    *   Note: Encoding T1 (32-bit)
    **********************************************************************************************/
    BL      m4_scst_loadstore_test3_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test3_init
    SUB     R5,R0,#0x154     /* Decrement address - address must be multiple of 4 */    
    /* <Rn[3:0]>:R5 0x5
       <Rt[15:12],Rt2[11:8]>:R1,R2 0x12
       <imm8[7:0]>:0x55     0x55*(4-bytes)=0x154 
       <data_to_store>: R1=0x55555555, R2=0xAAAAAAAA */
    STRD.W  R1,R2,[R5,#0x154]   
    DSB
    /* We need to check address was not incremented */
    ADD     R5,R5,#0x154
    CMP     R5,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    LDR     R3,[R0]
    CMP     R1,R3
    BNE     m4_scst_loadstore_test3_failed
    LDR     R4,[R0,#4]
    CMP     R2,R4
    BNE     m4_scst_loadstore_test3_failed
    
    SUB     R5,R0,#0x154     /* Decrement address - address must be multiple of 4 */
    /* <Rn[3:0]>:R5 0x5
       <Rt[15:12],Rt2[11:8]>:R2,R1 0x21
       <imm8[7:0]>:0x55    0x55*(4-bytes)=0x154
       <data_to_load>:R1=0xAAAAAAAA, R2=0x55555555 */
    LDRD.W  R2,R1,[R5,#0x154] 
    /* We need to check address was not incremented */
    ADD     R5,R5,#0x154
    CMP     R5,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    CMP     R1,R4
    BNE     m4_scst_loadstore_test3_failed
    CMP     R2,R3
    BNE     m4_scst_loadstore_test3_failed
    
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test3_init
    SUB     R5,R0,#0x2A8     /* Decrement address - address must be multiple of 4 */
    /* <Rn[3:0]>:R5 0x5
       <Rt[15:12],Rt2[11:8]>:R2,R1 0x21
       <imm8[7:0]>:0xAA    0xAA*(4-bytes)=0x2A8
       <data_to_store>: R2=0xAAAAAAAA, R1=0x55555555 */
    STRD.W  R2,R1,[R5,#0x2A8]!                    
    DSB
    /* We need to check address was incremented and written back */
    CMP     R5,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    LDR     R3,[R0]
    CMP     R2,R3
    BNE     m4_scst_loadstore_test3_failed
    LDR     R4,[R0,#4]
    CMP     R1,R4
    BNE     m4_scst_loadstore_test3_failed
    
    SUB     R5,R0,#0x2A8     /* Decrement address - address must be multiple of 4 */
    /* <Rn[3:0]>:R5 0x5
       <Rt[15:12],Rt2[11:8]>:R1,R2 0x12
       <imm8[7:0]>:0xAA    0xAA*(4-bytes)=0x2A8 
       <data_to_load>:R2=0x55555555 R1=0xAAAAAAAA,  */
    LDRD.W  R1,R2,[R5,#0x2A8]!
    /* We need to check address was incremented and written back */
    CMP     R5,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    CMP     R1,R3
    BNE     m4_scst_loadstore_test3_failed
    CMP     R2,R4
    BNE     m4_scst_loadstore_test3_failed
    
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test3_init 
    ADD     R10,R0,#0xCC    /* Increment address - address must be multiple of 4 */
    /* <Rn[3:0]>:R10 0xA
       <Rt[15:12],Rt2[11:8]>:R3,R4 0x34
       <imm8[7:0]>:0x33    0x33*(4-bytes)=0xCC 
       <data_to_store>: R3=0xCCCCCCCC, R4=0x33333333 */
    STRD.W  R3,R4,[R10,#-0xCC]      
    DSB
    /* We need to check address was not decremented */
    SUB     R10,R10,#0xCC
    CMP     R10,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    LDR     R1,[R0]
    CMP     R3,R1
    BNE     m4_scst_loadstore_test3_failed
    LDR     R2,[R0,#4]
    CMP     R4,R2
    BNE     m4_scst_loadstore_test3_failed
  
    ADD     R10,R0,#0xCC    /* Increment address - address must be multiple of 4 */
    /* <Rn[3:0]>:R5 0xA
       <Rt[15:12],Rt2[11:8]>:R4,R3 0x43
       <imm8[7:0]>:0x33    0x33*(4-bytes)=0xCC 
       <data_to_load>:R3=0x33333333, R4=0xCCCCCCCC */
    LDRD.W  R4,R3,[R10,#-0xCC]
    /* We need to check address was not decremented */
    SUB     R10,R10,#0xCC
    CMP     R10,R0
    BNE     m4_scst_loadstore_test3_failed
    /* Check data */
    CMP     R4,R1
    BNE     m4_scst_loadstore_test3_failed
    CMP     R3,R2
    BNE     m4_scst_loadstore_test3_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test3_init
    ADD    R10,R0,#0x330    /* Decrement address - address must be multiple of 4 */
    /* <Rn[3:0]>:R10 0xA
       <Rt[15:12],Rt2[11:8]>:R4,R3 0x43
       <imm8[7:0]>:0xCC    0xCC*(4-bytes)=0x330
       <data_to_store>:R4=0x33333333, R3=0xCCCCCCCC */
    STRD.W  R4,R3,[R10,#-0x330]!
    DSB
    /* We need to check address was decremented and written back */
    CMP     R10,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    LDR     R1,[R0]
    CMP     R4,R1
    BNE     m4_scst_loadstore_test3_failed
    LDR     R2,[R0,#4]
    CMP     R3,R2
    BNE     m4_scst_loadstore_test3_failed
    
    ADD     R10,R0,#0x330     /* Increment address - address must be multiple of 4 */
    /* <Rn[3:0]>:R5 0xA
       <Rt[15:12],Rt2[11:8]>:R3,R4 0x34
       <imm8[7:0]>:0xCC    0xCC*(4-bytes)=0x330 
       <data_to_load>:R4=0xCCCCCCCC, R3=0x33333333 */
    LDRD.W  R3,R4,[R10,#-0x330]!
    /* We need to check address was decremented and written back */
    CMP     R10,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    CMP     R3,R1
    BNE     m4_scst_loadstore_test3_failed
    CMP     R4,R2
    BNE     m4_scst_loadstore_test3_failed
    
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test3_init
    MOV     R7,R0     
    /* <Rn[3:0]>:R7 0x7
       <Rt[15:12],Rt2[11:8]>:R5,R6 0x56
       <imm8[7:0]>:0xC7    0xC7*(4-bytes)=0x31C 
       <data_to_store>:R5=0x99999999, R6=0x66666666 */
    STRD.W  R5,R6,[R7],#0x31C
    DSB
    /* We need to check address was incremented */
    SUB     R7,R7,#0x31C
    CMP     R7,R0
    BNE     m4_scst_loadstore_test3_failed
    /* Check data */
    LDR     R1,[R0]
    CMP     R5,R1
    BNE     m4_scst_loadstore_test3_failed
    LDR     R2,[R0,#4]
    CMP     R6,R2
    BNE     m4_scst_loadstore_test3_failed
    
    /* <Rn[3:0]>:R7 0x7
       <Rt[15:12],Rt2[11:8]>:R6,R5 0x65
       <imm8[7:0]>:0xC7    0xC7*(4-bytes)=0x31C 
       <data_to_load>:R5=0x66666666, R6=0x99999999 */
    LDRD.W  R6,R5,[R7],#0x31C
    /* We need to check address was incremented */
    SUB     R7,R7,#0x31C
    CMP     R7,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    CMP     R6,R1
    BNE     m4_scst_loadstore_test3_failed
    CMP     R5,R2
    BNE     m4_scst_loadstore_test3_failed
    
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test3_init
    MOV     R7,R0
    /* <Rn[3:0]>:R7 0x7
       <Rt[15:12],Rt2[11:8]>:R6,R5 0x65
       <imm8[7:0]>:0x38    0x38*(4-bytes)=0xE0
       <data_to_store>:R6=0x99999999, R5=0x66666666 */
    STRD.W  R6,R5,[R7],#-0xE0
    DSB
    /* We need to check address was decremented */
    ADD     R7,R7,#0xE0
    CMP     R7,R0
    BNE     m4_scst_loadstore_test3_failed
    /* CWe need to check data */
    LDR     R1,[R0]
    CMP     R6,R1
    BNE     m4_scst_loadstore_test3_failed
    LDR     R2,[R0,#4]
    CMP     R5,R2
    BNE     m4_scst_loadstore_test3_failed
    
    /* <Rn[3:0]>:R7 0x7
       <Rt[15:12],Rt2[11:8]>:R5,R6 0x56
       <imm8[7:0]>:0x38    0x38*(4-bytes)=0xE0 
       <data_to_load>:R6=0x66666666, R5=0x55555555 */
    LDRD.W  R5,R6,[R7],#-0xE0
    /* We need to check address was decremented */
    ADD     R7,R7,#0xE0
    CMP     R7,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    CMP     R5,R1
    BNE     m4_scst_loadstore_test3_failed
    CMP     R6,R2
    BNE     m4_scst_loadstore_test3_failed
    
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test3_init 
    MOV     R12,R0
    /* <Rn[3:0]>:R12 0xC
       <Rt[15:12],Rt2[11:8]>:R7,R8 0x78
       <imm8[7:0]>:0x00 
       <data_to_store>:R7=0x77777777, R8=0xEEEEEEEE */
    STRD.W  R7,R8,[R12,#0]!
    DSB
    /* We need to check address was not changed */
    CMP     R12,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    LDR     R1,[R0]
    CMP     R7,R1
    BNE     m4_scst_loadstore_test3_failed
    LDR     R2,[R0,#4]
    CMP     R8,R2
    BNE     m4_scst_loadstore_test3_failed
    
    /* <Rn[3:0]>:R12 0xC
       <Rt[15:12],Rt2[11:8]>:R8,R7 0x87
       <imm8[7:0]>:0x00 
       <data_to_load>:R7=0xEEEEEEEE, R8=0x77777777 */
    LDRD.W  R8,R7,[R12,#0]!
    /* We need to check address was not changed */
    CMP     R12,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    CMP     R8,R1
    BNE     m4_scst_loadstore_test3_failed
    CMP     R7,R2
    BNE     m4_scst_loadstore_test3_failed
    
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test3_init 
    MOV     R12,R0
    /* <Rn[3:0]>:R0 0x0
       <Rt[15:12],Rt2[11:8]>:R8,R7 0x87
       <imm8[7:0]>:0x00
       <data_to_store>: R8=0xEEEEEEEE, R7=0x77777777 */
    STRD.W  R8,R7,[R12,#-0]
    DSB
    /* We need check address was not changed */
    CMP     R12,R0
    BNE     m4_scst_loadstore_test3_failed   
    /* We need to check data */
    LDR     R1,[R0]
    CMP     R8,R1
    BNE     m4_scst_loadstore_test3_failed
    LDR     R2,[R0,#4]
    CMP     R7,R2
    BNE     m4_scst_loadstore_test3_failed
    
    /* <Rn[3:0]>:R0 0x0
       <Rt[15:12],Rt2[11:8]>:R7,R8 0x78
       <imm8[7:0]>:0x00
       <data_to_load>:R8=0x77777777, R7=0xEEEEEEEE,  */
    LDRD.W  R7,R8,[R12,#-0]
    /* We need check address was not changed */
    CMP     R12,R0
    BNE     m4_scst_loadstore_test3_failed 
    /* We need to check data */
    CMP     R7,R1
    BNE     m4_scst_loadstore_test3_failed
    CMP     R8,R2
    BNE     m4_scst_loadstore_test3_failed
    
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test3_init
    SUB     R8,R0,#0x3C
    /* <Rn[3:0]>:R8 0x8
       <Rt[15:12],Rt2[11:8]>:R9,R10 0x9A
       <imm8[7:0]>:0x0F     0xF*(4-bytes)=0x3C 
       <data_to_store>:R9=0x13579BDF, R10=0xFDB97531 */
    STRD.W  R9,R10,[R8,#0x3C]!
    DSB
    /* We need to check address was incremented and written back */
    CMP     R8,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    LDR     R1,[R0]
    CMP     R9,R1
    BNE     m4_scst_loadstore_test3_failed
    LDR     R2,[R0,#4]
    CMP     R10,R2
    BNE     m4_scst_loadstore_test3_failed
    
    SUB     R8,R0,#0x3C
    /* <Rn[3:0]>:R8 0x8
       <Rt[15:12],Rt2[11:8]>:R10,R9 0xA9
       <imm8[7:0]>:0x0F     0xF*(4-bytes)=0x3C 
       <data_to_load>:R9=0xFDB97531, R10=0x13579BDF */
    LDRD.W  R10,R9,[R8,#0x3C]!
    /* We need to check address was incremented and written back */
    CMP     R8,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    CMP     R10,R1
    BNE     m4_scst_loadstore_test3_failed
    CMP     R9,R2
    BNE     m4_scst_loadstore_test3_failed
    
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test3_init
    ADD     R8,R0,#0x3C0
    /* <Rn[3:0]>:R8 0x8
       <Rt[15:12],Rt2[11:8]>:R10,R9 0xA9
       <imm8[7:0]>:0xF0     0xF0*(4-bytes)=0x3C0
       <data_to_store>:R10=0xFDB97531, R9=0x13579BDF */
    STRD.W  R10,R9,[R8,#-0x3C0]!
    DSB
    /* We need to check address was decremented and written back */
    CMP     R8,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    LDR     R1,[R0]
    CMP     R10,R1
    BNE     m4_scst_loadstore_test3_failed
    LDR     R2,[R0,#4]
    CMP     R9,R2
    BNE     m4_scst_loadstore_test3_failed
    
    /* <Rn[3:0]>:R8 0x8
       <Rt[15:12],Rt2[11:8]>:R9,R10 0x9A
       <imm8[7:0]>:0xF0     0xF0*(4-bytes)=0x3C0
       <data_to_load>:R10=0x13579BDF, R9=0xFDB97531 */
    ADD     R8,R0,#0x3C0
    LDRD.W  R9,R10,[R8,#-0x3C0]!
    /* We need to check address was decremented and written back */
    CMP     R8,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    CMP     R9,R1
    BNE     m4_scst_loadstore_test3_failed
    CMP     R10,R2
    BNE     m4_scst_loadstore_test3_failed
    
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test3_init
    SUB     R3,R0,#0xEC
    /* <Rn[3:0]>:R3 0x3
       <Rt[15:12],Rt2[11:8]>:R11,R12 0xBC
       <imm8[7:0]>:0x3B     0x3B*(4-bytes)=0xEC
       <data_to_store>:R11=0x2468ACE0, R12=0x0ECA8642 */
    STRD.W  R11,R12,[R3,#0xEC]
    DSB
    /* We need to check address was not incremented */
    ADD     R3,R3,#0xEC
    CMP     R3,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    LDR     R1,[R0]
    CMP     R11,R1
    BNE     m4_scst_loadstore_test3_failed
    LDR     R2,[R0,#4]
    CMP     R12,R2
    BNE     m4_scst_loadstore_test3_failed
    
    SUB     R3,R0,#0xEC
    /* <Rn[3:0]>:R3 0x3
       <Rt[15:12],Rt2[11:8]>:R12,R11 0xCB
       <imm8[7:0]>:0x3B     0x3B*(4-bytes)=0xEC 
       <data_to_load>:R11=0x0ECA8642, R12=0x2468ACE0 */
    LDRD.W  R12,R11,[R3,#0xEC]
    /* We need to check address was not incremented */
    ADD     R3,R3,#0xEC
    CMP     R3,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    CMP     R12,R1
    BNE     m4_scst_loadstore_test3_failed
    CMP     R11,R2
    BNE     m4_scst_loadstore_test3_failed
    
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test3_init
    ADD     R3,R0,#0x348
    /* <Rn[3:0]>:R3 0x3
       <Rt[15:12],Rt2[11:8]>:R12,R11 0xCB
       <imm8[7:0]>:0xD2     0xD2*(4-bytes)=0x348
       <data_to_store>: R12=0x2468ACE0, R11=0xFDB97531 */
    STRD.W  R12,R11,[R3,#-0x348]
    DSB
    /* We need to check address was not decremented */
    SUB     R3,R3,#0x348
    CMP     R3,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    LDR     R1,[R0]
    CMP     R12,R1
    BNE     m4_scst_loadstore_test3_failed
    LDR     R2,[R0,#4]
    CMP     R11,R2
    BNE     m4_scst_loadstore_test3_failed
    
    /* <Rn[3:0]>:R3 0x3
       <Rt[15:12],Rt2[11:8]>:R11,R12 0xBC
       <imm8[7:0]>:0xD2     0xD2*(4-bytes)=0x348
       <data_to_load>:R12=0xFDB97531, R11=0x2468ACE0 */
    ADD     R3,R0,#0x348
    LDRD.W  R11,R12,[R3,#-0x348]
    /* We need to check address was not decremented */
    SUB     R3,R3,#0x348
    CMP     R3,R0
    BNE     m4_scst_loadstore_test3_failed
    /* We need to check data */
    CMP     R11,R1
    BNE     m4_scst_loadstore_test3_failed
    CMP     R12,R2
    BNE     m4_scst_loadstore_test3_failed
    
    POP.W   {R1,R14}    /* We need to restore R1 and R14. */
    BX      LR

    
m4_scst_loadstore_test3_init:
    
    LDR     R1,=VAL1
    LDR     R2,=VAL2
    LDR     R3,=VAL3
    LDR     R4,=VAL4
    LDR     R5,=VAL5
    LDR     R6,=VAL6
    LDR     R7,=VAL7
    LDR     R8,=VAL8
    LDR     R9,=VAL9
    LDR     R10,=VAL10
    LDR     R11,=VAL11
    LDR     R12,=VAL12

    BX      LR
    
    
 m4_scst_loadstore_test3_clear_target_memory:
    
    EORS    R1,R1   /* Clear R1 */
    
    STR     R1,[R0]
    STR     R1,[R0,#4]
    STR     R1,[R0,#8]
    STR     R1,[R0,#12]
    
    BX      LR
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    