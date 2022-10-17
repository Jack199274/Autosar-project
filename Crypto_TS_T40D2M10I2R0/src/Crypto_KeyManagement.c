/**
*   @file    Crypto_KeyManagement.c
*   @implements Crypto_KeyManagement.c_Artifact
*   @version 1.0.2
*   @brief   AUTOSAR Crypto - Cryptographic Services Engine (CRYPTO) functions
*   @details Contains functions for accessing CRYPTO from the CRYPTO driver perspective
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

#ifdef __cplusplus
extern "C"{
#endif

/**
* @page misra_violations MISRA-C:2004 violations
*
* @section Crypto_KeyManagement_c_REF_1
*           Violates MISRA 2004 Required Rule 1.4, The compiler/linker shall be checked
*           to ensure that 31 character significance 
*           and case sensitivity are supported for external identifiers.
*
* @section Crypto_KeyManagement_c_REF_2
*           Violates MISRA 2004 Required Rule 5.1, Identifiers (internal and external) shall not rely
*           on the significance of more than 31 characters. All compilers used support more than 31 chars for
*           identifiers.
*
* @section Crypto_KeyManagement_c_REF_3
*           Violates MISRA 2004 Advisory Rule 19.1, #include preceded by non preproc directives.
*           This violation is not fixed since the inclusion of MemMap.h is as per Autosar requirement MEMMAP003.
*
* @section Crypto_KeyManagement_c_REF_4
*           Violates MISRA 2004 Required Rule 19.15, Repeated include file MemMap.h
*           of a header file being included more than once. This comes from the order of includes in the .c file
*           and from include dependencies. As a safe approach, any file must include all its dependencies.
*           Header files are already protected against double inclusions. The inclusion of Crypto_MemMap.h is as
*           per AUTOSAR requirement [SWS_MemMap_00003].
*
* @section Crypto_KeyManagement_c_REF_5
*           Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer
*           arithmetic but used due to the code complexity.
*           they are referenced in only one translation unit.
*           These functions represent the API of the driver. External linkage is needed to "export" the API.
*
* @section Crypto_KeyManagement_c_REF_6
*          Violates MISRA 2004 Required Rule 8.10, could be made static The respective code could not be made 
*          static because of layers architecture design of the driver.
*
* @section Crypto_KeyManagement_c_REF_7
*           Violates MISRA 2004 Required Rule 8.7, could define variable at block scope.
*
*/



/*==================================================================================================
*                                        INCLUDE FILES
* 1) system and project includes
* 2) needed interfaces from external units
* 3) internal and external interfaces from this unit
==================================================================================================*/
/**
* @file           Crypto_KeyManagement.c    
*/
#include "Crypto.h"
#include "CryIf_Cbk.h"
#include "Crypto_KeyManagement.h"
#include "Det.h"
#include "Crypto_Ipw.h"

/*==================================================================================================
*                                       SOURCE FILE VERSION INFORMATION
==================================================================================================*/
/**
* @file           Crypto_KeyManagement.c
*/

/**
* @violates @ref Crypto_KeyManagement_c_REF_1 Violates MISRA 2004 Required Rule 1.4 The compiler/linker shall be checked.
*
* @violates @ref Crypto_KeyManagement_c_REF_2 Violates MISRA 2004 Required Rule 5.1 Identifiers (internal and external).
*/
#define CRYPTO_KEY_MANAGEMENT_VENDOR_ID_C                     43
/**
* @violates @ref Crypto_KeyManagement_c_REF_1 Violates MISRA 2004 Required Rule 1.4 The compiler/linker shall be checked.
*
* @violates @ref Crypto_KeyManagement_c_REF_2 Violates MISRA 2004 Required Rule 5.1 Identifiers (internal and external).
*/
#define CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MAJOR_VERSION_C      4
/**
* @violates @ref Crypto_KeyManagement_c_REF_1 Violates MISRA 2004 Required Rule 1.4 The compiler/linker shall be checked.
*
* @violates @ref Crypto_KeyManagement_c_REF_2 Violates MISRA 2004 Required Rule 5.1 Identifiers (internal and external).
*/
#define CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MINOR_VERSION_C      3
/**
* @violates @ref Crypto_KeyManagement_c_REF_1 Violates MISRA 2004 Required Rule 1.4 The compiler/linker shall be checked.
*
* @violates @ref Crypto_KeyManagement_c_REF_2 Violates MISRA 2004 Required Rule 5.1 Identifiers (internal and external).
*/
#define CRYPTO_KEY_MANAGEMENT_AR_RELEASE_REVISION_VERSION_C   1
/**
* @violates @ref Crypto_KeyManagement_c_REF_1 Violates MISRA 2004 Required Rule 1.4 The compiler/linker shall be checked.
*
* @violates @ref Crypto_KeyManagement_c_REF_2 Violates MISRA 2004 Required Rule 5.1 Identifiers (internal and external).
*/
#define CRYPTO_KEY_MANAGEMENT_SW_MAJOR_VERSION_C              1
/**
* @violates @ref Crypto_KeyManagement_c_REF_1 Violates MISRA 2004 Required Rule 1.4 The compiler/linker shall be checked.
*
* @violates @ref Crypto_KeyManagement_c_REF_2 Violates MISRA 2004 Required Rule 5.1 Identifiers (internal and external).
*/
#define CRYPTO_KEY_MANAGEMENT_SW_MINOR_VERSION_C              0
/**
* @violates @ref Crypto_KeyManagement_c_REF_1 Violates MISRA 2004 Required Rule 1.4 The compiler/linker shall be checked.
*
* @violates @ref Crypto_KeyManagement_c_REF_2 Violates MISRA 2004 Required Rule 5.1 Identifiers (internal and external).
*/
#define CRYPTO_KEY_MANAGEMENT_SW_PATCH_VERSION_C              2
/*==================================================================================================
*                                      FILE VERSION CHECKS
==================================================================================================*/
/* Check if Crypto key management source file and Crypto header file are of the same vendor */
#if (CRYPTO_KEY_MANAGEMENT_VENDOR_ID_C != CRYPTO_VENDOR_ID)
#error "Crypto_KeyManagement.c and Crypto.h have different vendor ids"
#endif

/* Check if Crypto key management source file and Crypto header file are of the same Autosar version */
#if ((CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MAJOR_VERSION_C != CRYPTO_AR_RELEASE_MAJOR_VERSION) || \
     (CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MINOR_VERSION_C != CRYPTO_AR_RELEASE_MINOR_VERSION) || \
     (CRYPTO_KEY_MANAGEMENT_AR_RELEASE_REVISION_VERSION_C != CRYPTO_AR_RELEASE_REVISION_VERSION) \
    )
#error "AutoSar Version Numbers of Crypto_KeyManagement.c and Crypto.h are different"
#endif

/* Check if Crypto key management source file and Crypto header file are of the same Software version */
#if ((CRYPTO_KEY_MANAGEMENT_SW_MAJOR_VERSION_C != CRYPTO_SW_MAJOR_VERSION) || \
     (CRYPTO_KEY_MANAGEMENT_SW_MINOR_VERSION_C != CRYPTO_SW_MINOR_VERSION) || \
     (CRYPTO_KEY_MANAGEMENT_SW_PATCH_VERSION_C != CRYPTO_SW_PATCH_VERSION) \
    )
#error "Software Version Numbers of Crypto_KeyManagement.c and Crypto.h are different"
#endif



/* Check if Crypto key management source file and CryIf callback header file are of the same vendor */
#if (CRYPTO_KEY_MANAGEMENT_VENDOR_ID_C != CRYIF_CBK_VENDOR_ID)
#error "Crypto_KeyManagement.c and CryIf_Cbk.h have different vendor ids"
#endif

#ifndef DISABLE_MCAL_INTERMODULE_ASR_CHECK
/* Check if Crypto key management source file and CryIf callback header file are of the same Autosar version */
#if ((CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MAJOR_VERSION_C != CRYIF_CBK_AR_RELEASE_MAJOR_VERSION) || \
     (CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MINOR_VERSION_C != CRYIF_CBK_AR_RELEASE_MINOR_VERSION) || \
     (CRYPTO_KEY_MANAGEMENT_AR_RELEASE_REVISION_VERSION_C != CRYIF_CBK_AR_RELEASE_REVISION_VERSION) \
    )
#error "AutoSar Version Numbers of Crypto_KeyManagement.c and CryIf_Cbk.h are different"
#endif
#endif /*DISABLE_MCAL_INTERMODULE_ASR_CHECK*/

/* Check if Crypto key management source file and CryIf callback header file are of the same Software version */
#if ((CRYPTO_KEY_MANAGEMENT_SW_MAJOR_VERSION_C != CRYIF_CBK_SW_MAJOR_VERSION) || \
     (CRYPTO_KEY_MANAGEMENT_SW_MINOR_VERSION_C != CRYIF_CBK_SW_MINOR_VERSION) || \
     (CRYPTO_KEY_MANAGEMENT_SW_PATCH_VERSION_C != CRYIF_CBK_SW_PATCH_VERSION) \
    )
#error "Software Version Numbers of Crypto_KeyManagement.c and CryIf_Cbk.h are different"
#endif



/* Check if Crypto key management source file and Crypto key management header file are of the same vendor */
#if (CRYPTO_KEY_MANAGEMENT_VENDOR_ID_C != CRYPTO_KEY_MANAGEMENT_VENDOR_ID)
#error "Crypto_KeyManagement.c and Crypto_KeyManagement.h have different vendor ids"
#endif

/* Check if Crypto key management source file and Crypto key management header file are of the same Autosar version */
#if ((CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MAJOR_VERSION_C != CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MAJOR_VERSION) || \
     (CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MINOR_VERSION_C != CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MINOR_VERSION) || \
     (CRYPTO_KEY_MANAGEMENT_AR_RELEASE_REVISION_VERSION_C != CRYPTO_KEY_MANAGEMENT_AR_RELEASE_REVISION_VERSION) \
    )
#error "AutoSar Version Numbers of Crypto_KeyManagement.c and Crypto_KeyManagement.h are different"
#endif

/* Check if Crypto key management source file and Crypto key management header file are of the same Software version */
#if ((CRYPTO_KEY_MANAGEMENT_SW_MAJOR_VERSION_C != CRYPTO_KEY_MANAGEMENT_SW_MAJOR_VERSION) || \
     (CRYPTO_KEY_MANAGEMENT_SW_MINOR_VERSION_C != CRYPTO_KEY_MANAGEMENT_SW_MINOR_VERSION) || \
     (CRYPTO_KEY_MANAGEMENT_SW_PATCH_VERSION_C != CRYPTO_KEY_MANAGEMENT_SW_PATCH_VERSION) \
    )
#error "Software Version Numbers of Crypto_KeyManagement.c and Crypto_KeyManagement.h are different"
#endif

#ifndef DISABLE_MCAL_INTERMODULE_ASR_CHECK
 #if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
    #if ((CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MAJOR_VERSION_C != DET_AR_RELEASE_MAJOR_VERSION) || \
         (CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MINOR_VERSION_C != DET_AR_RELEASE_MINOR_VERSION) \
        )
    #error "AutoSar Version Numbers of Crypto_KeyManagement.c and Det.h are different"
    #endif
 #endif 
#endif

/* Check if Crypto header file and Crypto IPW header file are of the same vendor */
#if (CRYPTO_KEY_MANAGEMENT_VENDOR_ID_C != CRYPTO_VENDOR_ID_IPW_H)
#error "Crypto_KeyManagement.c and Crypto_Ipw.h have different vendor ids"
#endif

/* Check if Crypto source file and Crypto IPW header file are of the same Autosar version */
#if ((CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MAJOR_VERSION_C != CRYPTO_AR_RELEASE_MAJOR_VERSION_IPW_H) || \
     (CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MINOR_VERSION_C != CRYPTO_AR_RELEASE_MINOR_VERSION_IPW_H) || \
     (CRYPTO_KEY_MANAGEMENT_AR_RELEASE_REVISION_VERSION_C != CRYPTO_AR_RELEASE_REVISION_VERSION_IPW_H) \
    )
#error "AutoSar Version Numbers of Crypto_KeyManagement.c and Crypto_Ipw.h are different"
#endif

/* Check if Crypto source file and Crypto IPW header file are of the same Software version */
#if ((CRYPTO_KEY_MANAGEMENT_SW_MAJOR_VERSION_C != CRYPTO_SW_MAJOR_VERSION_IPW_H) || \
     (CRYPTO_KEY_MANAGEMENT_SW_MINOR_VERSION_C != CRYPTO_SW_MINOR_VERSION_IPW_H) || \
     (CRYPTO_KEY_MANAGEMENT_SW_PATCH_VERSION_C != CRYPTO_SW_PATCH_VERSION_IPW_H) \
    )
#error "Software Version Numbers of Crypto_KeyManagement.c and Crypto_Ipw.h are different"
#endif

/*==================================================================================================
*                          LOCAL TYPEDEFS (STRUCTURES, UNIONS, ENUMS)
==================================================================================================*/

/*==================================================================================================
*                                       LOCAL MACROS
==================================================================================================*/

/*==================================================================================================
*                                      LOCAL CONSTANTS
==================================================================================================*/

/*==================================================================================================
*                                      LOCAL VARIABLES
==================================================================================================*/

/*==================================================================================================
*                                      GLOBAL CONSTANTS
==================================================================================================*/

/*==================================================================================================
*                                      GLOBAL VARIABLES
==================================================================================================*/
#define CRYPTO_START_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_KeyManagement_c_REF_3 Violates MISRA 2004 Advisory Rule 19.1, #include preceded by non preproc directives.
* @violates @ref Crypto_KeyManagement_c_REF_4 , Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"


/**
* @brief          This variable holds the state of the driver.
* @details        This variable holds the state of the driver. After reset is UNINIT. The output of Crypto_Init() function
*                 should set this variable into IDLE state.
*                  CRYPTO_UNINIT = The CRYPTO controller is not initialized. All registers belonging to the CRYPTO module are in reset state.
*
*/
/** 
* @violates @ref Crypto_KeyManagement_c_REF_7 Could define variable at block scope.
* @violates @ref Crypto_KeyManagement_c_REF_6 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
extern VAR(Crypto_InitStateType, CRYPTO_VAR) Crypto_eDriverStatus;

#define CRYPTO_STOP_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_KeyManagement_c_REF_3 Violates MISRA 2004 Advisory Rule 19.1, #include preceded by non preproc directives.
* @violates @ref Crypto_KeyManagement_c_REF_4 , Repeated include file MemMap.h
*/
#include "Crypto_MemMap.h"

#define CRYPTO_START_SEC_CODE
/**
* @violates @ref Crypto_KeyManagement_c_REF_3 Violates MISRA 2004 Advisory Rule 19.1, #include preceded by non preproc directives.
* @violates @ref Crypto_KeyManagement_c_REF_4 , Repeated include file MemMap.h
*/
#include "Crypto_MemMap.h"
/*==================================================================================================
*                                   LOCAL FUNCTION PROTOTYPES
==================================================================================================*/

#if (CRYPTO_KEYS_EXIST == 1U)

/**
* @brief           Memcopy function
* @details         Memcopy function
*
* @param[in]       pSource - address of the source
* @param[in]       pDest - address of the destination
* @param[in]       u32Size - size to be copied
* @param[inout]    none
* @param[out]      none
* @returns         void
*                  
* @api
*
* @pre            
*                   
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_Memcpy( P2CONST (uint8, AUTOMATIC, CRYPTO_APPL_CONST) pSource, P2VAR (uint8, AUTOMATIC, CRYPTO_APPL_DATA) pDest, VAR (uint32, AUTOMATIC) u32Size );
/**
* @brief           Get key material element index
* @details         Get key material element index
*
* @param[in]       u32CryptoKeyId - Crypto Key Id
* @param[in]       u32KeyIndex - Key Index
* @param[in]       u32TargetCryptoKeyIndex - Target Crypto Key Index
* @param[inout]    pu64KeyMaterialElementIdx - Key Material Element Index
* @returns         eOutResponse
*
* @api
*
* @pre
*
*/
LOCAL_INLINE FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_GetKeyMaterialElementIdx(VAR(uint32, AUTOMATIC) u32CryptoKeyId, VAR(uint32, AUTOMATIC) u32KeyIndex, VAR(uint32, AUTOMATIC) u32TargetCryptoKeyIndex);
#endif
/*==================================================================================================
*                                      LOCAL FUNCTIONS
==================================================================================================*/
#if (CRYPTO_KEYS_EXIST == 1U)

/**
* @brief           Memcopy function
* @details         Memcopy function
*
* @param[in]       pSource - address of the source
* @param[in]       pDest - address of the destination
* @param[in]       u32Size - size to be copied
* @param[inout]    none
* @param[out]      none
* @returns         void
*                  
* @api
*
* @pre            
*                   
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_Memcpy (P2CONST (uint8, AUTOMATIC, CRYPTO_APPL_CONST) pSource, P2VAR (uint8, AUTOMATIC, CRYPTO_APPL_DATA) pDest, VAR (uint32, AUTOMATIC) u32Size)
{
    /* Normally should never be null pointer, but double check */
    if ( ( NULL_PTR != pSource ) && ( NULL_PTR != pDest ) )
    {
        while ( 0U < u32Size ) 
        {
            u32Size--;
            *pDest = *pSource;
            /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
            pDest++;
            /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
            pSource++;
        }
    }
}

/**
* @brief           Get key material element index
* @details         Get key material element index
*
* @param[in]       u32CryptoKeyId - Crypto Key Id
* @param[in]       u32KeyIndex - Key Index
* @param[in]       u32TargetCryptoKeyIndex - Target Crypto Key Index
* @param[inout]    pu64KeyMaterialElementIdx - Key Material Element Index
* @returns         eOutResponse
*
* @api
*
* @pre
*
*/
LOCAL_INLINE FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_GetKeyMaterialElementIdx(VAR(uint32, AUTOMATIC) u32CryptoKeyId, VAR(uint32, AUTOMATIC) u32KeyIndex, VAR(uint32, AUTOMATIC) u32TargetCryptoKeyIndex)
{
    VAR(Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_OK;
    VAR(boolean, AUTOMATIC) bFound = (boolean)FALSE;
    VAR(boolean, AUTOMATIC) bKeyMaterialExists = (boolean)FALSE;
    VAR(uint32, AUTOMATIC) u32KeyMaterialElementIdx = 0U;
    VAR(uint32, AUTOMATIC) u32Counter1 = 0U;
    VAR(uint32, AUTOMATIC) u32Counter2 = 0U;
    
    for ( u32Counter1 = 0U; ((u32Counter1 < Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32NoCryptoKeyElements) && ((Std_ReturnType)E_OK == eOutResponse)); u32Counter1++ )
    {
        bFound = (boolean)FALSE;
        for ( u32Counter2 = 0U; ( ( u32Counter2 < Crypto_aKeyList[u32TargetCryptoKeyIndex]->pCryptoKeyElementList->u32NoCryptoKeyElements ) && ( (boolean)FALSE == bFound ) ); u32Counter2++ )
        {
            /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
            if ( Crypto_aKeyElementList[Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter1]]->u32CryptoKeyElementId ==  \
                 /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                 Crypto_aKeyElementList[Crypto_aKeyList[u32TargetCryptoKeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter2]]->u32CryptoKeyElementId
                )
            {
                bFound = (boolean)TRUE;
                /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                if ( CRYPTO_RA_DENIED == Crypto_aKeyElementList[Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter1]]->eCryptoKeyElementReadAccess )
                {
                    eOutResponse = (Std_ReturnType)CRYPTO_E_KEY_READ_FAIL;
                }
                /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                else if ( CRYPTO_WA_DENIED == Crypto_aKeyElementList[Crypto_aKeyList[u32TargetCryptoKeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter2]]->eCryptoKeyElementWriteAccess )
                {
                    eOutResponse = (Std_ReturnType)CRYPTO_E_KEY_WRITE_FAIL;
                }
                else if (
                         /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                         ( Crypto_aKeyElementList[Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter1]]->u32CryptoKeyElementActualSize > Crypto_aKeyElementList[Crypto_aKeyList[u32TargetCryptoKeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter2]]->u32CryptoKeyElementMaxSize ) || \
                          ( 
                            /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                           ( Crypto_aKeyElementList[Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter1]]->u32CryptoKeyElementActualSize != Crypto_aKeyElementList[Crypto_aKeyList[u32TargetCryptoKeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter2]]->u32CryptoKeyElementMaxSize ) && \
                           /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                           ( 0U == Crypto_aKeyElementList[Crypto_aKeyList[u32TargetCryptoKeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter2]]->bCryptoKeyElementAllowPartialAccess )
                          )
                         )
                {
                    eOutResponse = (Std_ReturnType)CRYPTO_E_KEY_SIZE_MISMATCH;
                }
                else
                {
                    /* do nothing*/
                }
                /* If any errors occured, get out*/
                if ( (Std_ReturnType)E_OK != eOutResponse )
                {
                    break;
                }
                /* if the key element is key material itself, store the position in the list of key elements, it is needed for later */
                /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                if ( 1U == Crypto_aKeyElementList[Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter1]]->u32CryptoKeyElementId )
                {
                    /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                    u32KeyMaterialElementIdx = Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter1];
                    bKeyMaterialExists = (boolean)TRUE;
                }
                else
                {
                    /* Do nothing*/
                }

                eOutResponse = (Std_ReturnType)E_OK;
            }
        }
        /* if no compatible key element was found, return */
        if ( ( (boolean)FALSE == bFound ) || ( (Std_ReturnType)E_OK != eOutResponse ) )
        {
            eOutResponse = (Std_ReturnType)E_NOT_OK;
            break;
        }
    }
    /* If verification for all key elements was succesful, start copying the elements; start with key material because in case there is an error the other elements should not be copied */
    if ( ( (boolean)TRUE == bKeyMaterialExists ) && ( (Std_ReturnType)E_OK == eOutResponse ) )
    {
        eOutResponse = Crypto_Ipw_LoadKey (u32CryptoKeyId, Crypto_aKeyElementList[u32KeyMaterialElementIdx]->pCryptoElementArray, Crypto_aKeyElementList[u32KeyMaterialElementIdx]->u32CryptoKeyElementActualSize );            
    }

    return eOutResponse;
}

#endif
/*==================================================================================================
*                                       GLOBAL FUNCTIONS
==================================================================================================*/

/**
* @brief           Sets the given key element bytes to the key identified by cryptoKeyId.
* @details         Sets the given key element bytes to the key identified by cryptoKeyId.
*
* @param[in]       cryptoKeyId -  Holds the identifier of the key whose key element shall be set.
* @param[in]       keyElementId - Holds the identifier of the key element which shall be set.
* @param[in]       keyPtr - Holds the pointer to the key data which shall be set as key element.
* @param[in]       keyLength - Contains the length of the key element in bytes.
* @param[inout]    None
* @param[out]      None
* @returns         E_OK: E_OK: Request successful
*                  E_NOT_OK: Request Failed
*                  CRYPTO_E_BUSY: Request Failed, Crypto Driver Object is Busy 
*                  CRYPTO_E_KEY_WRITE_FAIL:Request failed because write access was denied 
*                  CRYPTO_E_KEY_NOT_AVAILABLE: Request failed because the key is not available
*                  CRYPTO_E_KEY_SIZE_MISMATCH: Request failed, key element size does not match size of provided data.
* @api
*
* @pre            
*
* @implements     Crypto_KeyElementSet_Activity
*                   
*/
/**
* @violates @ref Crypto_KeyManagement_c_REF_6 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyElementSet ( VAR(uint32, AUTOMATIC) cryptoKeyId, VAR(uint32, AUTOMATIC) keyElementId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) keyPtr, 
                                                         VAR(uint32, AUTOMATIC) keyLength
                                                        )
{
    VAR(Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_NOT_OK;
#if (CRYPTO_KEYS_EXIST == 1U)
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey;
    VAR (Crypto_VerifyKeyElementType, AUTOMATIC) sVerifyKeyElement;
    
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
    /* If the Crypto Driver is not yet initialized and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementSet shall report CRYPTO_E_UNINIT to the DET and return E_NOT_OK. */
    if ( CRYPTO_UNINIT == Crypto_eDriverStatus )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTSET_ID, (uint8)CRYPTO_E_UNINIT );
    }
    /* If the parameter keyPtr is a null pointer and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementSet shall report CRYPTO_E_PARAM_POINTER to the DET and return E_NOT_OK. */
    else if ( NULL_PTR == keyPtr )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTSET_ID, (uint8)CRYPTO_E_PARAM_POINTER );
    }
    /* If keyLength is zero and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementSet shall report CRYPTO_E_PARAM_VALUE to the DET and return E_NOT_OK. */
    else if ( 0U == keyLength )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTSET_ID, (uint8)CRYPTO_E_PARAM_VALUE );
    }
    else
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
    { 
        /* If cryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementSet shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
        /* If parameter keyElementId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementSet shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
        sVerifyKey = Crypto_Ipw_VerifyKeyId (cryptoKeyId);
        if ( (Std_ReturnType)E_OK == sVerifyKey.eFound )
        {
            sVerifyKeyElement = Crypto_Ipw_VerifyKeyElementId ( sVerifyKey.u32Counter, keyElementId );
            if ( (Std_ReturnType)E_OK == sVerifyKeyElement.eFound )
            {
                /* If keylength parameter of the function is smaller than the size of the key element and the key element is not configured to allow partial access 
                   or if is greater than the key length configured in Tresos */
                if ( ( ( 0U == Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->bCryptoKeyElementAllowPartialAccess ) && ( keyLength < Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->u32CryptoKeyElementMaxSize ) ) ||
                    ( keyLength > Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->u32CryptoKeyElementMaxSize )
                    )
                {
                    eOutResponse = (Std_ReturnType)CRYPTO_E_KEY_SIZE_MISMATCH;
                }
                /* If the key does not allow write access - request failed because write access was denied */
                else if ( CRYPTO_WA_DENIED == Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->eCryptoKeyElementWriteAccess )
                {
                    eOutResponse = (Std_ReturnType)CRYPTO_E_KEY_WRITE_FAIL;
                }
                else
                {   
                    /* When the KeyElementSet is called, the key state is set to invalid */
                    Crypto_aKeyList[sVerifyKey.u32Counter]->bCryptoKeyValid = 0U;
                  
                    /* If the key element is key Certificate, send it to HSM to store it */
                    if ( 1000U == keyElementId )
                    {
#if (CRYPTO_INSTALL_CERT_EXIST == 1U)                      
                        eOutResponse = Crypto_Ipw_InstallCertificate (cryptoKeyId, keyPtr, keyLength );
#endif /* (CRYPTO_INSTALL_CERT_EXIST == 1U) */
                    }
                    /* If the key element is key material, send it to HSM to store it */
                    else if ( 1U == keyElementId )
                    {                 
                        eOutResponse = Crypto_Ipw_LoadKey (cryptoKeyId, keyPtr, keyLength );              
                    }
                    /* If the key element is different from key material (IV, seed) - store it */
                    else
                    {
                        Crypto_Memcpy(keyPtr, Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->pCryptoElementArray, keyLength);
                        eOutResponse = (Std_ReturnType)E_OK;
                    }
                    /* Store the actual size of the key element */
                    if ( (Std_ReturnType)E_OK == eOutResponse )
                    {
                        Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->u32CryptoKeyElementActualSize = keyLength;
                    }
                }
            }
            else
            {
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
            (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTSET_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
            }
        }
        else
        {
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
            (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTSET_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
        }
    }
    
#else
    (void) cryptoKeyId;
    (void) keyElementId;
    (void) keyPtr; 
    (void) keyLength;
#endif /* CRYPTO_KEYS_EXIST == 1 */

    return eOutResponse;
}

/**
* @brief           Sets the key state of the key identified by cryptoKeyId to valid.
* @details         Sets the key state of the key identified by cryptoKeyId to valid.
*
* @param[in]       cryptoKeyId - Holds the identifier of the key which shall be set to valid.
* @param[inout]    None
* @param[out]      None
* @returns         E_OK: E_OK: Request successful
*                  E_NOT_OK: Request Failed
*                  CRYPTO_E_BUSY: Request Failed, Crypto Driver Object is Busy 
* @api
*
* @pre            
*
* @implements     Crypto_KeyValidSet_Activity
*                   
*/
/**
* @violates @ref Crypto_KeyManagement_c_REF_6 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyValidSet (VAR(uint32, AUTOMATIC) cryptoKeyId)
{
    VAR(Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_NOT_OK;
#if (CRYPTO_KEYS_EXIST == 1U)
    VAR(uint32, AUTOMATIC) u32KeyIndex = 0U;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey;
    
    sVerifyKey = Crypto_Ipw_VerifyKeyId ( cryptoKeyId );
    /* If the key is valid, save the position of the key */
    if ( (Std_ReturnType)E_OK == sVerifyKey.eFound )
    {
        u32KeyIndex = sVerifyKey.u32Counter;
    }
    
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
    /* Check whether the Crypto driver is in CRYPTO_UNINIT state */
    if ( CRYPTO_UNINIT == Crypto_eDriverStatus )
    {
        /* If the module is not yet initialized and development error detection for the Crypto Driver is enabled, the function Crypto_KeyValidSet shall report CRYPTO_E_UNINIT to the DET and return E_NOT_OK. */
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYVALIDSET_ID, (uint8)CRYPTO_E_UNINIT );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    /* If parameter cryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyValidSet shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
    else if ( (Std_ReturnType)E_NOT_OK == sVerifyKey.eFound )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYVALIDSET_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    else
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
    {
        /* set the key to be valid */
        Crypto_aKeyList[u32KeyIndex]->bCryptoKeyValid = 1U;
        eOutResponse = (Std_ReturnType)E_OK;
    }
#else
    (void) cryptoKeyId;
#endif /* CRYPTO_KEYS_EXIST == 1 */

    return eOutResponse;
}




/**
* @brief           Sets the key state of the key identified by cryptoKeyId to valid.
* @details         Sets the key state of the key identified by cryptoKeyId to valid.
*
* @param[in]       cryptoKeyId - Holds the identifier of the key which shall be set to valid.
* @param[inout]    None
* @param[out]      None
* @returns         E_OK: E_OK: Request successful
*                  E_NOT_OK: Request Failed
*                  CRYPTO_E_BUSY: Request Failed, Crypto Driver Object is Busy 
* @api
*
* @pre            
*
* @implements     Crypto_KeySetValid_Activity
*                   
*/
/**
* @violates @ref Crypto_KeyManagement_c_REF_6 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeySetValid (VAR(uint32, AUTOMATIC) cryptoKeyId)
{
    VAR(Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_NOT_OK;
#if (CRYPTO_KEYS_EXIST == 1U)
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey;
    VAR(uint32, AUTOMATIC) u32KeyIndex = 0U;
    
    /* If the key is valid, save the position of the key */
    sVerifyKey = Crypto_Ipw_VerifyKeyId ( cryptoKeyId );
    if ( (Std_ReturnType)E_OK == sVerifyKey.eFound )
    {
        u32KeyIndex = sVerifyKey.u32Counter;
    }
    
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
    /* If the module is not yet initialized and development error detection for the Crypto Driver is enabled, the function Crypto_KeySetValid shall report CRYPTO_E_UNINIT to the DET and return E_NOT_OK. */
    if ( CRYPTO_UNINIT == Crypto_eDriverStatus )
    {
        /* Crypto driver has been already initialized */
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYVALIDSET_ID, (uint8)CRYPTO_E_UNINIT );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    /* If parameter cryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeySetValid shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
    else if ( (Std_ReturnType)E_NOT_OK == sVerifyKey.eFound )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYVALIDSET_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    else
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
    {
        /* set the key to be valid */
        Crypto_aKeyList[u32KeyIndex]->bCryptoKeyValid = 1U;
        eOutResponse = (Std_ReturnType)E_OK;
    }
#else
    (void) cryptoKeyId;
#endif /* CRYPTO_KEYS_EXIST == 1 */

    return eOutResponse;
}





/**
* @brief           This interface shall be used to get a key element of the key identified by the cryptoKeyId and store the key element in the memory location pointed by the result pointer.
* @details         This interface shall be used to get a key element of the key identified by the cryptoKeyId and store the key element in the memory location pointed by the result pointer. 
*                  Note: If the actual key element is directly mapped to flash memory, there could be a bigger delay when calling this function (synchronous operation).
*
* @param[in]       cryptoKeyId -     Holds the identifier of the key whose key element shall be returned.
* @param[in]       keyElementId -    Holds the identifier of the key element which shall be returned.
* @param[inout]    resultLengthPtr - Holds a pointer to a memory location in which the length information is stored. On calling this function this parameter shall contain the size of the buffer provided by resultPtr. 
*                                    If the key element is configured to allow partial access, this parameter contains the amount of data which should be read from the key element. 
*                                    The size may not be equal to the size of the provided buffer anymore. When the request has finished, the amount of data that has been stored shall be stored.
* @param[out]      resultPtr         Holds the pointer of the buffer for the returned key element
* @returns         E_OK: E_OK: Request successful
*                  E_NOT_OK: Request Failed
*                  CRYPTO_E_BUSY: Request Failed, Crypto Driver Object is Busy 
*                  CRYPTO_E_KEY_NOT_AVAILABLE: Request failed, the requested key element is not available 
*                  CRYPTO_E_KEY_READ_FAIL: Request failed because read access was denied 
*                  CRYPTO_E_SMALL_BUFFER: The provided buffer is too small to store the result
* @api
*
* @pre            
*
* @implements     Crypto_KeyElementGet_Activity
*                   
*/
/**
* @violates @ref Crypto_KeyManagement_c_REF_6 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyElementGet ( 
                                                         VAR(uint32, AUTOMATIC) cryptoKeyId, VAR(uint32, AUTOMATIC) keyElementId, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) resultPtr, 
                                                         P2VAR(uint32, AUTOMATIC, CRYPTO_APPL_DATA) resultLengthPtr
                                                        )
{
    VAR(Std_ReturnType, AUTOMATIC) eOutResponse = (uint8)E_NOT_OK;
#if (CRYPTO_KEYS_EXIST == 1U)
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey;
    VAR (Crypto_VerifyKeyElementType, AUTOMATIC) sVerifyKeyElement;
    
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
    /* If the module is not yet initialized and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementGet shall report CRYPTO_E_UNINIT to the DET and return E_NOT_OK. */
    if ( CRYPTO_UNINIT == Crypto_eDriverStatus )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTGET_ID, (uint8)CRYPTO_E_UNINIT );
    }
    /* If the parameter resultPtr is a null pointer and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementGet shall report CRYPTO_E_PARAM_POINTER the DET and return E_NOT_OK. */
    /* If the parameter resultLengthPtr is a null pointer and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementGet shall report CRYPTO_E_PARAM_POINTER to the DET and return E_NOT_OK. */
    else if ( ( NULL_PTR == resultPtr ) || ( NULL_PTR == resultLengthPtr ) )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTGET_ID, (uint8)CRYPTO_E_PARAM_POINTER );
    }
    /* If the value, which is pointed by resultLengthPtr is zero and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementGet shall report CRYPTO_E_PARAM_VALUE to the DET and return E_NOT_OK. */
    else if (0U == *resultLengthPtr)
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTGET_ID, (uint8)CRYPTO_E_PARAM_VALUE );
    }
    else
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
    { 
        /* If the parameter cryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementGet shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
        /* If the parameter keyElementId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementGet shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
        sVerifyKey = Crypto_Ipw_VerifyKeyId (cryptoKeyId);
        if ( (Std_ReturnType)E_OK == sVerifyKey.eFound )
        {
            /* Check if the key is valid */
            sVerifyKeyElement = Crypto_Ipw_VerifyKeyElementId (sVerifyKey.u32Counter, keyElementId);
            if ( (Std_ReturnType)E_OK == sVerifyKeyElement.eFound ) 
            {
                /* Request failed because read acces was denied */
                if ( CRYPTO_RA_DENIED ==  Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->eCryptoKeyElementReadAccess )
                {
                    eOutResponse = (Std_ReturnType)CRYPTO_E_KEY_READ_FAIL;      
                }
                /* If the buffer resultPtr is too small to store the result of the request, CRYPTO_E_SMALL_BUFFER shall be returned and if development error detection is enabled, CRYPTO_E_SMALL_BUFFER shall be reported to the DET. */
                else if ( *resultLengthPtr < Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->u32CryptoKeyElementActualSize )
                {
                    eOutResponse = (Std_ReturnType)CRYPTO_E_SMALL_BUFFER;
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
                    (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTGET_ID, (uint8)CRYPTO_E_SMALL_BUFFER );
#endif          
                }
                else
                {  
                    /* If the key element is key material, HSM will retrieve the key */
                    if (( 1U == keyElementId ) || ( 1000U == keyElementId ))
                    {
#if (CRYPTO_KEY_EXPORT_EXIST == 1U)                        
                        eOutResponse = Crypto_Ipw_ExportExtendedRamKey (cryptoKeyId, resultLengthPtr, resultPtr);
#endif
                    }
                    /* If the key element is different from key material (IV, seed) */
                    else
                    {
                        Crypto_Memcpy (Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->pCryptoElementArray, resultPtr, Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->u32CryptoKeyElementActualSize);
                        /* When the request has finished, the amount of data that has been stored shall be stored. */
                        *resultLengthPtr = Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->u32CryptoKeyElementActualSize;
                        eOutResponse = (Std_ReturnType)E_OK;
                    }        
                }
            }
            else
            {
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
                (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTGET_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
            }
        }
        else
        {
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
            (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTGET_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
        }
    }
    
    /* If the function Crypto_KeyElementGet returns CRYPTO_E_KEY_NOT_AVAILABLE, the function shall additionally report the runtime error CRYPTO_E_RE_KEY_NOT_AVAILABLE */
    if ( (Std_ReturnType)CRYPTO_E_KEY_NOT_AVAILABLE == eOutResponse )
    {
        (void) Det_ReportRuntimeError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTGET_ID, (uint8)CRYPTO_E_RE_KEY_NOT_AVAILABLE );
    }
    /* If the function Crypto_KeyElementGet returns CRYPTO_E_KEY_READ_FAIL, the function shall additionally report the runtime error CRYPTO_E_RE_KEY_READ_FAIL. */
    else if ( (Std_ReturnType)CRYPTO_E_KEY_READ_FAIL == eOutResponse )
    {
        (void) Det_ReportRuntimeError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTGET_ID, (uint8)CRYPTO_E_RE_KEY_READ_FAIL );
    }
    else
    {
        /* do nothing */
    }
    
#else
    (void) cryptoKeyId;
    (void) keyElementId;
    (void) resultPtr;
    (void) resultLengthPtr;
#endif /* CRYPTO_KEYS_EXIST == 1 */

    return eOutResponse;
}


/**
* @brief           Copies a key element to another key element in the same crypto driver.
* @details         Copies a key element to another key element in the same crypto driver. 
*                  Note: If the actual key element is directly mapped to flash memory, there could be a bigger delay when calling this function (synchronous operation)
*
* @param[in]       cryptoKeyId -         Holds the identifier of the key whose key element shall be the source element.
* @param[in]       keyElementId -        Holds the identifier of the key element which shall be the source for the copy operation.
* @param[in]       targetCryptoKeyId -   Holds the identifier of the key whose key element shall be the destination element.
* @param[in]       targetKeyElementId -  Holds the identifier of the key element which shall be the destination for the copy operation.
* @param[inout]    None
* @param[out]      None
* @returns         E_OK: E_OK: Request successful
*                  E_NOT_OK: Request Failed
*                  CRYPTO_E_BUSY: Request Failed, Crypto Driver Object is Busy 
*                  CRYPTO_E_KEY_NOT_AVAILABLE: Request failed, the requested key element is not available
*                  CRYPTO_E_KEY_READ_FAIL: Request failed, not allowed to extract key element
*                  CRYPTO_E_KEY_WRITE_FAIL: Request failed, not allowed to write key element.
*                  CRYPTO_E_KEY_SIZE_MISMATCH: Request failed, key element sizes are not compatible. 
* @api
*
* @pre            
*
* @implements     Crypto_KeyElementCopy_Activity
*                   
*/
/**
* @violates @ref Crypto_KeyManagement_c_REF_6 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyElementCopy (
                                                         VAR(uint32, AUTOMATIC) cryptoKeyId, VAR(uint32, AUTOMATIC) keyElementId, 
                                                         VAR(uint32, AUTOMATIC) targetCryptoKeyId, VAR(uint32, AUTOMATIC) targetKeyElementId
                                                        )
{
    VAR(Std_ReturnType, AUTOMATIC) eOutResponse = (uint8)E_NOT_OK;
#if (CRYPTO_KEYS_EXIST == 1U)
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyTargetKey;
    VAR (Crypto_VerifyKeyElementType, AUTOMATIC) sVerifyKeyElement;
    VAR (Crypto_VerifyKeyElementType, AUTOMATIC) sVerifyTargetKeyElement;
    
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
    /* If the Crypto Driver is not yet initialized and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementCopy shall report CRYPTO_E_UNINIT to the DET and return E_NOT_OK. */
    if ( CRYPTO_UNINIT == Crypto_eDriverStatus )
    {
        /* Crypto driver has been already initialized */
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTCOPY_ID, (uint8)CRYPTO_E_UNINIT );
    }
    else
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
    { 
        /* If cryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementCopy shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
        /* If targetCryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementCopy shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
        /* If parameter keyElementId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementCopy shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
        /* If parameter targetKeyElementId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementCopy shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
        sVerifyKey = Crypto_Ipw_VerifyKeyId ( cryptoKeyId );
        sVerifyTargetKey = Crypto_Ipw_VerifyKeyId ( targetCryptoKeyId );
        if ( ( (Std_ReturnType)E_OK == sVerifyKey.eFound ) && ( (Std_ReturnType)E_OK == sVerifyTargetKey.eFound ) )
        {
            sVerifyKeyElement = Crypto_Ipw_VerifyKeyElementId ( sVerifyKey.u32Counter, keyElementId );
            sVerifyTargetKeyElement = Crypto_Ipw_VerifyKeyElementId ( sVerifyTargetKey.u32Counter, targetKeyElementId );
            if ( ( (Std_ReturnType)E_OK == sVerifyKeyElement.eFound ) && ( (Std_ReturnType)E_OK == sVerifyTargetKeyElement.eFound ) )
            {
                /* Request failed, not allowed to extract key element */
                if ( CRYPTO_RA_DENIED == Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->eCryptoKeyElementReadAccess )
                {
                    eOutResponse = (Std_ReturnType)CRYPTO_E_KEY_READ_FAIL;
                }
                /* Request failed, not allowed to write key element */
                else if ( CRYPTO_WA_DENIED == Crypto_aKeyElementList[sVerifyTargetKeyElement.u32Counter]->eCryptoKeyElementWriteAccess )
                {
                    eOutResponse = (Std_ReturnType)CRYPTO_E_KEY_WRITE_FAIL;
                }
                /* Incompatible sizes between key elements */
                else if ( 
                          ( Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->u32CryptoKeyElementActualSize > Crypto_aKeyElementList[sVerifyTargetKeyElement.u32Counter]->u32CryptoKeyElementMaxSize ) || \
                          ( 
                            ( Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->u32CryptoKeyElementActualSize != Crypto_aKeyElementList[sVerifyTargetKeyElement.u32Counter]->u32CryptoKeyElementMaxSize ) && \
                            ( 0U == Crypto_aKeyElementList[sVerifyTargetKeyElement.u32Counter]->bCryptoKeyElementAllowPartialAccess )
                          )
                         )
                {
                    eOutResponse = (Std_ReturnType)CRYPTO_E_KEY_SIZE_MISMATCH;
                }
                else
                {
                    /* If the key element is key material, send it to HSM to store it */
                    if ( 1U == keyElementId )
                    {                         
                        eOutResponse = Crypto_Ipw_LoadKey (cryptoKeyId, Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->pCryptoElementArray, Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->u32CryptoKeyElementActualSize );                
                    }
                    /* If the key element is different from key material (IV, seed) - store it */
                    else
                    {
                        Crypto_Memcpy(Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->pCryptoElementArray, Crypto_aKeyElementList[sVerifyTargetKeyElement.u32Counter]->pCryptoElementArray , Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->u32CryptoKeyElementActualSize);
                        eOutResponse = (Std_ReturnType)E_OK;
                    }
                    /* If everything went fine, store the actual size of the element */
                    if ( (Std_ReturnType)E_OK == eOutResponse )
                    {
                        Crypto_aKeyElementList[sVerifyTargetKeyElement.u32Counter]->u32CryptoKeyElementActualSize = Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->u32CryptoKeyElementActualSize;
                    }
                }
            }
            else
            {
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
                (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTCOPY_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
            }
        }
        else
        {
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
            (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTCOPY_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
        }
    }
 

#else
    (void) cryptoKeyId;
    (void) keyElementId;
    (void) targetCryptoKeyId;
    (void) targetKeyElementId;
#endif /* CRYPTO_KEYS_EXIST == 1 */

    return eOutResponse;
}



/**
* @brief           Copies a key with all its elements to another key in the same crypto driver.
* @details         Copies a key with all its elements to another key in the same crypto driver.
*                  Note: If the actual key element is directly mapped to flash memory, there could be a bigger delay when calling this function (synchronous operation)
*
* @param[in]       cryptoKeyId -         Holds the identifier of the key whose key element shall be the source element.
* @param[in]       targetCryptoKeyId -   Holds the identifier of the key whose key element shall be the destination element.
* @param[inout]    None
* @param[out]      None
* @returns         E_OK: E_OK: Request successful
*                  E_NOT_OK: Request Failed
*                  CRYPTO_E_BUSY: Request Failed, Crypto Driver Object is Busy 
*                  CRYPTO_E_KEY_NOT_AVAILABLE: Request failed, the requested key element is not available
*                  CRYPTO_E_KEY_READ_FAIL: Request failed, not allowed to extract key element
*                  CRYPTO_E_KEY_WRITE_FAIL: Request failed, not allowed to write key element.
*                  CRYPTO_E_KEY_SIZE_MISMATCH: Request failed, key element sizes are not compatible. 
* @api
*
* @pre            
*
* @implements     Crypto_KeyCopy_Activity
*                   
*/
/**
* @violates @ref Crypto_KeyManagement_c_REF_6 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyCopy (VAR(uint32, AUTOMATIC) cryptoKeyId, VAR(uint32, AUTOMATIC) targetCryptoKeyId)
{
    VAR(Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_OK;
#if (CRYPTO_KEYS_EXIST == 1U)
    VAR(uint32, AUTOMATIC) u32KeyIndex = 0U;
    VAR(uint32, AUTOMATIC) u32TargetCryptoKeyIndex = 0U;
    VAR(uint32, AUTOMATIC) u32Counter1 = 0U;
    VAR(uint32, AUTOMATIC) u32Counter2 = 0U;
    VAR(boolean, AUTOMATIC) bFound = (boolean)FALSE;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyTargetKey;
    
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)    
    /* If the Crypto Driver is not yet initialized and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyCopy shall report CRYPTO_E_UNINIT to the DET and return E_NOT_OK. */ 
    if ( CRYPTO_UNINIT == Crypto_eDriverStatus )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYCOPY_ID, (uint8)CRYPTO_E_UNINIT );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
    }
    else
#endif
    { 
        /* If cryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyCopy shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
        /* If targetCryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyCopy shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
        sVerifyKey = Crypto_Ipw_VerifyKeyId ( cryptoKeyId );
        if ( (Std_ReturnType)E_OK == sVerifyKey.eFound )
        {
            u32KeyIndex = sVerifyKey.u32Counter;
            sVerifyTargetKey = Crypto_Ipw_VerifyKeyId ( targetCryptoKeyId );
            if ( (Std_ReturnType)E_OK == sVerifyTargetKey.eFound )
            {
                u32TargetCryptoKeyIndex = sVerifyTargetKey.u32Counter; 
                /* Verify if all the key elements are compatible (have the same key element ID) and have read/write access */
                if ( Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32NoCryptoKeyElements > Crypto_aKeyList[u32TargetCryptoKeyIndex]->pCryptoKeyElementList->u32NoCryptoKeyElements )
                {
                    eOutResponse = (Std_ReturnType)E_NOT_OK;
                }
                else
                {
                    /*Get key material*/
                    eOutResponse = Crypto_GetKeyMaterialElementIdx(cryptoKeyId,u32KeyIndex,u32TargetCryptoKeyIndex);
                    /* Copy the rest of the elements (different from key material) */
                    if ( (Std_ReturnType)E_OK == eOutResponse )
                    {
                        for ( u32Counter1 = 0U; u32Counter1 < Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32NoCryptoKeyElements; u32Counter1++ )
                        {
                            bFound = (boolean)FALSE;
                            for ( u32Counter2 = 0U; ( ( u32Counter2 < Crypto_aKeyList[u32TargetCryptoKeyIndex]->pCryptoKeyElementList->u32NoCryptoKeyElements ) && ( (boolean)FALSE == bFound ) ); u32Counter2++ )
                            {
                                /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                                if ( ( Crypto_aKeyElementList[Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter1]]->u32CryptoKeyElementId ==  \
                                    /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                                    Crypto_aKeyElementList[Crypto_aKeyList[u32TargetCryptoKeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter2]]->u32CryptoKeyElementId ) &&
                                    /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                                    ( 1U != Crypto_aKeyElementList[Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter1]]->u32CryptoKeyElementId ) 
                                    )
                                    
                                {
                                    bFound = (boolean)TRUE;
                                    /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                                    Crypto_Memcpy(Crypto_aKeyElementList[Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter1]]->pCryptoElementArray, Crypto_aKeyElementList[Crypto_aKeyList[u32TargetCryptoKeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter2]]->pCryptoElementArray , Crypto_aKeyElementList[Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter1]]->u32CryptoKeyElementActualSize);
                                    /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                                    Crypto_aKeyElementList[Crypto_aKeyList[u32TargetCryptoKeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter2]]->u32CryptoKeyElementActualSize = Crypto_aKeyElementList[Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter1]]->u32CryptoKeyElementActualSize;
                                }
                            }
                        }
                    }
                }
            }
            else
            {
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
                (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYCOPY_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
                eOutResponse = (Std_ReturnType)E_NOT_OK;
            }
        }
        else
        {
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
            (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYCOPY_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
            eOutResponse = (Std_ReturnType)E_NOT_OK;
        }
    }
#else
    (void) cryptoKeyId;
    (void) targetCryptoKeyId;
#endif /* CRYPTO_KEYS_EXIST == 1 */
  
    return eOutResponse;
}


/**
* @brief           Used to retrieve information which key elements are available in a given key.
* @details         Used to retrieve information which key elements are available in a given key.
*
* @param[in]       cryptoKeyId            -   Holds the identifier of the key whose available element ids shall be exported.
* @param[in]       keyElementIdsLengthPtr -   Holds a pointer to the memory location in which the number of key elements in the given key is stored. 
*                                             On calling this function, this parameter shall contain the size of the buffer provided by keyElementIdsPtr. 
*                                             When the request has finished, the actual number of key elements shall be stored.
* @param[inout]    None
* @param[out]      keyElementIdsPtr       -   Contains the pointer to the array where the ids of the key elements shall be stored.
* @returns         E_OK: E_OK: Request successful
*                  E_NOT_OK: Request Failed
*                  CRYPTO_E_BUSY: Request Failed, Crypto Driver Object is Busy 
*                  CRYPTO_E_SMALL_BUFFER: The provided buffer is too small to store the result
*
* @api
*
* @pre            
*
* @implements     Crypto_KeyElementIdsGet_Activity
*                   
*/
/**
* @violates @ref Crypto_KeyManagement_c_REF_6 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyElementIdsGet (
                                                           VAR(uint32, AUTOMATIC) cryptoKeyId, P2VAR(uint32, AUTOMATIC, CRYPTO_APPL_DATA) keyElementIdsPtr, 
                                                           P2VAR(uint32, AUTOMATIC, CRYPTO_APPL_DATA) keyElementIdsLengthPtr
                                                           )
{
    VAR(Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_NOT_OK;
#if (CRYPTO_KEYS_EXIST == 1U)
    VAR(uint32, AUTOMATIC) u32KeyIndex = 0U;
    VAR(uint32, AUTOMATIC) u32Index = 0U;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey;
    
    sVerifyKey = Crypto_Ipw_VerifyKeyId ( cryptoKeyId );
    if ( (Std_ReturnType)E_OK == sVerifyKey.eFound )
    {
        u32KeyIndex = sVerifyKey.u32Counter;
    }
    
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
    /* If the Crypto Driver is not yet initialized and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyElementIdsGet shall report CRYPTO_E_UNINIT to the DET and return E_NOT_OK. */
    if ( CRYPTO_UNINIT == Crypto_eDriverStatus )
    {
        /* Crypto driver has been already initialized */
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTIDSGET_ID, (uint8)CRYPTO_E_UNINIT );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    /* If cryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, 
    the function Crypto_KeyElementIdsGet shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
    else if ( (Std_ReturnType)E_NOT_OK == sVerifyKey.eFound )
    {  
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTIDSGET_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    /* If the buffer keyElementIdsPtr is too small to store the result of the request, 
    CRYPTO_E_SMALL_BUFFER shall be returned and if development error detection is enabled, CRYPTO_E_SMALL_BUFFER shall be reported to the DET. */
    else if ( Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32NoCryptoKeyElements > *keyElementIdsLengthPtr )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYELEMENTIDSGET_ID, (uint8)CRYPTO_E_SMALL_BUFFER );
        eOutResponse = (Std_ReturnType)CRYPTO_E_SMALL_BUFFER;
    }
    else
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
    {
        if ( ( NULL_PTR != keyElementIdsPtr ) && ( NULL_PTR != keyElementIdsLengthPtr ) )
        {
            *keyElementIdsLengthPtr = Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32NoCryptoKeyElements;
            for (u32Index = 0U; u32Index < Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32NoCryptoKeyElements; u32Index++ )
            {
                /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                *keyElementIdsPtr = Crypto_aKeyElementList[Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Index]]->u32CryptoKeyElementId;
                /*@violates @ref Crypto_KeyManagement_c_REF_5 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                keyElementIdsPtr++;
            }
            eOutResponse = (Std_ReturnType)E_OK;
        }
    }
#else
    (void) cryptoKeyId;
    (void) keyElementIdsPtr;
    (void) keyElementIdsLengthPtr;
#endif /* CRYPTO_KEYS_EXIST == 1 */

    return eOutResponse;
}


/**
* @brief           This function generates the internal seed state using the provided entropy source. Furthermore, this function can be used to update the seed state with new entropy.
* @details         This function generates the internal seed state using the provided entropy source. Furthermore, this function can be used to update the seed state with new entropy.
*
* @param[in]       cryptoKeyId            -   Holds the identifier of the key for which a new seed shall be generated.
* @param[in]       seedPtr                -   Holds a pointer to the memory location which contains the data to feed the entropy.
* @param[in]       seedLength             -   Contains the length of the entropy in bytes.
*
* @param[inout]    None
* @param[out]      None
* @returns         E_OK: E_OK: Request successful
*                  E_NOT_OK: Request Failed
*
* @api
*
* @pre            
*
* @implements     Crypto_RandomSeed_Activity
*                   
*/
/**
* @violates @ref Crypto_KeyManagement_c_REF_6 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_RandomSeed (VAR(uint32, AUTOMATIC) cryptoKeyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) seedPtr, VAR(uint32, AUTOMATIC) seedLength)
{
    VAR(Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_NOT_OK;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey;
    
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
    /* If the module is not yet initialized and if development error detection for the Crypto Driver is enabled, the function Crypto_RandomSeed shall report CRYPTO_E_UNINIT to the DET and return E_NOT_OK. */
    if ( CRYPTO_UNINIT == Crypto_eDriverStatus )
    {
        /* Crypto driver has been already initialized */
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_RANDOMSEED_ID, (uint8)CRYPTO_E_UNINIT );
    }
    /* If the parameter seedPtr is a null pointer and if development error detection for the Crypto Driver is enabled, the function Crypto_RandomSeed shall report CRYPTO_E_PARAM_POINTER to the DET and return E_NOT_OK. */
    else if ( NULL_PTR == seedPtr )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_RANDOMSEED_ID, (uint8)CRYPTO_E_PARAM_POINTER );
    }
    /* If seedLength is zero and if development error detection for the Crypto Driver is enabled, the function Crypto_RandomSeed shall report CRYPTO_E_PARAM_VALUE to the DET and return E_NOT_OK. */
    else if  ( 0U == seedLength )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_RANDOMSEED_ID, (uint8)CRYPTO_E_PARAM_VALUE );
    }
    else
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
    {
        /* If the parameter cryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_RandomSeed shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
        sVerifyKey = Crypto_Ipw_VerifyKeyId ( cryptoKeyId );
        if ( (Std_ReturnType)E_OK == sVerifyKey.eFound )
        {
            eOutResponse = Crypto_Ipw_ExtendPrngSeed(seedPtr);
        }
        else
        {
            (void)seedPtr;
            (void)seedLength;
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
            (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_RANDOMSEED_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
#endif
        }
    }

    return eOutResponse;
}


/**
* @brief           Generates new key material store it in the key identified by cryptoKeyId.
* @details         Generates new key material store it in the key identified by cryptoKeyId.
*
* @param[in]       cryptoKeyId            -   Holds the identifier of the key which is to be updated with the generated value.
* @param[inout]    None
* @param[out]      None
* @returns         E_OK: E_OK: Request successful
*                  E_NOT_OK: Request Failed
*                  E_BUSY: Request Failed, Crypto Driver Object is Busy
*
* @api
*
* @pre            
*
* @implements     Crypto_KeyGenerate_Activity
*                   
*/
/**
* @violates @ref Crypto_KeyManagement_c_REF_6 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyGenerate (VAR(uint32, AUTOMATIC) cryptoKeyId)
{
    VAR(Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_NOT_OK;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey;
    sVerifyKey = Crypto_Ipw_VerifyKeyId ( cryptoKeyId );
    
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
    /* If the module is not yet initialized and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyGenerate shall report CRYPTO_E_UNINIT to the DET and return E_NOT_OK. */
    if ( CRYPTO_UNINIT == Crypto_eDriverStatus )
    {
        /* Crypto driver has been already initialized */
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYGENERATE_ID, (uint8)CRYPTO_E_UNINIT );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    /* If the parameter cryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyGenerate shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
    else if ( (Std_ReturnType)E_NOT_OK == sVerifyKey.eFound )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYGENERATE_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    else
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
    {
     
        if ( (Std_ReturnType)E_OK == sVerifyKey.eFound )
        {
#if (CRYPTO_KEY_GEN_EXIST == 1U)               
            eOutResponse = Crypto_Ipw_GenerateExtendedRamKeysRandom(cryptoKeyId);
#endif /* (CRYPTO_KEY_GEN_EXIST == 1U) */
        }
        else
        {
            (void)cryptoKeyId;
        }
    }

    return eOutResponse;
}


/**
* @brief           Derives a new key by using the key elements in the given key identified by the cryptoKeyId.
* @details         Derives a new key by using the key elements in the given key identified by the cryptoKeyId. The given key contains the key elements for the password, salt. 
*                  The derived key is stored in the key element with the id 1 of the key identified by targetCryptoKeyId. The number of iterations is given in the key element CRYPTO_KE_KEYDERIVATION_ITERATIONS.
*
* @param[in]       cryptoKeyId            -   Holds the identifier of the key which is used for key derivation.
* @param[in]       targetCryptoKeyId      -   Holds the identifier of the key which is used to store the derived key.
* @param[inout]    None
* @param[out]      None
* @returns         E_OK: E_OK: Request successful
*                  E_NOT_OK: Request Failed
*                  E_BUSY: Request Failed, Crypto Driver Object is Busy
*
* @api
*
* @pre            
*
* @implements     Crypto_KeyDerive_Activity
*                   
*/
/**
* @violates @ref Crypto_KeyManagement_c_REF_6 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyDerive (VAR(uint32, AUTOMATIC) cryptoKeyId, VAR(uint32, AUTOMATIC) targetCryptoKeyId)
{
    VAR(Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_NOT_OK;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyTargetKey;

#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
    /* If the module is not yet initialized and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyDerive shall report CRYPTO_E_UNINIT to the DET and return E_NOT_OK. */
    if ( CRYPTO_UNINIT == Crypto_eDriverStatus )
    {
        /* Crypto driver has been already initialized */
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYDERIVE_ID, (uint8)CRYPTO_E_UNINIT );
    }
    else
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
    { 
        /* If the parameter cryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyDerive shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
        /* If the parameter targetCryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyDerive shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK.*/
        sVerifyKey = Crypto_Ipw_VerifyKeyId ( cryptoKeyId );
        if ( (Std_ReturnType)E_OK == sVerifyKey.eFound )
        {
            sVerifyTargetKey = Crypto_Ipw_VerifyKeyId ( targetCryptoKeyId );            
            if ((Std_ReturnType)E_OK == sVerifyTargetKey.eFound)
            {
#if (CRYPTO_KEY_DERIVE_EXIST == 1U)
                eOutResponse = Crypto_Ipw_GenerateExtendedRamKeysTls_1_2(cryptoKeyId);
#endif /* (CRYPTO_KEY_DERIVE_EXIST == 1U) */            
            }
            else
            {
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
                (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYDERIVE_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
            }
        }
        else
        {
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
            (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYDERIVE_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
        }
    }

    return eOutResponse;
}

/**
* @brief           Calculates the public value for the key exchange and stores the public key in the memory location pointed by the public value pointer.
* @details         Calculates the public value for the key exchange and stores the public key in the memory location pointed by the public value pointer. 
*
* @param[in]       cryptoKeyId            -   Holds the identifier of the key which shall be used for the key exchange protocol.
* @param[inout]    publicValueLengthPtr   -   Holds a pointer to the memory location in which the public value length information is stored. 
*                                             On calling this function, this parameter shall contain the size of the buffer provided by publicValuePtr.
*                                             When the request has finished, the actual length of the returned value shall be stored.
* @param[out]      publicValuePtr         -   Contains the pointer to the data where the public value shall be stored.
* @returns         E_OK: E_OK: Request successful
*                  E_NOT_OK: Request Failed
*                  E_BUSY: Request Failed, Crypto Driver Object is Busy
*                  CRYPTO_E_SMALL_BUFFER: The provided buffer is too small to store the result
*
* @api
*
* @pre            
*
* @implements     Crypto_KeyExchangeCalcPubVal_Activity
*                   
*/
/**
* @violates @ref Crypto_KeyManagement_c_REF_6 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyExchangeCalcPubVal (
                                                                VAR(uint32, AUTOMATIC) cryptoKeyId, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) publicValuePtr, 
                                                                P2VAR(uint32, AUTOMATIC, CRYPTO_APPL_DATA) publicValueLengthPtr
                                                                )
{
    VAR(Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_NOT_OK;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey = {(Std_ReturnType)E_NOT_OK, 0U};
    sVerifyKey = Crypto_Ipw_VerifyKeyId ( cryptoKeyId );
     
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
    /* If the module is not yet initialized and if development error detection for the Crypto Driver is enabled: The function Crypto_KeyExchangeCalcPubVal shall report CRYPTO_E_UNINIT to the DET and return E_NOT_OK. */
    if ( CRYPTO_UNINIT == Crypto_eDriverStatus )
    {
        /* Crypto driver has been already initialized */
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYEXCHANGECALCPUBVAL_ID, (uint8)CRYPTO_E_UNINIT );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    /* If the parameter cryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyExchangeCalcPubVal shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK. */
    else if ( (Std_ReturnType)E_NOT_OK == sVerifyKey.eFound )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYEXCHANGECALCPUBVAL_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }  
    /* If the parameter publicValuePtr is a null pointer and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyExchangeCalcPubVal shall report CRYPTO_E_PARAM_POINTER to the DET and return E_NOT_OK. */
    else if ( NULL_PTR == publicValuePtr )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYEXCHANGECALCPUBVAL_ID, (uint8)CRYPTO_E_PARAM_POINTER );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    /* If the parameter pubValueLengthPtr is a null pointer and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyExchangeCalcPubVal shall report CRYPTO_E_PARAM_POINTER to the DET and return E_NOT_OK. */
    else if ( NULL_PTR == publicValueLengthPtr )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYEXCHANGECALCPUBVAL_ID, (uint8)CRYPTO_E_PARAM_POINTER );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    /* If the value, which is pointed by pubValueLengthPtr is zero and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyExchangeCalcPubVal shall report CRYPTO_E_PARAM_VALUE to the DET and return E_NOT_OK. */
    else if ( 0U == *publicValueLengthPtr )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYEXCHANGECALCPUBVAL_ID, (uint8)CRYPTO_E_PARAM_VALUE );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    else
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
    {
        
        if ( (Std_ReturnType)E_OK == sVerifyKey.eFound )
        {
#if (CRYPTO_DH_PAIR_EXIST == 1U)
            eOutResponse = Crypto_Ipw_DhRsaKeyPairGen(cryptoKeyId, publicValueLengthPtr, publicValuePtr);
#endif /* (CRYPTO_DH_PAIR_EXIST == 1U) */
        }
        else
        {
            (void)cryptoKeyId;
            (void)publicValuePtr;
            (void)publicValueLengthPtr;
        }        
    }
#if (CRYPTO_DH_PAIR_EXIST == 1U)    
    /* If the buffer publicValuePtr is too small to store the result of the request, CRYPTO_E_SMALL_BUFFER shall be returned and the function shall additionally report the runtime error CRYPTO_E_RE_SMALL_BUFFER. */
    if ( (Std_ReturnType)CRYPTO_E_SMALL_BUFFER == eOutResponse )
    {
        (void) Det_ReportRuntimeError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYEXCHANGECALCPUBVAL_ID, (uint8)CRYPTO_E_RE_SMALL_BUFFER );
    }
#endif /* (CRYPTO_DH_PAIR_EXIST == 1U) */

    return eOutResponse;
}


/**
* @brief           Calculates the public value for the key exchange and stores the public key in the memory location pointed by the public value pointer.
* @details         Calculates the public value for the key exchange and stores the public key in the memory location pointed by the public value pointer. 
*
* @param[in]       cryptoKeyId                -   Holds the identifier of the key which shall be used for the key exchange protocol.
* @param[in]       partnerPublicValuePtr      -   Holds the pointer to the memory location which contains the partner's public value.
* @param[in]       partnerPublicValueLength   -   Contains the length of the partner's public value in bytes.
*                                                 On calling this function, this parameter shall contain the size of the buffer provided by publicValuePtr.
*                                                 When the request has finished, the actual length of the returned value shall be stored.
* @param[inout]    None
* @param[out]      None
* @returns         E_OK: E_OK: Request successful
*                  E_NOT_OK: Request Failed
*                  E_BUSY: Request Failed, Crypto Driver Object is Busy
*                  CRYPTO_E_SMALL_BUFFER: The provided buffer is too small to store the result
*
* @api
*
* @pre            
*
* @implements     Crypto_KeyExchangeCalcSecret_Activity
*                   
*/
/**
* @violates @ref Crypto_KeyManagement_c_REF_6 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_KeyExchangeCalcSecret (
                                                                VAR(uint32, AUTOMATIC) cryptoKeyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) partnerPublicValuePtr, 
                                                                VAR(uint32, AUTOMATIC) partnerPublicValueLength
                                                                )
{
    VAR(Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_NOT_OK;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey = {(Std_ReturnType)E_NOT_OK, 0U};
    sVerifyKey = Crypto_Ipw_VerifyKeyId ( cryptoKeyId );
    
#if (CRYPTO_DEV_ERROR_DETECT == STD_ON)
    /* If the module is not yet initialized and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyExchangeCalcSecret shall report CRYPTO_E_UNINIT to the DET and return E_NOT_OK. */
    if ( CRYPTO_UNINIT == Crypto_eDriverStatus )
    {
        /* Crypto driver has been already initialized */
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYEXCHANGECALCSECRET_ID, (uint8)CRYPTO_E_UNINIT );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    /* If the parameter cryptoKeyId is out of range and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyExchangeCalcSecret shall report CRYPTO_E_PARAM_HANDLE to the DET and return E_NOT_OK */
    else if ( (Std_ReturnType)E_NOT_OK == sVerifyKey.eFound )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYEXCHANGECALCSECRET_ID, (uint8)CRYPTO_E_PARAM_HANDLE );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    /* If the parameter partnerPublicValuePtr is a null pointer and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyExchangeCalcSecret shall report CRYPTO_E_PARAM_POINTER to the DET and return E_NOT_OK. */
    else if ( NULL_PTR == partnerPublicValuePtr )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYEXCHANGECALCSECRET_ID, (uint8)CRYPTO_E_PARAM_POINTER );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    /* If partnerPublicValueLength is zero and if development error detection for the Crypto Driver is enabled, the function Crypto_KeyExchangeCalcSecret shall report CRYPTO_E_PARAM_VALUE to the DET and return E_NOT_OK. */
    else if ( 0U == partnerPublicValueLength )
    {
        (void) Det_ReportError( (uint16)CRYPTO_MODULE_ID, (uint8)CRYPTO_INSTANCE_ID, (uint8)CRYPTO_KEYEXCHANGECALCSECRET_ID, (uint8)CRYPTO_E_PARAM_VALUE );
        eOutResponse = (Std_ReturnType)E_NOT_OK;
    }
    else
#endif /* (CRYPTO_DEV_ERROR_DETECT == STD_ON) */
    {
        
        if ( (Std_ReturnType)E_OK == sVerifyKey.eFound )
        {
#if (CRYPTO_DH_PAIR_EXIST == 1U)
            eOutResponse = Crypto_Ipw_DhRsaComputeSharedSecret((Hsm_DhKeyIdType)cryptoKeyId, partnerPublicValueLength, partnerPublicValuePtr);
#endif /* (CRYPTO_DH_PAIR_EXIST == 1U) */
        }
        else
        {
            (void)cryptoKeyId;
            (void)partnerPublicValuePtr;
            (void)partnerPublicValueLength; 
        }
    }

    return eOutResponse;
}

#define CRYPTO_STOP_SEC_CODE
/**
* @violates @ref Crypto_KeyManagement_c_REF_3 Violates MISRA 2004 Advisory Rule 19.1, #include preceded by non preproc directives.
* @violates @ref Crypto_KeyManagement_c_REF_4 , Repeated include file MemMap.h
*/
#include "Crypto_MemMap.h"
#ifdef __cplusplus
}
#endif

/** @} */
