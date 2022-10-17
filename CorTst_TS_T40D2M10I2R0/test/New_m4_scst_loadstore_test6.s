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
*   - exclusive operation
*   - CLREX
*
* Overall coverage:
* -----------------
* Covers LDREX, STREX, LDREXB, STREXB, LDREXH, STREXH, CLREX instructions 
* as well as  logic processing its '<Rn>','<Rt>','<Rd>(STREX)' and '#<imm8>' 
* as well as  <data_to_store> and <data_to_load>.
*
* DECODER:
* Thumb (32-bit)
*   - Encoding of "Load/store dual or exclusive, table branch" instructions - Load/store exclusive 
* 测试总结：
* -------------
*
* 涵盖 LSU 操作类型：
* - 独占操作
* - 克莱克斯
*
* 整体覆盖：
* -----------------
* 涵盖 LDREX、STREX、LDREXB、STREXB、LDREXH、STREXH、CLREX 指令
* 以及对其 '<Rn>'、'<Rt>'、'<Rd>(STREX)' 和 '#<imm8>' 的逻辑处理
* 以及 <data_to_store> 和 <data_to_load>。
*
* 解码器：
* 拇指（32 位）
* - “加载/存储双重或独占，表分支”指令的编码 - 加载/存储独占

******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_loadstore_test6

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

SCST_SET(PRESIGNATURE,0xD2C79E31) /* this macro has to be at the beginning of the line */
    

    SCST_SECTION_EXEC(m4_scst_test_code)
    SCST_THUMB2    
  

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_loadstore_test6" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_loadstore_test6, function)
m4_scst_loadstore_test6:

    PUSH.W  {R1-R12,R14}

    /*************************************************************************************************
    * Instructions: 
    *   - LDR (literal) Encoding T2 (32-bit)
    *
    * Note: Tested indirectly.    
    *************************************************************************************************/
    LDR.W   R0,=SCST_RAM_TARGET0
    BL      m4_scst_loadstore_test6_common
    LDR.W   R0,=SCST_RAM_TARGET1
    BL      m4_scst_loadstore_test6_common
    
    /* Test passed -> store result */
    LDR.W     R0,=VAL9
    EORS    R0,R1
    
m4_scst_loadstore_test6_end:
    B      m4_scst_test_tail_end
    

m4_scst_loadstore_test6_failed:
    POP.W   {R1,R2,R14}    /* We just need to pop three words from stack */
    MSR     PRIMASK,R2     /* We need to restore the PRIMASK register */
    MOVW    R0,#0x444
    B       m4_scst_loadstore_test6_end

    
m4_scst_loadstore_test6_common:

    /* Load pre-signature */ 
    LDR.W     R1,=PRESIGNATURE
    
    MRS     R2,PRIMASK      /* Load R2 with PRIMASK */
    
    PUSH    {R1,R2,R14}     /* We need to store R1,R2 and R14. */
   
    /*************************************************************************************************
    * Instructions: 
    *   - STREX     Encoding T1 (32-bit)
    *   - LDREX     Encoding T1 (32-bit)
    ***************************************************************************************************/
    BL      m4_scst_loadstore_test6_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    SUB     R10,R0,#0x154
    /* <Rn[3:0]>:R10
       <Rt[15:12]>:R1(STREX) R2(LDREX)
       <Rd[11:8]>:R3(STREX)
       <imm8[7:0]>:0x55     0x55*(4-bytes)=0x154 */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREX   R3,[R10,#0x154]     /* -> Exclusive Access */
    STREX   R3,R1,[R10,#0x154]  /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R3,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREX   R2,[R10,#0x154]     /* -> Exclusive Access */
    CLREX                       /* Open Access <- */
    STREX   R4,R3,[R10,#0x154]
    CMP     R4,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R2,[R10,#0x154]     /* Load R2 again to verify it was not overwritten */
    CMP     R2,R1
    BNE     m4_scst_loadstore_test6_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    SUB     R10,R0,#0x2A8
    /* <Rn[3:0]>:R10
       <Rt[15:12]>:R2(STREX) R1(LDREX)
       <Rd[11:8]>:R4(STREX)
       <imm8[7:0]>:0xAA     0xAA*(4-bytes)=0x2A8 */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREX   R4,[R10,#0x2A8]     /* -> Exclusive Access */
    STREX   R4,R2,[R10,#0x2A8]  /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R4,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREX   R1,[R10,#0x2A8]     /* -> Exclusive Access */
    CLREX                       /* Open Access <- */
    STREX   R3,R4,[R10,#0x2A8]
    CMP     R3,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R1,[R10,#0x2A8]     /* Load R1 again to verify it was not overwritten */
    CMP     R1,R2
    BNE     m4_scst_loadstore_test6_failed
    
    ADD     R0,R0,#4
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    SUB     R5,R0,#0xCC
    /* <Rn[3:0]>:R5
       <Rt[15:12]>:R3(STREX) R4(LDREX)
       <Rd[11:8]>:R1(STREX)
       <imm8[7:0]>:0x33     0x33*(4-bytes)=0xCC */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREX   R1,[R5,#0xCC]       /* -> Exclusive Access */
    STREX   R1,R3,[R5,#0xCC]    /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R1,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREX   R4,[R5,#0xCC]       /* -> Exclusive Access */
    CLREX                       /* Open Access <- */
    STREX   R2,R1,[R5,#0xCC]
    CMP     R2,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R4,[R5,#0xCC]     /* Load R4 again to verify it was not overwritten */
    CMP     R4,R3
    BNE     m4_scst_loadstore_test6_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    SUB     R5,R0,#0x330
    /* <Rn[3:0]>:R5
       <Rt[15:12]>:R4(STREX) R3(LDREX)
       <Rd[11:8]>:R2(STREX)
       <imm8[7:0]>:0xCC     0xCC*(4-bytes)=0x330 */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREX   R2,[R5,#0x330]     /* -> Exclusive Access */
    STREX   R2,R4,[R5,#0x330]  /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R2,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREX   R3,[R5,#0x330]     /* -> Exclusive Access */
    CLREX                      /* Open Access <- */
    STREX   R1,R2,[R5,#0x330]
    CMP     R1,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R3,[R5,#0x330]     /* Load R3 again to verify it was not overwritten */
    CMP     R3,R4
    BNE     m4_scst_loadstore_test6_failed
    
    ADD     R0,R0,#4
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    SUB     R9,R0,#0x3C
    /* <Rn[3:0]>:R9
       <Rt[15:12]>:R5(STREX) R6(LDREX)
       <Rd[11:8]>:R7(STREX)
       <imm8[7:0]>:0x0F     0x0F*(4-bytes)=0x3C */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREX   R7,[R9,#0x3C]       /* -> Exclusive Access */
    STREX   R7,R5,[R9,#0x3C]    /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R7,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREX   R6,[R9,#0x3C]       /* -> Exclusive Access */
    CLREX                       /* Open Access <- */
    STREX   R8,R7,[R9,#0x3C]
    CMP     R8,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R6,[R9,#0x3C]     /* Load R6 again to verify it was not overwritten */
    CMP     R6,R5
    BNE     m4_scst_loadstore_test6_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    SUB     R9,R0,#0x3C0
    /* <Rn[3:0]>:R9
       <Rt[15:12]>:R6(STREX) R5(LDREX)
       <Rd[11:8]>:R8(STREX)
       <imm8[7:0]>:0xF0     0xF0*(4-bytes)=0x3C0 */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREX   R8,[R9,#0x3C0]     /* -> Exclusive Access */
    STREX   R8,R6,[R9,#0x3C0]  /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R8,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREX   R5,[R9,#0x3C0]     /* -> Exclusive Access */
    CLREX                      /* Open Access <- */
    STREX   R7,R8,[R9,#0x3C0]
    CMP     R7,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R5,[R9,#0x3C0]     /* Load R5 again to verify it was not overwritten */
    CMP     R5,R6
    BNE     m4_scst_loadstore_test6_failed
    
    ADD     R0,R0,#4
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    SUB     R3,R0,#0x00
    /* <Rn[3:0]>:R3
       <Rt[15:12]>:R7(STREX) R8(LDREX)
       <Rd[11:8]>:R11(STREX)
       <imm8[7:0]>:0x00     0x00*(4-bytes)=0x00 */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREX   R11,[R3,#0x00]       /* -> Exclusive Access */
    STREX   R11,R7,[R3,#0x00]    /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R11,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREX   R8,[R3,#0x00]       /* -> Exclusive Access */
    CLREX                       /* Open Access <- */
    STREX   R12,R11,[R3,#0x00]
    CMP     R12,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R8,[R3,#0x00]     /* Load R8 again to verify it was not overwritten */
    CMP     R8,R7
    BNE     m4_scst_loadstore_test6_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    SUB     R3,R0,#0x3FC
    /* <Rn[3:0]>:R3
       <Rt[15:12]>:R8(STREX) R7(LDREX)
       <Rd[11:8]>:R12(STREX)
       <imm8[7:0]>:0xFF     0xFF*(4-bytes)=0x3FC */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREX   R12,[R3,#0x3FC]     /* -> Exclusive Access */
    STREX   R12,R8,[R3,#0x3FC]  /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R12,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREX   R7,[R3,#0x3FC]     /* -> Exclusive Access */
    CLREX                      /* Open Access <- */
    STREX   R11,R12,[R3,#0x3FC]
    CMP     R11,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R7,[R3,#0x3FC]     /* Load R7 again to verify it was not overwritten */
    CMP     R7,R8
    BNE     m4_scst_loadstore_test6_failed
    
    ADD     R0,R0,#4
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    SUB     R12,R0,#0x44
    /* <Rn[3:0]>:R12
       <Rt[15:12]>:R9(STREX) R10(LDREX)
       <Rd[11:8]>:R5(STREX)
       <imm8[7:0]>:0x11     0x11*(4-bytes)=0x44 */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREX   R5,[R12,#0x44]       /* -> Exclusive Access */
    STREX   R5,R9,[R12,#0x44]    /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R5,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREX   R10,[R12,#0x44]       /* -> Exclusive Access */
    CLREX                       /* Open Access <- */
    STREX   R6,R5,[R12,#0x44]
    CMP     R6,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R10,[R12,#0x44]     /* Load R10 again to verify it was not overwritten */
    CMP     R10,R9
    BNE     m4_scst_loadstore_test6_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    SUB     R12,R0,#0x3B8
    /* <Rn[3:0]>:R12
       <Rt[15:12]>:R10(STREX) R9(LDREX)
       <Rd[11:8]>:R6(STREX)
       <imm8[7:0]>:0xEE     0xEE*(4-bytes)=0x3B8 */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREX   R6,[R12,#0x3B8]     /* -> Exclusive Access */
    STREX   R6,R10,[R12,#0x3B8]  /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R6,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREX   R9,[R12,#0x3B8]     /* -> Exclusive Access */
    CLREX                      /* Open Access <- */
    STREX   R5,R6,[R12,#0x3B8]
    CMP     R5,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R9,[R12,#0x3B8]     /* Load R9 again to verify it was not overwritten */
    CMP     R9,R10
    BNE     m4_scst_loadstore_test6_failed
    
    ADD     R0,R0,#4
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    SUB     R7,R0,#0x88
    /* <Rn[3:0]>:R7
       <Rt[15:12]>:R11(STREX) R12(LDREX)
       <Rd[11:8]>:R9(STREX)
       <imm8[7:0]>:0x22     0x22*(4-bytes)=0x44 */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREX   R9,[R7,#0x88]       /* -> Exclusive Access */
    STREX   R9,R11,[R7,#0x88]    /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R9,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREX   R12,[R7,#0x88]       /* -> Exclusive Access */
    CLREX                        /* Open Access <- */
    STREX   R10,R9,[R7,#0x88]
    CMP     R10,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R12,[R7,#0x88]     /* Load R10 again to verify it was not overwritten */
    CMP     R12,R11
    BNE     m4_scst_loadstore_test6_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    SUB     R7,R0,#0x2EC
    /* <Rn[3:0]>:R7
       <Rt[15:12]>:R12(STREX) R11(LDREX)
       <Rd[11:8]>:R10(STREX)
       <imm8[7:0]>:0xBB     0xBB*(4-bytes)=0x3B8 */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREX   R10,[R7,#0x2EC]      /* -> Exclusive Access */
    STREX   R10,R12,[R7,#0x2EC]  /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R10,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREX   R11,[R7,#0x2EC]     /* -> Exclusive Access */
    CLREX                       /* Open Access <- */
    STREX   R9,R10,[R7,#0x2EC]
    CMP     R9,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R11,[R7,#0x2EC]     /* Load R9 again to verify it was not overwritten */
    CMP     R11,R12
    BNE     m4_scst_loadstore_test6_failed
    
    /*************************************************************************************************
    * Instructions: 
    *   - STREXB    Encoding T1 (32-bit)
    *   - LDREXB    Encoding T1 (32-bit)
    **************************************************************************************************/
    SUB     R0,R0,#20
    BL      m4_scst_loadstore_test6_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    MOV     R3,R0
    /* <Rn[3:0]>:R3
       <Rt[15:12]>:R9(STREX) R10(LDREX)
       <Rd[3:0]>:R5(STREX) */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREXB  R5,[R3]         /* -> Exclusive Access */
    STREXB  R5,R9,[R3]      /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R5,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREXB  R10,[R3]        /* -> Exclusive Access */
    CLREX                   /* Open Access <- */
    STREXB  R6,R5,[R3]
    CMP     R6,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R9,[R3]
    LDR     R8,=0xFFFFFF00
    EOR     R9,R9,R8
    CMP     R10,R9
    BNE     m4_scst_loadstore_test6_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    MOV     R12,R0
    /* <Rn[3:0]>:R12
       <Rt[15:12]>:R10(STREX) R9(LDREX)
       <Rd[3:0]>:R3(STREX) */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREXB  R3,[R12]        /* -> Exclusive Access */
    STREXB  R3,R10,[R12]    /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R3,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREXB  R9,[R12]        /* -> Exclusive Access */
    CLREX                   /* Open Access <- */
    STREXB  R4,R3,[R12]
    CMP     R4,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R10,[R12]     
    LDR     R8,=0xFFFFFF00
    EOR     R10,R10,R8
    CMP     R9,R10
    BNE     m4_scst_loadstore_test6_failed
    
    ADD     R0,R0,#4
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    MOV     R5,R0
    /* <Rn[3:0]>:R5
       <Rt[15:12]>:R11(STREX) R12(LDREX)
       <Rd[3:0]>:R10(STREX) */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREXB  R10,[R5]         /* -> Exclusive Access */
    STREXB  R10,R11,[R5]     /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R10,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREXB  R12,[R5]        /* -> Exclusive Access */
    CLREX                   /* Open Access <- */
    STREXB  R9,R10,[R5]
    CMP     R9,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R11,[R5]
    LDR     R8,=0xFFFFFF00
    EOR     R11,R11,R8
    CMP     R12,R11
    BNE     m4_scst_loadstore_test6_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    MOV     R10,R0
    /* <Rn[3:0]>:R10
       <Rt[15:12]>:R12(STREX) R11(LDREX)
       <Rd[3:8]>:R4(STREXB) */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREXB  R4,[R10]        /* -> Exclusive Access */
    STREXB  R4,R12,[R10]    /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R4,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREXB  R11,[R10]       /* -> Exclusive Access */
    CLREX                   /* Open Access <- */
    STREXB  R5,R4,[R10]
    CMP     R5,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R12,[R10]
    LDR     R8,=0xFFFFFF00
    EOR     R12,R12,R8
    CMP     R11,R12
    BNE     m4_scst_loadstore_test6_failed
    
    /*************************************************************************************************
    * Instructions: 
    *   - STREXH    Encoding T1 (32-bit)
    *   - LDREXH    Encoding T1 (32-bit)
    **************************************************************************************************/
    ADD     R0,R0,#4
    BL      m4_scst_loadstore_test6_clear_target_memory
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    MOV     R1,R0
    /* <Rn[3:0]>:R1
       <Rt[15:12]>:R9(STREX) R10(LDREX)
       <Rd[3:0]>:R2(STREX) */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREXH  R2,[R1]         /* -> Exclusive Access */
    STREXH  R2,R9,[R1]      /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R2,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREXH  R10,[R1]        /* -> Exclusive Access */
    CLREX                   /* Open Access <- */
    STREXH  R3,R2,[R1]
    CMP     R3,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R9,[R1]
    LDR     R8,=0xFFFF0000
    EOR     R9,R9,R8
    CMP     R10,R9
    BNE     m4_scst_loadstore_test6_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    MOV     R6,R0
    /* <Rn[3:0]>:R6
       <Rt[15:12]>:R10(STREX) R9(LDREX)
       <Rd[3:0]>:R11(STREX) */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREXH  R11,[R6]        /* -> Exclusive Access */
    STREXH  R11,R10,[R6]    /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R11,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREXH  R9,[R6]         /* -> Exclusive Access */
    CLREX                   /* Open Access <- */
    STREXH  R12,R11,[R6]
    CMP     R12,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R10,[R6]     
    LDR     R8,=0xFFFF0000
    EOR     R10,R10,R8
    CMP     R9,R10
    BNE     m4_scst_loadstore_test6_failed
    
    ADD     R0,R0,#4
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    /* <Rn[3:0]>:R0
       <Rt[15:12]>:R11(STREX) R12(LDREX)
       <Rd[3:0]>:R6(STREX) */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREXH  R6,[R0]         /* -> Exclusive Access */
    STREXH  R6,R11,[R0]     /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R6,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREXH  R12,[R0]        /* -> Exclusive Access */
    CLREX                   /* Open Access <- */
    STREXH  R7,R6,[R0]
    CMP     R7,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R11,[R0]
    LDR     R8,=0xFFFF0000
    EOR     R11,R11,R8
    CMP     R12,R11
    BNE     m4_scst_loadstore_test6_failed
    
    /* --- Prepare data to be stored and loaded ---  */
    BL      m4_scst_loadstore_test6_init
    MOV     R7,R0
    /* <Rn[3:0]>:R7
       <Rt[15:12]>:R12(STREX) R11(LDREX)
       <Rd[3:8]>:R9(STREXB) */
    CPSID   i   /* Disable interrupts to ensure that Exclusive Access is not cleared an external ISR */
    LDREXH  R9,[R7]         /* -> Exclusive Access */
    STREXH  R9,R12,[R7]     /* Open Access <- */
    DSB
    CPSIE   i   /* Enable interrupts */
    CMP     R9,#0
    BNE     m4_scst_loadstore_test6_failed
    LDREXH  R11,[R7]        /* -> Exclusive Access */
    CLREX                   /* Open Access <- */
    STREXH  R10,R9,[R7]
    CMP     R10,#1
    BNE     m4_scst_loadstore_test6_failed
    /* We need to check data */
    LDR.W   R12,[R7]
    LDR     R8,=0xFFFF0000
    EOR     R12,R12,R8
    CMP     R11,R12
    BNE     m4_scst_loadstore_test6_failed
    
    POP.W   {R1,R2,R14}     /* We need to restore R1,R2 and R14. */
    
    MSR     PRIMASK,R2      /* We need to restore the PRIMASK register */
    
    BX  LR

    
m4_scst_loadstore_test6_init:

    /*************************************************************************************************
    * Instruction: 
    * - LDR.W (literal) Encoding T2 (32-bit)
    *
    * Note: Tested indirectly 
    **************************************************************************************************/
    LDR.W     R1,=VAL1
    LDR.W     R2,=VAL2
    LDR.W     R3,=VAL3
    LDR.W     R4,=VAL4
    LDR.W     R5,=VAL5
    LDR.W     R6,=VAL6
    LDR.W     R7,=VAL7
    LDR.W     R8,=VAL8
    LDR.W     R9,=VAL9
    LDR.W     R10,=VAL10
    LDR.W     R11,=VAL11
    LDR.W     R12,=VAL12

    BX  LR
    
m4_scst_loadstore_test6_clear_target_memory:
    
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
