/**
* @file    Crypto_Cfg.h
*   @implements Crypto_Cfg.h_Artifact
* @version 1.0.2
* @brief   AUTOSAR Crypto - CRYPTO driver configuration.
* @details This is the CRYPTO driver configuration header.
*
* @addtogroup Crypto
* @{
*/
/*=================================================================================================
*   Project              : AUTOSAR 4.3 MCAL
*   Platform             : ARM
*   Peripheral           : Crypto
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
=================================================================================================*/
/*=================================================================================================
=================================================================================================*/


#ifndef CRYPTO_CFG_H
#define CRYPTO_CFG_H

#ifdef __cplusplus
extern "C" {
#endif

/**
* @page misra_violations MISRA-C:2004 violations
*
* @section Crypto_cfg_h_REF_1
*           Violates MISRA 2004 Required Rule 1.4, Identifier clash.
*           This violation is due to the requirement that request to have a file version check.
*
* @section Crypto_cfg_h_REF_2
*           Violates MISRA 2004 Required Rule 5.1, External identifiers shall be distinct.
*           The used compilers use more than 31 chars for identifiers.
*
*/

/*=================================================================================================
                                         INCLUDE FILES
 1) system and project includes
 2) needed interfaces from external units
 3) internal and external interfaces from this unit
=================================================================================================*/

/*=================================================================================================
*                              SOURCE FILE VERSION INFORMATION
=================================================================================================*/

#define CRYPTO_VENDOR_ID_CFG                       43
/**
* @violates @ref Crypto_cfg_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_cfg_h_REF_2 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_AR_RELEASE_MAJOR_VERSION_CFG        4
/**
* @violates @ref Crypto_cfg_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_cfg_h_REF_2 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_AR_RELEASE_MINOR_VERSION_CFG        3
/**
* @violates @ref Crypto_cfg_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_cfg_h_REF_2 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_AR_RELEASE_REVISION_VERSION_CFG     1
#define CRYPTO_SW_MAJOR_VERSION_CFG                1
#define CRYPTO_SW_MINOR_VERSION_CFG                0
#define CRYPTO_SW_PATCH_VERSION_CFG                2

/*=================================================================================================
*                               FILE VERSION CHECKS
=================================================================================================*/
[!NOCODE!][!//
[!INCLUDE "Crypto_VersionCheck_Inc.m"!][!//
[!ENDNOCODE!][!//

/*=================================================================================================
*                                          CONSTANTS
=================================================================================================*/

/*=================================================================================================
*                                      DEFINES AND MACROS
=================================================================================================*/


/* Pre-processor switch to enable and disable development error detection */
#define CRYPTO_DEV_ERROR_DETECT                ([!IF "CryptoGeneral/CryptoDevErrorDetect"!]STD_ON[!ELSE!]STD_OFF[!ENDIF!])

/* User mode support */
#define CRYPTO_ENABLE_USER_MODE_SUPPORT           ([!IF "CryptoGeneral/CryptoEnableUserModeSupport"!]STD_ON[!ELSE!]STD_OFF[!ENDIF!])
/* Pre-processor switch to enable / disable the API to read out the modules
    version information */
#define CRYPTO_VERSION_INFO_API                ([!IF "CryptoGeneral/CryptoVersionInfoApi"!]STD_ON[!ELSE!]STD_OFF[!ENDIF!])

/* Crypto instance ID value */
#define CRYPTO_INSTANCE_ID                     ((uint8)[!"node:value(CryptoGeneral/CryptoInstanceId)"!])

/* Crypto Timeout value */
#define CRYPTO_TIMEOUT_DURATION                ([!"node:value("CryptoGeneral/CryptoTimeoutDuration")"!]U)


[!IF "node:exists(CryptoGeneral/CryptoMainFunctionPeriod)"!][!//
#define CRYPTO_MAIN_FUNCTION_PERIOD   ([!"node:value(CryptoGeneral/CryptoMainFunctionPeriod)"!])
[!ENDIF!][!//


/* Number of configured Crypto driver objects */
#define CRYPTO_NUMBER_OF_DRIVER_OBJECTS                 ([!"num:i(count(CryptoDriverObjects/CryptoDriverObject/*))"!]U)

/* Verify if there are keys configured or not */
[!IF "node:exists(CryptoKeys)"!][!//
#define CRYPTO_KEYS_EXIST                               (1U)

/* Number of Crypto keys */
#define CRYPTO_NUMBER_OF_KEYS                           ([!"num:i(count(CryptoKeys/CryptoKey/*))"!]U)

/* Number of Crypto key elements */
#define CRYPTO_NUMBER_OF_KEY_ELEMENTS                   ([!"num:i(count(CryptoKeyElements/CryptoKeyElement/*))"!]U)
[!ELSE!]
#define CRYPTO_KEYS_EXIST                               (0U)
[!ENDIF!][!//

/* Verify if there are keys configured or not */
[!IF "node:exists(CryptoLoadKeys)"!][!//
#define CRYPTO_LOAD_KEYS_EXIST                          (1U)

/* Number of Crypto Load key*/
#define CRYPTO_NUMBER_OF_LOAD_KEY_ELEMENTS              ([!"num:i(count(CryptoLoadKeys/CryptoLoadKey/*))"!]U)

[!ELSE!]
#define CRYPTO_LOAD_KEYS_EXIST                          (0U)
[!ENDIF!][!//

/* Verify if there are keys configured or not */
[!IF "node:exists(CryptoInstallCerts)"!][!//
#define CRYPTO_INSTALL_CERT_EXIST                       (1U)

/* Number of Crypto Install Cert*/
#define CRYPTO_NUMBER_OF_INSTALL_CERT_ELEMENTS          ([!"num:i(count(CryptoInstallCerts/CryptoInstallCert/*))"!]U)

[!ELSE!]
#define CRYPTO_INSTALL_CERT_EXIST                       (0U)
[!ENDIF!][!//

/* Verify if there are keys configured or not */
[!IF "node:exists(CryptoDhKeyPairGens)"!][!//
#define CRYPTO_DH_PAIR_EXIST                            (1U)

/* Number of Crypto Dh key*/
#define CRYPTO_NUMBER_OF_DH_PAIR_ELEMENTS               ([!"num:i(count(CryptoDhKeyPairGens/CryptoDhKeyPairGen/*))"!]U)

[!ELSE!]
#define CRYPTO_DH_PAIR_EXIST                            (0U)
[!ENDIF!][!//

/* Verify if there are keys configured or not */
[!IF "node:exists(CryptoKeyGenerates)"!][!//
#define CRYPTO_KEY_GEN_EXIST                            (1U)

/* Number of Crypto key generate*/
#define CRYPTO_NUMBER_OF_KEY_GEN_ELEMENTS               ([!"num:i(count(CryptoKeyGenerates/CryptoKeyGenerate/*))"!]U)

[!ELSE!]
#define CRYPTO_KEY_GEN_EXIST                            (0U)
[!ENDIF!][!//

/* Verify if there are keys configured or not */
[!IF "node:exists(CryptoKeyDerives)"!][!//
#define CRYPTO_KEY_DERIVE_EXIST                         (1U)

/* Number of Crypto key derives*/
#define CRYPTO_NUMBER_OF_KEY_DERIVE_ELEMENTS            ([!"num:i(count(CryptoKeyDerives/CryptoKeyDerive/*))"!]U)

[!ELSE!]
#define CRYPTO_KEY_DERIVE_EXIST                         (0U)
[!ENDIF!][!//

/* Verify if there are keys export or not */
[!IF "node:exists(CryptoExportKeys)"!][!//
#define CRYPTO_KEY_EXPORT_EXIST                         (1U)

/* Number of Crypto key derives*/
#define CRYPTO_NUMBER_OF_KEY_EXPORT_ELEMENTS            ([!"num:i(count(CryptoExportKeys/CryptoExportKey/*))"!]U)

[!ELSE!]
#define CRYPTO_KEY_EXPORT_EXIST                         (0U)
[!ENDIF!][!//

[!LOOP "CryptoKeys/CryptoKey/*"!][!//
[!VAR "KeyId" = "CryptoKeyId"!][!//
/**
* @brief          Symbolic name for the CryptoKeyId [!"node:name(.)"!].
*
*/
#define  CryptoConf_[!"node:name(.)"!]_CryptoKeyId   ((uint32)[!"num:i($KeyId)"!]U)

[!ENDLOOP!][!//

[!LOOP "CryptoDriverObjects/CryptoDriverObject/*"!][!//
[!VAR "ObjectId" = "CryptoDriverObjectId"!][!//
/**
* @brief          Symbolic name for the CryptoDriverObjectId [!"node:name(.)"!].
*
*/
#define  CryptoConf_[!"node:name(.)"!]_CryptoDriverObjectId   ((uint32)[!"num:i($ObjectId)"!]U)

[!ENDLOOP!][!//

[!LOOP "CryptoKeyElements/CryptoKeyElement/*"!][!//
[!VAR "ElementId" = "CryptoKeyElementId"!][!//
/**
* @brief          Symbolic name for the CryptoKeyElementId [!"node:name(.)"!].
*
*/
#define  CryptoConf_[!"node:name(.)"!]_CryptoKeyElementId   ((uint32)[!"num:i($ElementId)"!]U)

[!ENDLOOP!][!//
/*=================================================================================================
*                                             ENUMS
=================================================================================================*/

/*=================================================================================================
*                                STRUCTURES AND OTHER TYPEDEFS
=================================================================================================*/

/*=================================================================================================
                                 GLOBAL VARIABLE DECLARATIONS
=================================================================================================*/

/*=================================================================================================
*                                    FUNCTION PROTOTYPES
=================================================================================================*/

#ifdef __cplusplus
}
#endif

#endif /* CRYPTO_CFG_H */
