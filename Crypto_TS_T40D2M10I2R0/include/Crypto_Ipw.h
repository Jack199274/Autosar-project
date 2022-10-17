/**
*   @file    Crypto_Ipw.h
*   @version 1.0.2
*
*   @brief   AUTOSAR Crypto - Separation header layer of high-low level drivers.
*   @details Header interface between common and low level driver.
*
*   @addtogroup Crypto
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

#ifndef CRYPTO_IPW_H
#define CRYPTO_IPW_H

#ifdef __cplusplus
extern "C"{
#endif

/**
* @page misra_violations MISRA-C:2004 violations
*
* @section Ctypto_Ipw_H_REF_1
*           Violates MISRA 2004 Required Rule 8.7, could define variable at block scope.
*
* @section Ctypto_Ipw_H_REF_2
*           Violates MISRA 2004 Required Rule 1.4, Identifier clash.
*           This violation is due to the requirement that request to have a file version check.
*
* @section Ctypto_Ipw_H_REF_3
*           Violates MISRA 2004 Required Rule 5.1, External identifiers shall be distinct.
*           The used compilers use more than 31 chars for identifiers.
*
* @section Ctypto_Ipw_H_REF_4
*           Violates MISRA 2004 Advisory Rule 19.7,A function should be used in preference to a function-like macro.
*           Use function like macro to improve performance and avoid a complex statement
*
* @section Ctypto_Ipw_H_REF_5
*           Violates MISRA 2004 Required Rule 19.10,In the definition of a function-like macro each instance of a
*           parameter shall be enclosed in parentheses unless it is used as the operand of # or ##.
*           Macro is used to call functions in underlying layers.
*
* @section Ctypto_Ipw_H_REF_6
*           Violates MISRA 2004 Required Rule 19.15, Repeated include file MemMap.h
*           of a header file being included more than once. This comes from the order of includes in the .c file
*           and from include dependencies. As a safe approach, any file must include all its dependencies.
*           Header files are already protected against double inclusions. The inclusion of Crypto_MemMap.h is as
*           per AUTOSAR requirement [SWS_MemMap_00003].
*/
/*==================================================================================================
*                                        INCLUDE FILES
* 1) system and project includes
* 2) needed interfaces from external units
* 3) internal and external interfaces from this unit
==================================================================================================*/
#include "SchM_Crypto.h"
#include "Crypto_Types.h"
#include "Crypto_Cse.h"
#include "Crypto_Cfg.h"
/*==================================================================================================
*                              SOURCE FILE VERSION INFORMATION
==================================================================================================*/
#define CRYPTO_VENDOR_ID_IPW_H                       43
/**
* @violates @ref Ctypto_Ipw_H_REF_2 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Ctypto_Ipw_H_REF_3 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_AR_RELEASE_MAJOR_VERSION_IPW_H        4
/**
* @violates @ref Ctypto_Ipw_H_REF_2 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Ctypto_Ipw_H_REF_3 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_AR_RELEASE_MINOR_VERSION_IPW_H        3
/**
* @violates @ref Ctypto_Ipw_H_REF_2 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Ctypto_Ipw_H_REF_3 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_AR_RELEASE_REVISION_VERSION_IPW_H     1
#define CRYPTO_SW_MAJOR_VERSION_IPW_H                1
#define CRYPTO_SW_MINOR_VERSION_IPW_H                0
#define CRYPTO_SW_PATCH_VERSION_IPW_H                2

/*==================================================================================================
*                                     FILE VERSION CHECKS
==================================================================================================*/

#if (CRYPTO_VENDOR_ID_IPW_H != CRYPTO_VENDOR_ID_TYPES)
#error "Crypto_Ipw.h and Crypto_Types.h have different vendor ids"
#endif

/* Check if Crypto Ipw header file and Crypto Types header file are of the same Autosar version */
#if ((CRYPTO_AR_RELEASE_MAJOR_VERSION_IPW_H != CRYPTO_AR_RELEASE_MAJOR_VERSION_TYPES) || \
     (CRYPTO_AR_RELEASE_MINOR_VERSION_IPW_H != CRYPTO_AR_RELEASE_MINOR_VERSION_TYPES) || \
     (CRYPTO_AR_RELEASE_REVISION_VERSION_IPW_H != CRYPTO_AR_RELEASE_REVISION_VERSION_TYPES) \
    )
#error "AutoSar Version Numbers of Crypto_Ipw.h and Crypto_Types.h are different"
#endif

/* Check if Crypto Ipw header file and Crypto Types header file are of the same Software version */
#if ((CRYPTO_SW_MAJOR_VERSION_IPW_H != CRYPTO_SW_MAJOR_VERSION_TYPES) || \
     (CRYPTO_SW_MINOR_VERSION_IPW_H != CRYPTO_SW_MINOR_VERSION_TYPES) || \
     (CRYPTO_SW_PATCH_VERSION_IPW_H != CRYPTO_SW_PATCH_VERSION_TYPES) \
    )
#error "Software Version Numbers of Crypto_Ipw.h and Crypto_Types.h are different"
#endif

/* Check if Crypto Ipw source file and Crypto Cse header file are of the same vendor */
#if (CRYPTO_VENDOR_ID_IPW_H != CRYPTO_CSE_H_VENDOR_ID )
#error "Crypt_Ipw.h and Crypto_Cse.h have different vendor ids"
#endif

/* Check if Crypto Ipw source file and Crypto Cse header file are of the same Autosar version */
#if ((CRYPTO_AR_RELEASE_MAJOR_VERSION_IPW_H != CRYPTO_CSE_H_AR_RELEASE_MAJOR_VERSION ) || \
     (CRYPTO_AR_RELEASE_MINOR_VERSION_IPW_H != CRYPTO_CSE_H_AR_RELEASE_MINOR_VERSION) || \
     (CRYPTO_AR_RELEASE_REVISION_VERSION_IPW_H != CRYPTO_CSE_H_AR_RELEASE_REVISION_VERSION) \
    )
#error "AutoSar Version Numbers of Crypto_Ipw.h and Crypto_Cse.h are different"
#endif

/* Check if Crypto Ipw source file and Crypto Cse header file are of the same Software version */
#if ((CRYPTO_SW_MAJOR_VERSION_IPW_H != CRYPTO_CSE_H_SW_MAJOR_VERSION) || \
     (CRYPTO_SW_MINOR_VERSION_IPW_H != CRYPTO_CSE_H_SW_MINOR_VERSION) || \
     (CRYPTO_SW_PATCH_VERSION_IPW_H != CRYPTO_CSE_H_SW_PATCH_VERSION) \
    )
#error "Software Version Numbers of Crypto_Ipw.h and Crypto_Cse.h are different"
#endif

/* Check if Crypto Ipw source file and Crypto Cfg header file are of the same vendor */
#if (CRYPTO_VENDOR_ID_IPW_H != CRYPTO_VENDOR_ID_CFG )
#error "Crypt_Ipw.h and Crypto_Cfg.h have different vendor ids"
#endif

/* Check if Crypto Ipw source file and Crypto Cfg header file are of the same Autosar version */
#if ((CRYPTO_AR_RELEASE_MAJOR_VERSION_IPW_H != CRYPTO_AR_RELEASE_MAJOR_VERSION_CFG ) || \
     (CRYPTO_AR_RELEASE_MINOR_VERSION_IPW_H != CRYPTO_AR_RELEASE_MINOR_VERSION_CFG) || \
     (CRYPTO_AR_RELEASE_REVISION_VERSION_IPW_H != CRYPTO_AR_RELEASE_REVISION_VERSION_CFG) \
    )
#error "AutoSar Version Numbers of Crypto_Ipw.h and Crypto_Cfg.h are different"
#endif

/* Check if Crypto Ipw source file and Crypto Cfg header file are of the same Software version */
#if ((CRYPTO_SW_MAJOR_VERSION_IPW_H != CRYPTO_SW_MAJOR_VERSION_CFG) || \
     (CRYPTO_SW_MINOR_VERSION_IPW_H != CRYPTO_SW_MINOR_VERSION_CFG) || \
     (CRYPTO_SW_PATCH_VERSION_IPW_H != CRYPTO_SW_PATCH_VERSION_CFG) \
    )
#error "Software Version Numbers of Crypto_Ipw.h and Crypto_Cfg.h are different"
#endif
/*==================================================================================================
*                                          CONSTANTS
==================================================================================================*/
#define     CRYPTO_LENGTH_OF_ARRAY_16                           16
/*==================================================================================================
*                                      DEFINES AND MACROS
==================================================================================================*/
#if (CRYPTO_KEY_EXPORT_EXIST == 1U)
/** 
* @violates @ref Ctypto_Ipw_H_REF_4 A function should be used in preference to a function-like macro.
* Macro is used for interaction of MCAL layers.
* @violates @ref Ctypto_Ipw_H_REF_5 A In the definition of a function-like macro each instance of a
* parameter shall be enclosed in parentheses unless it is used as the operand of # or ## 
*/
#define    Crypto_Ipw_ExportExtendedRamKey(cryptoKeyId,resultLengthPtr,resultPtr)                 (Crypto_Ipw_ExportRamKey(cryptoKeyId,resultLengthPtr,resultPtr))
#endif /*(CRYPTO_KEY_EXPORT_EXIST == 1U)*/

#if (CRYPTO_KEY_GEN_EXIST == 1U)
/** 
* @violates @ref Ctypto_Ipw_H_REF_4 A function should be used in preference to a function-like macro.
* Macro is used for interaction of MCAL layers.
*/
#define    Crypto_Ipw_GenerateExtendedRamKeysRandom(keyId)                                        (Crypto_Ipw_GenerateKeysRandom(keyId))
#endif /*(CRYPTO_KEY_GEN_EXIST == 1U)*/
/*==================================================================================================
*                                             ENUMS
==================================================================================================*/

/*==================================================================================================
*                                STRUCTURES AND OTHER TYPEDEFS
==================================================================================================*/

/*==================================================================================================
*                                GLOBAL VARIABLE DECLARATIONS
==================================================================================================*/
#define CRYPTO_START_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Ctypto_Ipw_H_REF_6 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

extern P2VAR(Crypto_ObjectType, AUTOMATIC, CRYPTO_APPL_DATA) Crypto_aObjectList[CRYPTO_NUMBER_OF_DRIVER_OBJECTS];

#define CRYPTO_STOP_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Ctypto_Ipw_H_REF_6 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

#define CRYPTO_START_SEC_VAR_NO_INIT_UNSPECIFIED
/**
* @violates @ref Ctypto_Ipw_H_REF_6 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"
/** @violates @ref Ctypto_Ipw_H_REF_1 Could define variable at block scope */
extern P2FUNC (void, CRYPTO_CODE, Crypto_Callback) (const Crypto_JobType* job, Std_ReturnType result);

#define CRYPTO_STOP_SEC_VAR_NO_INIT_UNSPECIFIED
/**
* @violates @ref Ctypto_Ipw_H_REF_6 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

#if (CRYPTO_KEYS_EXIST == 1U)

#define CRYPTO_START_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Ctypto_Ipw_H_REF_6 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

extern P2VAR(Crypto_KeyType, AUTOMATIC, CRYPTO_APPL_DATA) Crypto_aKeyList[CRYPTO_NUMBER_OF_KEYS];

extern P2VAR(Crypto_KeyElementType, AUTOMATIC, CRYPTO_APPL_DATA) Crypto_aKeyElementList[CRYPTO_NUMBER_OF_KEY_ELEMENTS];

#define CRYPTO_STOP_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Ctypto_Ipw_H_REF_6 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

#endif

#if (CRYPTO_KEY_GEN_EXIST == 1U) 

#define CRYPTO_START_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Ctypto_Ipw_H_REF_6 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

extern P2VAR(Crypto_Cse_RandomKeyParams, AUTOMATIC, CRYPTO_APPL_DATA) Crypto_aKeyGenerateList[CRYPTO_NUMBER_OF_KEY_GEN_ELEMENTS];

#define CRYPTO_STOP_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Ctypto_Ipw_H_REF_6 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

#endif

#if (CRYPTO_KEY_EXPORT_EXIST == 1U)

#define CRYPTO_START_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Ctypto_Ipw_H_REF_6 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

extern P2VAR(Crypto_Cse_GetKeyParams, AUTOMATIC, CRYPTO_APPL_DATA) Crypto_aExportKeyList[CRYPTO_NUMBER_OF_KEY_EXPORT_ELEMENTS];

#define CRYPTO_STOP_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Ctypto_Ipw_H_REF_6 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

#endif

/*==================================================================================================
*                                    FUNCTION PROTOTYPES
==================================================================================================*/
#define CRYPTO_START_SEC_CODE
/**
* @violates @ref Ctypto_Ipw_H_REF_6 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_Init (void);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_ProcessJob (VAR(uint32, AUTOMATIC) u32ObjectIdx, P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_LoadKey (VAR(uint32, AUTOMATIC) cryptoKeyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) pKeyPtr, VAR(uint32, AUTOMATIC) u32KeyLength);

FUNC(void, CRYPTO_CODE) Crypto_Ipw_MainFunction (void);  

FUNC(Crypto_VerifyKeyType, CRYPTO_CODE) Crypto_Ipw_VerifyKeyId (VAR(uint32, AUTOMATIC) u32keyId);

FUNC(Crypto_VerifyKeyElementType, CRYPTO_CODE) Crypto_Ipw_VerifyKeyElementId ( VAR(uint32, AUTOMATIC) u32KeyIndex, VAR(uint32, AUTOMATIC) u32keyElementId );

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_InstallCertificate (VAR(uint32, AUTOMATIC) cryptoKeyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) pKeyPtr, VAR(uint32, AUTOMATIC) u32KeyLength );
                                      
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_ExtendPrngSeed (P2CONST (uint8, AUTOMATIC, CRYPTO_APPL_CONST) entropy);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_CancelJob (VAR(uint32, AUTOMATIC) u32ObjectIdx, P2CONST(Crypto_JobInfoType, AUTOMATIC, CRYPTO_APPL_CONST) pJob);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_GenerateKeysRandom(VAR(uint32, AUTOMATIC) KeyId);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_ExportRamKey (VAR(uint32, AUTOMATIC) cryptoKeyId, P2VAR(uint32, AUTOMATIC, CRYPTO_APPL_DATA) resultLengthPtr, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) resultPtr);

FUNC(void, CRYPTO_CODE) Crypto_Ipw_CallBackNotification (VAR (Crypto_Cse_ErrorCodeType, AUTOMATIC) eOutResponse);
#define CRYPTO_STOP_SEC_CODE
/**
* @violates @ref Ctypto_Ipw_H_REF_6 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

#ifdef __cplusplus
}
#endif

#endif /* CRYPTO_IPW_H */

/** @} */
