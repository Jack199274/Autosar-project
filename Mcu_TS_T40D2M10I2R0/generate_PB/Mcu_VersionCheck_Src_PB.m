[!NOCODE!][!//
/**
  @file    Mcu_VersionCheck_Src_PB.m
  @version 1.0.2

  @brief   AUTOSAR Mcu - version check macro.
  @details Version checks.
  
  Project AUTOSAR 4.3 MCAL
  Patform ARM
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
[!/* avoid multiple inclusion */!]
[!IF "not(var:defined('MCU_VERSION_CHECK_SRC_M'))"!]
[!VAR "MCU_VERSION_CHECK_SRC_M"="'true'"!]

[!VAR "McuArReleaseMajorVersionTemplate"="4"!][!//
[!VAR "McuArReleaseMinorVersionTemplate"="3"!][!//
[!VAR "McuArReleaseRevisionVersionTemplate"="1"!][!//
[!VAR "McuSwMajorVersionTemplate"="1"!][!//     
[!VAR "McuSwMinorVersionTemplate"="0"!][!//     
[!VAR "McuSwPatchVersionTemplate"="2"!][!//

[!SELECT "CommonPublishedInformation"!][!//
[!IF "not(num:i(ArReleaseMajorVersion) = num:i($McuArReleaseMajorVersionTemplate))"!]
    [!ERROR!]
        "AUTOSAR major version number of the Basic Software Module Description file (Mcu.epd version [!"ArReleaseMajorVersion"!]) and the Code template file (Mcu_PBcfg.c version [!"num:i($McuArReleaseMajorVersionTemplate)"!]) are different"
    [!ENDERROR!]
[!ENDIF!][!//
[!IF "not(num:i(ArReleaseMinorVersion)  = num:i($McuArReleaseMinorVersionTemplate))"!]
     [!ERROR!]
        "AUTOSAR minor version number of the Basic Software Module Description file (Mcu.epd version [!"ArReleaseMinorVersion"!]) and the Code template file (Mcu_PBcfg.c version [!"num:i($McuArReleaseMinorVersionTemplate)"!]) are different"
    [!ENDERROR!]
[!ENDIF!][!//
[!IF "not(num:i(ArReleaseRevisionVersion)  = num:i($McuArReleaseRevisionVersionTemplate))"!]
    [!ERROR!]
        "AUTOSAR revision version number of the Basic Software Module Description file (Mcu.epd version [!"ArReleaseRevisionVersion"!]) and the Code template file (Mcu_PBcfg.c version [!"num:i($McuArReleaseRevisionVersionTemplate)"!]) are different"
    [!ENDERROR!]
[!ENDIF!][!//

[!IF "not(num:i(SwMajorVersion) = num:i($McuSwMajorVersionTemplate))"!]
    [!ERROR!]
        "The software major number of the Basic Software Module Description file (Mcu.epd version [!"SwMajorVersion"!]) and the Code template file (Mcu_PBcfg.c version [!"num:i($McuSwMajorVersionTemplate)"!]) are different"
    [!ENDERROR!]
[!ENDIF!][!//
[!IF "not(num:i(SwMinorVersion) = num:i($McuSwMinorVersionTemplate))"!]
    [!ERROR!]   
        "The software minor number of the Basic Software Module Description file (Mcu.epd version [!"SwMinorVersion"!]) and the Code template file (Mcu_PBcfg.c version [!"num:i($McuSwMinorVersionTemplate)"!]) are different"
    [!ENDERROR!]
[!ENDIF!][!//
[!IF "not(num:i(SwPatchVersion) = num:i($McuSwPatchVersionTemplate))"!]
    [!ERROR!]
        "The software patch number of the Basic Software Module Description file (Mcu.epd version [!"SwPatchVersion"!]) and the Code template file (Mcu_PBcfg.c version [!"num:i($McuSwPatchVersionTemplate)"!]) are different"
    [!ENDERROR!]
[!ENDIF!]
[!ENDSELECT!][!//

[!ENDIF!][!// avoid multiple inclusion ENDIF

[!ENDNOCODE!][!//
