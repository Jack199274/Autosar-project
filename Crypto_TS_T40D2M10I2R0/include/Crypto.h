/**
*   @file       Crypto.h
*   @implements Crypto.h_Artifact
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

#ifndef CRYPTO_H
#define CRYPTO_H

#ifdef __cplusplus
extern "C"{
#endif

/**
* @page misra_violations MISRA-C:2004 violations
* @section Crypto_h_REF_1
* Violates MISRA 2004 Required Rule 1.4, Identifier clash.
* This violation is due to the requirement that request to have a file version check.
*
* @section Crypto_h_REF_2
* Violates MISRA 2004 Required Rule 5.1, External identifiers shall be distinct.
* The used compilers use more than 31 chars for identifiers.
*
* @section Crypto_h_REF_3
* Violates MISRA 2004 Required Rule 19.15, Repeated include file MemMap.h
* of a header file being included more than once. This comes from the order of includes in the .c file
* and from include dependencies. As a safe approach, any file must include all its dependencies.
* Header files are already protected against double inclusions. The inclusion of Crypto_MemMap.h is as
* per AUTOSAR requirement [SWS_MemMap_00003].
*/


/*==================================================================================================
*                                        INCLUDE FILES
* 1) system and project includes
* 2) needed interfaces from external units
* 3) internal and external interfaces from this unit
==================================================================================================*/


#include "Mcal.h"
#include "Crypto_Cfg.h"
#include "Csm_Types.h"
#include "Crypto_Ipw.h"

/*==================================================================================================
*                              SOURCE FILE VERSION INFORMATION
==================================================================================================*/
/**
* @file           Crypto.h    
*/
#define CRYPTO_VENDOR_ID                       43
#define CRYPTO_MODULE_ID                       114
/**
* @violates @ref Crypto_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_h_REF_2 Violates MISRA 2004 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_AR_RELEASE_MAJOR_VERSION        4
/**
* @violates @ref Crypto_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_h_REF_2 Violates MISRA 2004 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_AR_RELEASE_MINOR_VERSION        3
/**
* @violates @ref Crypto_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_h_REF_2 Violates MISRA 2004 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_AR_RELEASE_REVISION_VERSION     1
#define CRYPTO_SW_MAJOR_VERSION                1
#define CRYPTO_SW_MINOR_VERSION                0
#define CRYPTO_SW_PATCH_VERSION                2

/*==================================================================================================
*                                    FILE VERSION CHECKS
==================================================================================================*/
#ifndef DISABLE_MCAL_INTERMODULE_ASR_CHECK
 /* Check if header file and Mcal header file are of the same AutoSar version */
 #if ((CRYPTO_AR_RELEASE_MAJOR_VERSION != MCAL_AR_RELEASE_MAJOR_VERSION) || \
      (CRYPTO_AR_RELEASE_MINOR_VERSION != MCAL_AR_RELEASE_MINOR_VERSION) \
     )
 #error "AutoSar Version Numbers of Crypto.h and Mcal.h are different"
 #endif 
#endif


/* Check if Crypto header file and Crypto configuration header file are of the same vendor */
#if (CRYPTO_VENDOR_ID != CRYPTO_VENDOR_ID_CFG)
#error "Crypto.h and Crypto_Cfg.h have different vendor ids"
#endif

/* Check if Crypto source file and Crypto configuration header file are of the same Autosar version */
#if ((CRYPTO_AR_RELEASE_MAJOR_VERSION != CRYPTO_AR_RELEASE_MAJOR_VERSION_CFG) || \
     (CRYPTO_AR_RELEASE_MINOR_VERSION != CRYPTO_AR_RELEASE_MINOR_VERSION_CFG) || \
     (CRYPTO_AR_RELEASE_REVISION_VERSION != CRYPTO_AR_RELEASE_REVISION_VERSION_CFG) \
    )
#error "AutoSar Version Numbers of Crypto.h and Crypto_Cfg.h are different"
#endif

/* Check if Crypto source file and Crypto configuration header file are of the same Software version */
#if ((CRYPTO_SW_MAJOR_VERSION != CRYPTO_SW_MAJOR_VERSION_CFG) || \
     (CRYPTO_SW_MINOR_VERSION != CRYPTO_SW_MINOR_VERSION_CFG) || \
     (CRYPTO_SW_PATCH_VERSION != CRYPTO_SW_PATCH_VERSION_CFG) \
    )
#error "Software Version Numbers of Crypto.h and Crypto_Cfg.h are different"
#endif



/* Check if Crypto header file and Csm types header file are of the same vendor */
#if (CRYPTO_VENDOR_ID != CSM_VENDOR_ID_TYPES)
#error "Crypto.h and Csm_Types.h have different vendor ids"
#endif

#ifndef DISABLE_MCAL_INTERMODULE_ASR_CHECK
/* Check if Crypto source file and Csm types header file are of the same Autosar version */
#if ((CRYPTO_AR_RELEASE_MAJOR_VERSION != CSM_AR_RELEASE_MAJOR_VERSION_TYPES) || \
     (CRYPTO_AR_RELEASE_MINOR_VERSION != CSM_AR_RELEASE_MINOR_VERSION_TYPES) || \
     (CRYPTO_AR_RELEASE_REVISION_VERSION != CSM_AR_RELEASE_REVISION_VERSION_TYPES) \
    )
#error "AutoSar Version Numbers of Crypto.h and Csm_Types.h are different"
#endif
#endif /*DISABLE_MCAL_INTERMODULE_ASR_CHECK*/

/* Check if Crypto source file and Csm types header file are of the same Software version */
#if ((CRYPTO_SW_MAJOR_VERSION != CSM_SW_MAJOR_VERSION_TYPES) || \
     (CRYPTO_SW_MINOR_VERSION != CSM_SW_MINOR_VERSION_TYPES) || \
     (CRYPTO_SW_PATCH_VERSION != CSM_SW_PATCH_VERSION_TYPES) \
    )
#error "Software Version Numbers of Crypto.h and Csm_Types.h are different"
#endif

/* Check if Crypto header file and Crypto IPW header file are of the same vendor */
#if (CRYPTO_VENDOR_ID != CRYPTO_VENDOR_ID_IPW_H)
#error "Crypto.h and Crypto_Ipw.h have different vendor ids"
#endif

/* Check if Crypto source file and Crypto IPW header file are of the same Autosar version */
#if ((CRYPTO_AR_RELEASE_MAJOR_VERSION != CRYPTO_AR_RELEASE_MAJOR_VERSION_IPW_H) || \
     (CRYPTO_AR_RELEASE_MINOR_VERSION != CRYPTO_AR_RELEASE_MINOR_VERSION_IPW_H) || \
     (CRYPTO_AR_RELEASE_REVISION_VERSION != CRYPTO_AR_RELEASE_REVISION_VERSION_IPW_H) \
    )
#error "AutoSar Version Numbers of Crypto.h and Crypto_Ipw.h are different"
#endif

/* Check if Crypto source file and Crypto IPW header file are of the same Software version */
#if ((CRYPTO_SW_MAJOR_VERSION != CRYPTO_SW_MAJOR_VERSION_IPW_H) || \
     (CRYPTO_SW_MINOR_VERSION != CRYPTO_SW_MINOR_VERSION_IPW_H) || \
     (CRYPTO_SW_PATCH_VERSION != CRYPTO_SW_PATCH_VERSION_IPW_H) \
    )
#error "Software Version Numbers of Crypto.h and Crypto_Ipw.h are different"
#endif

/*==================================================================================================
*                                           CONSTANTS
==================================================================================================*/

/*==================================================================================================
*                                       DEFINES AND MACROS
==================================================================================================*/

/**
* @brief   The service request failed because the service is still busy.
* 
* */
#define CRYPTO_E_BUSY                       ((uint8)0x02U)

/**
* @brief   The service request failed because the provided buffer is too small to store the result.
* 
* */
#define CRYPTO_E_SMALL_BUFFER               ((uint8)0x03U)

/**
* @brief   The service request failed because the entropy of the random number generator is exhausted.
* 
* */
/**
* @violates @ref Crypto_c_REF_3 A project should not contain unused macro declarations.
*/
#define CRYPTO_E_ENTROPY_EXHAUSTION         ((uint8)0x04U)

/**
* @brief   The service request failed because the queue is full.
* 
* */
#define CRYPTO_E_QUEUE_FULL                 ((uint8)0x05U)

/**
* @brief   The service request failed because read access failed.
* 
* */
#define CRYPTO_E_KEY_READ_FAIL              ((uint8)0x06U)

/**
* @brief   The service request failed because write access failed.
* 
* */
#define CRYPTO_E_KEY_WRITE_FAIL             ((uint8)0x07U)

/**
* @brief   The service request failed because the key is not available.
* 
* */
#define CRYPTO_E_KEY_NOT_AVAILABLE          ((uint8)0x08U)

/**
* @brief   The service request failed because at least one needed key element is invalid.
* 
* */
#define CRYPTO_E_KEY_NOT_VALID              ((uint8)0x09U)

#if (CRYPTO_KEYS_EXIST == 1U)
/**
* @brief   The service request failed because the key element is not partially accessible and the provided key element length is too short or too long for that key element.
* 
* */
#define CRYPTO_E_KEY_SIZE_MISMATCH          ((uint8)0x0AU)
#endif /* (CRYPTO_KEYS_EXIST == 1U) */

/**
* @brief   The service request failed because the counter overflowed.
* 
* */
/**
* @violates @ref Crypto_c_REF_3 A project should not contain unused macro declarations.
*/
#define CRYPTO_E_COUNTER_OVERFLOW           ((uint8)0x0BU)


/**
* @brief   The service request failed because the Job has been canceled.
* 
* */
/**
* @violates @ref Crypto_c_REF_3 A project should not contain unused macro declarations.
*/
#define CRYPTO_E_JOB_CANCELED               ((uint8)0x0CU)

/**
* @brief          Development error codes (passed to DET).
* @implements     DETERRORCODE_enumeration
*/

#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
    /**
    * @brief   API request called before initialization of Crypto Driver.
    * 
    * */
    #define CRYPTO_E_UNINIT                    ((uint8)0x00U)

    /**
    * @brief   Initiation of Crypto Driver failed
    *         
    * */
    #define CRYPTO_E_INIT_FAILED               ((uint8)0x01U)
    
    /**
    * @brief   API request called with invalid parameter (Nullpointer).
    *         
    * */
    #define CRYPTO_E_PARAM_POINTER             ((uint8)0x02U)
        /**
    * @brief   API request called with invalid parameter (out of range).
    * 
    * */
    #define CRYPTO_E_PARAM_HANDLE              ((uint8)0x04U)
    
    /**
    * @brief   API request called with invalid parameter (invalid value).
    *         
    * */
    #define CRYPTO_E_PARAM_VALUE               ((uint8)0x05U)

#endif /* (CRYPTO_DEV_ERROR_DETECT == 1U) */


/* DET Runtime errors */

/**
* @brief Buffer is too small for operation
* */
#define CRYPTO_E_RE_SMALL_BUFFER             ((uint8)0x00U)

#if (CRYPTO_KEYS_EXIST == 1U)
/**
* @brief Requested key is not available
* */
#define CRYPTO_E_RE_KEY_NOT_AVAILABLE        ((uint8)0x01U)

/**
* @brief Key cannot be read
* */
#define CRYPTO_E_RE_KEY_READ_FAIL            ((uint8)0x02U)
#endif /* (CRYPTO_KEYS_EXIST == 1U) */

/**
* @brief Entropy is too low
* */
/**
* @violates @ref Crypto_c_REF_3 A project should not contain unused macro declarations.
*/
#define CRYPTO_E_RE_ENTROPY_EXHAUSTED        ((uint8)0x03U)


/**
          AUTOSAR API's service IDs
*/

#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
/**
* @brief API service ID for Crypto_Init function
* */
#define CRYPTO_INIT_ID            ((uint8)0x01U)
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */

#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
/**
* @brief API service ID for Crypto_GetVersionInfo function
* */
#define CRYPTO_GETVERSIONINFO_ID            ((uint8)0x01U)
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
/**
* @brief API service ID for Crypto_ProcessJob function
* */
#define CRYPTO_PROCESSJOB_ID                ((uint8)0x03U)

#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
/**
* @brief API service ID for Crypto_CancelJob function
* */
#define CRYPTO_CANCELJOB_ID                 ((uint8)0x0EU)

#if (CRYPTO_KEYS_EXIST == 1U)
/**
* @brief API service ID for Crypto_KeyElementSet function
* */
#define CRYPTO_KEYELEMENTSET_ID             ((uint8)0x04U)

/**
* @brief API service ID for Crypto_KeyValidSet function
* */
#define CRYPTO_KEYVALIDSET_ID               ((uint8)0x05U)
#endif /* (CRYPTO_KEYS_EXIST == 1U) */
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */

#if (CRYPTO_KEYS_EXIST == 1U)
/**
* @brief API service ID for Crypto_KeyElementGet function
* */
#define CRYPTO_KEYELEMENTGET_ID             ((uint8)0x06U)
#endif /* (CRYPTO_KEYS_EXIST == 1U) */

#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
#if (CRYPTO_KEYS_EXIST == 1U)
/**
* @brief API service ID for Crypto_KeyElementCopy function
* */
#define CRYPTO_KEYELEMENTCOPY_ID            ((uint8)0x0FU)
#endif /* (CRYPTO_KEYS_EXIST == 1U) */

#if (CRYPTO_KEYS_EXIST == 1U)
/**
* @brief API service ID for Crypto_KeyCopy function
* */
#define CRYPTO_KEYCOPY_ID                   ((uint8)0x10U)
#endif /* (CRYPTO_KEYS_EXIST == 1U) */

#if (CRYPTO_KEYS_EXIST == 1U)
/**
* @brief API service ID for Crypto_KeyElementIdsGet function
* */
#define CRYPTO_KEYELEMENTIDSGET_ID          ((uint8)0x11U)
#endif /* (CRYPTO_KEYS_EXIST == 1U) */

/**
* @brief API service ID for Crypto_RandomSeed function
* */
#define CRYPTO_RANDOMSEED_ID                ((uint8)0x0DU)

/**
* @brief API service ID for Crypto_KeyGenerate function
* */
#define CRYPTO_KEYGENERATE_ID               ((uint8)0x07U)

/**
* @brief API service ID for Crypto_KeyDerive function
* */
#define CRYPTO_KEYDERIVE_ID                 ((uint8)0x08U)

/**
* @brief API service ID for Crypto_KeyExchangeCalcPubVal function
* */
#define CRYPTO_KEYEXCHANGECALCPUBVAL_ID     ((uint8)0x09U)

/**
* @brief API service ID for Crypto_KeyExchangeCalcSecret function
* */
#define CRYPTO_KEYEXCHANGECALCSECRET_ID     ((uint8)0x0AU)

/**
* @brief API service ID for Crypto_CertificateParse function
* */
#define CRYPTO_CERTIFICATEPARSE_ID          ((uint8)0x0BU)

/**
* @brief API service ID for Crypto_CertificateVerify function
* */
#define CRYPTO_CERTIFICATEVERIFY_ID         ((uint8)0x12U)
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */

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
/**
* @violates @ref Crypto_h_REF_3 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

FUNC(void, CRYPTO_CODE) Crypto_Init( void );

#if ( CRYPTO_VERSION_INFO_API == STD_ON )
FUNC(void, CRYPTO_CODE) Crypto_GetVersionInfo (P2VAR( Std_VersionInfoType, AUTOMATIC, CRYPTO_APPL_DATA ) versioninfo);
#endif  /* CRYPTO_VERSION_INFO_API == STD_ON */

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_ProcessJob (VAR(uint32, AUTOMATIC) u32ObjectId, P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_CancelJob (VAR(uint32, AUTOMATIC) u32ObjectId, P2CONST(Crypto_JobInfoType, AUTOMATIC, CRYPTO_APPL_CONST) pJob);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_CertificateParse (VAR(uint32, AUTOMATIC) cryptoKeyId);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_CertificateVerify (VAR(uint32, AUTOMATIC) cryptoKeyId, VAR(uint32, AUTOMATIC) verifyCryptoKeyId, 
                                                            P2VAR(Crypto_VerifyResultType, AUTOMATIC, CRYPTO_APPL_DATA) verifyPtr
                                                            );

FUNC(void, CRYPTO_CODE) Crypto_MainFunction( void );

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyElementSet (VAR(uint32, AUTOMATIC) cryptoKeyId, VAR(uint32, AUTOMATIC) keyElementId, 
                                                        P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) keyPtr, VAR(uint32, AUTOMATIC) keyLength
                                                        );

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyValidSet (VAR(uint32, AUTOMATIC) cryptoKeyId);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeySetValid (VAR(uint32, AUTOMATIC) cryptoKeyId);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyElementGet (VAR(uint32, AUTOMATIC) cryptoKeyId, VAR(uint32, AUTOMATIC) keyElementId, 
                                                        P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) resultPtr, P2VAR(uint32, AUTOMATIC, CRYPTO_APPL_DATA) resultLengthPtr
                                                        );

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyElementCopy (VAR(uint32, AUTOMATIC) cryptoKeyId, VAR(uint32, AUTOMATIC) keyElementId, 
                                                        VAR(uint32, AUTOMATIC) targetCryptoKeyId, VAR(uint32, AUTOMATIC) targetKeyElementId
                                                         );

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyCopy (VAR(uint32, AUTOMATIC) cryptoKeyId, VAR(uint32, AUTOMATIC) targetCryptoKeyId);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyElementIdsGet (VAR(uint32, AUTOMATIC) cryptoKeyId, P2VAR(uint32, AUTOMATIC, CRYPTO_APPL_DATA) keyElementIdsPtr,
                                                           P2VAR(uint32, AUTOMATIC, CRYPTO_APPL_DATA) keyElementIdsLengthPtr
                                                           );

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_RandomSeed (VAR(uint32, AUTOMATIC) cryptoKeyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) seedPtr, VAR(uint32, AUTOMATIC) seedLength);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyGenerate (VAR(uint32, AUTOMATIC) cryptoKeyId);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyDerive (VAR(uint32, AUTOMATIC) cryptoKeyId, VAR(uint32, AUTOMATIC) targetCryptoKeyId);

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyExchangeCalcPubVal (VAR(uint32, AUTOMATIC) cryptoKeyId, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) publicValuePtr,
                                                                P2VAR(uint32, AUTOMATIC, CRYPTO_APPL_DATA) publicValueLengthPtr
                                                                );

FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyExchangeCalcSecret (VAR(uint32, AUTOMATIC) cryptoKeyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) partnerPublicValuePtr, 
                                                                VAR(uint32, AUTOMATIC) partnerPublicValueLength
                                                                );

#define CRYPTO_STOP_SEC_CODE
/**
* @violates @ref Crypto_h_REF_3 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

#ifdef __cplusplus
}
#endif

#endif /* CRYPTO_H */

/** @} */
