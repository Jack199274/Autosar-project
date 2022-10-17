/**
*   @file    Mcu_CortexM4_Types.h
*   @version 1.0.2
*
*   @brief   AUTOSAR Mcu - Exported data outside of the Mcu from SRC.
*   @details Public data types exported outside of the Mcu driver.
*
*   @addtogroup MCU
*   @{
*/
/*==================================================================================================
*   Project              : AUTOSAR 4.3 MCAL
*   Platform             : ARM
*   Peripheral           : MC
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


#ifndef Mcu_CortexM4_Types_H
#define Mcu_CortexM4_Types_H

#ifdef __cplusplus
extern "C"{
#endif

/**
* @page misra_violations MISRA-C:2004 violations
*
* @section Mcu_CortexM4_Types_h_REF_1
* Violates MISRA 2004 Required Rule 1.4, : The compiler/linker shall be checked to ensure that 31
* character significance and case sensitivity are supported for external identifiers
*
* @section [global]
* Violates MISRA 2004 Required Rule 5.1, Identifiers (internal and external) shall not rely
* on the significance of more than 31 characters. The used compilers use more than 31 chars for
* identifiers.
*/

/*==================================================================================================
                                         INCLUDE FILES
 1) system and project includes
 2) needed interfaces from external units
 3) internal and external interfaces from this unit
==================================================================================================*/


/*==================================================================================================
                               SOURCE FILE VERSION INFORMATION
==================================================================================================*/

#define MCU_CORTEXM4_TYPES_VENDOR_ID                     43
/** @violates @ref Mcu_CortexM4_Types_h_REF_1 MISRA 2004 Required Rule 1.4, 31 characters limit.*/
#define MCU_CORTEXM4_TYPES_AR_RELEASE_MAJOR_VERSION      4
/** @violates @ref Mcu_CortexM4_Types_h_REF_1 MISRA 2004 Required Rule 1.4, 31 characters limit.*/
#define MCU_CORTEXM4_TYPES_AR_RELEASE_MINOR_VERSION      3
#define MCU_CORTEXM4_TYPES_AR_RELEASE_REVISION_VERSION   1
#define MCU_CORTEXM4_TYPES_SW_MAJOR_VERSION              1
#define MCU_CORTEXM4_TYPES_SW_MINOR_VERSION              0
#define MCU_CORTEXM4_TYPES_SW_PATCH_VERSION              2


/*==================================================================================================
                                      FILE VERSION CHECKS
==================================================================================================*/

/*==================================================================================================
*                                          CONSTANTS
==================================================================================================*/

/*==================================================================================================
                                       DEFINES AND MACROS
==================================================================================================*/

/**************************************************************/
/*                 System Control Register                    */
/**************************************************************/
#define CM4_SCR_SLEEPONEXIT_ENA_U32    ((uint32)0x00000002U)
#define CM4_SCR_SLEEPONEXIT_DIS_U32    ((uint32)0x00000000U)


/*==================================================================================================
*                                             ENUMS
==================================================================================================*/

/*==================================================================================================
*                                GLOBAL VARIABLE DECLARATIONS
==================================================================================================*/


/*==================================================================================================
*                                    FUNCTION PROTOTYPES
==================================================================================================*/


#ifdef __cplusplus
}
#endif

#endif /* Mcu_CortexM4_Types_H */

/** @} */
