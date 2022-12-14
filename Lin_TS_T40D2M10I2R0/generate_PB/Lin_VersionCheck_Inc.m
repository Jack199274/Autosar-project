[!NOCODE!][!//
/**
    @file    LIN_VersionCheck_Inc.m
    @version 1.0.2

    @brief   AUTOSAR Lin - Brief description.
    @details Version check variables vor Lin_Cfg.h

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
*/
/*==================================================================================================
==================================================================================================*/
[!VAR "LIN_AR_MAJOR_VERSION_TEMPLATE"="4"!][!//
[!VAR "LIN_AR_MINOR_VERSION_TEMPLATE"="3"!][!//
[!VAR "LIN_AR_PATCH_VERSION_TEMPLATE"="1"!][!//
[!VAR "LIN_SW_MAJOR_VERSION_TEMPLATE"="1"!][!//
[!VAR "LIN_SW_MINOR_VERSION_TEMPLATE"="0"!][!//
[!VAR "LIN_SW_PATCH_VERSION_TEMPLATE"="2"!][!//
[!ENDNOCODE!][!//

[!SELECT "CommonPublishedInformation"!][!//
[!IF "num:i(ArReleaseMajorVersion) != num:i($LIN_AR_MAJOR_VERSION_TEMPLATE)"!]
    [!ERROR!]
          **** AUTOSAR major version number of the Basic Software Module Description file (Lin.epd version [!"ArReleaseMajorVersion"!]) and the Code template file (Lin_Cfg.h  version [!"num:i($LIN_AR_MAJOR_VERSION_TEMPLATE)"!]) are different ****
    [!ENDERROR!]
[!ENDIF!][!//
[!IF "num:i(ArReleaseMinorVersion)  != num:i($LIN_AR_MINOR_VERSION_TEMPLATE)"!]
    [!ERROR!]
          **** AUTOSAR minor version number of the Basic Software Module Description file (Lin.epd version [!"ArReleaseMinorVersion"!]) and the Code template file (Lin_Cfg.h  version [!"num:i($LIN_AR_MINOR_VERSION_TEMPLATE)"!]) are different ****
    [!ENDERROR!]
[!ENDIF!][!//
[!IF "num:i(ArReleaseRevisionVersion)  != num:i($LIN_AR_PATCH_VERSION_TEMPLATE)"!]
    [!ERROR!]
          **** AUTOSAR patch version number of the Basic Software Module Description file (Lin.epd version [!"ArReleaseRevisionVersion"!]) and the Code template file (Lin_Cfg.h version [!"num:i($LIN_AR_PATCH_VERSION_TEMPLATE)"!]) are different ****
    [!ENDERROR!]
[!ENDIF!][!//
[!IF "num:i(SwMajorVersion) != num:i($LIN_SW_MAJOR_VERSION_TEMPLATE)"!]
    [!ERROR!]
          **** The software major number of the Basic Software Module Description file (Lin.epd version [!"SwMajorVersion"!]) and the Code template file (Lin_Cfg.h version [!"num:i($LIN_SW_MAJOR_VERSION_TEMPLATE)"!]) are different ****
    [!ENDERROR!]
[!ENDIF!][!//
[!IF "num:i(SwMinorVersion) != num:i($LIN_SW_MINOR_VERSION_TEMPLATE)"!]
    [!ERROR!]
          **** The software minor number of the Basic Software Module Description file (Lin.epd version [!"SwMinorVersion"!]) and the Code template file (Lin_Cfg.h version [!"num:i($LIN_SW_MINOR_VERSION_TEMPLATE)"!]) are different ****
    [!ENDERROR!]
[!ENDIF!][!//
[!IF "not(num:i(SwPatchVersion) = num:i($LIN_SW_PATCH_VERSION_TEMPLATE))"!]
    [!ERROR!]
      **** The software patch number of the Basic Software Module Description file (Lin.epd version [!"SwPatchVersion"!]) and the Code template file (Lin_Cfg.h version [!"num:i($LIN_SW_PATCH_VERSION_TEMPLATE)"!]) are different ****
    [!ENDERROR!]
[!ENDIF!]
[!ENDSELECT!][!//
[!NOCODE!][!//
[!ENDNOCODE!][!//
