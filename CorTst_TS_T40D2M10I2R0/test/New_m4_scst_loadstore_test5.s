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
*   - 2 bit immediate shift value
*   - write back control
*
* Overall coverage:
* -----------------
* Covers LDR.W, STR.W, LDRB.W, STRB.W, LDRH.W, STRH.W, LDRSB.W, STRSB.W, LDRSH.W, STRSH.W,
* LDRT.W, LDRBT.W, LDRHT.W, LDRSBT.W, LDRSHT.W instructions as well as logic processing
* its various encoding types:
* - '<Rn>','<Rt>' and '#<imm12>' as well as  <data_to_store> and <data_to_load>
* - '<Rn>','<Rt>' and '#<imm8>' as well as  <data_to_store> and <data_to_load>
* - '<Rn>','<Rt>','#<imm2>' and 'Rm' as well as  <data_to_store> and <data_to_load>
* - '<Rt>',<label> as well as  <data_to_load> 
* 
* DECODER:
* Thumb (32-bit)
*   - Encoding of "Store single data item" instructions
*   - Encoding of "Load byte, memory hints" instructions - Load byte
*   - Encoding of "Load halfword, memory hints" instructions - Load halfword
*   - Encoding of "Load word" instructions
* 测试总结：
* -------------
*
* 涵盖 LSU 操作类型：
* - 加载/存储单个
* - 2 位立即移位值
* - 写回控制
*
* 整体覆盖：
* -----------------
* 涵盖 LDR.W、STR.W、LDRB.W、STRB.W、LDRH.W、STRH.W、LDRSB.W、STRSB.W、LDRSH.W、STRSH.W、
* LDRT.W, LDRBT.W, LDRHT.W, LDRSBT.W, LDRSHT.W 指令以及逻辑处理
* 其各种编码类型：
* - '<Rn>'、'<Rt>' 和 '#<imm12>' 以及 <data_to_store> 和 <data_to_load>
* - '<Rn>'、'<Rt>' 和 '#<imm8>' 以及 <data_to_store> 和 <data_to_load>
* - '<Rn>'、'<Rt>'、'#<imm2>' 和 'Rm' 以及 <data_to_store> 和 <data_to_load>
* - '<Rt>',<label> 以及 <data_to_load>
*
* 解码器：
* 拇指（32 位）
* - “存储单个数据项”指令的编码
* - “加载字节，内存提示”指令的编码 - 加载字节
* - “加载半字，内存提示”指令的编码 - 加载半字
* - “加载字”指令的编码
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_loadstore_test5

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
    
SCST_SET(PRESIGNATURE, 0xE54D84AB) /* this macro has to be at the beginning of the line */

    
    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)
    SCST_THUMB2    

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_loadstore_test5" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_loadstore_test5, function)
m4_scst_loadstore_test5:

    PUSH.W  {R1-R12,R14}

    /**********************************************************************************************
    * Instructions: 
    *   - LDR (literal)     Encoding T2 (32-bit)
    *
    * Note: Tested indirectly.    
    **********************************************************************************************/
    LDR.W   R0,=SCST_RAM_TARGET0
    BL      m4_scst_loadstore_test5_common
    LDR.W   R0,=SCST_RAM_TARGET1
    BL      m4_scst_loadstore_test5_common
    
    /* Test passed -> store result */
    LDR.W     R0,=VAL9
    EORS    R0,R1
     
m4_scst_loadstore_test5_end:
    B      m4_scst_test_tail_end
    

m4_scst_loadstore_test5_failed:
    POP.W   {R1,R14}    /* We just need to pop two words from stack */
    MOVW    R0,#0x444
    B       m4_scst_loadstore_test5_end

    
m4_scst_loadstore_test5_common:
    
    /* Load pre-signature */ 
    LDR.W   R1,=PRESIGNATURE
    
    PUSH    {R1,R14}    /* We need to store R1 and R14. */
    
    /**********************************************************************************************
    * Instructions: 
    *   - STR (immediate)   Encoding T3 (32-bit)
    *   - LDR (immediate)   Encoding T3 (32-bit)
    **********************************************************************************************/
    BL      m4_scst_loadstore_test5_clear_target_memory
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    SUB     R10,R0,#0x555    /* Decrement address 0x555 */
    /* <Rn[3:0]>:R10
       <Rt[15:12]>:R1(STR) R2(LDR)
       <imm12[11:0]>:0x555 */
    STR.W   R1,[R10,#0x555]  /* <data_to_store>:R1=0x55555555 */
    DSB
    LDR.W   R2,[R10,#0x555]  /* <data_to_load>:R2=0x55555555 */
    /* We need to check data */
    CMP     R1,R2
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    SUB     R10,R0,#0xAAA    /* Decrement address 0xAAA */
    /* <Rn[3:0]>:R10
       <Rt[15:12]>:R2(STR) R1(LDR)
       <imm12[11:0]>:0xAAA */
    STR.W   R2,[R10,#0xAAA]  /* <data_to_store>:R2=0xAAAAAAAA */
    DSB
    LDR.W   R1,[R10,#0xAAA]  /* <data_to_load>:R1=0xAAAAAAAA */
    /* We need to check data */
    CMP     R2,R1
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    ADD     R0,R0,#4
    SUB     R5,R0,#0x333    /* Decrement address 0x333 */
    /* <Rn[3:0]>:R5
       <Rt[15:12]>:R3(STR) R4(LDR)
       <imm12[11:0]>:0x333 */
    STR.W   R3,[R5,#0x333]  /* <data_to_store>:R3=0xCCCCCCCC */
    DSB
    LDR.W   R4,[R5,#0x333]  /* <data_to_load>:R4=0xCCCCCCCC */
    /* We need to check data */
    CMP     R3,R4
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init  
    SUB     R5,R0,#0xCCC    /* Decrement address 0xCCC */
    /* <Rn[3:0]>:R5
       <Rt[15:12]>:R4(STR) R3(LDR)
       <imm12[11:0]>:0xCCC */
    STR.W   R4,[R5,#0xCCC]  /* <data_to_store>:R4=0x33333333 */
    DSB
    LDR.W   R3,[R5,#0xCCC]  /* <data_to_load>:R3=0x33333333 */
    /* We need to check data */
    CMP     R4,R3
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    ADD     R0,R0,#4
    SUB     R7,R0,#0x777    /* Decrement address 0x777 */
    /* <Rn[3:0]>:R7
       <Rt[15:12]>:R5(STR) R6(LDR)
       <imm12[11:0]>:0x777 */
    STR.W   R5,[R7,#0x777]  /* <data_to_store>:R5=0x99999999 */
    DSB
    LDR.W   R6,[R7,#0x777]  /* <data_to_load>:R6=0x99999999 */
    /* We need to check data */
    CMP     R5,R6
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    SUB     R7,R0,#0xEEE    /* Decrement address 0xEEE */
    /* <Rn[3:0]>:R7
       <Rt[15:12]>:R6(STR) R5(LDR)
       <imm12[11:0]>:0xEEE */
    STR.W   R6,[R7,#0xEEE]  /* <data_to_store>:R6=0x66666666 */
    DSB
    LDR.W   R5,[R7,#0xEEE]  /* <data_to_load>:R5=0x66666666 */
    /* We need to check data */
    CMP     R6,R5
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    ADD     R0,R0,#4
    SUB     R3,R0,#0xFFF    /* Decrement address 0xFFF */
    /* <Rn[3:0]>:R3
       <Rt[15:12]>:R7(STR) R8(LDR)
       <imm12[11:0]>:0xFFF */
    STR.W   R7,[R3,#0xFFF]  /* <data_to_store>:R7=0x77777777 */
    DSB
    LDR.W   R8,[R3,#0xFFF]  /* <data_to_load>:R8=0x77777777 */
    /* We need to check data */
    CMP     R7,R8
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R3,R0
    /* <Rn[3:0]>:R3
       <Rt[15:12]:R8(STR) R7(LDR)
       <imm12[11:0]>:0x000 */
    STR.W   R8,[R3,#0x0]    /* <data_to_store>:R8=0xEEEEEEEE */
    DSB
    LDR.W   R7,[R3,#0x0]    /* <data_to_load>:R7=0xEEEEEEEE */
    /* We need to check data */
    CMP     R8,R7
    BNE     m4_scst_loadstore_test5_failed
    
    /**********************************************************************************************
    * Instructions: 
    *   - STRB (immediate)  Encoding T2 (32-bit)
    *   - LDRB (immediate)  Encoding T2 (32-bit)
    *
    * Note: Formats of these instructions are identical to T3 encoding of the STR (immediate) 
    *       and LDR (immediate) ones.
    *       Testing only of "byte" operations are performed.
    **********************************************************************************************/
    ADD     R0,R0,#4
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    SUB     R12,R0,#0xF0F   /* Decrement address 0xF0F */    
    /* <Rn[3:0]>:R12
       <Rt[15:12]>:R9(STRB) R10(LDRB)
       <imm12[11:0]>:0xF0F */
    STRB.W  R9,[R12,#0xF0F]  /* <data_to_store>:R9=0x13579BDF (0xDF) */
    DSB
    LDRB.W  R10,[R12,#0xF0F]  /* <data_to_load>:R10=0xDF */
    /* We need to check data */
    LDR     R9,[R12,#0xF0F]
    LDR     R8,=0xFFFFFF00
    EOR     R9,R9,R8
    CMP     R10,R9
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    SUB     R12,R0,#0x3D1    /* Decrement address 0x3D1 */
    /* <Rn[3:0]>:R12
       <Rt[15:12]>:R10(STRB) R9(LDRB)
       <imm12[11:0]>:0x3D1 */
    STRB.W  R10,[R12,#0x3D1]  /* <data_to_store>:R10=0xFDB97531 (0x31) */
    DSB
    LDRB.W  R9,[R12,#0x3D1]  /* <data_to_load>:R9=0x31 */
    /* We need to check data */
    LDR     R10,[R12,#0x3D1]
    LDR     R8,=0xFFFFFF00
    EOR     R10,R10,R8
    CMP     R9,R10
    BNE     m4_scst_loadstore_test5_failed
    
    /**********************************************************************************************
    * Instructions: 
    *   - LDRSB (immediate) Encoding T1 (32-bit)
    *
    * Note: Format of this instruction is identical to T3 encoding of the LDR (immediate) one.
    *       Testing only of "signed-byte" operation is performed.
    **********************************************************************************************/
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    SUB     R1,R0,#0x222   /* Decrement address 0x222 */    
    /* <Rn[3:0]>:R1
       <Rt[15:12]>:R11(STR) R12(LDRSH)
       <imm12[11:0]>:0x222 */
    STR.W   R11,[R1,#0x222]  /* <data_to_store>:R11=0x2468ACE0 */
    DSB
    LDRSB.W R12,[R1,#0x222]  /* <data_to_load>:R12=0xFFFFFFE0 */
    /* We need to check data */
    SBFX    R10,R11,#0,#8
    CMP     R12,R10
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    SUB     R1,R0,#0xC21    /* Decrement address 0xC21 */
    /* <Rn[3:0]>:R2
       <Rt[15:12]>:R12(STR) R11(LDRSH)
       <imm12[11:0]>:0xC21 */
    STR.W   R12,[R1,#0xC21]  /* <data_to_store>:R12=0x0ECA8642 */
    DSB
    LDRSB.W R11,[R1,#0xC21]  /* <data_to_load>:R11=0x00000042 */
    /* We need to check data */
    SBFX    R10,R12,#0,#8
    CMP     R11,R10
    BNE     m4_scst_loadstore_test5_failed
    
    /**********************************************************************************************
    * Instructions: 
    *   - STRH (immediate)  Encoding T2 (32-bit)
    *   - LDRH (immediate)  Encoding T2 (32-bit)
    *
    * Note: Formats of these instructions are identical to T3 encoding of the STR (immediate) 
    *       and LDR (immediate) ones.
    *       Testing only of "halfword" operations are performed.
    **********************************************************************************************/
    ADD     R0,R0,#4
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    SUB     R9,R0,#0x0F0    /* Decrement address 0x0F0 */    
    /* <Rn[3:0]>:R2
       <Rt[15:12]>:R0(STRH) R1(LDRH)
       <imm12[11:0]>:0x0F0 */
    STRH.W  R11,[R9,#0x0F0]  /* <data_to_store>:R11=0x2468ACE0 (0xACE0) */
    DSB
    LDRH.W  R12,[R9,#0x0F0]  /* <data_to_load>:R12=0xACE0 */
    /* We need to check data */
    LDR     R11,[R9,#0x0F0]
    LDR     R8,=0xFFFF0000
    EOR     R11,R11,R8
    CMP     R12,R11
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    SUB     R9,R0,#0xE52   /* Decrement address 0xE52 */
    /* <Rn[3:0]>:R2
       <Rt[15:12]>:R1(STRH) R0(LDRH)
       <imm12[11:0]>:0xE52*/
    STRH.W  R12,[R9,#0xE52]  /* <data_to_store>:R12=0x0ECA8642 (0x8642) */
    DSB
    LDRH.W  R11,[R9,#0xE52]  /* <data_to_load>:R11=0x8642 */
    /* We need to check data */
    LDR     R12,[R9,#0xE52]
    LDR     R8,=0xFFFF0000
    EOR     R12,R12,R8
    CMP     R11,R12
    BNE     m4_scst_loadstore_test5_failed
    
    
    /**********************************************************************************************
    * Instructions: 
    *   - LDRSH (immediate) Encoding T1 (32-bit)
    *
    * Note: Format of this instruction is identical to T3 encoding of the LDR.W (immediate) one.
    *       Testing only of "signed-halfword" operation is performed.
    **********************************************************************************************/
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    SUB     R2,R0,#0x111   /* Decrement address 0x111 */    
    /* <Rn[3:0]>:R2
       <Rt[15:12]>:R9(STR) R10(LDRSB)
       <imm12[11:0]>:0x111 */
    STR.W   R9,[R2,#0x111]  /* <data_to_store>:R9=0x13579BDF */
    DSB
    LDRSH.W R10,[R2,#0x111]  /* <data_to_load>:R10=0xFFFFDBDF */
    /* We need to check data */
    SBFX    R8,R9,#0,#16
    CMP     R10,R8
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    SUB     R2,R0,#0x5A3    /* Decrement address 0x5A3 */
    /* <Rn[3:0]>:R2
       <Rt[15:12]>:R10(STR) R10(LDRSB)
       <imm12[11:0]>:0x5A3 */
    STR.W   R10,[R2,#0x5A3]  /* <data_to_store>:R10=0xFDB97531 */
    DSB
    LDRSH.W R9,[R2,#0x5A3]  /* <data_to_load>:R9=0x00007531 */
    /* We need to check data */
    SBFX    R8,R10,#0,#16
    CMP     R9,R8
    BNE     m4_scst_loadstore_test5_failed
    
    
    /**********************************************************************************************
    * Instructions: 
    *   - STR (immediate)   Encoding T4 (32-bit)
    *   - LDR (immediate)   Encoding T4 (32-bit)
    **********************************************************************************************/
    SUB     R0,R0,#20
    BL      m4_scst_loadstore_test5_clear_target_memory
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    ADD     R10,R0,#0x55     /* Increment address 0x55 */    
    /* <Rn[3:0]>:R10
       <Rt[15:12]>:R1(STR) R2(LDR)
       <imm8[7:0]>:0x55 */
    STR.W   R1,[R10,#-0x55]  /* <data_to_store>:R0=0x55555555 */
    DSB
    /* We need to check address was not changed */
    SUB     R10,R10,#0x55 
    CMP     R10,R0
    BNE     m4_scst_loadstore_test5_failed
    ADD     R10,R0,#0x55     /* Increment address 0x55 */    
    LDR.W   R2,[R10,#-0x55]  /* <data_to_load>:R1=0x55555555 */
    /* We need to check address was not changed */
    SUB     R10,R10,#0x55 
    CMP     R10,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    CMP     R1,R2
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    SUB     R10,R0,#0xAA     /* Decrement address 0xAA */
    /* <Rn[3:0]>:R10
       <Rt[15:12]>:R2(STR) R1(LDR)
       <imm8[7:0]>:0xAA */
    STR.W   R2,[R10,#0xAA]!  /* <data_to_store>:R1=0xAAAAAAAA */
    DSB
    /* We need to check address was incremented */
    CMP     R10,R0
    BNE     m4_scst_loadstore_test5_failed
    SUB     R10,R0,#0xAA     /* Decrement address 0xAA */
    LDR.W   R1,[R10,#0xAA]!  /* <data_to_load>:R0=0xAAAAAAAA */
    /* We need to check address was incremented */
    CMP     R10,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    CMP     R2,R1
    BNE     m4_scst_loadstore_test5_failed
    
    ADD     R0,R0,#4
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R5,R0
    /* <Rn[3:0]>:R5
       <Rt[15:12]>:R3(STR) R4(LDR)
       <imm8[7:0]>:0x33 */
    STR.W   R3,[R5],#0x33   /* <data_to_store>:R3=0xCCCCCCCC */
    DSB
    /* We need to check address was incremented */
    SUB     R5,R5,#0x33
    CMP     R5,R0
    BNE     m4_scst_loadstore_test5_failed
    LDR.W   R4,[R5],#0x33   /* <data_to_load>:R4=0xCCCCCCCC */
    /* We need to check address was incremented */
    SUB     R5,R5,#0x33
    CMP     R5,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    CMP     R3,R4
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R5,R0
    /* <Rn[3:0]>:R5
       <Rt[15:12]>:R4(STR) R3(LDR)
       <imm8[7:0]>:0xCC */
    STR.W   R4,[R5],#-0xCC  /* <data_to_store>:R4=0x33333333 */
    DSB
    /* We need to check address was decremented */
    ADD     R5,R5,#0xCC
    CMP     R5,R0
    BNE     m4_scst_loadstore_test5_failed
    LDR.W   R3,[R5],#-0xCC  /* <data_to_load>:R3=0x33333333 */
    /* We need to check address was decremented */
    ADD     R5,R5,#0xCC
    CMP     R5,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    CMP     R4,R3
    BNE     m4_scst_loadstore_test5_failed
    
    ADD     R0,R0,#4
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    ADD     R7,R0,#0x77     /* Increment address 0x77 */
    /* <Rn[3:0]>:R7
       <Rt[15:12]>:R5(STR) R6(LDR)
       <imm8[7:0]>:0x77 */
    STR.W   R5,[R7,#-0x77]! /* <data_to_store>:R5=0x99999999 */
    DSB
    /* We need to check address was decremented */
    CMP     R7,R0
    BNE     m4_scst_loadstore_test5_failed
    ADD     R7,R0,#0x77     /* Increment address 0x77 */
    LDR.W   R6,[R7,#-0x77]! /* <data_to_load>:R6=0x99999999 */
    /* We need to check address was decremented */
    CMP     R7,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    CMP     R5,R6
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    ADD     R7,R0,#0xEE     /* Increment address 0xEE */
    /* <Rn[3:0]>:R7
       <Rt[15:12]>:R6(STR) R5(LDR)
       <imm8[7:0]>:0xEE */
    STR.W   R6,[R7,#-0xEE]  /* <data_to_store>:R6=0x66666666 */
    DSB
    /* We need to check address was not changed */
    SUB     R7,R7,#0xEE 
    CMP     R7,R0
    BNE     m4_scst_loadstore_test5_failed
    ADD     R7,R0,#0xEE     /* Increment address 0xEE */ 
    LDR.W   R5,[R7,#-0xEE]  /* <data_to_load>:R5=0x66666666 */
    /* We need to check address was not changed */
    SUB     R7,R7,#0xEE 
    CMP     R7,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    CMP     R6,R5
    BNE     m4_scst_loadstore_test5_failed
    
    ADD     R0,R0,#4
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R3,R0
    /* <Rn[3:0]>:R3
       <Rt[15:12]>:R7(STR) R8(LDR)
       <imm8[7:0]>:0xFF */
    STR.W   R7,[R3],#0xFF   /* <data_to_store>:R7=0x77777777 */
    DSB
    /* We need check address was incremented */
    SUB     R3,R3,#0xFF
    CMP     R3,R0
    BNE     m4_scst_loadstore_test5_failed
    LDR.W   R8,[R3],#0xFF   /* <data_to_load>:R8=0x77777777 */
    /* We need check address was incremented */
    SUB     R3,R3,#0xFF
    CMP     R3,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    CMP     R7,R8
    BNE     m4_scst_loadstore_test5_failed
    
    /**********************************************************************************************
    * Instructions: 
    *   - LDRT  Encoding T1 (32-bit)
    *
    * Note: Format of this instruction is identical to T4 encoding of the LDR (immediate) one.
    **********************************************************************************************/
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R3,R0
    /* <Rn[3:0]>:R3
       <Rt[15:12]:R8(STR) R7(LDRT)
       <imm8[7:0]>:0x00 */
    STR.W   R8,[R3,#0x0]!   /* <data_to_store>:R8=0xEEEEEEEE */
    DSB
    /* We need to check address was not changed */
    CMP     R3,R0
    BNE     m4_scst_loadstore_test5_failed
    LDRT.W  R7,[R3,#0x0]   /* <data_to_load>:R7=0xEEEEEEEE */
    /* We need to check address was not changed */
    CMP     R3,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    CMP     R8,R7
    BNE     m4_scst_loadstore_test5_failed
    
    /**********************************************************************************************
    * Instructions: 
    *   - STRB (immediate)  Encoding T3 (32-bit)
    *   - LDRB (immediate)  Encoding T3 (32-bit)
    *
    * Note: Format of these instructions are identical to T4 encoding of the STR (immediate)
            and LDR (immediate) ones.
    *       Testing only of "byte" operations are performed.
    **********************************************************************************************/
    ADD     R0,R0,#4
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    ADD     R12,R0,#0x0F     /* Increment address 0x0F */    
    /* <Rn[3:0]>:R12
       <Rt[15:12]>:R9(STRB) R10(LDRB)
       <imm8[7:0]>:0x0F */
    STRB.W  R9,[R12,#-0x0F]  /* <data_to_store>:R9=0x13579BDF (0xDF) */
    DSB
    /* We need to check address was not changed */
    SUB     R12,R12,#0x0F 
    CMP     R12,R0
    BNE     m4_scst_loadstore_test5_failed
    ADD     R12,R0,#0x0F     /* Increment address 0x0F */    
    LDRB.W  R10,[R12,#-0x0F]  /* <data_to_load>:R10=0xDF */
    /* We need to check address was not changed */
    SUB     R12,R12,#0x0F 
    CMP     R12,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    LDR     R9,[R12]
    LDR     R8,=0xFFFFFF00
    EOR     R9,R9,R8
    CMP     R10,R9
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    SUB     R12,R0,#0x3B     /* Decrement address 0x3B */
    /* <Rn[3:0]>:R12
       <Rt[15:12]>:R10(STRB) R9(LDRB)
       <imm8[7:0]>:0x3B */
    STRB.W  R10,[R12,#0x3B]!  /* <data_to_store>:R10=0xFDB97531 */
    DSB
    /* We need to check address was incremented */
    CMP     R12,R0
    BNE     m4_scst_loadstore_test5_failed
    SUB     R12,R0,#0x3B     /* Decrement address 0x3B */
    LDRB.W  R9,[R12,#0x3B]!  /* <data_to_load>:R9=0x31 */
    /* We need to check address was incremented */
    CMP     R12,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    LDR     R10,[R12]
    LDR     R8,=0xFFFFFF00
    EOR     R10,R10,R8
    CMP     R9,R10
    BNE     m4_scst_loadstore_test5_failed
    
    /**********************************************************************************************
    * Instructions: 
    *   - LDRBT     Encoding T1 (32-bit)
    *
    * Note: Format of this instruction is identical to T2 encoding of the LDRB (immediate) one.
    *       Testing only of "byte" operation is performed.
    **********************************************************************************************/
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R2,R0
    /* <Rn[3:0]>:R2
       <Rt[15:12]>:R11(STR) R12(LDRBT)
       <imm8[7:0]>:0x1F */
    STR.W   R11,[R2]  /* <data_to_store>:R11=0x2468ACE0 */
    DSB
    SUB     R2,R2,#0x1F     /* Decrement address 0x1F */    
    LDRBT.W R12,[R2,#0x1F]  /* <data_to_load>:R10=0xE0 */
    /* We need to check address was not changed */
    ADD     R2,R2,#0x1F 
    CMP     R2,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    LDR     R11,[R2]
    BFC     R11,#8,#24
    CMP     R12,R11
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R2,R0
    /* <Rn[3:0]>:R2
       <Rt[15:12]>:R10(STR) R9(LDRBT)
       <imm8[7:0]>:0xB3 */
    STR.W   R12,[R2]    /* <data_to_store>:R12=0x0ECA8642 */
    DSB
    SUB     R2,R2,#0xB3     /* Decrement address 0xB3 */
    LDRBT.W R11,[R2,#0xB3]  /* <data_to_load>:R11=0x42 */
    /* We need to check address was not changed */
    ADD     R2,R2,#0xB3
    CMP     R2,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    LDR     R12,[R2]
    BFC     R12,#8,#24
    CMP     R11,R12
    BNE     m4_scst_loadstore_test5_failed
    
    
    /**********************************************************************************************
    * Instructions: 
    *   LDRSB (immediate)   Encoding T2 (32-bit)
    *
    * Note: Format of this instruction is identical to T4 encoding of the LDR (immediate) one.
    *       Testing only of "signed-byte" operation is performed.
    **********************************************************************************************/
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init 
    MOV     R1,R0
    /* <Rn[3:0]>:R1
       <Rt[15:12]>:R11(STR) R12(LDRSB)
       <imm8[7:0]>:0x22 */
    STR.W   R11,[R1],#0x22   /* <data_to_store>:R11=0x2468ACE0 */
    DSB
    /* We need to check address was incremented */
    SUB     R1,R1,#0x22
    CMP     R1,R0
    BNE     m4_scst_loadstore_test5_failed
    LDRSB.W R12,[R1],#0x22   /* <data_to_load>:R12=0xFFFFFFE0 */
    /* We need to check address was incremented */
    SUB     R1,R1,#0x22
    CMP     R1,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    SBFX    R10,R11,#0,#8
    CMP     R12,R10
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init 
    MOV     R1,R0
    /* <Rn[3:0]>:R1
       <Rt[15:12]>:R12(STR) R11(LDRSB)
       <imm8[7:0]>:0xA1 */
    STR.W   R12,[R1],#-0xA1  /* <data_to_store>:R12=0x0ECA8642 */
    DSB
    /* We need to check address was decremented */
    ADD     R1,R1,#0xA1
    CMP     R1,R0
    BNE     m4_scst_loadstore_test5_failed
    LDRSB.W R11,[R1],#-0xA1 /* <data_to_load>:R11=0x00000042 */
    /* We need to check address was decremented */
    ADD     R1,R1,#0xA1
    CMP     R1,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    SBFX    R10,R12,#0,#8
    CMP     R11,R10
    BNE     m4_scst_loadstore_test5_failed
    
    /**********************************************************************************************
    * Instructions: 
    *   LDRSBT  Encoding T1 (32-bit)
    *
    * Note: Format of this instruction is identical to T2 encoding of the LDRSB (immediate) one.
    *       Testing only of "signed-byte" operation is performed.
    **********************************************************************************************/
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init 
    MOV     R4,R0
    /* <Rn[3:0]>:R4
       <Rt[15:12]>:R9(STR) R10(LDRSBT)
       <imm8[7:0]>:0x11 */
    STR.W   R9,[R4]     /* <data_to_store>:R9=0x13579BDF */
    DSB
    /* We need to check address was incremented */
    SUB     R4,R4,#0x11
    LDRSBT.W  R10,[R4,#0x11]   /* <data_to_load>:R10=0xFFFFFFDF */
    /* We need to check address was not changed */
    ADD     R4,R4,#0x11
    CMP     R4,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    SBFX    R8,R9,#0,#8
    CMP     R10,R8
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init 
    MOV     R4,R0
    /* <Rn[3:0]>:R4
       <Rt[15:12]>:R10(STR) R9(LDRSBT)
       <imm8[7:0]>:0x2D */
    STR.W   R10,[R4]  /* <data_to_store>:R10=0xFDB97531 */
    DSB
    SUB     R4,R4,#0x2D
    LDRSBT.W  R9,[R4,#0x2D]    /* <data_to_load>:R9=0x00000031 */
    /* We need to check address was not changed */
    ADD     R4,R4,#0x2D
    CMP     R4,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    SBFX    R8,R10,#0,#8
    CMP     R9,R8
    BNE     m4_scst_loadstore_test5_failed
    
    
    /**********************************************************************************************
    * Instructions: 
    *   - STRH (immediate)  Encoding T3 (32-bit)
    *   - LDRH (immediate)  Encoding T3 (32-bit)
    *
    * Note: Formats of these instructions are identical to T4 encoding of the STR (immediate)
    *       and LDR (immediate) ones.
    *       Testing only of "halfword" operations are performed.
    **********************************************************************************************/
    ADD     R0,R0,#4
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    ADD     R9,R0,#0xF0     /* Increment address 0xF0 */
    /* <Rn[3:0]>:R9
       <Rt[15:12]>:R11(STRH) R12(LDRH)
       <imm8[7:0]>:0xF0 */
    STRH.W  R11,[R9,#-0xF0]! /* <data_to_store>:R11=0x2468ACE0 (0xACE0)*/
    DSB
    /* We need to check address was decremented */
    CMP     R9,R0
    BNE     m4_scst_loadstore_test5_failed
    ADD     R9,R0,#0xF0     /* Increment address 0xF0 */
    LDRH.W  R12,[R9,#-0xF0]! /* <data_to_load>:R12=0xACE0 */
    /* We need to check address was decremented */
    CMP     R9,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    LDR     R11,[R9]
    LDR     R8,=0xFFFF0000
    EOR     R11,R11,R8
    CMP     R12,R11
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    ADD     R9,R0,#0xE4     /* Increment address 0xE4 */
    /* <Rn[3:0]>:R9
       <Rt[15:12]>:R12(STRH) R11(LDRH)
       <imm8[7:0]>:0xE4 */
    STRH.W  R12,[R9,#-0xE4]  /* <data_to_store>:R12=0x0ECA8642 (0x8642) */
    DSB
    /* We need to check address was not changed */
    SUB     R9,R9,#0xE4 
    CMP     R9,R0
    BNE     m4_scst_loadstore_test5_failed
    ADD     R9,R0,#0xE4     /* Increment address 0xE4 */ 
    LDRH.W  R11,[R9,#-0xE4]  /* <data_to_load>:R11=0x8642 */
    /* We need to check address was not changed */
    SUB     R9,R9,#0xE4 
    CMP     R9,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    LDR     R12,[R9]
    LDR     R8,=0xFFFF0000
    EOR     R12,R12,R8
    CMP     R11,R12
    BNE     m4_scst_loadstore_test5_failed
    
    /**********************************************************************************************
    * Instructions: 
    *   - LDRHT     Encoding T1 (32-bit)
    *
    * Note: Format of this instruction is identical to T2 encoding of the LDRH (immediate) one.
    *       Testing only of "halfword" operation is performed.
    **********************************************************************************************/
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R11,R0
    /* <Rn[3:0]>:R11
       <Rt[15:12]>:R9(STR) R10(LDRHT)
       <imm8[7:0]>:0xF1 */
    STR.W   R9,[R11]    /* <data_to_store>:R9=0x13579BDF */
    DSB
    SUB     R11,R11,#0xF1       /* Decrement address 0xF1 */
    LDRHT.W R10,[R11,#0xF1]     /* <data_to_load>:R10=0x9BDF */
    /* We need to check address was not changed */
    ADD     R11,R11,#0xF1
    CMP     R11,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    LDR     R9,[R11]
    BFC     R9,#16,#16
    CMP     R10,R9
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R11,R0
    /* <Rn[3:0]>:R11
       <Rt[15:12]>:R10(STR) R9(LDRHT)
       <imm8[7:0]>:0xC4 */
    STR.W  R10,[R11]    /* <data_to_store>:R10=0xFDB97531  */
    DSB
    SUB     R11,R11,#0xC4       /* Decrement address 0xC4 */ 
    LDRHT.W R9,[R11,#0xC4]      /* <data_to_load>:R11=0x7531 */
    /* We need to check address was not changed */
    ADD     R11,R11,#0xC4 
    CMP     R11,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    LDR     R10,[R11]
    BFC     R10,#16,#16
    CMP     R9,R10
    BNE     m4_scst_loadstore_test5_failed
    
    
    /**********************************************************************************************
    * Instructions: 
    *   - LDRSH (immediate) Encoding T2 (32-bit)
    *
    * Note: Format of this instruction is identical to T4 encoding of the LDR (immediate) one.
    *       Testing only of "signed-halfword" operation is performed.
    **********************************************************************************************/
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R2,R0
    /* <Rn[3:0]>:R2
       <Rt[15:12]>:R9(STR) R10(LDRSH)
       <imm8[7:0]>:0x11 */
    STR.W   R9,[R2],#0x11   /* <data_to_store>:R9=0x13579BDF */
    DSB
    /* We need check address was incremented */
    SUB     R2,R2,#0x11
    CMP     R2,R0
    BNE     m4_scst_loadstore_test5_failed
    LDRSH.W R10,[R2],#0x11   /* <data_to_load>:R10=0xFFFF9BDF */
    /* We need check address was incremented */
    SUB     R2,R2,#0x11
    CMP     R2,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    SBFX    R8,R9,#0,#16
    CMP     R10,R8
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R2,R0
    /* <Rn[3:0]>:R2
       <Rt[15:12]:R10(STR) R9(LDRSH)
       <imm8[7:0]>:0x34 */
    SUB     R2,R0,#0x34     /* Decrement address 0x34 */
    STR.W   R10,[R2,#0x34]!  /* <data_to_store>:R10=0xFDB97531 */
    DSB
    /* We need to check address was incremented */
    CMP     R2,R0
    BNE     m4_scst_loadstore_test5_failed
    SUB     R2,R0,#0x34     /* Decrement address 0x34 */
    LDRSH.W R9,[R2,#0x34]!  /* <data_to_load>:R9=0x00007531 */
    /* We need to check address was incremented */
    CMP     R2,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    SBFX    R8,R10,#0,#16
    CMP     R9,R8
    BNE     m4_scst_loadstore_test5_failed
    
    /**********************************************************************************************
    * Instructions: 
    *   - LDRSHT    Encoding T1 (32-bit)
    *
    * Note: Format of this instruction is identical to T2 encoding of the LDRSH (immediate) one.
    *       Testing only of "signed-halfword" operation is performed.
    **********************************************************************************************/
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R6,R0
    /* <Rn[3:0]>:R6
       <Rt[15:12]:R10(STR) R9(LDRSHT)
       <imm8[7:0]>:0x4E */
    STR.W   R12,[R6]  /* <data_to_store>:R10=0xFDB97531 */
    DSB
    SUB     R6,R6,#0x4E     /* Decrement address 0x34 */
    LDRSHT.W R11,[R6,#0x4E]  /* <data_to_load>:R9=0x00007531 */
    /* We need to check address was not changed */
    ADD     R6,R6,#0x4E
    CMP     R6,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    SBFX    R8,R12,#0,#16
    CMP     R11,R8
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R6,R0
    /* <Rn[3:0]>:R6
       <Rt[15:12]>:R10(STR) R9(LDRSHT)
       <imm8[7:0]>:0x33 */
    STR.W   R10,[R6]   /* <data_to_store>:R9=0x13579BDF */
    DSB
    /* We need check address was incremented */
    SUB     R6,R6,#0x33
    LDRSHT.W R9,[R6,#0x33]   /* <data_to_load>:R10=0xFFFF9BDF */
    /* We need check address was not changed*/
    ADD     R6,R6,#0x33
    CMP     R6,R0
    BNE     m4_scst_loadstore_test5_failed
    /* We need to check data */
    SBFX    R8,R10,#0,#16
    CMP     R9,R8
    BNE     m4_scst_loadstore_test5_failed
    
    
    /**********************************************************************************************
    * Instructions: 
    *   - STR (register)    Encoding T2 (32-bit)
    *   - LDR (register)    Encoding T2 (32-bit)
    **********************************************************************************************/
    SUB    R0,R0,#20
    BL     m4_scst_loadstore_test5_clear_target_memory
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R3,R0       /* Load address to R3 */
    MOV     R4,#0x0     /* Add offset to R4 */ 
    /* <Rn[3:0]>:R3
       <Rt[15:12]>:R1(STR) R2(LDR)
       <imm2[5:4]>:#0
       <Rm[3:0]>:R4 */
    STR.W   R1,[R3,R4,LSL #0]       /* <data_to_store>:R1=0x55555555 */
    DSB
    LDR.W   R2,[R3,R4,LSL #0]       /* <data_to_load>:R2=0x55555555 */
    /* We need to check data */
    CMP     R1,R2
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R4,#0x0     /* Load address to R4 */ 
    MOV     R3,R0       /* Add offset to R3 */
    /* <Rn[3:0]>:R4
       <Rt[15:12]>:R2(STR) R1(LDR)
       <imm2[5:4]>:#0
       <Rm[3:0]>:R3 */
    STR.W   R2,[R4,R3,LSL #0]       /* <data_to_store>:R2=0xAAAAAAAA */
    DSB
    LDR.W   R1,[R4,R3,LSL #0]       /* <data_to_load>:R1=0xAAAAAAAA */
    /* We need to check data */
    CMP     R2,R1
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init 
    MOV     R1,R0       /* Load address to R1 */
    MOV     R2,#0x2     /* Add offset to R2 */
    /* <Rn[3:0]>:R1
       <Rt[15:12]>:R3(STR) R4(LDR)
       <imm2[5:4]>:#1
       <Rm[3:0]>:R2 */
    STR.W   R3,[R1,R2,LSL #1]       /* <data_to_store>:R3=0xCCCCCCCC */
    DSB
    LDR.W   R4,[R1,R2,LSL #1]       /* <data_to_load>:R4=0xCCCCCCCC */
    /* We need to check data */
    CMP     R3,R4
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R2,#0x4     /* Load address to R2 */
    MOV     R1,R0       /* Add offset to R1 */
    /* <Rn[3:0]>:R2
       <Rt[15:12]>:R4(STR) R3(LDR)
       <imm2[5:4]>:#0
       <Rm[3:0]>:R1 */
    STR.W   R4,[R2,R1,LSL #0]       /* <data_to_store>:R4=0x33333333 */
    DSB
    LDR.W   R3,[R2,R1,LSL #0]       /* <data_to_load>:R3=0x33333333 */
    /* We need to check data */
    CMP     R4,R3
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R8,R0       /* Load address to R7 */
    MOV     R7,#0x1     /* Add offset to R6 */
    /* <Rn[3:0]>:R8
       <Rt[15:12]>:R5(STR) R6(LDR)
       <imm2[5:4]>:#3
       <Rm[3:0]>:R7 */
    STR.W   R5,[R8,R7,LSL #3]       /* <data_to_store>:R5=0x99999999 */
    DSB
    LDR.W   R6,[R8,R7,LSL #3]       /* <data_to_load>:R6=0x99999999 */
    /* We need to check data */
    CMP     R5,R6
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R7,#0x8      /* Load address to R7 */
    MOV     R8,R0       /* Add offset to R8 */
    /* <Rn[3:0]>:R7
       <Rt[15:12]>:R6(STR) R5(LDR)
       <imm2[5:4]>:#0
       <Rm[3:0]>:R8 */
    STR.W   R6,[R7,R8,LSL #0]      /* <data_to_store>:R6=0x66666666 */
    DSB
    LDR.W   R5,[R7,R8,LSL #0]      /* <data_to_load>:R5=0x66666666 */
    /* We need to check data */
    CMP     R6,R5
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    
    MOV     R9,R0       /* Load address to R9 */
    MOV     R10,#0x3    /* Add offset to R10 */
    /* <Rn[3:0]>:R9
       <Rt[15:12]>:R7(STR) R8(LDR)
       <imm2[5:4]>:#2
       <Rm[3:0]>:R10 */
    STR.W   R7,[R9,R10,LSL #2]       /* <data_to_store>:R7=0x77777777 */
    DSB
    LDR.W   R8,[R9,R10,LSL #2]       /* <data_to_load>:R8=0x77777777 */
    /* We need to check data */
    CMP     R7,R8
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    
    MOV     R10,#0xC    /* Load address to R10 */
    MOV     R9,R0       /* Add offset to R9 */       
    /* <Rn[3:0]>:R10
       <Rt[15:12]>:R8(STR) R7(LDR)
       <imm2[5:4]>:#0
       <Rm[3:0]>:R9 */
    STR.W   R8,[R10,R9,LSL #0]       /* <data_to_store>:R8=0xEEEEEEEE */
    DSB
    LDR.W   R7,[R10,R9,LSL #0]       /* <data_to_load>:R7=0xEEEEEEEE */
    /* We need to check data */
    CMP     R8,R7
    BNE     m4_scst_loadstore_test5_failed
    
    /**********************************************************************************************
    * Instructions: 
    *   - STRB (register)   Encoding T2 (32-bit)
    *   - LDRB (register)   Encoding T2 (32-bit)
    *
    * Note: Formats of these instructions are identical to T2 encoding of the STR (register)
    *       and LDR (register) ones.
    *       Testing only of "byte" operations are performed.
    **********************************************************************************************/
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R11,R0      /* Load address to R11 */
    MOV     R12,#0x4    /* Add offset to R12 */ 
    /* <Rn[3:0]>:R11
       <Rt[15:12]>:R9(STRB) R10(LDRB)
       <imm2[5:4]>:#4
       <Rm[3:0]>:R12 */
    STRB.W  R9,[R11,R12,LSL #2]     /* <data_to_store>:R9=0x13579BDF (0xDF)*/
    DSB
    LDRB.W  R10,[R11,R12,LSL #2]    /* <data_to_load>:R10=0xDF */
    /* We need to check data */
    LDR     R9,[R11,R12,LSL #2]
    LDR     R8,=0xFFFFFF00
    EOR     R9,R9,R8
    CMP     R10,R9
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R12,#0x10   /* Load address to R12 */ 
    MOV     R11,R0      /* Add offset to R11 */
    /* <Rn[3:0]>:R12
       <Rt[15:12]>:R10(STRB) R9(LDRB)
       <imm2[5:4]>:#0
       <Rm[3:0]>:R11 */
    STRB.W  R10,[R12,R11,LSL #0]      /* <data_to_store>:R10=0xFDB97531 (0x31) */
    DSB
    LDRB.W  R9,[R12,R11,LSL #0]       /* <data_to_load>:R9=0x31 */
    /* We need to check data */
    LDR     R10,[R12,R11,LSL #0]
    LDR     R8,=0xFFFFFF00
    EOR     R10,R10,R8
    CMP     R9,R10
    BNE     m4_scst_loadstore_test5_failed

    
    /**********************************************************************************************
    * Instructions: 
    *   - LDRSB (register)  Encoding T2 (32-bit)
    *
    * Note: Format of this instruction is identical to T2 encoding of the LDR (register) one.
    *       Testing only of "signed-byte" operation is performed.
    **********************************************************************************************/
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R1,R0       /* Load address to R1 */
    MOV     R2,#0x2     /* Add offset to R2 */
    /* <Rn[3:0]>:R1
       <Rt[15:12]>:R11(STR) R12(LDRSB)
       <imm2[5:4]>:#3
       <Rm[3:0]>:R2 */
    STR.W   R11,[R1,R2,LSL #3]       /* <data_to_store>:R11=0x2468ACE0 */
    DSB
    LDRSB.W R12,[R1,R2,LSL #3]       /* <data_to_load>:R12=0xFFFFFFE0 */
    /* We need to check data */
    SBFX    R10,R11,#0,#8
    CMP     R12,R10
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init  
    MOV     R2,#0x10    /* Load address to R2 */
    MOV     R1,R0       /* Add offset to R1 */
    /* <Rn[3:0]>:R2
       <Rt[15:12]>:R12(STR) R11(LDRSB)
       <imm2[5:4]>:#0
       <Rm[3:0]>:R1 */
    STR.W   R12,[R2,R1,LSL #0]       /* <data_to_store>:R12=0x0ECA8642*/
    DSB
    LDRSB.W R11,[R2,R1,LSL #0]       /* <data_to_load>:R11=0x00000042 */
    /* We need to check data */
    SBFX    R10,R12,#0,#8
    CMP     R11,R10
    BNE     m4_scst_loadstore_test5_failed
        
    /**********************************************************************************************
    * Instructions: 
    *   - STRH (register)   Encoding T2 (32-bit)
    *   - LDRH (register)   Encoding T2 (32-bit)
    *
    * Note: Formats of these instructions are identical to T2 encoding of the STR (register)
    *       and LDR (register) ones.
    *       Testing only of "halfword" operations are performed.
    **********************************************************************************************/
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R2,R0       /* Load address to R2 */
    MOV     R3,#0x5     /* Add offset to R3 */ 
    /* <Rn[3:0]>:R2
       <Rt[15:12]>:R11(STRH) R12(LDRH)
       <imm2[5:4]>:#0
       <Rm[3:0]>:R3 */
    STRH.W  R11,[R2,R3,LSL #2]       /* <data_to_store>:R11=0x2468ACE0 (0xACE0) */
    DSB
    LDRH.W  R12,[R2,R3,LSL #2]       /* <data_to_load>:R12=0xACE0 */
    /* We need to check data */
    LDR     R11,[R2,R3,LSL #2]
    LDR     R8,=0xFFFF0000
    EOR     R11,R11,R8
    CMP     R12,R11
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R3,#0x14     /* Load address to R3 */ 
    MOV     R2,R0       /* Add offset to R2 */
    /* <Rn[3:0]>:R3
       <Rt[15:12]>:R12(STRH) R11(LDRH)
       <imm2[5:4]>:#0
       <Rm[3:0]>:R2 */
    STRH.W  R12,[R3,R2,LSL #0]       /* <data_to_store>:R12=0x0ECA8642 (0x8642) */
    DSB
    LDRH.W  R11,[R3,R2,LSL #0]       /* <data_to_load>:R1=0x8642 */
    /* We need to check data */
    LDR     R12,[R3,R2,LSL #0]
    LDR     R8,=0xFFFF0000
    EOR     R12,R12,R8
    CMP     R11,R12
    BNE     m4_scst_loadstore_test5_failed
    
    
    /**********************************************************************************************
    * Instructions: 
    *   - LDRSH (register)  Encoding T2 (32-bit)
    *
    * Note: Format of this instruction is identical to T2 encoding of the LDR (register) one.
    *       Testing only of "signed-halfword" operation is performed.
    **********************************************************************************************/
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R1,#0xA     /* Add offset to R1 */
    /* <Rn[3:0]>:R0
       <Rt[15:12]>:R9(STR) R10(LDRSH)
       <imm2[5:4]>:#1
       <Rm[3:0]>:R2 */
    STR.W   R9,[R0,R1,LSL #1]       /* <data_to_store>:R9=0x13579BDF*/
    DSB
    LDRSH.W R10,[R0,R1,LSL #1]      /* <data_to_load>:R10=0xFFFF9BDF */
    /* We need to check data */
    SBFX    R8,R9,#0,#16
    CMP     R10,R8
    BNE     m4_scst_loadstore_test5_failed
    
    /* --- Prepare data to be stored and loaded --- */
    BL      m4_scst_loadstore_test5_init
    MOV     R1,#0x14    /* Load address to R1 */
    /* <Rn[3:0]>:R1
       <Rt[15:12]>:R10(STR) R9(LDRSH)
       <imm2[5:4]>:#0
       <Rm[3:0]>:R0 */
    STR.W   R10,[R1,R0,LSL #0]       /* <data_to_store>:R10=0xFDB97531 */
    DSB
    LDRSH.W R9,[R1,R0,LSL #0]       /* <data_to_load>:R9=0x00007531 */
    /* We need to check data */
    SBFX    R8,R10,#0,#16
    CMP     R9,R8
    BNE     m4_scst_loadstore_test5_failed
    
    POP.W   {R1,R14}    /* We need to restore R1 and R14. */
    BX  LR

    
m4_scst_loadstore_test5_init:

    /**********************************************************************************************
    * Instruction: 
    * - LDR (literal)   Encoding T2 (32-bit)
    *
    * Note: Tested indirectly 
    **********************************************************************************************/
    LDR.W   R1,=VAL1
    LDR.W   R2,=VAL2
    LDR.W   R3,=VAL3
    LDR.W   R4,=VAL4
    LDR.W   R5,=VAL5
    LDR.W   R6,=VAL6
    LDR.W   R7,=VAL7
    LDR.W   R8,=VAL8
    LDR.W   R9,=VAL9
    LDR.W   R10,=VAL10
    LDR.W   R11,=VAL11
    LDR.W   R12,=VAL12

    BX      LR
    
m4_scst_loadstore_test5_clear_target_memory:
    
    EORS    R1,R1   /* Clear R1 */
    MVN     R1,R1
    
    /* Clear memory */
    STR     R1,[R0]
    STR     R1,[R0,#4]
    STR     R1,[R0,#8]
    STR     R1,[R0,#12]
    STR     R1,[R0,#16]
    STR     R1,[R0,#20]
    
    BX      LR
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */
    
    SCST_FILE_END
    