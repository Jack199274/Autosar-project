[!/* *** multiple inclusion protection *** */!]
[!IF "not(var:defined('ICU_VERSIONCHECK_SRC_PB_M'))"!]
[!VAR "ICU_VERSIONCHECK_SRC_PB_M"="'true'"!]
[!NOCODE!][!//
/**
*   @file    Icu_VersionCheck_Src_PB.m
*   @version 1.0.2
*
*   @brief   AUTOSAR Icu - version check macro.
*   @details Version checks.
*
*   @addtogroup ICU
*   @{
*/
/*==================================================================================================
*   Project              : AUTOSAR 4.3 MCAL
*   Platform             : ARM
*   Peripheral           : FTM PORT_CI LPIT LPTMR
*   Dependencies         : none
*
*   Autosar Version      : 4.3.1
*   Autosar Revision     : ASR_REL_4_3_REV_0001
*   Autosar Conf.Variant :
*   SW Version           : 1.0.2
*   Build Version        : S32K1XX_MCAL_1_0_2_RTM_ASR_REL_4_3_REV_0001_23-Apr-21
*
*   (c) Copyright 2006-2016 Freescale Semiconductor, Inc. 
*       Copyright 2017-2021 NXP
*   All Rights Reserved.
==================================================================================================*/
/*==================================================================================================
==================================================================================================*/

[!VAR "ICU_AR_RELEASE_MAJOR_VERSION_TEMPLATE"="4"!][!//
[!VAR "ICU_AR_RELEASE_MINOR_VERSION_TEMPLATE"="3"!][!//
[!VAR "ICU_AR_RELEASE_REVISION_VERSION_TEMPLATE"="1"!][!//
[!VAR "ICU_SW_MAJOR_VERSION_TEMPLATE"="1"!][!//
[!VAR "ICU_SW_MINOR_VERSION_TEMPLATE"="0"!][!//
[!ENDNOCODE!][!//
[!SELECT "CommonPublishedInformation"!][!//
[!/*
[!ASSERT "ArReleaseMajorVersion = num:i($ICU_AR_RELEASE_MAJOR_VERSION_TEMPLATE)"!]
        **** AUTOSAR release major version number of the Basic Software Module Description file (Icu.epd version [!"ArReleaseMajorVersion "!]) and the Code template file (Icu_PBcfg.c version [!"num:i($ICU_AR_RELEASE_MAJOR_VERSION_TEMPLATE)"!]) are different ****
[!ENDASSERT!][!//
[!ASSERT "ArReleaseMinorVersion  = num:i($ICU_AR_RELEASE_MINOR_VERSION_TEMPLATE)"!]
        **** AUTOSAR release minor version number of the Basic Software Module Description file (Icu.epd version [!"ArReleaseMinorVersion"!]) and the Code template files (Icu_PBcfg.c version [!"num:i($ICU_AR_RELEASE_MINOR_VERSION_TEMPLATE)"!]) are different ****
[!ENDASSERT!][!//
[!ASSERT "ArReleaseRevisionVersion  = num:i($ICU_AR_RELEASE_REVISION_VERSION_TEMPLATE)"!]
        **** AUTOSAR release revision version number of the Basic Software Module Description file (Icu.epd version [!"ArReleaseRevisionVersion"!]) and the Code template files (Icu_PBcfg.c version [!"num:i($ICU_AR_RELEASE_REVISION_VERSION_TEMPLATE)"!]) are different ****
[!ENDASSERT!][!//
*/!]
[!ASSERT "SwMajorVersion = num:i($ICU_SW_MAJOR_VERSION_TEMPLATE)"!]
        **** The software major number of the Basic Software Module Description file (Icu.epd version [!"SwMajorVersion"!]) and the Code template files (Icu_PBcfg.c version [!"num:i($ICU_SW_MAJOR_VERSION_TEMPLATE)"!]) are different ****
[!ENDASSERT!][!//
[!ASSERT "SwMinorVersion = num:i($ICU_SW_MINOR_VERSION_TEMPLATE)"!]
        **** The software minor number of the Basic Software Module Description file (Icu.epd version [!"SwMinorVersion"!]) and the Code template files (Icu_PBcfg.c version [!"num:i($ICU_SW_MINOR_VERSION_TEMPLATE)"!]) are different ****
[!ENDASSERT!][!//
[!ENDSELECT!][!//
[!NOCODE!][!//
[!ENDNOCODE!][!//
[!ENDIF!]