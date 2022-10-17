/**
*   @file    Crypto_KeyManagement.h
*   @implements Crypto_KeyManagement.h_Artifact
*   @version 1.0.2
*   @brief   AUTOSAR Crypto - Crypto Key Management interface
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

#ifndef CRYPTO_KEYMANAGEMENT_H
#define CRYPTO_KEYMANAGEMENT_H

#ifdef __cplusplus
extern "C"{
#endif

/**
* @page misra_violations MISRA-C:2004 violations
*
*
* @section Crypto_KeyManagement_h_REF_1
*           Violates MISRA 2004 Required Rule 1.4, Identifier clash.
*           This violation is due to the requirement that request to have a file version check.
*
* @section Crypto_KeyManagement_h_REF_2
*           Violates MISRA 2004 Required Rule 5.1, External identifiers shall be distinct.
*           The used compilers use more than 31 chars for identifiers.
*
** @section Crypto_KeyManagement_h_REF_3
*          Violates MISRA 2004 Required Rule 19.15, Precautions shall be taken in order to
*          prevent the contents of a header file being included twice. All header files are
*          protected against multiple inclusions.
*/



/*==================================================================================================
*                                        INCLUDE FILES
* 1) system and project includes
* 2) needed interfaces from external units
* 3) internal and external interfaces from this unit
==================================================================================================*/

/*==================================================================================================
*                              SOURCE FILE VERSION INFORMATION
==================================================================================================*/
/**
* @file           Crypto_KeyManagement.h    
*/
/**
* @violates @ref Crypto_KeyManagement_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_KeyManagement_h_REF_2 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_KEY_MANAGEMENT_VENDOR_ID                       43
/**
* @violates @ref Crypto_KeyManagement_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_KeyManagement_h_REF_2 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MAJOR_VERSION        4
/**
* @violates @ref Crypto_KeyManagement_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_KeyManagement_h_REF_2 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_KEY_MANAGEMENT_AR_RELEASE_MINOR_VERSION        3
/**
* @violates @ref Crypto_KeyManagement_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_KeyManagement_h_REF_2 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_KEY_MANAGEMENT_AR_RELEASE_REVISION_VERSION     1
/**
* @violates @ref Crypto_KeyManagement_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_KeyManagement_h_REF_2 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_KEY_MANAGEMENT_SW_MAJOR_VERSION                1
/**
* @violates @ref Crypto_KeyManagement_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_KeyManagement_h_REF_2 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_KEY_MANAGEMENT_SW_MINOR_VERSION                0
/**
* @violates @ref Crypto_KeyManagement_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_KeyManagement_h_REF_2 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_KEY_MANAGEMENT_SW_PATCH_VERSION                2
/**
* @violates @ref Crypto_KeyManagement_h_REF_1 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_KeyManagement_h_REF_2 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
/*==================================================================================================
*                                    FILE VERSION CHECKS
==================================================================================================*/

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

#ifdef __cplusplus
}
#endif

#endif /* CRYPTO_KEYMANAGEMENT_H */

/** @} */
