/**
*   @file    Crypto_Cfg.c
*   @version 1.0.2
*
*   @brief   AUTOSAR Crypto - Brief file description (one line).
*   @details This is the CRYPTO driver configuration source file.
*
*   @addtogroup CRYPTO
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
extern "C"
{
#endif

/**
* @page misra_violations MISRA-C:2012 violations
*
* @section Crypto_cfg_c_REF_1
* Violates MISRA 2012 Advisory Rule 20.1, #include directives should only be preceded by preprocessor
* directives or comments. AUTOSAR imposes the specification of the sections in which certain parts
* of the driver must be placed.
*
* @section Crypto_cfg_c_REF_2
* Violates MISRA 2012 Required Directive 4.10, Precautions shall be taken in order to prevent the contents
* of a header file being included more than once. This comes from the order of includes in the .c file
* and from include dependencies. As a safe approach, any file must include all its dependencies.
* Header files are already protected against double inclusions. The inclusion of Crypto_MemMap.h is as
* per AUTOSAR requirement [SWS_MemMap_00003].
*
* @section [global]
* Violates MISRA 2004 Required Rule 1.4, The compiler/linker shall be checked to ensure that
* 31 character significance and case sensitivity are supported for external identifiers
* This violation is due to the requirement that requests to have a file version check.
* 
* @section [global]
* Violates MISRA 2004 Required Rule 5.1,
* Identifiers (internal and external) shall not rely on the significance of more than 31 characters. 
* The used compilers use more than 31 chars for identifiers.
*
* @section Crypto_cfg_c_REF_7
*          Violates MISRA 2004 Required Rule 19.15, Precautions shall be taken in order to
*          prevent the contents of a header file being included twice. All header files are
*          protected against multiple inclusions.
*
** @section Crypto_cfg_c_REF_8
*          Violates MISRA 2004 Advisory Rule 19.1, #include statements in a file should only be preceded 
*          by other preprocessor directives or comments. AUTOSAR imposes the specification of the sections 
*          in which certain parts of the driver must be placed.
*  @section Crypto_cfg_c_REF_9
*          Violates MISRA 2004 Required Rule 8.10, could be made static The respective code could not be made 
*          static because of layers architecture design of the driver.
*/

/*==================================================================================================
*                                        INCLUDE FILES
* 1) system and project includes
* 2) needed interfaces from external units
* 3) internal and external interfaces from this unit
==================================================================================================*/

#include "Crypto_Cfg.h"
#include "Crypto_Types.h"
#include "Crypto_Ipw.h"

/*==================================================================================================
*                              SOURCE FILE VERSION INFORMATION
==================================================================================================*/

#define CRYPTO_VENDOR_ID_CFG_C                      43

#define CRYPTO_AR_RELEASE_MAJOR_VERSION_CFG_C       4

#define CRYPTO_AR_RELEASE_MINOR_VERSION_CFG_C       3

#define CRYPTO_AR_RELEASE_REVISION_VERSION_CFG_C    1
#define CRYPTO_SW_MAJOR_VERSION_CFG_C               1
#define CRYPTO_SW_MINOR_VERSION_CFG_C               0
#define CRYPTO_SW_PATCH_VERSION_CFG_C               2

/*==================================================================================================
*                                     FILE VERSION CHECKS
==================================================================================================*/
[!NOCODE!][!//
[!INCLUDE "Crypto_VersionCheck_Src.m"!][!//
[!ENDNOCODE!][!//

/* Check if Crypto configuration source file and Crypto configuration header file are of the same vendor */
#if (CRYPTO_VENDOR_ID_CFG_C != CRYPTO_VENDOR_ID_CFG)
#error "Crypto_Cfg.c and Crypto_Cfg.h have different vendor ids"
#endif

/* Check if Crypto configuration source file and Crypto configuration header file are of the same Autosar version */
#if ((CRYPTO_AR_RELEASE_MAJOR_VERSION_CFG_C != CRYPTO_AR_RELEASE_MAJOR_VERSION_CFG) || \
     (CRYPTO_AR_RELEASE_MINOR_VERSION_CFG_C != CRYPTO_AR_RELEASE_MINOR_VERSION_CFG) || \
     (CRYPTO_AR_RELEASE_REVISION_VERSION_CFG_C != CRYPTO_AR_RELEASE_REVISION_VERSION_CFG) \
    )
#error "AutoSar Version Numbers of Crypto_Cfg.c and Crypto_Cfg.h are different"
#endif

/* Check if Crypto configuration source file and Crypto configuration header file are of the same Software version */
#if ((CRYPTO_SW_MAJOR_VERSION_CFG_C != CRYPTO_SW_MAJOR_VERSION_CFG) || \
     (CRYPTO_SW_MINOR_VERSION_CFG_C != CRYPTO_SW_MINOR_VERSION_CFG) || \
     (CRYPTO_SW_PATCH_VERSION_CFG_C != CRYPTO_SW_PATCH_VERSION_CFG) \
    )
#error "Software Version Numbers of Crypto_Cfg.c and Crypto_Cfg.h are different"
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

[!AUTOSPACING!]


[!IF "node:exists(CryptoKeys)"!][!//
    [!INDENT "0"!]
#define CRYPTO_START_SEC_VAR_INIT_8
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

    /* Create an array for each key element that is different from key material */
    [!ENDINDENT!][!//
    [!LOOP "node:order(CryptoKeyElements/CryptoKeyElement/*,'node:value(./CryptoKeyElementUniqueIndex)')"!][!//
        [!IF "node:value(./CryptoKeyElementId)!=1"!][!//
            [!IF "num:i(string-length(node:value(./CryptoKeyElementInitValue)))!=0"!][!//
                [!INDENT "0"!]
                [!CODE!][!//
                static VAR(uint8, CRYPTO_VAR) Crypto_aValue[!"node:name(.)"!][[!"num:i(./CryptoKeyElementSize)"!]] =
                {
                [!ENDCODE!][!//
                [!ENDINDENT!][!//
                [!INDENT "4"!][!//
                [!FOR "index" = "num:i(1)" TO "num:i(string-length(node:value(./CryptoKeyElementInitValue)))" STEP "num:i(2)"!][!//
                    [!IF "num:i((($index + 1) div 2)) = (node:value(./CryptoKeyElementSize) ) "!][!//
                        [!CODE!][!//
                        0x[!"substring(node:value(./CryptoKeyElementInitValue), $index, 2)"!]U
                        [!ENDCODE!][!//
                    [!ELSE!][!//
                        [!CODE!][!//
                        0x[!"substring(node:value(./CryptoKeyElementInitValue), $index, 2)"!]U,
                        [!ENDCODE!][!//
                    [!ENDIF!][!//
                [!ENDFOR!][!//
                [!VAR "countEl" = "$index"!][!//
                [!FOR "index" = "num:i($countEl+1)" TO "num:i(2 * node:value(./CryptoKeyElementSize) - 2)" STEP "num:i(2)"!][!//
                    [!IF "num:i(num:i(($index) div 2)+1) =(node:value(./CryptoKeyElementSize)) "!][!//
                        [!CODE!][!//
                        0x00U
                        [!ENDCODE!][!//
                    [!ELSE!][!//
                        [!CODE!][!//
                        0x00U,
                        [!ENDCODE!][!//
                    [!ENDIF!][!//
                [!ENDFOR!][!//
                [!ENDINDENT!][!//
                [!INDENT "0"!][!//
                };
                [!ENDINDENT!]
                [!CR!]
            [!ELSE!][!//
                [!INDENT "0"!]
                [!CODE!][!//
                static VAR(uint8, CRYPTO_VAR) Crypto_aValue[!"node:name(.)"!][[!"num:i(./CryptoKeyElementSize)"!]]=
                {
                [!FOR "index" = "num:i(1)" TO "num:i(node:value(./CryptoKeyElementSize) - 1)"!][!//
                    [!INDENT "4"!][!//
                    0x00U,
                    [!ENDINDENT!][!//
                [!ENDFOR!][!//
                [!INDENT "4"!][!//
                0x00U
                [!ENDINDENT!][!//
                [!INDENT "0"!][!//
                };
                [!ENDINDENT!]
                [!CR!]
                [!ENDCODE!][!//
                [!ENDINDENT!]
            [!ENDIF!][!//
        [!ENDIF!][!//
    [!ENDLOOP!]

#define CRYPTO_STOP_SEC_VAR_INIT_8
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

#define CRYPTO_START_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"
  
    [!INDENT "0"!]
    /* Create an info structure for each crypto key element */
    [!ENDINDENT!][!//
    [!LOOP "node:order(CryptoKeyElements/CryptoKeyElement/*,'node:value(./CryptoKeyElementUniqueIndex)')"!][!//
    [!INDENT "0"!]
    static VAR(Crypto_KeyElementType, CRYPTO_VAR) Crypto_s[!"node:name(.)"!] =
    {
    [!ENDINDENT!][!//
    [!INDENT "4"!]
    [!"node:value(./CryptoKeyElementId)"!]U,
    [!"node:value(./CryptoKeyElementUniqueIndex)"!]U,
    [!IF "node:value(./CryptoKeyElementAllowPartialAccess)"!][!//
        1U,
    [!ELSE!][!//
        0U,
    [!ENDIF!][!//
    [!"node:value(./CryptoKeyElementFormat)"!],
    [!IF "node:value(./CryptoKeyElementPersist)"!][!//
        1U,
    [!ELSE!][!//
        0U,
    [!ENDIF!][!//
    [!"node:value(./CryptoKeyElementReadAccess)"!],
    [!"node:value(./CryptoKeyElementSize)"!]U,
    [!"num:i((num:i(string-length(./CryptoKeyElementInitValue))) div 2)"!]U,
    [!"node:value(./CryptoKeyElementWriteAccess)"!],
    [!IF "node:value(./CryptoKeyElementId)!= 1"!][!//
        Crypto_aValue[!"node:name(.)"!]
    [!ELSE!][!//
        NULL_PTR
    [!ENDIF!][!//
    [!ENDINDENT!][!//
    [!INDENT "0"!]
    };
    [!CR!]
    [!ENDINDENT!][!//    
    [!ENDLOOP!][!//

#define CRYPTO_STOP_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"


#define CRYPTO_START_SEC_CONST_32
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

    [!INDENT "0"!]
    /* Create a array of elements for each crypto key type, containing the unique indexes of each crypto key element included inside this key type */
    [!ENDINDENT!]
    [!LOOP "node:order(CryptoKeyTypes/CryptoKeyType/*,'node:value(.)')"!][!//
        [!CODE!][!//
        [!INDENT "0"!]
        static CONST(uint32, CRYPTO_CONST) Crypto_aList[!"node:name(.)"!][[!"num:i(count(CryptoKeyElementRef/*))"!]] =
        {
        [!ENDINDENT!]
        [!ENDCODE!][!//
        [!VAR "CryptoLoopIt" = "num:i(count(CryptoKeyElementRef/*))"!][!//
        [!LOOP "node:order(CryptoKeyElementRef/*,'node:value(.)')"!][!//
            [!VAR "CryptoLoopIt" = "$CryptoLoopIt - 1"!][!//
            [!IF "$CryptoLoopIt != 0"!][!//
                [!CODE!][!//
                [!INDENT "4"!]
                [!"node:value(as:ref(node:value(.))/CryptoKeyElementUniqueIndex)"!]U,
                [!ENDINDENT!][!//
                [!ENDCODE!][!//
            [!ELSE!][!//
                [!CODE!][!//
                [!INDENT "4"!]
                [!"node:value(as:ref(node:value(.))/CryptoKeyElementUniqueIndex)"!]U
                [!ENDINDENT!][!//
                [!ENDCODE!][!//
            [!ENDIF!][!//
        [!ENDLOOP!][!//
        [!CODE!][!//
        [!INDENT "0"!]
        };
        [!ENDINDENT!]
        [!CR!]
        [!ENDCODE!][!//
    [!ENDLOOP!][!//
    
#define CRYPTO_STOP_SEC_CONST_32
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

#define CRYPTO_START_SEC_CONST_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

    [!INDENT "0"!]
    /* Create an info structure for each crypto key type, containing the number of key elements of this key type and also the array of the elements */
    [!ENDINDENT!]
    [!LOOP "node:order(CryptoKeyTypes/CryptoKeyType/*,'node:value(.)')"!]
        [!INDENT "0"!][!//
        static CONST(Crypto_KeyElementsType, CRYPTO_CONST) Crypto_a[!"node:name(.)"!] =
        {
        [!ENDINDENT!][!//
        [!VAR "CryptoLoopIt" = "num:i(count(CryptoKeyElementRef/*))"!][!//
        [!INDENT "4"!]
        [!"num:i($CryptoLoopIt)"!]U,
        Crypto_aList[!"node:name(.)"!]
        [!ENDINDENT!][!//
        [!INDENT "0"!][!//
        };
        [!ENDINDENT!][!//
        [!CR!]
    [!ENDLOOP!]
    
#define CRYPTO_STOP_SEC_CONST_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"


#define CRYPTO_START_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

    [!INDENT "0"!]
    /* Crypto driver key elements */
    P2VAR(Crypto_KeyElementType, AUTOMATIC, CRYPTO_APPL_DATA) Crypto_aKeyElementList[[!"num:i(count(CryptoKeyElements/CryptoKeyElement/*))"!]] =
    {
    [!ENDINDENT!]
    [!VAR "CryptoLoopIt" = "count(CryptoKeyElements/CryptoKeyElement/*)"!][!//
    [!LOOP "node:order(CryptoKeyElements/CryptoKeyElement/*,'node:value(./CryptoKeyElementUniqueIndex)')"!][!//
        [!VAR "CryptoLoopIt" = "$CryptoLoopIt - 1"!][!//
        [!INDENT "4"!]
        &Crypto_s[!"node:name(.)"!][!//
        [!IF "$CryptoLoopIt != 0"!][!//
            ,
        [!ELSE!][!//
            [!CR!]
        [!ENDIF!][!//
        [!ENDINDENT!]
    [!ENDLOOP!][!//
    [!INDENT "0"!]
    };
    [!ENDINDENT!]

    
    [!INDENT "0"!]
    /* Create an info structure for each crypto key */
    [!ENDINDENT!][!//
    [!LOOP "node:order(CryptoKeys/CryptoKey/*,'node:value(./CryptoKeyId)')"!][!//
        [!INDENT "0"!]
        static VAR(Crypto_KeyType, AUTOMATIC) Crypto_s[!"node:name(.)"!] =
        {
        [!ENDINDENT!][!//
        [!INDENT "4"!]
        [!"node:value(./CryptoKeyId)"!]U,
        [!"node:value(./CryptoKeyDeriveIterations)"!]U,
        0U,
        &Crypto_a[!"node:name(as:ref(node:value(./CryptoKeyTypeRef)))"!]
        [!ENDINDENT!][!//
        [!INDENT "0"!]
        };
        [!ENDINDENT!][!//
        [!CR!]
    [!ENDLOOP!][!//

    [!INDENT "0"!]
    /* Crypto keys */
    [!CODE!][!//
    P2VAR(Crypto_KeyType, AUTOMATIC, CRYPTO_APPL_DATA) Crypto_aKeyList[[!"num:i(count(CryptoKeys/CryptoKey/*))"!]] =
    {
    [!ENDCODE!][!//
    [!ENDINDENT!][!//
    [!VAR "CryptoLoopIt" = "count(CryptoKeys/CryptoKey/*)"!][!//
    [!LOOP "node:order(CryptoKeys/CryptoKey/*,'node:value(./CryptoKeyId)')"!][!//
        [!VAR "CryptoLoopIt" = "$CryptoLoopIt - 1"!][!//
        [!CODE!][!//
        [!INDENT "4"!]
        [!IF "$CryptoLoopIt != 0"!][!//
            &Crypto_s[!"node:name(.)"!],
        [!ELSE!][!//
            &Crypto_s[!"node:name(.)"!]
        [!ENDIF!][!// 
        [!ENDINDENT!][!//
        [!ENDCODE!][!//
    [!ENDLOOP!][!//
    [!CODE!][!//
    [!INDENT "0"!]
    };
    [!ENDINDENT!][!//
    [!ENDCODE!][!//

[!ENDIF!]
#define CRYPTO_STOP_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"


#define CRYPTO_START_SEC_VAR_NO_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

/* Create an array for queued jobs for each crypto driver object */
[!LOOP "node:order(CryptoDriverObjects/CryptoDriverObject/*,'node:value(./CryptoDriverObjectId)')"!][!//
    [!IF "node:value(./CryptoQueueSize)!= 0"!][!//
        [!INDENT "0"!]
        static VAR (Crypto_QueueType, CRYTO_VAR) Crypto_aQueuedJobs[!"node:name(.)"!][[!"node:value(./CryptoQueueSize)"!]U];
        [!ENDINDENT!][!//
    [!ENDIF!][!//
[!ENDLOOP!]

#define CRYPTO_STOP_SEC_VAR_NO_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"


#define CRYPTO_START_SEC_CONST_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

/* Create an array for all the primitives belonging to one crypto driver object */
[!LOOP "node:order(CryptoDriverObjects/CryptoDriverObject/*,'node:value(./CryptoDriverObjectId)')"!][!//
    [!INDENT "0"!]
    static CONST(Crypto_PrimitiveType, CRYPTO_CONST) Crypto_aPrimitive[!"node:name(.)"!][[!"num:i(count(CryptoPrimitiveRef/*))"!]] =
    {
    [!ENDINDENT!][!//
    [!VAR "CryptoLoopIt" = "num:i(count(CryptoPrimitiveRef/*))"!][!//
    [!LOOP "node:order(CryptoPrimitiveRef/*)"!][!//
        [!INDENT "4"!]
        {
        [!ENDINDENT!][!//
        [!INDENT "8"!]
        [!"node:value(as:ref(node:value(.))/CryptoPrimitiveService)"!],
        [!"node:value(as:ref(node:value(.))/CryptoPrimitiveAlgorithmFamily)"!],
        [!"node:value(as:ref(node:value(.))/CryptoPrimitiveAlgorithmMode)"!],
        [!"node:value(as:ref(node:value(.))/CryptoPrimitiveAlgorithmSecondaryFamily)"!]
        [!ENDINDENT!]
        [!INDENT "4"!]
        [!IF "$CryptoLoopIt != 1"!][!//
            },
        [!ELSE!][!//
            }
        [!ENDIF!][!//
        [!ENDINDENT!][!//
        [!VAR "CryptoLoopIt" = "$CryptoLoopIt - 1"!][!//
    [!ENDLOOP!][!//
    [!INDENT "0"!]
    };
    [!ENDINDENT!][!//
[!ENDLOOP!]

#define CRYPTO_STOP_SEC_CONST_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"


#define CRYPTO_START_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

/* Create an info structure for each crypto driver object */
[!LOOP "node:order(CryptoDriverObjects/CryptoDriverObject/*,'node:value(./CryptoDriverObjectId)')"!][!//
    [!INDENT "0"!]
    static VAR(Crypto_ObjectType, CRYPTO_VAR) Crypto_s[!"node:name(.)"!] =
    {
    [!ENDINDENT!][!//
    [!INDENT "4"!]
    [!"node:value(./CryptoDriverObjectId)"!]U,
    [!IF "node:value(./CryptoQueueSize)!= 0"!][!//
        Crypto_aQueuedJobs[!"node:name(.)"!],
    [!ELSE!][!//
        NULL_PTR,
    [!ENDIF!][!//
    [!"node:value(./CryptoQueueSize)"!]U,
    0U,
    0U,
    Crypto_aPrimitive[!"node:name(.)"!],
    [!"num:i(count(CryptoPrimitiveRef/*))"!]U
    [!ENDINDENT!][!//
    [!INDENT "0"!]
    };
    [!ENDINDENT!][!//
    [!CR!]
[!ENDLOOP!][!//

/* Crypto driver object description */
[!INDENT "0"!]
P2VAR(Crypto_ObjectType, AUTOMATIC, CRYPTO_APPL_DATA) Crypto_aObjectList[[!"num:i(count(CryptoDriverObjects/CryptoDriverObject/*))"!]] =
{
[!ENDINDENT!][!//
[!VAR "CryptoLoopIt" = "count(CryptoDriverObjects/CryptoDriverObject/*)"!][!//
[!LOOP "node:order(CryptoDriverObjects/CryptoDriverObject/*,'node:value(./CryptoDriverObjectId)')"!][!//
    [!INDENT "4"!]
    [!VAR "CryptoLoopIt" = "$CryptoLoopIt - 1"!][!//
    &[!"node:name(./../../../../..)"!]_s[!"node:name(.)"!][!//
    [!IF "$CryptoLoopIt != 0"!][!//
        ,
    [!ELSE!][!//
        [!CR!]
    [!ENDIF!][!//
    [!ENDINDENT!]
[!ENDLOOP!]
};

#define CRYPTO_STOP_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

[!IF "node:exists(CryptoExportKeys)"!][!//
#define CRYPTO_START_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"
    [!INDENT "0"!]
    /* Create an info structure for CryptoExportKeys */
    [!ENDINDENT!][!//
    [!LOOP "node:order(CryptoExportKeys/CryptoExportKey/*,'node:value(.)')"!][!//
    [!INDENT "0"!]
/**
* @violates @ref Crypto_Cfg_c_REF_1 Violates MISRA 2004 Required Rule 1.4 The compiler/linker shall be checked.
*
* @violates @ref Crypto_Cfg_c_REF_2 Violates MISRA 2004 Required Rule 5.1 Identifiers (internal and external).
*/
    static VAR(Crypto_Cse_GetKeyParams, CRYPTO_VAR) Crypto_s[!"node:name(.)"!] =
    {
    [!ENDINDENT!][!//
    [!INDENT "4"!]
    [!"node:value(./KeyId)"!]U,
    [!"node:value(./KeyElementId)"!]U,
    [!"node:value(./PtrLength)"!]U,
    &Crypto_s[!"node:name(as:ref(node:value(./CryptoKeyRef)))"!]
    [!ENDINDENT!][!//
    [!INDENT "0"!]
    };
    [!CR!]
    [!ENDINDENT!][!//
    [!ENDLOOP!][!//
#define CRYPTO_STOP_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

#define CRYPTO_START_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"
    [!INDENT "0"!]
    /* Crypto ExportKey */
    /**
    * @violates @ref Crypto_cfg_c_REF_9 Violates MISRA 2004 Required Rule 8.10 could be made static
    */
    P2VAR(Crypto_Cse_GetKeyParams, AUTOMATIC, CRYPTO_APPL_DATA) Crypto_aExportKeyList[[!"num:i(count(CryptoExportKeys/CryptoExportKey/*))"!]] =
    {
    [!ENDINDENT!]
    [!VAR "CryptoLoopIt" = "count(CryptoExportKeys/CryptoExportKey/*)"!][!//
    [!LOOP "node:order(CryptoExportKeys/CryptoExportKey/*,'node:value(.)')"!][!//
        [!VAR "CryptoLoopIt" = "$CryptoLoopIt - 1"!][!//
        [!INDENT "4"!]
        &Crypto_s[!"node:name(.)"!][!//
        [!IF "$CryptoLoopIt != 0"!][!//
            ,
        [!ELSE!][!//
            [!CR!]
        [!ENDIF!][!//
        [!ENDINDENT!]
    [!ENDLOOP!][!//
    [!INDENT "0"!]
    };
    [!ENDINDENT!]
#define CRYPTO_STOP_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_cfg_c_REF_7 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_cfg_c_REF_8 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"
[!ENDIF!]


[!NOCODE!]
[!LOOP "node:order(CryptoKeyTypes/CryptoKeyType/*,'node:value(.)')"!]
    [!SELECT "CryptoKeyElementRef"!]
        [!VAR "countEl" = "num:i(count(*))"!]
        [!FOR "index" = "num:i(1)" TO "num:i($countEl - 1)"!]
            [!SELECT "./*[num:i($index)]"!]
                [!VAR "prevId" = "node:ref(node:value(.))/CryptoKeyElementId"!]
                [!FOR "secondIndex" = "num:i($index + 1)" TO "$countEl"!]
                    [!SELECT "../*[num:i($secondIndex)]"!]
                        [!IF "$prevId = node:ref(node:value(.))/CryptoKeyElementId"!]
                            [!ERROR!]
                                "Duplicated CryptoKeyElementId, please check that the KeyTypes lists have elements with unique keyElementId"
                            [!ENDERROR!]
                        [!ENDIF!]
                    [!ENDSELECT!]
                [!ENDFOR!]
            [!ENDSELECT!]
        [!ENDFOR!]
    [!ENDSELECT!]
[!ENDLOOP!]
[!ENDNOCODE!]

/*==================================================================================================
*                                   LOCAL FUNCTION PROTOTYPES
==================================================================================================*/


/*==================================================================================================
*                                       LOCAL FUNCTIONS
==================================================================================================*/

/*==================================================================================================
*                                       GLOBAL FUNCTIONS
==================================================================================================*/

#ifdef __cplusplus
}
#endif

/** @} */
