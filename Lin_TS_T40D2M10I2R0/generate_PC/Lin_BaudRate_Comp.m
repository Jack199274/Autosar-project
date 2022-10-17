[!/*
    @file    Lin_BaudRate_Comp.m
    @version 1.0.2

    @brief   AUTOSAR Lin - Baud rate computation for Lin_Cfg.c, Lin_PBcfg.c.
    @details Baud rate computation for Lin_Cfg.c, Lin_PBcfg.c
    
    Project AUTOSAR 4.3 MCAL
    Patform ARM
    Peripheral LPUART,FLEXIO
    Dependencies 
    
    ARVersion 4.3.1
    ARRevision ASR_REL_4_3_REV_0001
    ARConfVariant
    SWVersion 1.0.2
    BuildVersion S32K1XX_MCAL_1_0_2_RTM_ASR_REL_4_3_REV_0001_23-Apr-21

    (c) Copyright 2006-2016 Freescale Semiconductor, Inc. 
*       Copyright 2017-2021 NXP
    All Rights Reserved.
*/!]
[!/*==================================================================================================
==================================================================================================
*/!]
[!VAR "ClockFrequencyFromMcu" = "McuClockReferencePointFrequency"!]
[!/* LPUART baudrate */!]
    [!VAR "CTRL_SBR" = "($ClockFrequencyFromMcu div ($linBaudrate * 16))"!][//
    [!VAR "CTRL_SBR" = "num:inttohex($CTRL_SBR)"!][!//

[!/* FlexIO baudrate */!]
[!IF "$LinFlexIOChannel = 'true'"!][!//
    [!VAR "TIMCMPL" = "(($ClockFrequencyFromMcu div ($linBaudrate * 2))-1)"!][//
    [!IF "$TIMCMPL > 255"!][!//
        [!ERROR!] Lin baud rate divider = [!"$TIMCMPL"!], it should be < 255, please select a lower MCU clock.[!ENDERROR!]
    [!ENDIF!][!//
    [!VAR "TIMCMPL" = "num:inttohex($TIMCMPL)"!][!//
[!ENDIF!]

