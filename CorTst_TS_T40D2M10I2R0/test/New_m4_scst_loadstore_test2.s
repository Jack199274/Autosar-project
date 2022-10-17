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
*
* Overall coverage:
* -----------------
* Covers STM.W, STMDB.W, LDM.W, LDMDB.W instructions as well as logic processing its
* '<Rn>' and '<register_list>' fields, as well as <data_to_store> and <data_to_load>.
*
* DECODER:
* Thumb (32-bit)
*   - Encoding of "Load Multiple and Store Multiple" instructions
* 
* 测试总结：
* -------------
*
* 涵盖 LSU 操作类型：
* - 加载/存储多个
*
* 整体覆盖：
* -----------------
* 涵盖STM.W、STMDB.W、LDM.W、LDMDB.W指令及其逻辑处理
* '<Rn>' 和 '<register_list>' 字段，以及 <data_to_store> 和 <data_to_load>。
*
* 解码器：
* 拇指（32 位）
* - “加载多个和存储多个”指令的编码
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_loadstore_test2

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
    
SCST_SET(PRESIGNATURE, 0xBD4A865C) /*this macro has to be at the beginning of the line*/
    
    
    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_loadstore_test2" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_loadstore_test2, function)
m4_scst_loadstore_test2:

    PUSH.W  {R1-R12,R14}
    
    LDR     R0,=SCST_RAM_TARGET0
    BL      m4_scst_loadstore_test2_common
    LDR     R0,=SCST_RAM_TARGET1
    BL      m4_scst_loadstore_test2_common
    
    /* Test passed -> store result */
    LDR     R0,=VAL9
    EORS    R0,R1
    
m4_scst_loadstore_test2_end:
    B      m4_scst_test_tail_end
    
    
m4_scst_loadstore_test2_failed:

    POP.W   {R1,R14}    /* We just need to pop two words from stack */
    MOVW    R0,#0x444
    B       m4_scst_loadstore_test2_end
            

m4_scst_loadstore_test2_common:

    /* Load pre-signature */ 
    LDR     R1,=PRESIGNATURE

    PUSH    {R1,R14}    /* We need to store R1 and R14. */
    
    /**********************************************************************************************
    * Instructions: 
    *   - STM   Encoding T2 (32-bit)
    *   - LDM   Encoding T2 (32-bit)
    *   - STMDB Encoding T1 (32-bit)
    *   - LDMDB Encoding T1 (32-bit)
    **********************************************************************************************/
    BL      m4_scst_loadstore_test2_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test2_init
    MOV     R5,R0
    LDR     R0,=VAL5
    /* <Rn[3:0]>:R5 0b0101
       <register_list>:R0,R2,R4,R6,R8,R10,R12 0b1010101010101 */
    STM.W   R5,{R0,R2,R4,R6,R8,R10,R12} 
    DSB
    LDR     R1,[R5]
    SUBS    R0,R1,R0
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R5,#4]
    SUBS    R2,R1,R2
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R5,#8]
    SUBS    R4,R1,R4
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R5,#12]
    SUBS    R6,R1,R6
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R5,#16]
    SUBS    R8,R1,R8
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R5,#20]
    SUBS    R10,R1,R10
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R5,#24]
    SUBS    R12,R1,R12
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R5,#28]
    CMP     R1,#0
    BNE     m4_scst_loadstore_test2_failed
    
    /* <Rn[3:0]>:R5 0b0101
       <register_list>:R0,R2,R4,R6,R8,R10,R12 0b1010101010101 */
    LDM.W   R5,{R0,R2,R4,R6,R8,R10,R12} 
    DSB
    LDR     R1,[R5]
    CMP     R1,R0
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R5,#4]
    CMP     R1,R2
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R5,#8]
    CMP     R1,R4
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R5,#12]
    CMP     R1,R6
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R5,#16]
    CMP     R1,R8
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R5,#20]
    CMP     R1,R10
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R5,#24]
    CMP     R1,R12
    BNE     m4_scst_loadstore_test2_failed
    /* Load address back to R0 */
    MOV     R0,R5
    
    
    BL      m4_scst_loadstore_test2_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test2_init
    ADD     R10,R0,#24
    /* <Rn[3:0]>:R10 0b1010
       <register_list>:R1,R3,R5,R7,R9,R11 0b0101010101010 */
    STMDB.W R10!,{R1,R3,R5,R7,R9,R11} 
    DSB
    /* We need to check address */
    CMP     R10,R0
    BNE     m4_scst_loadstore_test2_failed
    /* We need to check data */
    LDR     R2,[R0]
    SUBS    R1,R2,R1
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R0,#4]
    SUBS    R3,R2,R3
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R0,#8]
    SUBS    R5,R2,R5
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R0,#12]
    SUBS    R7,R2,R7
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R0,#16]
    SUBS    R9,R2,R9
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R0,#20]
    SUBS    R11,R2,R11
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R0,#24]
    CMP     R2,#0
   
    ADD     R10,R0,#24
    /* <Rn[3:0]>:R10 0b1010
       <register_list>:R1,R3,R5,R7,R9,R11 0b0101010101010 */
    LDMDB.W R10!,{R1,R3,R5,R7,R9,R11}
    /* We need to check address */
    CMP     R10,R0
    BNE     m4_scst_loadstore_test2_failed
    /* We need to check data */
    LDR     R2,[R0]
    CMP     R2,R1
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R0,#4]
    CMP     R2,R3
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R0,#8]
    CMP     R2,R5
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R0,#12]
    CMP     R2,R7
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R0,#16]
    CMP     R2,R9
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R0,#20]
    CMP     R2,R11
    BNE     m4_scst_loadstore_test2_failed
    
    
    BL      m4_scst_loadstore_test2_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test2_init
    ADD     R7,R0,#28
    MOV     R2,R0
    LDR     R0,=VAL7
    /* <Rn[3:0]>:R7 0b0111
       <register_list>:R0,R1,R4,R5,R8,R9,R12 0b1001100110011 */
    STMDB.W R7,{R0,R1,R4,R5,R8,R9,R12}
    DSB
    /* We need to check address was not changed */
    SUB     R7,R7,#28
    CMP     R7,R2
    BNE     m4_scst_loadstore_test2_failed
    /* We need to check data */
    LDR     R2,[R7]
    SUBS    R0,R2,R0
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R7,#4]
    SUBS    R1,R2,R1
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R7,#8]
    SUBS    R4,R2,R4
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R7,#12]
    SUBS    R5,R2,R5
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R7,#16]
    SUBS    R8,R2,R8
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R7,#20]
    SUBS    R9,R2,R9
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R7,#24]
    SUBS    R12,R2,R12
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R7,#28]
    CMP     R2,#0
    BNE     m4_scst_loadstore_test2_failed
    
    
    B m4_scst_loadstore_test2_common_label1_ltorg_jump /* jump over the following LTORG section */
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
m4_scst_loadstore_test2_common_label1_ltorg_jump:
   
    MOV     R2,R7
    ADD     R7,R7,#28
    /* <Rn[3:0]>:R7 0b0111
       <register_list>:R0,R1,R4,R5,R8,R9,R12 0b1001100110011 */
    LDMDB.W R7,{R0,R1,R4,R5,R8,R9,R12}
    /* We need to check address was not changed */
    SUB     R7,R7,#28
    CMP     R7,R2
    BNE     m4_scst_loadstore_test2_failed
    /* We need to check data */
    LDR     R2,[R7]
    CMP     R2,R0
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R7,#4]
    CMP     R2,R1
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R7,#8]
    CMP     R2,R4
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R7,#12]
    CMP     R2,R5
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R7,#16]
    CMP     R2,R8
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R7,#20]
    CMP     R2,R9
    BNE     m4_scst_loadstore_test2_failed
    LDR     R2,[R7,#24]
    CMP     R2,R12
    BNE     m4_scst_loadstore_test2_failed
    /* Load address back to R0 */
    MOV     R0,R7
    
    
    BL      m4_scst_loadstore_test2_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test2_init
    MOV     R8,R0
    /* <Rn[3:0]>:R8 0b1000
       <register_list>:R2,R3,R6,R7,R10,R11 0b0110011001100 */
    STM.W   R8!,{R2,R3,R6,R7,R10,R11}
    DSB
    /* We need to check address */
    SUB     R8,R8,#24
    CMP     R8,R0
    BNE     m4_scst_loadstore_test2_failed
    /* We need to check data */
    LDR     R1,[R0]
    SUBS    R2,R1,R2
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#4]
    SUBS    R3,R1,R3
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#8]
    SUBS    R6,R1,R6
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#12]
    SUBS    R7,R1,R7
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#16]
    SUBS    R10,R1,R10
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#20]
    SUBS    R11,R1,R11
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#24]
    CMP     R1,#0
    BNE     m4_scst_loadstore_test2_failed
   
    MOV     R8,R0
    /* <Rn[3:0]>:R8 0b1000
       <register_list>:R2,R3,R6,R7,R10,R11 0b0110011001100 */
    LDM.W   R8!,{R2,R3,R6,R7,R10,R11}
    /* We need to check address */
    SUB     R8,R8,#24
    CMP     R8,R0
    BNE     m4_scst_loadstore_test2_failed
    /* We need to check data */
    LDR     R1,[R0]
    CMP     R1,R2
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#4]
    CMP     R1,R3
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#8]
    CMP     R1,R6
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#12]
    CMP     R1,R7
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#16]
    CMP     R1,R10
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#20]
    CMP     R1,R11
    BNE     m4_scst_loadstore_test2_failed
    
    
    BL      m4_scst_loadstore_test2_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test2_init
    MOV     R4,R0
    MOV     R3,R0
    LDR     R0,=VAL4
    /* <Rn[3:0]>:R4 0b0100
       <register_list>:R0,R1,R2,R6,R7,R8,R12 0b1000111000111 */
    STM.W   R4,{R0,R1,R2,R6,R7,R8,R12}
    DSB
    /* We need to check address was not changed */
    CMP     R4,R3
    BNE     m4_scst_loadstore_test2_failed
    /* We need to check data */
    LDR     R3,[R4]
    SUBS    R0,R3,R0
    BNE     m4_scst_loadstore_test2_failed
    LDR     R3,[R4,#4]
    SUBS    R1,R3,R1
    BNE     m4_scst_loadstore_test2_failed
    LDR     R3,[R4,#8]
    SUBS    R2,R3,R2
    BNE     m4_scst_loadstore_test2_failed
    LDR     R3,[R4,#12]
    SUBS    R6,R3,R6
    BNE     m4_scst_loadstore_test2_failed
    LDR     R3,[R4,#16]
    SUBS    R7,R3,R7
    BNE     m4_scst_loadstore_test2_failed
    LDR     R3,[R4,#20]
    SUBS    R8,R3,R8
    BNE     m4_scst_loadstore_test2_failed
    LDR     R3,[R4,#24]
    SUBS    R12,R3,R12
    BNE     m4_scst_loadstore_test2_failed
    LDR     R3,[R4,#28]
    CMP     R1,#0
    BNE     m4_scst_loadstore_test2_failed
   
    MOV     R3,R4
    /* <Rn[3:0]>:R4 0b0100
       <register_list>:R0,R1,R2,R6,R7,R8,R12 0b1000111000111 */
    LDM.W   R4,{R0,R1,R2,R6,R7,R8,R12}
    /* We need to check address was not changed */
    CMP     R4,R3
    BNE     m4_scst_loadstore_test2_failed
    /* We need to check data */
    LDR     R3,[R4]
    CMP     R3,R0
    BNE     m4_scst_loadstore_test2_failed
    LDR     R3,[R4,#4]
    CMP     R3,R1
    BNE     m4_scst_loadstore_test2_failed
    LDR     R3,[R4,#8]
    CMP     R3,R2
    BNE     m4_scst_loadstore_test2_failed
    LDR     R3,[R4,#12]
    CMP     R3,R6
    BNE     m4_scst_loadstore_test2_failed
    LDR     R3,[R4,#16]
    CMP     R3,R7
    BNE     m4_scst_loadstore_test2_failed
    LDR     R3,[R4,#20]
    CMP     R3,R8
    BNE     m4_scst_loadstore_test2_failed
    LDR     R3,[R4,#24]
    CMP     R3,R12
    BNE     m4_scst_loadstore_test2_failed
    /* Load address back to R0 */
    MOV     R0,R4
    
    
    BL      m4_scst_loadstore_test2_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test2_init
    ADD     R12,R0,#24
    /* <Rn[3:0]>:R12 0b1100
       <register_list>:R3,R4,R5,R9,R10,R11 0b0111000111000 */
    STMDB.W R12!,{R3,R4,R5,R9,R10,R11}
    DSB
    /* We need to check address */
    CMP     R12,R0
    BNE     m4_scst_loadstore_test2_failed
    /* We need to check data */
    LDR     R1,[R0]
    SUBS    R3,R1,R3
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#4]
    SUBS    R4,R1,R4
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#8]
    SUBS    R5,R1,R5
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#12]
    SUBS    R9,R1,R9
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#16]
    SUBS    R10,R1,R10
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#20]
    SUBS    R11,R1,R11
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#24]
    CMP     R1,#0
    BNE     m4_scst_loadstore_test2_failed
   
    ADD     R12,R0,#24
    /* <Rn[3:0]>:R12 0b1100
       <register_list>:R3,R4,R5,R9,R10,R11 0b0111000111000 */
    LDMDB.W R12!,{R3,R4,R5,R9,R10,R11}
    /* We need to check address */
    CMP     R12,R0
    BNE     m4_scst_loadstore_test2_failed
    /* We need to check data */
    LDR     R1,[R0]
    CMP     R1,R3
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#4]
    CMP     R1,R4
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#8]
    CMP     R1,R5
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#12]
    CMP     R1,R9
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#16]
    CMP     R1,R10
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#20]
    CMP     R1,R11
    BNE     m4_scst_loadstore_test2_failed
    
    
    BL      m4_scst_loadstore_test2_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test2_init
    MOV     R6,R0
    MOV     R4,R0
    LDR     R0,=VAL6
    /* <Rn[3:0]>:R6 0b0110
       <register_list>:R0,R1,R2,R3,R8,R9,R10,R11 0b0111100001111 */
    STM.W   R6,{R0,R1,R2,R3,R8,R9,R10,R11}
    DSB
    /* We need to check address was not changed */
    CMP     R6,R4
    BNE     m4_scst_loadstore_test2_failed
    /* We need to check data */
    LDR     R4,[R6]
    SUBS    R0,R4,R0
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#4]
    SUBS    R1,R4,R1
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#8]
    SUBS    R2,R4,R2
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#12]
    SUBS    R3,R4,R3
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#16]
    SUBS    R8,R4,R8
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#20]
    SUBS    R9,R4,R9
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#24]
    SUBS    R10,R4,R10
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#28]
    SUBS    R11,R4,R11
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#32]
    CMP     R4,#0
    BNE     m4_scst_loadstore_test2_failed
   
    MOV     R4,R6
    /* <Rn[3:0]>:R6 0b0110
       <register_list>:R0,R1,R2,R3,R8,R9,R10,R11 0b0111100001111 */
    LDM.W   R6,{R0,R1,R2,R3,R8,R9,R10,R11}
    /* We need to check address was not changed */
    CMP     R6,R4
    BNE     m4_scst_loadstore_test2_failed
    /* We need to check data */
    LDR     R4,[R6]
    CMP     R4,R0
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#4]
    CMP     R4,R1
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#8]
    CMP     R4,R2
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#12]
    CMP     R4,R3
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#16]
    CMP     R4,R8
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#20]
    CMP     R4,R9
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#24]
    CMP     R4,R10
    BNE     m4_scst_loadstore_test2_failed
    LDR     R4,[R6,#28]
    CMP     R4,R11
    BNE     m4_scst_loadstore_test2_failed
    /* Load address back to R0 */
    MOV     R0,R6
    
    
    BL      m4_scst_loadstore_test2_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test2_init
    MOV     R3,R0
    /* <Rn[3:0]>:R3 0b0011
       <register_list>:R0,R4,R5,R6,R7 0b0000011110001
       Special case where base address is member of register list !! */
    STM.W   R0,{R0,R4,R5,R6,R7}     
    DSB
    LDR     R1,[R3]
    SUBS    R0,R1,R0
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R3,#4]
    SUBS    R4,R1,R4
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R3,#8]
    SUBS    R5,R1,R5
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R3,#12]
    SUBS    R6,R1,R6
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R3,#16]
    SUBS    R7,R1,R7
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R3,#20]
    CMP     R1,#0
    BNE     m4_scst_loadstore_test2_failed
    
    LDR     R0,=VAL3
    STR     R0,[R3] /* Rewrite value in memory it contains address */
    DSB
    MOV     R0,R3   /* Move address back to R0 */
    /* <Rn[3:0]>:R3 0b0011
       <register_list>:R3,R4,R5,R6,R7 0b0000011111000
       Special case where base address is member of register list !! */
    LDM.W   R3,{R3,R4,R5,R6,R7}
    /* We need to check data */
    LDR     R1,[R0]
    CMP     R1,R3
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#4]
    CMP     R1,R4
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#8]
    CMP     R1,R5
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#12]
    CMP     R1,R6
    BNE     m4_scst_loadstore_test2_failed
    LDR     R1,[R0,#16]
    CMP     R1,R7
    BNE     m4_scst_loadstore_test2_failed
    
    POP.W   {R1,R14}    /* We need to restore R1 and R14. */
    BX  LR
    

m4_scst_loadstore_test2_init:

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
    
    BX  LR
    
m4_scst_loadstore_test2_clear_target_memory:
    
    EORS    R1,R1
    
    STR     R1,[R0]
    STR     R1,[R0,#4]
    STR     R1,[R0,#8]
    STR     R1,[R0,#12]
    STR     R1,[R0,#16]
    STR     R1,[R0,#20]
    STR     R1,[R0,#24]
    STR     R1,[R0,#28]
    STR     R1,[R0,#32]
    STR     R1,[R0,#36]
    STR     R1,[R0,#40]
    STR     R1,[R0,#44]
    STR     R1,[R0,#48]
    
    BX      LR
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    