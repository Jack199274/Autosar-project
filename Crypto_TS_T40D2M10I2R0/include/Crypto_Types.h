/**
*   @file    Crypto_Types.h
*
*   @version 1.0.2
*   @brief   AUTOSAR Crypto - Crypto interface
*   @details API header for Crypto driver.
*
*   @addtogroup  Crypto
*   @{
*/
/*==================================================================================================
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
==================================================================================================*/
/*==================================================================================================
==================================================================================================*/

#ifndef CRYPTO_TYPES_H
#define CRYPTO_TYPES_H

#ifdef __cplusplus
extern "C"{
#endif

/**
* @page misra_violations MISRA-C:2004 violations
*
* @section Crypto_Types_h_REF_1
*           Violates MISRA 2004 Required Rule 1.4, Identifier clash.
*           This violation is due to the requirement that request to have a file version check.
*
* @section Crypto_Types_h_REF_2
*           Violates MISRA 2004 Required Rule 5.1, External identifiers shall be distinct.
*           The used compilers use more than 31 chars for identifiers.
*
* @section Crypto_Types_h_REF_3
*           Violates MISRA 2004 Required Rule 19.4, C macros shall only expand to a braced initialiser,
*           a constant, a string literal, a parenthesised expression, a type qualifier, a
*           storage class specifier, or a do-while-zero construct.
*
* @section Crypto_Types_h_REF_4
*           Violates MISRA 2004 Required Rule 20.2, The names of standard library macros, 
*           objects and functions shall not be reused.
*/

/*==================================================================================================
*                                        INCLUDE FILES
* 1) system and project includes
* 2) needed interfaces from external units
* 3) internal and external interfaces from this unit
==================================================================================================*/

#include "Mcal.h"
#include "Csm_Types.h"
#include "Crypto_Cfg.h"

/*==================================================================================================
*                              SOURCE FILE VERSION INFORMATION
==================================================================================================*/
/**
* @file           Crypto_Types.h    
*/
#define CRYPTO_VENDOR_ID_TYPES                       43
/**
* @violates @ref Crypto_Types_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_Types_h_REF_2 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_AR_RELEASE_MAJOR_VERSION_TYPES        4
/**
* @violates @ref Crypto_Types_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_Types_h_REF_2 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_AR_RELEASE_MINOR_VERSION_TYPES        3
/**
* @violates @ref Crypto_Types_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_Types_h_REF_2 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_AR_RELEASE_REVISION_VERSION_TYPES     1
#define CRYPTO_SW_MAJOR_VERSION_TYPES                1
#define CRYPTO_SW_MINOR_VERSION_TYPES                0
#define CRYPTO_SW_PATCH_VERSION_TYPES                2

/*==================================================================================================
*                                    FILE VERSION CHECKS
==================================================================================================*/
#ifndef DISABLE_MCAL_INTERMODULE_ASR_CHECK
 /* Check if header file and Mcal header file are of the same AutoSar version */
 #if ((CRYPTO_AR_RELEASE_MAJOR_VERSION_TYPES != MCAL_AR_RELEASE_MAJOR_VERSION) || \
      (CRYPTO_AR_RELEASE_MINOR_VERSION_TYPES != MCAL_AR_RELEASE_MINOR_VERSION) \
     )
 #error "AutoSar Version Numbers of Crypto_Types.h and Mcal.h are different"
 #endif 
#endif


/* Check if Crypto types header file and Csm types header file are of the same vendor */
#if (CRYPTO_VENDOR_ID_TYPES != CSM_VENDOR_ID_TYPES)
#error "Crypto_Types.h and Csm_Types.h have different vendor ids"
#endif

#ifndef DISABLE_MCAL_INTERMODULE_ASR_CHECK
/* Check if Crypto types header file and Csm types header file are of the same Autosar version */
#if ((CRYPTO_AR_RELEASE_MAJOR_VERSION_TYPES != CSM_AR_RELEASE_MAJOR_VERSION_TYPES) || \
     (CRYPTO_AR_RELEASE_MINOR_VERSION_TYPES != CSM_AR_RELEASE_MINOR_VERSION_TYPES) || \
     (CRYPTO_AR_RELEASE_REVISION_VERSION_TYPES != CSM_AR_RELEASE_REVISION_VERSION_TYPES) \
    )
#error "AutoSar Version Numbers of Crypto_Types.h and Csm_Types.h are different"
#endif
#endif /* DISABLE_MCAL_INTERMODULE_ASR_CHECK */

/* Check if Crypto types header file and Csm types header file are of the same Software version */
#if ((CRYPTO_SW_MAJOR_VERSION_TYPES != CSM_SW_MAJOR_VERSION_TYPES) || \
     (CRYPTO_SW_MINOR_VERSION_TYPES != CSM_SW_MINOR_VERSION_TYPES) || \
     (CRYPTO_SW_PATCH_VERSION_TYPES != CSM_SW_PATCH_VERSION_TYPES) \
    )
#error "Software Version Numbers of Crypto_Types.h and Csm_Types.h are different"
#endif


/* Check if Crypto types header file and Crypto Cfg header file are of the same vendor */
#if (CRYPTO_VENDOR_ID_TYPES != CRYPTO_VENDOR_ID_CFG)
#error "Crypto_Types.h and Crypto_Cfg.h have different vendor ids"
#endif

/* Check if Crypto types header file and Crypto Cfg header file are of the same Autosar version */
#if ((CRYPTO_AR_RELEASE_MAJOR_VERSION_TYPES != CRYPTO_AR_RELEASE_MAJOR_VERSION_CFG) || \
     (CRYPTO_AR_RELEASE_MINOR_VERSION_TYPES != CRYPTO_AR_RELEASE_MINOR_VERSION_CFG) || \
     (CRYPTO_AR_RELEASE_REVISION_VERSION_TYPES != CRYPTO_AR_RELEASE_REVISION_VERSION_CFG) \
    )
#error "AutoSar Version Numbers of Crypto_Types.h and Crypto_Cfg.h are different"
#endif

/* Check if Crypto types header file and Crypto Cfg header file are of the same Software version */
#if ((CRYPTO_SW_MAJOR_VERSION_TYPES != CRYPTO_SW_MAJOR_VERSION_CFG) || \
     (CRYPTO_SW_MINOR_VERSION_TYPES != CRYPTO_SW_MINOR_VERSION_CFG) || \
     (CRYPTO_SW_PATCH_VERSION_TYPES != CRYPTO_SW_PATCH_VERSION_CFG) \
    )
#error "Software Version Numbers of Crypto_Types.h and Crypto_Cfg.h are different"
#endif
/*==================================================================================================
*                                           CONSTANTS
==================================================================================================*/

/*==================================================================================================
*                                       DEFINES AND MACROS
==================================================================================================*/
/** 
* @violates @ref Crypto_Types_h_REF_4 Violates MISRA 2004 Required Rule 20.2, The names of standard library macros,
* @violates @ref Crypto_Types_h_REF_3 Violates MISRA 2004 Required Rule 19.4, C macros shall only expand to a braced initialiser,
*/ 
#define  ENCRYPT                CRYPTO_ENCRYPT
/** 
* @violates @ref Crypto_Types_h_REF_3 Violates MISRA 2004 Required Rule 19.4, C macros shall only expand to a braced initialiser,
*/ 
#define  DECRYPT                CRYPTO_DECRYPT
/** 
* @violates @ref Crypto_Types_h_REF_3 Violates MISRA 2004 Required Rule 19.4, C macros shall only expand to a braced initialiser,
*/ 
#define  HASH                   CRYPTO_HASH
/** 
* @violates @ref Crypto_Types_h_REF_3 Violates MISRA 2004 Required Rule 19.4, C macros shall only expand to a braced initialiser,
*/ 
#define  MAC_GENERATE           CRYPTO_MACGENERATE
/** 
* @violates @ref Crypto_Types_h_REF_3 Violates MISRA 2004 Required Rule 19.4, C macros shall only expand to a braced initialiser,
*/ 
#define  MAC_VERIFY             CRYPTO_MACVERIFY
/** 
* @violates @ref Crypto_Types_h_REF_3 Violates MISRA 2004 Required Rule 19.4, C macros shall only expand to a braced initialiser,
*/ 
#define  AEAD_ENCRYPT           CRYPTO_AEADENCRYPT
/** 
* @violates @ref Crypto_Types_h_REF_3 Violates MISRA 2004 Required Rule 19.4, C macros shall only expand to a braced initialiser,
*/ 
#define  AEAD_DECRYPT           CRYPTO_AEADDECRYPT
/** 
* @violates @ref Crypto_Types_h_REF_4 Violates MISRA 2004 Required Rule 20.2, The names of standard library macros,
* @violates @ref Crypto_Types_h_REF_3 Violates MISRA 2004 Required Rule 19.4, C macros shall only expand to a braced initialiser,
*/     
#define  SIGNATURE_GENERATE     CRYPTO_SIGNATUREGENERATE
/** 
* @violates @ref Crypto_Types_h_REF_4 Violates MISRA 2004 Required Rule 20.2, The names of standard library macros,
* @violates @ref Crypto_Types_h_REF_3 Violates MISRA 2004 Required Rule 19.4, C macros shall only expand to a braced initialiser,
*/ 
#define  SIGNATURE_VERIFY       CRYPTO_SIGNATUREVERIFY
/** 
* @violates @ref Crypto_Types_h_REF_3 Violates MISRA 2004 Required Rule 19.4, C macros shall only expand to a braced initialiser,
*/   
#define  SECCOUNTERINCREMENT    CRYPTO_SECCOUNTERINCREMENT
/** 
* @violates @ref Crypto_Types_h_REF_3 Violates MISRA 2004 Required Rule 19.4, C macros shall only expand to a braced initialiser,
*/ 
#define  SECCOUNTERREAD         CRYPTO_SECCOUNTERREAD
/** 
* @violates @ref Crypto_Types_h_REF_3 Violates MISRA 2004 Required Rule 19.4, C macros shall only expand to a braced initialiser,
*/ 
#define  RANDOM                 CRYPTO_RANDOMGENERATE 
/*==================================================================================================
*                                             ENUMS
==================================================================================================*/
#if (CRYPTO_KEYS_EXIST == 1U)
typedef enum
{
    CRYPTO_WA_DENIED        = 0x01U,
    CRYPTO_WA_INTERNAL_COPY = 0x02U,
    CRYPTO_WA_ALLOWED       = 0x03U,
    CRYPTO_WA_ENCRYPTED     = 0x04U
} Crypto_KeyElementWriteAccessType;

typedef enum
{
    CRYPTO_RA_DENIED         = 0x01U,
    CRYPTO_RA_INTERNAL_COPY  = 0x02U,
    CRYPTO_RA_ALLOWED        = 0x03U,
    CRYPTO_RA_ENCRYPTED      = 0x04U
} Crypto_KeyElementReadAccessType;

typedef enum
{
    CRYPTO_KE_FORMAT_BIN_OCTET                       = 0x01U,
    CRYPTO_KE_FORMAT_BIN_SHEKEYS                     = 0x02U,
    CRYPTO_KE_FORMAT_BIN_IDENT_PRIVATEKEY_PKCS8      = 0x03U,
    CRYPTO_KE_FORMAT_BIN_IDENT_PUBLICKEY             = 0x04U,
    CRYPTO_KE_FORMAT_BIN_RSA_PRIVATEKEY              = 0x05U,
    CRYPTO_KE_FORMAT_BIN_RSA_PUBLICKEY               = 0x06U,
    CRYPTO_KE_FORMAT_BIN_CERT_X509_V3                = 0x07U,
    CRYPTO_KE_FORMAT_BIN_CERT_CVC                    = 0x08U
} Crypto_KeyFormatType;
#endif

typedef enum
{
    CRYPTO_UNINIT = 0X00U,
    CRYPTO_IDLE   = 0x01U
} Crypto_InitStateType;

#if( CRYPTO_DEV_ERROR_DETECT == STD_ON )
typedef enum
{
    CRYPTO_NULL_PTR     = 0x00U,
    CRYPTO_INVALID_LEN  = 0x01U,
    CRYPTO_NO_ERROR     = 0x02U,
    CRYPTO_NOT_OK       = 0x03U
} Crypto_ErrorType;
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */

/*==================================================================================================
*                                 STRUCTURES AND OTHER TYPEDEFS
==================================================================================================*/
typedef struct
{
    CONST (Crypto_ServiceInfoType, CRYPTO_CONST) eService;
    CONST (Crypto_AlgorithmFamilyType, CRYPTO_CONST) eFamily;
    CONST (Crypto_AlgorithmModeType, CRYPTO_CONST) eMode;
    CONST (Crypto_AlgorithmFamilyType, CRYPTO_CONST) eSecondaryFamily;
} Crypto_PrimitiveType;

#if (CRYPTO_KEYS_EXIST == 1U)
typedef struct
{
    CONST(uint32, CRYPTO_CONST) u32CryptoKeyElementId;
    CONST(uint32, CRYPTO_CONST) u32CryptoKeyElementUniqueId;
    CONST(boolean, CRYPTO_CONST) bCryptoKeyElementAllowPartialAccess;
    CONST(Crypto_KeyFormatType, CRYPTO_CONST) Crypto_KeyFormatType;
    CONST(boolean, CRYPTO_CONST) bCryptoKeyElementPersist;
    CONST(Crypto_KeyElementReadAccessType, CRYPTO_CONST) eCryptoKeyElementReadAccess;
    CONST(uint32, CRYPTO_CONST) u32CryptoKeyElementMaxSize;
    VAR(uint32, CRYPTO_VAR) u32CryptoKeyElementActualSize;
    CONST(Crypto_KeyElementWriteAccessType, CRYPTO_CONST) eCryptoKeyElementWriteAccess;
    P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) pCryptoElementArray;
} Crypto_KeyElementType;

typedef struct
{
    CONST(uint32, CRYPTO_CONST) u32NoCryptoKeyElements;
    CONSTP2CONST(uint32, CRYPTO_VAR, CRYPTO_APPL_CONST) u32CryptoKeyElements; 
} Crypto_KeyElementsType;

typedef struct
{
    CONST(uint32, CRYPTO_CONST)  u32CryptoKeyId;
    CONST(uint32, CRYPTO_CONST)  u32CryptoKeyDeriveIterations;
    VAR(boolean, AUTOMATIC) bCryptoKeyValid;
    CONSTP2CONST(Crypto_KeyElementsType, CRYPTO_VAR, CRYPTO_APPL_CONST) pCryptoKeyElementList;
} Crypto_KeyType;
#endif

typedef struct
{
    VAR(uint32,AUTOMATIC) u32Next;
    P2CONST(Crypto_JobType, AUTOMATIC,CRYPTO_APPL_CONST) pJob;
} Crypto_QueueType;

typedef struct
{
    CONST(uint32, CRYPTO_CONST) u32CryptoDriverObjectId;
    P2VAR(Crypto_QueueType, AUTOMATIC, CRYPTO_APPL_DATA) pQueuedJobs;
    CONST(uint32, CRYPTO_CONST) u32CryptoQueueSize;
    VAR(uint32, CRYPTO_VAR) u32HeadOfFreeJobs;
    VAR(uint32, CRYPTO_VAR) u32HeadOfQueuedJobs;
    CONSTP2CONST(Crypto_PrimitiveType, CRYPTO_VAR, CRYPTO_APPL_CONST) pCryptoKeyPrimitives;
    CONST(uint32, CRYPTO_CONST) u32NoCryptoPrimitives;
} Crypto_ObjectType;

typedef struct
{
    VAR (Std_ReturnType, AUTOMATIC) eFound;
    VAR (uint32, AUTOMATIC) u32Counter;
} Crypto_VerifyKeyType;

typedef struct
{
    VAR (Std_ReturnType, AUTOMATIC) eFound;
    VAR (uint32, AUTOMATIC) u32Counter;
} Crypto_VerifyKeyElementType;

typedef struct
{
    VAR (Std_ReturnType, AUTOMATIC) eFound;
    VAR (uint32, AUTOMATIC) u32ObjectIndex;
} Crypto_VerifyObjectIdType;
/*==================================================================================================
*                                GLOBAL VARIABLE DECLARATIONS
==================================================================================================*/

/*==================================================================================================
*                                     FUNCTION PROTOTYPES
==================================================================================================*/

#ifdef __cplusplus
}
#endif

#endif /* CRYPTO_TYPES_H */

/** @} */
