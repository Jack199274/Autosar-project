/**
*   @file    Crypto_Cse.h
*
*   @version 1.0.2
*   @brief   AUTOSAR Crypto - Cryptographic (Crypto) interface
*   @details API header for Crypto driver.
*
*   @addtogroup  Crypto_Cse
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

#ifndef CRYPTO_CSE_H
#define CRYPTO_CSE_H

#ifdef __cplusplus
extern "C"{
#endif

/**
* @page misra_violations MISRA-C:2004 violations
*
* @section Crypto_Cse_H_REF_1
*          Violates MISRA 2004 Required Rule 19.15, Precautions shall be taken in order to
*          prevent the contents of a header file being included twice. All header files are
*          protected against multiple inclusions.
*
*/

/*==================================================================================================
*                                        INCLUDE FILES
* 1) system and project includes
* 2) needed interfaces from external units
* 3) internal and external interfaces from this unit
==================================================================================================*/

#include "Crypto_CseTypes.h"
#include "Mcal.h"
#include "Crypto_Cfg.h"
#include "Crypto_Types.h"

/*==================================================================================================
*                              SOURCE FILE VERSION INFORMATION
==================================================================================================*/


/*==================================================================================================
*                                    FILE VERSION CHECKS
==================================================================================================*/
#define CRYPTO_CSE_H_VENDOR_ID                       43
#define CRYPTO_CSE_H_AR_RELEASE_MAJOR_VERSION        4
#define CRYPTO_CSE_H_AR_RELEASE_MINOR_VERSION        3
#define CRYPTO_CSE_H_AR_RELEASE_REVISION_VERSION     1
#define CRYPTO_CSE_H_SW_MAJOR_VERSION                1
#define CRYPTO_CSE_H_SW_MINOR_VERSION                0
#define CRYPTO_CSE_H_SW_PATCH_VERSION                2


/*==================================================================================================
*                                           CONSTANTS
==================================================================================================*/

/*==================================================================================================
*                                       DEFINES AND MACROS
==================================================================================================*/

/*==================================================================================================
*                                             ENUMS
==================================================================================================*/

/*==================================================================================================
*                                 STRUCTURES AND OTHER TYPEDEFS
==================================================================================================*/

/*==================================================================================================
*                                GLOBAL VARIABLE DECLARATIONS
==================================================================================================*/

/*==================================================================================================
*                                     FUNCTION PROTOTYPES
==================================================================================================*/


#define CRYPTO_START_SEC_CODE

#include "Crypto_MemMap.h"

FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_EcbEncrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) plainTextPtr,
                                                    VAR(uint32, AUTOMATIC) plainTextLength, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) cipherTextPtr
                                                   );
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_EcbAsyncEncrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) plainTextPtr,
                                                    VAR(uint32, AUTOMATIC) plainTextLength, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) cipherTextPtr
                                                   );
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_EcbDecrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) cipherTextPtr,
                                                    VAR(uint32, AUTOMATIC) cipherTextLength, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) plainTextPtr
                                                   );
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_EcbAsyncDecrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) cipherTextPtr,
                                                    VAR(uint32, AUTOMATIC) cipherTextLength, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) plainTextPtr
                                                   );
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_CbcEncrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) plainTextPtr,
                                                    VAR(uint32, AUTOMATIC) plainTextLength, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) ivPtr,
                                                    P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) cipherTextPtr
                                                   );
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_CbcAsyncEncrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) plainTextPtr,
                                                    VAR(uint32, AUTOMATIC) plainTextLength, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) ivPtr,
                                                    P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) cipherTextPtr
                                                   );
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_CbcDecrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) cipherTextPtr,
                                                    VAR(uint32, AUTOMATIC) cipherTextLength, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) ivPtr,
                                                    P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) plainTextPtr
                                                   );
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_CbcAsyncDecrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) cipherTextPtr,
                                                    VAR(uint32, AUTOMATIC) cipherTextLength, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) ivPtr,
                                                    P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) plainTextPtr
                                                   );
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_MacGenerate(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) dataPtr,
                                                     VAR(uint32, AUTOMATIC) dataLength, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) macPtr
                                                    );
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_MacAsyncGenerate(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) dataPtr,
                                                     VAR(uint32, AUTOMATIC) dataLength, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) macPtr
                                                    );
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_MacVerify(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) dataPtr,
                                                    VAR(uint32, AUTOMATIC) dataLength, VAR(uint32, AUTOMATIC) macLength,
                                                    P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) macRefPtr, P2VAR(Crypto_VerifyResultType, AUTOMATIC, CRYPTO_APPL_DATA) verifyPtr);   
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_MacAsyncVerify(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) dataPtr,
                                                    VAR(uint32, AUTOMATIC) dataLength, VAR(uint32, AUTOMATIC) macLength,
                                                    P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) macRefPtr, P2VAR(Crypto_VerifyResultType, AUTOMATIC, CRYPTO_APPL_DATA) verifyPtr);  
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_LoadKey(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) keyM1Ptr,
                                                    P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) keyM2Ptr, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) keyM3Ptr
                                                );
                                                        
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_PlainKey(P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) keyPtr);

FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_ExportRamKey(P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) keyPtr);
                                                       
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_InitRng( void );

FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_ExtendPrngSeed(P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) entropyPtr);

FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_GenerateRnd(P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) rndPtr);

FUNC(boolean, CRYPTO_CODE) Crypto_Cse_IsBusy(void);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Cse_Cancel(void);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Cse_CheckHwInit(void);

FUNC(void, CRYPTO_CODE) Crypto_Cse_FTFCProcessInterrupt(void);
#define CRYPTO_STOP_SEC_CODE

/**
* @brief Include Memory mapping specification
* @violates @ref Crypto_Cse_H_REF_1 MISRA 2004 Required Rule 19.15 precautions to prevent the contents
*                of a header file being included twice
*/
#include "Crypto_MemMap.h"

#ifdef __cplusplus
}
#endif

#endif /* CRYPTO_CSE_H */

/** @} */
