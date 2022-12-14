/**
*   @file    Lin_Cfg.c
*   @implements Lin_Cfg.c_Artifact
*   @version 1.0.2
*
*   @brief   AUTOSAR Lin - Brief file description (one line).
*   @details Detailed file description (can be multiple lines).
*
*   @addtogroup LIN
*   @{
*/
/*==================================================================================================
*   Project              : AUTOSAR 4.3 MCAL
*   Platform             : ARM
*   Peripheral           : LPUART,FLEXIO
*   Dependencies         : 
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
* @page misra_violations MISRA-C:2004 violations
*
* @section [global]
* Violates MISRA 2004 Required Rule 5.1, Identifiers (internal and external) shall not rely
* on the significance of more than 31 characters. The used compilers use more than 31 chars for
* identifiers.
*
* @section Lin_Cfg_c_REF_1
* Violates MISRA 2004 Required Rule 19.15, Precautions shall be taken
* in order to prevent the contents of a header file being included twice.
* This comes from the order of includes in the .c file and from
* include dependencies. As a safe approach, any file must include all
* its dependencies. Header files are already protected against double
* inclusions. The inclusion of MemMap.h is as per Autosar
* requirement MEMMAP003.
*
* @section Lin_Cfg_c_REF_2
* Violates MISRA 2004 Advisory Rule 19.1, only preprocessor statements and comments
* before '#include' MemMap.h included after each section define in order to set
* the current memory section
*
* @section Lin_Cfg_c_REF_3
* Violates MISRA 2004 Required Rule 1.4, Identifier clash
* This violation is due to the requirement that request to have a file version check.
*
* @section Lin_Cfg_c_REF_4
* Violates MISRA 2004 Required Rule 8.10, All declarations and defnitions of objects or functions at
* file scope shall have internal linkage unless external linkage is required.
*
*/


/*==================================================================================================
*                                        INCLUDE FILES
* 1) system and project includes
* 2) needed interfaces from external units
* 3) internal and external interfaces from this unit
==================================================================================================*/
#include "Std_Types.h"
#include "Lin.h"

#if (LIN_FLEXIO_USED == STD_ON)
#include "Reg_eSys_FlexIO.h"
#endif

#if (LIN_DISABLE_DEM_REPORT_ERROR_STATUS == STD_OFF)
#include "Dem.h"
#endif /* (LIN_DISABLE_DEM_REPORT_ERROR_STATUS == STD_OFF) */

/*==================================================================================================
*                              SOURCE FILE VERSION INFORMATION
==================================================================================================*/
/**
* @file           Lin_Cfg.c
*/
#define LIN_VENDOR_ID_CFG_C                      43
/*
* @violates @ref Lin_Cfg_c_REF_3 The compiler/linker shall be checked to
* ensure that 31 character signifiance and case sensitivity are supported for
* external identifiers.
*/
#define LIN_AR_RELEASE_MAJOR_VERSION_CFG_C       4
/*
* @violates @ref Lin_Cfg_c_REF_3 The compiler/linker shall be checked to
* ensure that 31 character signifiance and case sensitivity are supported for
* external identifiers.
*/
#define LIN_AR_RELEASE_MINOR_VERSION_CFG_C       3
/*
* @violates @ref Lin_Cfg_c_REF_3 The compiler/linker shall be checked to
* ensure that 31 character signifiance and case sensitivity are supported for
* external identifiers.
*/
#define LIN_AR_RELEASE_REVISION_VERSION_CFG_C    1
#define LIN_SW_MAJOR_VERSION_CFG_C               1
#define LIN_SW_MINOR_VERSION_CFG_C               0
#define LIN_SW_PATCH_VERSION_CFG_C               2

/*==================================================================================================
*                                     FILE VERSION CHECKS
==================================================================================================*/
[!NOCODE!][!//
[!INCLUDE "Lin_VersionCheck_Src.m"!][!//
[!ENDNOCODE!][!//
/* Check if current file and Lin.h header file are of the same Autosar version */
#if (LIN_VENDOR_ID_CFG_C != LIN_VENDOR_ID)
    #error "Lin_Cfg.c and Lin.h have different vendor ids"
#endif
#if ((LIN_AR_RELEASE_MAJOR_VERSION_CFG_C    != LIN_AR_RELEASE_MAJOR_VERSION) || \
     (LIN_AR_RELEASE_MINOR_VERSION_CFG_C    != LIN_AR_RELEASE_MINOR_VERSION) || \
     (LIN_AR_RELEASE_REVISION_VERSION_CFG_C != LIN_AR_RELEASE_REVISION_VERSION))
  #error "AutoSar Version Numbers of Lin_Cfg.c and Lin.h are different"
#endif
/* Check if current file and Lin.h header file are of the same Software version */
#if ((LIN_SW_MAJOR_VERSION_CFG_C != LIN_SW_MAJOR_VERSION) || \
     (LIN_SW_MINOR_VERSION_CFG_C != LIN_SW_MINOR_VERSION) || \
     (LIN_SW_PATCH_VERSION_CFG_C != LIN_SW_PATCH_VERSION) )
  #error "Software Version Numbers of Lin_Cfg.c and Lin.h are different"
#endif

#ifndef DISABLE_MCAL_INTERMODULE_ASR_CHECK
    #if ((LIN_AR_RELEASE_MAJOR_VERSION_CFG_C != STD_AR_RELEASE_MAJOR_VERSION) || \
       (LIN_AR_RELEASE_MINOR_VERSION_CFG_C != STD_AR_RELEASE_MINOR_VERSION))
    #error "AutoSar Version Numbers of Lin_Cfg.c and Std_Types.h are different"
    #endif

    #if (LIN_DISABLE_DEM_REPORT_ERROR_STATUS == STD_OFF)
    /* Check if current file and Dem.h header file are of the same Autosar version */
    #if ((LIN_AR_RELEASE_MAJOR_VERSION_CFG_C != DEM_AR_RELEASE_MAJOR_VERSION) || \
         (LIN_AR_RELEASE_MINOR_VERSION_CFG_C != DEM_AR_RELEASE_MINOR_VERSION))
        #error "AutoSar Version Numbers of Lin_Cfg.c and Dem.h are different"
    #endif
    #endif /* (LIN_DISABLE_DEM_REPORT_ERROR_STATUS == STD_OFF) */

    #if (LIN_FLEXIO_USED == STD_ON)
        /* Check if current file and Reg_eSys_FlexIO.h header file are of the same Autosar version */
        #if ((LIN_AR_RELEASE_MAJOR_VERSION_CFG_C    != REG_ESYS_FLEXIO_AR_RELEASE_MAJOR_VERSION) || \
             (LIN_AR_RELEASE_MINOR_VERSION_CFG_C    != REG_ESYS_FLEXIO_AR_RELEASE_MINOR_VERSION) \
            )
            #error "AutoSar Version Numbers of Lin_Cfg.c and Reg_eSys_FlexIO.h are different"
        #endif
    #endif /* (LIN_FLEXIO_USED == STD_ON) */
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
#define LIN_START_SEC_CONST_UNSPECIFIED
/**
* @violates @ref Lin_Cfg_c_REF_1 #include statements in a file should
*     only be preceded by other preprocessor directives or comments.
*/
#include "Lin_MemMap.h"

[!NOCODE!][!//
[!LOOP "LinGlobalConfig/LinChannel/*"!][!//
    [!VAR "nodeName" = "name(.)"!]
    [!CODE!]
CONST(Lin_StaticConfig_ChannelConfigType,LIN_CONST) Lin_[!"node:name(.)"!]_PC=
{
    (uint8)[!"LinChannelId"!]U,     /* Lin Channel ID */
    [!"LinHwChannel"!],             /* Lin Hardware channel*/
    [!IF "contains(node:value(LinHwChannel), 'FLEXIO')"!]LIN_FLEXIO_CHANNEL[!ELSE!] LIN_LPUART_CHANNEL [!ENDIF!],[!// /* Lin Hardware channel Type */
[!IF "LinChannelWakeupSupport"!][!//
    (uint8)STD_ON,                /* Wakeup support enabled */
[!ELSE!][!//
    (uint8)STD_OFF,               /* Wakeup support disabled */
    [!ENDIF!][!//
    [!IF "(node:exists(LinChannelEcuMWakeupSource) = 'true') and (node:value(LinChannelEcuMWakeupSource) != '')"!][!//
    (EcuM_WakeupSourceType)((uint32)1U<<(uint32)[!"as:ref(LinChannelEcuMWakeupSource)/EcuMWakeupSourceId"!]U) /* Wakeup Source transmitted to the Ecu State Manager (used only when Wakeup Support is true) */
    [!ELSE!][!//
    (EcuM_WakeupSourceType)LIN_NONE_ECUM_WAKEUP_SOURCE_REF /* None Wakeup Source was referred */
    [!ENDIF!]
};
    [!ENDCODE!]
[!IF "contains(node:value(LinHwChannel),'FLEXIO')"!][!//
    [!VAR "TxPinID" = "num:i(substring-after(LinFlexIOModuleConfiguration/LinTxPinConfiguration,'FXIO_D'))"!][!//
    [!VAR "RxPinID" = "num:i(substring-after(LinFlexIOModuleConfiguration/LinRxPinConfiguration,'FXIO_D'))"!][!//
    [!VAR "index" = "num:i(substring-after(LinHwChannel,'LIN_'))"!][!//
[!CODE!]
/**
 * @brief   FlexIO Config parameters
 */
/**
* @violates @ref Lin_Cfg_c_REF_4 declarations and definitions of objects or functions at
* file scope shall have internal linkage unless external linkage is required.
*/
CONST(Lin_FlexIO_ConfigType,LIN_CONST) Lin_FlexIO_[!"node:name(.)"!]_PC=
{
    (uint8)[!"substring(LinHwChannel,14,1)"!]U,  /* FlexIO Hw Module */
    (uint32)[!"num:i(2 * $index)"!]U,       /* TxShifterID */
    (uint32)[!"num:i((2 * $index)+1)"!]U,   /* RxShifterID */
    (uint32)[!"num:i(2 * $index)"!]U,       /* TxTimerID */
    (uint32)[!"num:i((2 * $index)+1)"!]U,   /* RxTimerID */
    (uint32)[!"num:i($TxPinID)"!]U,       /* TxPinID */
    (uint32)[!"num:i($RxPinID)"!]U    /* RxPinID */
};
[!ENDCODE!]
[!ENDIF!][!//
[!ENDLOOP!][!//


[!LOOP "LinGlobalConfig/LinChannel/*"!][!//
[!IF "contains(node:value(LinHwChannel), 'FLEXIO')"!]
[!CODE!]
/**
 * @brief   Null FlexIO Config parameters
 */
/**
* @violates @ref Lin_Cfg_c_REF_4 declarations and definitions of objects or functions at
* file scope shall have internal linkage unless external linkage is required.
*/
CONST(Lin_FlexIO_ConfigType,LIN_CONST) Lin_FlexIO_Null_PC=
{
    (uint8)0U,   /* FlexIO Hw Module */
    (uint32)0U,   /* TxShifterID */
    (uint32)0U,   /* TxTimerID */
    (uint32)0U,   /* RxShifterID */
    (uint32)0U,   /* RxTimerID */
    (uint32)0U,   /* TxPinID */
    (uint32)0U    /* RxPinID */
};
[!ENDCODE!]
[!BREAK!]
[!ENDIF!][!//
[!ENDLOOP!][!//

[!CODE!]
#if (LIN_DISABLE_DEM_REPORT_ERROR_STATUS == STD_OFF)
/**
 * @brief   DEM error parameters
 */
CONST(Mcal_DemErrorType,LIN_CONST) Lin_E_TimeoutCfg =
{
[!ENDCODE!]

[!VAR "LinDemErrorEnable" = "'false'"!]
[!IF "AutosarExt/LinDisableDemReportErrorStatus ='false'"!][!//
    [!IF "node:exists(LinDemEventParameterRefs)"!]
        [!VAR "LinDemErrorEnable" = "'true'"!]
    [!ENDIF!]
[!ENDIF!]

[!IF "$LinDemErrorEnable"!]
    [!IF "node:exists(LinDemEventParameterRefs/LIN_E_TIMEOUT)"!]
        [!IF "node:exists(node:value(LinDemEventParameterRefs/LIN_E_TIMEOUT))"!]
            [!CODE!]
    (uint32)STD_ON,
    DemConf_DemEventParameter_[!"node:name(node:ref(LinDemEventParameterRefs/LIN_E_TIMEOUT))"!]
            [!ENDCODE!]
        [!ELSE!]
            [!ERROR "Invalid reference for LIN_E_ERROR"!]
        [!ENDIF!]
    [!ELSE!]
        [!CODE!]
    (uint32)STD_OFF,
    0U
        [!ENDCODE!]
    [!ENDIF!]
[!ELSE!]
    [!CODE!]
    (uint32)STD_OFF,
    0U
    [!ENDCODE!]
[!ENDIF!]

[!CODE!]
};
#endif /* LIN_DISABLE_DEM_REPORT_ERROR_STATUS == STD_OFF */
[!ENDCODE!]
[!ENDNOCODE!][!//

#define LIN_STOP_SEC_CONST_UNSPECIFIED
/**
* @violates @ref Lin_Cfg_c_REF_1 Precautions shall be taken in order to prevent the contents
* of a header file being included twice.
*
* @violates @ref Lin_Cfg_c_REF_2 Only preprocessor
* statements and comments before '#include'
*/
#include "Lin_MemMap.h"

/*==================================================================================================
*                                      GLOBAL VARIABLES
==================================================================================================*/

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
