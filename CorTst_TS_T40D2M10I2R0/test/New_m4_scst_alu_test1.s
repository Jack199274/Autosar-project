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
* Test ALU module - ALU unit control bus
* 测试 ALU 模块 - ALU 单元控制总线
* Overall coverage:
* -----------------
* ALU control bus:
*   - use carry
*   - adder input 2 valid
*   - adder input 1 valid
*   - invert ALU input 2
*   - invert ALU input 1
*   - ALU operation type:
*       - no operation
*       - MOV(normal)	
* ALU 控制总线：
* - 使用携带
* - 加法器输入 2 有效
* - 加法器输入 1 有效
* - 反转 ALU 输入 2
* - 反转 ALU 输入 1
* - ALU 操作类型：
* - 无操作
* - MOV（正常）
*
* DECODER:
* Thumb (32-bit)
*   - Encoding of "Data processing (modified immediate)" instructions
*   - Encoding of "Data processing (shifted register)" instructions
* 解码器：
* 拇指（32 位）
* - “数据处理（修改立即数）”指令的编码
* - “数据处理（移位寄存器）”指令的编码
******************************************************************************/

#include "m4_scst_configuration.h"
#include "m4_scst_compiler.h"
    
    /* Symbols defined in the current module but to be visible to outside *
       在当前模块中定义但对外可见的符号/        
    SCST_EXPORT m4_scst_alu_test1
    
    /* Symbols defined outside but used within current module 在外部定义但在当前模块中使用的符号*/    
    SCST_EXTERN m4_scst_test_tail_end
    SCST_EXTERN m4_scst_clear_flags
    SCST_EXTERN m4_scst_check_flags_cleared
    
    
    SCST_SECTION_EXEC(m4_scst_test_code_unprivileged)        
    SCST_THUMB2
    
    /* The ".type" directive instructs the assembler/linker that the label "m4_scst_alu_test1" designates a function.
       In combination with the above specified ".thumb2" directive, this would cause setting
       the least significant bit to '1' within any pointer to this function,
       causing change to Thumb mode whenever this function is called. 
        “.type”指令指示汇编器/链接器标签“m4_scst_alu_test1”指定一个函数。
        结合上面指定的“.thumb2”指令，这将导致设置
        指向此函数的任何指针中为“1”的最低有效位，
        每当调用此函数时都会导致更改为 Thumb 模式。 */
    SCST_TYPE(m4_scst_alu_test1, function)
m4_scst_alu_test1:

    PUSH.W  {R1-R12,R14}
    
    /* R9 is used as intermediate result */
	/* R9用作中间结果*/
    MOV     R9,#0x0
    
    /***************************************************************************************************
    * ALU control bus:
    * - use adder input1
    * - use adder input2 (used together with input1)
    * - ALU operation type:
    *   - no operation
    *
    * Note: Linked with ADD, ADDW instructions
    *
    * ALU 控制总线：
     * - 使用加法器      input1
     * - 使用加法器 input2（与 input1 一起使用）
     * - ALU 操作类型：
     * - 无操作
     *
     * 注：与 ADD、ADDW 指令链接
    ***************************************************************************************************/
    /* ADD */
    MOV     R10,#0x0
    /* ADD(immediate) Encoding T3 32bit     
       ADD（立即）编码 T3 32bit*/
    ADDS.W  R5,R10,#0x55555555   /* Set flag bit to verify it is not stuck-at "1" in next call 
                                    设置标志位以验证它在下一次调用中没有卡在“1”*/
    CMP     R5,#0x55555555       /*比较.(两操作数作减法,仅修改标志位,不回送结果).*/
    BNE     m4_scst_test_tail_end /*BNE:条件跳转，即：是“不相等（或不为0）跳转指令”。 如果不为0就跳转到后面指定的地址，继续执行*/
    
    /* ADD(immediate) Encoding T3 32bit */
    MOV     R5,#0x0
    BL      m4_scst_clear_flags /* Clear flags BL:实现程序跳转，也就是调用子程序*/
    ADD.W   R10,R5,#0xAAAAAAAA   /* If flag bit set then N flag is updated !! */
    BL      m4_scst_check_flags_cleared /* Check flags were not updated !!! encoding of flag bit is not stuck-at "1" 
                                            检查标志未更新！！！ 标志位的编码不是固定在“1”*/
    CMP     R10,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
        
    LDR     R10,=0x55555555
    MOV     R5,#0x0
    /* ADD(register) Encoding T3 32bit */
    ADDS.W  R5,R10,R5   /* Set flag bit to verify it is not stuck-at "1" in next call 设置标志位以验证它在下一次调用中没有卡在“1” */
    CMP     R5,#0x55555555
    BNE     m4_scst_test_tail_end
        
    LDR     R5,=0xAAAAAAAA
    MOV     R10,#0x0
    /* ADD(register) Encoding T3 32bit */
    BL      m4_scst_clear_flags /* Clear flags */
    ADD.W   R10,R5,R10    /* If flag bit set then N flag is updated !! */
    BL      m4_scst_check_flags_cleared /* Check flags were not updated !!! encoding of flag bit is not stuck-at "1" */
    CMP     R10,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    MOV     R5,#0x0    
    LDR     R10,=0x55555555
    /* ADD(register) Encoding T3 32bit */
    ADD.W   R5,R5,R10
    CMP     R5,#0x55555555
    BNE     m4_scst_test_tail_end
    
    MOV     R10,#0x0    
    LDR     R5,=0xAAAAAAAA
    /* ADD(register) Encoding T3 32bit */
    ADD.W   R10,R10,R5
    CMP     R10,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /* ADDW */    
    LDR     R2,=0x55555000
    /* ADD(immediate) Encoding T4 32bit */
    ADDW    R3,R2,#0x555   /* Use imm12 value */
    CMP     R3,#0x55555555
    BNE     m4_scst_test_tail_end
        
    LDR     R2,=0xAAAAA000
    /* ADD(immediate) Encoding T4 32bit */
    ADDW    R3,R2,#0xAAA   /* Use immed12 value */
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0A46
    
    
    /***************************************************************************************************
    * ALU control bus:
    * - invert ALU input1
    * - use adder input1
    * - use adder input2
    * - ALU operation type:
    *   - no operation
    *
    *   
    *   Note: Linked with RSB instruction
    * ALU 控制总线：
     * - 反转 ALU 输入 1
     * - 使用加法器输入1
     * - 使用加法器 input2
     * - ALU 操作类型：
     * - 无操作
     *
     *
     *注：与RSB指令链接
    ***************************************************************************************************/    
    LDR     R12,=0x55555555
    /* RSB(immediate) Encoding T2 32bit */
    RSB.W   R3,R12,#0x0
    LDR     R6,=0xAAAAAAAB /* - 0x55555555 */
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xAAAAAAAB /* -0x55555555 */
    /* RSB(immediate) Encoding T2 32bit */
    RSB.W   R12,R3,#0x0
    LDR     R6,=0x55555555
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R3,=0xAAAAAAAA /* -0x55555556 */
    MOV     R12,#0
    /* RSB(register) Encoding T1 32bit */
    RSB.W   R3,R3,R12
    LDR     R6,=0x55555556
    CMP     R3,R6
    BNE     m4_scst_test_tail_end
    
    LDR     R12,=0x55555556
    MOV     R3,#0
    /* RSB(register) Encoding T1 32bit */
    RSB.W   R12,R12,R3
    LDR     R6,=0xAAAAAAAA /* -0x55555556 */
    CMP     R12,R6
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x08E7
    
    
    /***************************************************************************************************
    * ALU control bus:
    * - invert ALU input 2
    * - use adder input1
    * - use adder input2
    * - ALU operation type:
    *   - no operation
    *
    * Note: Linked with SUB, SUBW instructions
    * ALU 控制总线：
     * - 反转 ALU 输入 2
     * - 使用加法器输入1
     * - 使用加法器 input2
     * - ALU 操作类型：
     * - 无操作
     *
     *注：与SUB、SUBW指令联动
    *
    ***************************************************************************************************/
    /* SUB */
    MOV     R7,#0x0
    /* SUB(immediate) Encoding T3 32bit */
    SUB.W   R8,R7,#0xAAAAAAAB   /* Use immediate value 使用立即值         SUB:减法     */
    CMP     R8,#0x55555555
    BNE     m4_scst_test_tail_end
    
    MOV     R8,#0x0
    /* SUB(immediate) Encoding T3 32bit */
    SUB.W   R7,R8,#0x55555556   /* Use immediate value 使用立即值 */
    CMP     R7,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R8,=0x55555555
    LDR     R7,=0xAAAAAAAA
    /* SUB(register) Encoding T2 32bit */
    SUB.W   R8,R8,R7
    CMP     R8,#0xAAAAAAAB
    BNE     m4_scst_test_tail_end
    
    LDR     R7,=0xAAAAAAAA
    MOV     R8,#0x55555555
    /* SUB(register) Encoding T2 32bit */
    SUB.W   R7,R7,R8
    CMP     R7,#0x55555555
    BNE     m4_scst_test_tail_end
    
    MOV     R8,#0x0
    LDR     R7,=0x55555556
    /* SUB(register) Encoding T2 32bit */
    SUB.W   R7,R8,R7
    CMP     R7,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    /* SUBW */
    LDR     R2,=0x55555FFF
    /* SUB(immediate) Encoding T4 32bit */
    SUBW    R3,R2,#0xAAA
    CMP     R3,#0x55555555
    BNE     m4_scst_test_tail_end
    
    LDR     R2,=0xAAAAAFFF
    /* SUB(immediate) Encoding T4 32bit */
    SUBW    R3,R2,#0x555
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x0365
    
    
    /***************************************************************************************************
    * ALU control bus:
    * - use carry
    * - use adder input1
    * - use adder input2
    * - ALU operation type:
    *   - no operation
    *
    * Note: Linked with ADC instruction
    * ALU 控制总线：
    * - 使用携带
    * - 使用加法器 input1
    * - 使用加法器 input2
    * - ALU 操作类型：
    * - 无操作
    *
    * 注：与ADC指令链接
    *
    ***************************************************************************************************/
    BL      m4_scst_clear_flags
    /* ADC ：带进位加法.   */
    LDR     R4,=0x55555555
    /* ADC(immediate) Encoding T1 32bit */
    ADC.W   R11,R4,#0x55555555   /* Use immediate value */
    CMP     R11,#0xAAAAAAAA      /* Carry flag is not added 未添加进位标志 */
    BNE     m4_scst_test_tail_end
    
    /* Set Carry flag */
    LDR     R4,=0x20000000
    MSR     APSR_nzcvq,R4        /*MSR : 恢复或改变程序状态寄存器的内容*/
    ISB   	/*指令同步隔离。最严格：它会清洗流水线，以保证所有它前面的指令都执行完毕之后，才执行它后面的指令*/
    LDR     R11,=0xAAAAAAAA
    /* ADC(immediate) Encoding T1 32bit */
    ADC.W   R4,R11,#0xAAAAAAAA   /* Use immediate value */
    CMP     R4,#0x55555555      /* Carry flag is added */
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    
    LDR     R4,=0x55555555
    LDR     R11,=0x55555555
    /* ADC(register) Encoding T2 32bit */
    ADC.W   R11,R4,R11
    CMP     R11,#0xAAAAAAAA      /* Carry flag is not added */
    BNE     m4_scst_test_tail_end
    
    /* Set Carry flag */
    LDR     R4,=0x20000000
    MSR     APSR_nzcvq,R4
    ISB
    LDR     R11,=0xAAAAAAAA
    LDR     R4,=0xAAAAAAAA
    /* ADC(register) Encoding T2 32bit */
    ADC.W   R4,R11,R4
    CMP     R4,#0x55555555      /* Carry flag is added */
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x089E
    
    
    /***************************************************************************************************
    * ALU control bus:
    * - use carry
    * - invert ALU input 2
    * - use adder input1
    * - use adder input2
    * - ALU operation type:
    *   - no operation
    *
    * Note: Linked with SBC instruction
    *
    * ALU 控制总线：
     * - 使用携带
     * - 反转 ALU     input2
     * - 使用加法器 input1
     * - 使用加法器 input2
     * - ALU 操作类型：
     * - 无操作
     *
     *注：与SBC指令链接
    ***************************************************************************************************/
    /* SBC - invert ALU input 2  带进位的减法指令*/
    BL      m4_scst_clear_flags
    
    LDR     R2,=0x55555555
    /* SBC(immediate) Encoding T1 32bit */
    SBC.W   R3,R2,#0xAAAAAAAA
    CMP     R3,#0xAAAAAAAA      /* Carry flag is not added */
    BNE     m4_scst_test_tail_end
    
    /* Set Carry flag */
    LDR     R4,=0x20000000
    MSR     APSR_nzcvq,R4
    ISB
    LDR     R3,=0xAAAAAAAA
    /* SBC(immediate) Encoding T1 32bit */
    SBC.W   R2,R3,#0x55555555   /* Use immediate value */
    CMP     R2,#0x55555555      /* Carry flag is added */
    BNE     m4_scst_test_tail_end
    
    BL      m4_scst_clear_flags
    
    LDR     R2,=0x55555555
    LDR     R1,=0xAAAAAAAA
    /* SBC(register) Encoding T2 32bit */
    SBC.W   R3,R2,R1
    CMP     R3,#0xAAAAAAAA      /* Carry flag is not added */
    BNE     m4_scst_test_tail_end
    
    /* Set Carry flag */
    LDR     R4,=0x20000000
    MSR     APSR_nzcvq,R4
    ISB
    LDR     R2,=0xAAAAAAAA
    LDR     R1,=0x55555555
    /* SBC(register) Encoding T2 32bit */
    SBC.W   R3,R2,R1
    CMP     R3,#0x55555555      /* Carry flag is added */
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x02EF
    
    
    /***************************************************************************************************
    * ALU control bus:
    * - invert ALU input2
    * - use adder input2
    * - ALU operation type:
    *   - MOV(normal)
    *   
    *   Note: Linked with MVN instruction
    * ALU 控制总线：
     * - 反转 ALU input2
     * - 使用加法器 input2
     * - ALU 操作类型：
     * - MOV（正常）
     *
     *注：与MVN指令链接
    ***************************************************************************************************/
    /* MVN(immediate) Encoding T1 32bit mvn：与mov指令用法差不多，唯一的区别是：它赋值的时候，先按位取反*/
    MVN.W   R3,#0x55555555
    CMP     R3,#0xAAAAAAAA
    BNE     m4_scst_test_tail_end
    
    LDR     R2,=0xAAAAAAAA
    /* MVN(register) Encoding T2 32bit */
    MVN.W   R3,R2
    CMP     R3,#0x55555555
    BNE     m4_scst_test_tail_end
    
    ADDW    R9,R9,#0x09EA
    
    
    MOV     R0,R9          /* Test result is returned in R0, according to the conventions 根据约定，测试结果在 R0 中返回*/
    
    B       m4_scst_test_tail_end
    
    
    SCST_ALIGN_BYTES_4
    SCST_LTORG  /* Marks the current location for dumping psuedoinstruction pools (literal pool)
                   (containing numeric values for used symbolic names used within LDR instruction).
                   It is 4-byte aligned, as 2-byte alignment causes incorrect work. 
                   标记转储伪指令池（文字池）的当前位置
                    包含 LDR 指令中使用的符号名称的数值）。
                    它是 4 字节对齐的，因为 2 字节对齐会导致错误的工作。*/
    
    SCST_FILE_END
    