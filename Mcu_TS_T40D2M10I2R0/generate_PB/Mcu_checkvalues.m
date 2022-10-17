[!NOCODE!]
/**
    @file    Mcu_checkvalues.m
    @version 1.0.2

    @brief   AUTOSAR Mcu - File used by the C generation templates.
    @details This file contains macros used by the C generation templates.

    Project AUTOSAR 4.3 MCAL
    Platform ARM
    Peripheral MC
    Dependencies none

    ARVersion 4.3.1
    ARRevision ASR_REL_4_3_REV_0001
    ARConfVariant
    SWVersion 1.0.2
    BuildVersion S32K1XX_MCAL_1_0_2_RTM_ASR_REL_4_3_REV_0001_23-Apr-21
    
    (c) Copyright 2006-2016 Freescale Semiconductor, Inc. 
*       Copyright 2017-2021 NXP
    All Rights Reserved.
 */
/*==================================================================================================
==================================================================================================*/

/* Macro to check one RAM section */
[!MACRO "MCheckRamSection"!]
    [!VAR "tmp_m"="0"!]

    [!// stop generation if ram section base address is not aligned to 4 bytes
    [!VAR "tmp_m"="McuRamSectionBaseAddress"!]
    [!IF "$tmp_m mod 4 != 0"!]
        [!INFO!]
*****************
Error: Ram Section Base Address in [!"text:replace(node:path(.),'\/.+\/McuGeneralConfiguration','')"!] is not aligned to 4 bytes (current value: [!"$tmp_m"!])!
*****************
        [!ENDINFO!]
        [!//[!VAR "error"="$error+1"!]
    [!ENDIF!]

    [!// stop generation if ram section size is not multiple of 4
    [!VAR "tmp_m"="McuRamSectionSize"!]
    [!IF "$tmp_m mod 4 != 0"!]
        [!INFO!]
*****************
Error: Ram Section Size in [!"text:replace(node:path(.),'\/.+\/McuGeneralConfiguration','')"!] is not multiple of 4 (current value: [!"$tmp_m"!])!
*****************
        [!ENDINFO!]
        [!//[!VAR "error"="$error+1"!]
    [!ENDIF!]
[!ENDMACRO!]


/* Macro to check one clock setting */
[!MACRO "MCheckClockSettings"!]
    [!VAR "tmp_m"="0"!]
    [!VAR "tmp_n"="0"!]

[!/*
    [!// stop generation if McuSystemClockFrequency is less than 4 MHz
    [!VAR "tmp_m"="McuSystemClockFrequency"!]
    [!IF "($tmp_m<4000000) and ($tmp_m!=0)"!]
        [!INFO!]
*****************
Error: McuSystemClockFrequency in [!"text:replace(node:path(.),'\/.+\/McuGeneralConfiguration','')"!] cannot be less than 4 MHz (current value: [!"$tmp_m"!]Hz)!
*****************
        [!ENDINFO!]
        [!//[!VAR "error"="$error+1"!]
    [!ENDIF!]
*/!]


    [!// stop generation if McuSystemClockFrequency is greater than 200MHz
    [!VAR "tmp_m"="McuSystemClockFrequency"!]
    [!IF "$tmp_m>200000000"!]
        [!INFO!]
*****************
Error:McuSystemClockFrequency in [!"text:replace(node:path(.),'\/.+\/McuGeneralConfiguration','')"!] cannot be greater than 200 MHz (current value: [!"$tmp_m"!]Hz)!
*****************
        [!ENDINFO!]
        [!//[!VAR "error"="$error+1"!]
    [!ENDIF!]
[!ENDMACRO!]
[!ENDNOCODE!]
