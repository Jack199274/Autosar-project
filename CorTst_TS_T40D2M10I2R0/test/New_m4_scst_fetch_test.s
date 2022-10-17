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
* This test focuses on fetch unit. Here we test that code which is modified during runtime
* is correctly fetched and then executed.
*
* Overall coverage:
* -----------------
* Covers DSB, ISB instructions where DSB instruction ensures that new code is
* stored and ISB instruction ensures that this new code is fetched.
* 测试总结：
* -------------
* 此测试侧重于获取单元。 在这里，我们测试在运行时修改的代码
* 正确获取然后执行。
*
* 整体覆盖：
* -----------------
* 涵盖 DSB、ISB 指令，其中 DSB 指令可确保新代码
* 存储和 ISB 指令确保获取此新代码。
******************************************************************************/

#include "m4_scst_compiler.h"

    /* Symbols defined in the current module but to be visible to outside */
    SCST_EXPORT m4_scst_fetch_test
    
    /* Symbols defined outside but used within current module */
    SCST_EXTERN SCST_RAM_FETCH_TEST_CODE
    SCST_EXTERN m4_scst_test_tail_end

    /* Local defines */    
SCST_DEFINE(PRESIGNATURE,0xB14D3642) /*this macro has to be at the beginning of the line*/


    SCST_SECTION_EXEC(m4_scst_test_code)
    SCST_THUMB2 

    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_fetch_test" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. */
    SCST_TYPE(m4_scst_fetch_test, function)
m4_scst_fetch_test:

    PUSH.W  {R1-R12,R14}
    
    LDR     R8,=PRESIGNATURE
    /* We will disable interrupts store original content of PRIMASK to R11. */
    MRS     R11,PRIMASK     /* Do not use R11 register until PRIMASK is restored !! */
    
    MOVW    R0,#0x444
    
    /* Load the SRAM memory address where the test code will be stored.
       This is start address of the "m4_scst_ram_test_code" section. */
    LDR     R1,=SCST_RAM_FETCH_TEST_CODE
    
    /* Load R9 with address of the m4_scst_branch_test_end */
    LDR     R9,=m4_scst_branch_test_end
    ORR     R9,R9,#1    /* bit0 must be set for BX instruction */
    /* Load R10 with address of the m4_scst_fetch_test_testlabel 
       We will reach m4_scst_fetch_test_testlabel in case of code in SRAM
       is  successfully modified */
    LDR     R10,=m4_scst_fetch_test_testlabel
    ORR     R10,R10,#1
    
    /*  We prepare the following code which is stored to SRAM. This code will be partially modified 
        during the runtime by the STR.W R7,[R1,#16] instruction.
        
        Test code in SRAM before modification by the STR.W R7,[R1,#16] instruction:
        offset  instruction
        --------------------
        #0      ADDW    R8,R8,#0x1ED    
        #4      STR.W   R7,[R1,#16] -> This instruction modifies code in SRAM
        #8      DSB
        #12     ISB
        #16     BX      R9  -> branch to m4_scst_branch_test_end
        #18     BX      R9  -> branch to m4_scst_branch_test_end
    */
    
    LDR     R2,=0x18EDF208     /* Load to R2 opcode for "ADDW R8,R8,#0x1ED" */
    LDR     R3,=0x7010F8C1     /* Load to R3 opcode for "STR.W R7,[R1,#16]" - This instruction overwrites original SRAM code */
    LDR     R4,=0x8F4FF3BF     /* Load to R4 opcode for "DSB */
    LDR     R5,=0x8F6FF3BF     /* Load to R5 opcode for "ISB" */
    LDR     R6,=0x47484748     /* Load to R9 opcodes for "BX R9" and "BX R9" */
    
    /* Store self-modifiable code to SRAM into the "m4_scst_ram_test_code" section */
    STM.W   R1,{R2,R3,R4,R5,R6}
    DSB
    /* Verify code in SRAM memory */
    LDR     R7,[R1,#16]
    CMP     R6,R7
    BNE     m4_scst_branch_test_end

    /*  Prepare code which will modify original code in SRAM
    
        Test code in SRAM after successful modification by the STR.W R7,[R1,#16] instruction:
        offset  instruction 
        --------------------
        #0      ADDW    R8,R8,#0x1ED    
        #4      STR.W   R7,[R1,#16] -> This instruction modifies code in SRAM
        #8      DSB
        #12     ISB
        #16     BX      R10 -> branch to m4_scst_fetch_test_testlabel
        #18     BX      R9  -> branch to m4_scst_branch_test_end
    */
    
    LDR     R7,=0x47484750      /* Load to R7 opcodes for "BX R10" and "BX R9" */
    
    /* Disable all interrupts to ensure that test code running from SRAM is not interrupted 
       to avoid scenario that pipeline is flushed by external interrupt and fetched again when
       returns from interrupt. */
    CPSID   i
    
    /* Set PC register to start test code execution from RAM memory 
       from the "m4_scst_ram_test_code" section !! */
    MOV     PC,R1
    
    
m4_scst_branch_test_end:
    MSR     PRIMASK,R11 /* Restore PRIMASK from R11 */
    MOV     R0,R8       /* Test result is returned in R0 */
    B       m4_scst_test_tail_end
    
    /* This label is reached only in case of the test code in SRAM was successfully modified. */
m4_scst_fetch_test_testlabel:
    ADDW    R8,R8,#0x1DE
    B       m4_scst_branch_test_end


    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. */    

    SCST_FILE_END
 