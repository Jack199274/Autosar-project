[!NOCODE!][!//
/**
  @file    Crypto_VersionCheck_Inc.m
  @version 1.0.2

  @brief   AUTOSAR Crypto - version check macro.
  @details Version checks.
  
  Project AUTOSAR 4.3 MCAL
  Patform ARM
  Peripheral Crypto
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
[!VAR "CryptoArMajorVersionTemplate"="4"!][!//
[!VAR "CryptoArMinorVersionTemplate"="3"!][!//
[!VAR "CryptoArPatchVersionTemplate"="1"!][!//
[!VAR "CryptoSwMajorVersionTemplate"="1"!][!//     
[!VAR "CryptoSwMinorVersionTemplate"="0"!][!//     

[!ENDNOCODE!][!//
[!SELECT "CommonPublishedInformation"!][!//
[!/*
[!IF "not(num:i(ArMajorVersion) = num:i($CryptoArMajorVersionTemplate))"!]
    [!ERROR!]
        "AUTOSAR major version number of the Basic Software Module Description file (Crypto.epd version [!"ArMajorVersion"!]) and the Code template file (Crypto_Cfg.h version [!"num:i($CryptoArMajorVersionTemplate)"!]) are different"
    [!ENDERROR!]
[!ENDIF!][!//
[!IF "not(num:i(ArMinorVersion)  = num:i($CryptoArMinorVersionTemplate))"!]
     [!ERROR!]
        "AUTOSAR minor version number of the Basic Software Module Description file (Crypto.epd version [!"ArMinorVersion"!]) and the Code template file (Crypto_Cfg.h version [!"num:i($CryptoArMinorVersionTemplate)"!]) are different"
    [!ENDERROR!]
[!ENDIF!][!//
[!IF "not(num:i(ArPatchVersion)  = num:i($CryptoArPatchVersionTemplate))"!]
    [!ERROR!]
        "AUTOSAR patch version number of the Basic Software Module Description file (Crypto.epd version [!"ArPatchVersion"!]) and the Code template file (Crypto_Cfg.h version [!"num:i($CryptoArPatchVersionTemplate)"!]) are different"
    [!ENDERROR!]
[!ENDIF!][!//
*/!]
[!IF "not(num:i(SwMajorVersion) = num:i($CryptoSwMajorVersionTemplate))"!]
    [!ERROR!]
        "The software major number of the Basic Software Module Description file (Crypto.epd version [!"SwMajorVersion"!]) and the Code template file (Crypto_Cfg.h version [!"num:i($CryptoSwMajorVersionTemplate)"!]) are different"
    [!ENDERROR!]
[!ENDIF!][!//
[!IF "not(num:i(SwMinorVersion) = num:i($CryptoSwMinorVersionTemplate))"!]
    [!ERROR!]   
        "The software minor number of the Basic Software Module Description file (Crypto.epd version [!"SwMinorVersion"!]) and the Code template file (Crypto_Cfg.h version [!"num:i($CryptoSwMinorVersionTemplate)"!]) are different"
    [!ENDERROR!]
[!ENDIF!][!//
[!ENDSELECT!][!//
[!NOCODE!][!//

[!ENDNOCODE!][!//
