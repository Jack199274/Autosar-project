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
*   - load/store multiple
*   - write back control
*
* Overall coverage:
* -----------------
* Covers STMIA.N LDMIA.N instructions as well as logic processing its '<Rn>' 
* and '<register_list>' fields, as well as <data_to_store> and <data_to_load>.
*
* DECODER:
* Thumb (16-bit)
*   - Encoding of "Store multiple registers" instructions
*   - Encoding of "Load multiple registers" instructions
*   - Encoding of "Load from Literal Pool" instructions
*   - Encoding of "Miscellaneous 16-bit instructions" instructions - PUSH.N, POP.N
*
* 测试总结：
* -------------
*
* 涵盖 LSU 操作类型：
* - 加载/存储多个
* - 写回控制
*
* 整体覆盖：
* -----------------
* 涵盖 STMIA.N LDMIA.N 指令以及其“<Rn>”的逻辑处理
* 和 '<register_list>' 字段，以及 <data_to_store> 和 <data_to_load>。
*
* 解码器：
* 拇指（16 位）
* - “存储多个寄存器”指令的编码
* - “加载多个寄存器”指令的编码
* - “从文字池加载”指令的编码
* - “杂项 16 位指令”指令的编码 - PUSH.N、POP.N
*
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_loadstore_test1

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

SCST_SET(PRESIGNATURE, 0xD56B91A4) /*this macro has to be at the beginning of the line*/
    
    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_loadstore_test1" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_loadstore_test1, function)
m4_scst_loadstore_test1:

    PUSH.W  {R1-R12,R14}
    
    /* Load pre-signature */ 
    LDR.W     R1,=PRESIGNATURE
    
    /* Store R1 to stack - This instruction uses the same encoding as T3 encoding for PUSH.W <registers>. */
    STR.W   R1,[SP,#-4]!
    
    LDR     R8,=SCST_RAM_TARGET0
    BL      m4_scst_loadstore_test1_common
    LDR     R8,=SCST_RAM_TARGET1
    BL      m4_scst_loadstore_test1_common
    
    LDR.W   R1,[SP],#4      /* We need to restore R1 which contains PRESIGNATURE. */
    
    ADDW    R1,R1,#0xDEF    /* Update PRESIGNATURE */
    
    STR.W   R1,[SP,#-4]!    /* Store R1 to stack */
    
    MOV     R8,SP   /* Move SP address to  R8 -> Do not use R8!!!! */
    /**********************************************************************************************
    * Instructions: 
    *   - PUSH  Encoding T1 (16-bit)
    *   - POP   Encoding T1 (16-bit)
    *
    * Note: For decoder purposes we test only encoding T1.
    *       PUSH, POP encoding T2 is same as STM T2 and LDM T2 encoding.
    *       PUSH, POP encoding T3 is same as STR and LDR T4 encoding.
    **********************************************************************************************/
    BL      m4_scst_loadstore_test1_init
    /* <register_list>[7:0]:R0,R2,R4,R6 0b01010101 */
    PUSH.N  {R0,R2,R4,R6}
    /* We have to check SP address */
    MOV     R10,SP
    ADD     R10,R10,#16
    CMP     R10,R8    
    BNE.W     m4_scst_loadstore_test1_failed_push_pop
    /* <register_list>[7:0]:R1,R3,R5,R7 0b10101010 */
    POP.N   {R1,R3,R5,R7}
    /* We need to check SP address */
    CMP     SP,R8
    BNE.W     m4_scst_loadstore_test1_failed_push_pop
    /* We need to check SP data */
    CMP     R7,R6
    BNE.W     m4_scst_loadstore_test1_failed_push_pop
    CMP     R5,R4
    BNE.W     m4_scst_loadstore_test1_failed_push_pop
    CMP     R3,R2
    BNE.W     m4_scst_loadstore_test1_failed_push_pop
    CMP     R1,R0
    BNE.W     m4_scst_loadstore_test1_failed_push_pop
    
    BL      m4_scst_loadstore_test1_init
    /* <register_list>[7:0]:R1,R3,R5,R7 0b10101010 */
    PUSH.N  {R1,R3,R5,R7}
    /* We have to check SP address */
    MOV     R10,SP
    ADD     R10,R10,#16
    CMP     R10,R8
    BNE.W     m4_scst_loadstore_test1_failed_push_pop
    /* <register_list>[7:0]:R0,R2,R4,R6 0b01010101 */
    POP.N   {R0,R2,R4,R6}
    /* We need to check address */
    CMP     SP,R8
    BNE.W     m4_scst_loadstore_test1_failed_push_pop
    /* We need to check SP data */
    CMP     R6,R7
    BNE.W     m4_scst_loadstore_test1_failed_push_pop
    CMP     R4,R5
    BNE.W     m4_scst_loadstore_test1_failed_push_pop
    CMP     R2,R3
    BNE.W     m4_scst_loadstore_test1_failed_push_pop
    CMP     R0,R1
    BNE.W     m4_scst_loadstore_test1_failed_push_pop
    
    BL      m4_scst_loadstore_test1_init
    /* <register_list>[7:0]:R0,R1,R4,R5 0b00110011 */
    PUSH.N  {R0,R1,R4,R5}
    /* We have to check SP address */
    MOV     R10,SP
    ADD     R10,R10,#16
    CMP     R10,R8
    BNE     m4_scst_loadstore_test1_failed_push_pop
    /* <register_list>[7:0]:R2,R3,R6,R7 0b11001100 */
    POP.N   {R2,R3,R6,R7}
    /* We need to check address */
    CMP     SP,R8
    BNE     m4_scst_loadstore_test1_failed_push_pop
    /* We need to check SP data */
    CMP     R7,R5
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R6,R4
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R3,R1
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R2,R0
    BNE     m4_scst_loadstore_test1_failed_push_pop
    
    BL      m4_scst_loadstore_test1_init
    /* <register_list>[7:0]:R2,R3,R6,R7 0b11001100 */
    PUSH.N  {R2,R3,R6,R7}
    /* We have to check SP address */
    MOV     R10,SP
    ADD     R10,R10,#16
    CMP     R10,R8
    BNE     m4_scst_loadstore_test1_failed_push_pop
    /* <register_list>[7:0]:R0,R1,R4,R5 0b00110011 */
    POP.N   {R0,R1,R4,R5}
    /* We need to check SP address */
    CMP     SP,R8
    BNE     m4_scst_loadstore_test1_failed_push_pop
    /* We need to check data */
    CMP     R5,R7
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R4,R6
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R1,R3
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R0,R2
    BNE     m4_scst_loadstore_test1_failed_push_pop
    
    BL      m4_scst_loadstore_test1_init
    /* <register_list>[7:0]:R0,R1,R2 0b00000111 */
    /* <M>: R14 */
    PUSH.N  {R0,R1,R2,R14}
    /* We have to check SP address */
    MOV     R10,SP
    ADD     R10,R10,#16
    CMP     R10,R8
    BNE     m4_scst_loadstore_test1_failed_push_pop
    MOV     R10,LR
    EOR     R14,R14,#0xFFFFFFFF
    /* <register_list>[7:0]:R3,R4,R5 0b00111000 */
    /* <M>: R14 */
    POP.W   {R3,R4,R5,R14}  /* Note: POP.N can not include R14 */
    /* We need to check address */
    CMP     SP,R8
    BNE     m4_scst_loadstore_test1_failed_push_pop
    /* We need to check SP data */
    CMP     R10,R14
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R5,R2
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R4,R1
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R3,R0
    BNE     m4_scst_loadstore_test1_failed_push_pop
    
    BL      m4_scst_loadstore_test1_init
    /* <register_list>[7:0]:R3,R4,R5 0b00111000 */
    PUSH.N  {R3,R4,R5}
    /* We have to check SP address */
    MOV     R10,SP
    ADD     R10,R10,#12
    CMP     R10,R8
    BNE     m4_scst_loadstore_test1_failed_push_pop
    /* <register_list>[7:0]:R0,R1,R2 0b00000111 */
    POP.N   {R0,R1,R2}
    /* We need to check SP address */
    CMP     SP,R8
    BNE     m4_scst_loadstore_test1_failed_push_pop
    /* We need to check data */
    CMP     R2,R5
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R1,R4
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R0,R3
    
    BL      m4_scst_loadstore_test1_init
    /* <register_list>[7:0]:R0,R1,R2,R3 0b00001111 */
    /* <M>: R14 */
    PUSH.N  {R0,R1,R2,R3,R14}
    /* We have to check SP address */
    MOV     R10,SP
    ADD     R10,R10,#20
    CMP     R10,R8
    BNE     m4_scst_loadstore_test1_failed_push_pop
    MOV     R10,LR
    EOR     R14,R14,#0xFFFFFFFF
    /* <register_list>[7:0]:R4,R5,R6,R7 0b11110000 */
    /* <M>: R14 */
    POP.W   {R4,R5,R6,R7,R14}    /* Note: POP.N can not include R14 */
    /* We need to check SP address */
    CMP     SP,R8
    BNE     m4_scst_loadstore_test1_failed_push_pop
    /* We need to check data */
    CMP     R10,R14
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R7,R3
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R6,R2
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R5,R1
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R4,R0
    BNE     m4_scst_loadstore_test1_failed_push_pop
    
    BL      m4_scst_loadstore_test1_init
    /* <register_list>[7:0]:R4,R5,R6,R7 0b11110000 */
    PUSH.N  {R4,R5,R6,R7}
    /* We have to check address */
    MOV     R10,SP
    ADD     R10,R10,#16
    CMP     R10,R8
    BNE     m4_scst_loadstore_test1_failed_push_pop
    /* <register_list>[7:0]:R0,R1,R4,R5 0b00001111 */
    POP.N   {R0,R1,R2,R3}
    /* We need to check address */
    CMP     SP,R8
    BNE     m4_scst_loadstore_test1_failed_push_pop
    /* We need to check data */
    CMP     R3,R7
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R2,R6
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R1,R5
    BNE     m4_scst_loadstore_test1_failed_push_pop
    CMP     R0,R4
    
    
    /* Load R1 from stack - This instruction uses the same encoding as T3 encoding for PUSH.W <registers>. */
    LDR.W   R1,[SP],#4    /* We need to restore R1 which contains PRESIGNATURE. */
    
    /* Test passed -> store result */
    LDR     R0,=VAL9
    EORS    R0,R1
    

m4_scst_loadstore_test1_end:
    B      m4_scst_test_tail_end

m4_scst_loadstore_test1_failed:

    LDR.W   R14,[SP],#4    /* We need to restore R14 */
    LDR.W   R1,[SP],#4     /* We need to restore R1 which contains PRESIGNATURE. */
    MOVW    R0,#0x444
    B       m4_scst_loadstore_test1_end

m4_scst_loadstore_test1_failed_push_pop:
    MOV     SP,R8
    LDR.W   R1,[SP],#4    /* We need to restore R1 which contains PRESIGNATURE. */
    MOVW    R0,#0x445
    B       m4_scst_loadstore_test1_end

m4_scst_loadstore_test1_common:

    /* Store R1 to stack - This instruction uses the same encoding as T3 encoding for PUSH.W <registers>. */
    STR.W  R14,[SP,#-4]!    /* We need to store R14. */
    
    /**********************************************************************************************
    * Instructions: 
    *   - STM   Encoding T1 (16-bit)
    *   - LDM   Encoding T1 (16-bit)
    **********************************************************************************************/
    BL      m4_scst_loadstore_test1_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test1_init
    
    MOV     R5,R8
    /* <Rn[10:8]>:R5 0b101
       <register_list>[7:0]:R0,R2,R4,R6 0b01010101 */ 
    STMIA.N R5!,{R0,R2,R4,R6}
    DSB
    /* We need to check address was incremented */
    SUB     R5,R5,#16
    CMP     R5,R8
    BNE     m4_scst_loadstore_test1_failed
    /* We need to check data */
    LDR     R5,[R8]
    SUBS    R0,R0,R5   
    BNE     m4_scst_loadstore_test1_failed
    LDR     R5,[R8,#4]
    SUBS    R2,R2,R5   
    BNE     m4_scst_loadstore_test1_failed
    LDR     R5,[R8,#8]
    SUBS    R4,R4,R5   
    BNE     m4_scst_loadstore_test1_failed
    LDR     R5,[R8,#12]
    SUBS    R6,R6,R5   
    BNE     m4_scst_loadstore_test1_failed
    LDR     R5,[R8,#16] /* We need to check that only 4 registers were stored */
    CMP     R5,#0x0
    BNE     m4_scst_loadstore_test1_failed
    
    MOV     R5,R8
    /* <Rn[10:8]>:R5 0b101
       <register_list>[7:0]:R0,R2,R4,R6 0b01010101 */
    LDMIA.N R5!,{R0,R2,R4,R6}
    /* We need to check address was incremented */
    SUB     R5,R5,#16
    CMP     R5,R8
    BNE     m4_scst_loadstore_test1_failed
    /* We need to check data */
    LDR R5,[R8]
    CMP R5,R0
    BNE m4_scst_loadstore_test1_failed
    LDR R5,[R8,#4]
    CMP R5,R2
    BNE m4_scst_loadstore_test1_failed
    LDR R5,[R8,#8]
    CMP R5,R4
    BNE m4_scst_loadstore_test1_failed
    LDR R5,[R8,#12]
    CMP R5,R6
    BNE m4_scst_loadstore_test1_failed
    
    
    BL      m4_scst_loadstore_test1_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test1_init
    
    MOV     R2,R8
    /* <Rn[10:8]>:R2 0b010
       <register_list>[7:0]:R1,R3,R5,R7 0b10101010 */ 
    STMIA.N R2!,{R1,R3,R5,R7}
    DSB
    /* We need to check address was incremented */
    SUB     R2,R2,#16
    CMP     R2,R8
    BNE     m4_scst_loadstore_test1_failed
    /* We need to check data */
    LDR     R2,[R8]
    SUBS    R1,R1,R2  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R2,[R8,#4]
    SUBS    R3,R3,R2  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R2,[R8,#8]
    SUBS    R5,R5,R2  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R2,[R8,#12]
    SUBS    R7,R7,R2  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R2,[R8,#16] /* We need to check that only 4 registers were stored */
    CMP     R2,#0x0
    BNE     m4_scst_loadstore_test1_failed
    
    MOV     R2,R8
    /* <Rn[10:8]>:R5 0b101
       <register_list>[7:0]:R1,R3,R5,R7 0b10101010 */
    LDMIA.N R2!,{R1,R3,R5,R7}
    /* We need to check address was incremented */
    SUB     R2,R2,#16
    CMP     R2,R8
    BNE     m4_scst_loadstore_test1_failed
    /* We need to check data */
    LDR     R2,[R8]
    CMP     R2,R1
    BNE     m4_scst_loadstore_test1_failed
    LDR     R2,[R8,#4]
    CMP     R2,R3
    BNE     m4_scst_loadstore_test1_failed
    LDR     R2,[R8,#8]
    CMP     R2,R5
    BNE     m4_scst_loadstore_test1_failed
    LDR     R2,[R8,#12]
    CMP     R2,R7
    BNE     m4_scst_loadstore_test1_failed
    
    
    BL      m4_scst_loadstore_test1_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test1_init
    
    MOV     R3,R8
    /* <Rn[10:8]>:R3 0b011
       <register_list>[7:0]:R1,R3,R5,R7 0b00110011 */ 
    STMIA.N R3!,{R0,R1,R4,R5}
    DSB
    /* We need to check address was incremented */
    SUB     R3,R3,#16
    CMP     R3,R8
    BNE     m4_scst_loadstore_test1_failed
    /* We need to check data */
    LDR     R3,[R8]
    SUBS    R0,R0,R3  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R3,[R8,#4]
    SUBS    R1,R1,R3  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R3,[R8,#8]
    SUBS    R4,R4,R3  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R3,[R8,#12]
    SUBS    R5,R5,R3  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R3,[R8,#16] /* We need to check that only 4 registers were stored */
    CMP     R3,#0x0
    BNE     m4_scst_loadstore_test1_failed
    
    MOV     R3,R8
    /* <Rn[10:8]>:R3 0b011
       <register_list>[7:0]:R0,R1,R4,R5 0b00110011 */
    LDMIA.N R3!,{R0,R1,R4,R5}
    /* We need to check address was incremented */
    SUB     R3,R3,#16
    CMP     R3,R8
    BNE     m4_scst_loadstore_test1_failed
    /* We need to check data */
    LDR     R3,[R8]
    CMP     R3,R0
    BNE     m4_scst_loadstore_test1_failed
    LDR     R3,[R8,#4]
    CMP     R3,R1
    BNE     m4_scst_loadstore_test1_failed
    LDR     R3,[R8,#8]
    CMP     R3,R4
    BNE     m4_scst_loadstore_test1_failed
    LDR     R3,[R8,#12]
    CMP     R3,R5
    BNE     m4_scst_loadstore_test1_failed
    
    
    BL      m4_scst_loadstore_test1_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test1_init
    
    MOV     R4,R8
    /* <Rn[10:8]>:R4 0b100
       <register_list>[7:0]:R2,R3,R6,R7 0b11001100 */ 
    STMIA.N R4!,{R2,R3,R6,R7}
    DSB
    /* We need to check address was incremented */
    SUB     R4,R4,#16
    CMP     R4,R8
    BNE     m4_scst_loadstore_test1_failed
    /* We need to check data */
    LDR     R4,[R8]
    SUBS    R2,R2,R4  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R4,[R8,#4]
    SUBS    R3,R3,R4  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R4,[R8,#8]
    SUBS    R6,R6,R4  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R4,[R8,#12]
    SUBS    R7,R7,R4  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R4,[R8,#16] /* We need to check that only 4 registers were stored */
    CMP     R4,#0x0
    BNE     m4_scst_loadstore_test1_failed
    
    MOV     R4,R8
    /* <Rn[10:8]>:R4 0b100
       <register_list>[7:0]:R1,R2,R5,R6 0b11001100 */
    LDMIA.N R4!,{R2,R3,R6,R7}
    /* We need to check address was incremented */
    SUB     R4,R4,#16
    CMP     R4,R8
    BNE     m4_scst_loadstore_test1_failed
    /* We need to check data */
    LDR     R4,[R8]
    CMP     R4,R2
    BNE     m4_scst_loadstore_test1_failed
    LDR     R4,[R8,#4]
    CMP     R4,R3
    BNE     m4_scst_loadstore_test1_failed
    LDR     R4,[R8,#8]
    CMP     R4,R6
    BNE     m4_scst_loadstore_test1_failed
    LDR     R4,[R8,#12]
    CMP     R4,R7
    BNE     m4_scst_loadstore_test1_failed
    
    
    BL      m4_scst_loadstore_test1_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test1_init
    
    MOV     R7,R8
    /* <Rn[10:8]>:R7 0b111
       <register_list>[7:0]:R0,R1,R2 0b00000111 */ 
    STMIA.N R7!,{R0,R1,R2}
    DSB
    /* We need to check address was incremented */
    SUB     R7,R7,#12
    CMP     R7,R8
    BNE     m4_scst_loadstore_test1_failed
    /* We need to check data */
    LDR     R7,[R8]
    SUBS    R0,R0,R7  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R7,[R8,#4]
    SUBS    R1,R1,R7  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R7,[R8,#8]
    SUBS    R2,R2,R7  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R7,[R8,#12] /* We need to check that only 4 registers were stored */
    CMP     R7,#0x0
    BNE     m4_scst_loadstore_test1_failed
    
    MOV     R7,R8
    /* <Rn[10:8]>:R7 0b111
       <register_list>[7:0]:R0,R1,R2 0b00000111 */
    LDMIA.N R7!,{R0,R1,R2}
    /* We need to check address was incremented */
    SUB     R7,R7,#12
    CMP     R7,R8
    BNE     m4_scst_loadstore_test1_failed
    /* We need to check data */
    LDR     R7,[R8]
    CMP     R7,R0
    BNE     m4_scst_loadstore_test1_failed
    LDR     R7,[R8,#4]
    CMP     R7,R1
    BNE     m4_scst_loadstore_test1_failed
    LDR     R7,[R8,#8]
    CMP     R7,R2
    BNE     m4_scst_loadstore_test1_failed
    
    
    BL      m4_scst_loadstore_test1_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL  m4_scst_loadstore_test1_init
    
    MOV     R1,R8
    /* <Rn[10:8]>:R1 0b001
       <register_list>[7:0]:R4,R5,R6,R7 0b11110000 */ 
    STMIA.N R1!,{R4,R5,R6,R7}
    DSB
    /* We need to check address was incremented */
    SUB     R1,R1,#16
    CMP     R1,R8
    BNE     m4_scst_loadstore_test1_failed
    /* We need to check data */
    LDR     R1,[R8]
    SUBS    R4,R4,R1  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R1,[R8,#4]
    SUBS    R5,R5,R1  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R1,[R8,#8]
    SUBS    R6,R6,R1  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R1,[R8,#12]
    SUBS    R7,R7,R1  
    BNE     m4_scst_loadstore_test1_failed
    LDR     R1,[R8,#16] /* We need to check that only 4 registers were stored */
    CMP     R1,#0x0
    BNE     m4_scst_loadstore_test1_failed
    
    MOV     R1,R8
    /* <Rn[10:8]>:R1 0b001
       <register_list>[7:0]:R4,R5,R6,R7 0b11110000 */
    
    LDMIA.N R1!,{R4,R5,R6,R7}
    
    /* We need to check address was incremented */
    SUB     R1,R1,#16
    CMP     R1,R8
    BNE     m4_scst_loadstore_test1_failed
    /* We need to check data */
    LDR     R1,[R8]
    CMP     R1,R4
    BNE     m4_scst_loadstore_test1_failed
    LDR     R1,[R8,#4]
    CMP     R1,R5
    BNE     m4_scst_loadstore_test1_failed
    LDR     R1,[R8,#8]
    CMP     R1,R6
    BNE     m4_scst_loadstore_test1_failed
    LDR     R1,[R8,#12]
    CMP     R1,R7
    BNE     m4_scst_loadstore_test1_failed
        
    /* Load R14 from stack - This instruction uses the same encoding as T3 encoding for PUSH.W <registers>. */
    LDR.W   R14,[SP],#4    /* We need to restore R14. */
    BX      LR

    
m4_scst_loadstore_test1_init:

    /**********************************************************************************************
    * Instruction: 
    * - LDR (literal) Encoding T1 (16-bit)
    *
    * Note: Tested indirectly 
    **********************************************************************************************/
    LDR.N   R0,=VAL1
    LDR.N   R1,=VAL2
    LDR.N   R2,=VAL3
    LDR.N   R3,=VAL4
    LDR.N   R4,=VAL5
    LDR.N   R5,=VAL6
    LDR.N   R6,=VAL7
    LDR.N   R7,=VAL8

    BX      LR
    
    
m4_scst_loadstore_test1_clear_target_memory:
    
    EORS    R1,R1
    
    STR     R1,[R8]
    STR     R1,[R8,#4]
    STR     R1,[R8,#8]
    STR     R1,[R8,#12]
    STR     R1,[R8,#16]
    STR     R1,[R8,#20]
    STR     R1,[R8,#24]
    STR     R1,[R8,#28]
    
    BX      LR
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    