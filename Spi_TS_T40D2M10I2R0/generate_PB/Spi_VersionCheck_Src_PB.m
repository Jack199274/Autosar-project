[!NOCODE!][!//
/**
  @file    Spi_VersionCheck_Src_PB.m
  @version 1.0.2

  @brief   AUTOSAR Spi - version check macro.
  @details Version checks.
  
  Project AUTOSAR 4.3 MCAL
  Patform ARM
  Peripheral LPSPI,FLEXIO
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

[!/* avoid multiple inclusion */!]
[!IF "not(var:defined('SPI_VERSION_CHECK_SRC_PB_M'))"!]
[!VAR "SPI_VERSION_CHECK_SRC_PB_M"="'true'"!]

[!VAR "SPI_AR_RELEASE_MAJOR_VERSION_TEMPLATE"="4"!][!//
[!VAR "SPI_AR_RELEASE_MINOR_VERSION_TEMPLATE"="3"!][!//
[!VAR "SPI_AR_RELEASE_REVISION_VERSION_TEMPLATE"="1"!][!//
[!VAR "SPI_SW_MAJOR_VERSION_TEMPLATE"="1"!][!//
[!VAR "SPI_SW_MINOR_VERSION_TEMPLATE"="0"!][!//
[!VAR "SPI_SW_PATCH_VERSION_TEMPLATE"="2"!][!// 

[!SELECT "CommonPublishedInformation"!][!//
[!IF "not(num:i(ArReleaseMajorVersion) = num:i($SPI_AR_RELEASE_MAJOR_VERSION_TEMPLATE))"!]
    [!ERROR!]
        "AUTOSAR release major version number of the Basic Software Module Description file (Spi.epd version [!"ArReleaseMajorVersion "!]) and the Code template files (Spi_PBcfg.c version [!"num:i($SPI_AR_RELEASE_MAJOR_VERSION_TEMPLATE)"!]) are different"
    [!ENDERROR!]
[!ENDIF!]
[!IF "not(num:i(ArReleaseMinorVersion) = num:i($SPI_AR_RELEASE_MINOR_VERSION_TEMPLATE))"!]
    [!ERROR!]
        "AUTOSAR release minor version number of the Basic Software Module Description file (Spi.epd version [!"ArReleaseMinorVersion"!]) and the Code template files (Spi_PBcfg.c version [!"num:i($SPI_AR_RELEASE_MINOR_VERSION_TEMPLATE)"!]) are different"
    [!ENDERROR!]
[!ENDIF!]    
[!IF "not(num:i(ArReleaseRevisionVersion)  = num:i($SPI_AR_RELEASE_REVISION_VERSION_TEMPLATE))"!]
    [!ERROR!]
        "AUTOSAR release revision version number of the Basic Software Module Description file (Spi.epd version [!"ArReleaseRevisionVersion"!]) and the Code template files (Spi_PBcfg.c version [!"num:i($SPI_AR_RELEASE_REVISION_VERSION_TEMPLATE)"!]) are different"
    [!ENDERROR!]
[!ENDIF!] 
[!IF "not(num:i(SwMajorVersion) = num:i($SPI_SW_MAJOR_VERSION_TEMPLATE))"!]
    [!ERROR!]
        "The software major number of the Basic Software Module Description file (Spi.epd version [!"SwMajorVersion"!]) and the Code template files (Spi_PBcfg.c version [!"num:i($SPI_SW_MAJOR_VERSION_TEMPLATE)"!]) are different"
    [!ENDERROR!]
[!ENDIF!]
[!IF "not(num:i(SwMinorVersion) = num:i($SPI_SW_MINOR_VERSION_TEMPLATE))"!]
    [!ERROR!]
        "The software minor number of the Basic Software Module Description file (Spi.epd version [!"SwMinorVersion"!]) and the Code template files (Spi_PBcfg.c version [!"num:i($SPI_SW_MINOR_VERSION_TEMPLATE)"!]) are different"
    [!ENDERROR!]
[!ENDIF!]
[!IF "not(num:i(SwPatchVersion) = num:i($SPI_SW_PATCH_VERSION_TEMPLATE))"!]
    [!ERROR!]
        "The software minor number of the Basic Software Module Description file (Spi.epd version [!"SwPatchVersion"!]) and the Code template files (Spi_PBcfg.c version [!"num:i($SPI_SW_PATCH_VERSION_TEMPLATE)"!]) are different"
    [!ENDERROR!]
[!ENDIF!]

[!ENDSELECT!][!//

[!ENDIF!][!// avoid multiple inclusion ENDIF
[!ENDNOCODE!][!//
