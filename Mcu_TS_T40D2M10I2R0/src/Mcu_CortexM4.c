/**
*   @file    Mcu_CortexM4.c
*   @version 1.0.2
*
*   @brief   AUTOSAR Mcu - ARM CortexM4 Registers and Macros Definitions.
*   @details ARM CortexM4 Registers and Macros Definitions.
*
*   @addtogroup CORTEXM_DRIVER
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

/**
@file        Mcu_CortexM4.c
*/


#ifdef __cplusplus
extern "C"{
#endif

/**
* @page misra_violations MISRA-C:2004 violations
*
* @section Mcu_CortexM4_c_REF_1
* Violates MISRA 2004 Required Rule 19.15, Repeated include file MemMap.h,  Precautions shall be
* taken in order to prevent the contents of a header file being included twice This is not a
* violation since all header files are protected against multiple inclusions
*
* @section Mcu_CortexM4_c_REF_2
* Violates MISRA 2004 Advisory Rule 19.1, only preprocessor statements and comments
* before '#include' MemMap.h included after each section define in order to set the current memory
* section
*
* @section Mcu_CortexM4_c_REF_3
* Violates MISRA 2004 Required Rule 1.4, The compiler/linker shall be checked to ensure
* that 31 character significance and case sensitivity are supported for external identifiers.
* The defines are validated.
*
* @section Mcu_CortexM4_c_REF_4
* Violates MISRA 2004 Required Rule 11.1, Conversions shall not be performed between a pointer
* to a function and any other type than an integral type. Specific for accessing memory-mapped
* registers
*
* @section Mcu_CortexM4_c_REF_5
* Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed between
* a pointer type and an integral type
* The cast is used to access memory mapped registers.
*
* @section Mcu_CortexM4_c_REF_6
* Violates MISRA 2004 Required Rule 8.10, All declarations and definitions of objects
* or functions at file scope shall have internal linkage unless external linkage is required
* This warning appears when defining functions that will be used by the upper layers.
*
* @section [global]
* Violates MISRA 2004 Required Rule 5.1, Identifiers (internal and external) shall not rely
* on the significance of more than 31 characters. The used compilers use more than 31 chars for
* identifiers.
*/

/*==================================================================================================
*                                         INCLUDE FILES
* 1) system and project includes
* 2) needed interfaces from external units
* 3) internal and external interfaces from this unit
==================================================================================================*/
#include "Mcu_Cfg.h"
#include "Mcu_CortexM4.h"
#include "StdRegMacros.h"
#include "Reg_eSys_SMC.h"
/*==================================================================================================
*                               SOURCE FILE VERSION INFORMATION
==================================================================================================*/
/**
* @file           CORTEXM4.c
* @requirements   
*/
#define MCU_CORTEXM4_VENDOR_ID_C                       43
/** @violates @ref Mcu_CortexM4_c_REF_3 MISRA 2004 Required Rule 1.4,The compiler/linker shall be
checked to ensure that 31 character significance and case sensitivity are supported for external identifiers. */
#define MCU_CORTEXM4_AR_RELEASE_MAJOR_VERSION_C        4
/** @violates @ref Mcu_CortexM4_c_REF_3 MISRA 2004 Required Rule 1.4,The compiler/linker shall be
checked to ensure that 31 character significance and case sensitivity are supported for external identifiers. */
#define MCU_CORTEXM4_AR_RELEASE_MINOR_VERSION_C        3
/** @violates @ref Mcu_CortexM4_c_REF_3 MISRA 2004 Required Rule 1.4,The compiler/linker shall be
checked to ensure that 31 character significance and case sensitivity are supported for external identifiers. */
#define MCU_CORTEXM4_AR_RELEASE_REVISION_VERSION_C     1
#define MCU_CORTEXM4_SW_MAJOR_VERSION_C                1
#define MCU_CORTEXM4_SW_MINOR_VERSION_C                0
#define MCU_CORTEXM4_SW_PATCH_VERSION_C                2


/*==================================================================================================
*                                      FILE VERSION CHECKS
==================================================================================================*/
/* Check if source file and Mcu_Cfg.h header file have same versions */
#if (MCU_CORTEXM4_VENDOR_ID_C != MCU_CORTEXM4_VENDOR_ID)
#error "Mcu_CortexM4.h and Mcu_CortexM4.c have different vendor IDs"
#endif
#if ((MCU_CORTEXM4_AR_RELEASE_MAJOR_VERSION_C != MCU_CORTEXM4_AR_RELEASE_MAJOR_VERSION) || \
     (MCU_CORTEXM4_AR_RELEASE_MINOR_VERSION_C != MCU_CORTEXM4_AR_RELEASE_MINOR_VERSION) || \
     (MCU_CORTEXM4_AR_RELEASE_REVISION_VERSION_C != MCU_CORTEXM4_AR_RELEASE_REVISION_VERSION))
#error "AutoSar Version Numbers of Mcu_CortexM4.c and Mcu_CortexM4.h are different"
#endif
#if ((MCU_CORTEXM4_SW_MAJOR_VERSION_C != MCU_CORTEXM4_SW_MAJOR_VERSION) || \
     (MCU_CORTEXM4_SW_MINOR_VERSION_C != MCU_CORTEXM4_SW_MINOR_VERSION) || \
     (MCU_CORTEXM4_SW_PATCH_VERSION_C != MCU_CORTEXM4_SW_PATCH_VERSION))
#error "Software Version Numbers of Mcu_CortexM4.c and Mcu_CortexM4.h are different"
#endif

/* Check if source file and StdRegMacros.h header file have same versions */
#if (MCU_CORTEXM4_VENDOR_ID_C != MCU_CFG_VENDOR_ID)
#error "CortexM4.h and Mcu_Cfg.h have different vendor IDs"
#endif
#if ((MCU_CORTEXM4_AR_RELEASE_MAJOR_VERSION_C != MCU_CFG_AR_RELEASE_MAJOR_VERSION) || \
     (MCU_CORTEXM4_AR_RELEASE_MINOR_VERSION_C != MCU_CFG_AR_RELEASE_MINOR_VERSION) || \
     (MCU_CORTEXM4_AR_RELEASE_REVISION_VERSION_C != MCU_CFG_AR_RELEASE_REVISION_VERSION))
#error "AutoSar Version Numbers of Mcu_CortexM4.c and Mcu_Cfg.h are different"
#endif
#if ((MCU_CORTEXM4_SW_MAJOR_VERSION_C != MCU_CFG_SW_MAJOR_VERSION) || \
     (MCU_CORTEXM4_SW_MINOR_VERSION_C != MCU_CFG_SW_MINOR_VERSION) || \
     (MCU_CORTEXM4_SW_PATCH_VERSION_C != MCU_CFG_SW_PATCH_VERSION))
#error "Software Version Numbers of Mcu_CortexM4.c and Mcu_Cfg.h are different"
#endif

/* Check if source file and Reg_eSys_SMC.h file have same versions */
#if (MCU_CORTEXM4_VENDOR_ID_C != REG_ESYS_SMC_VENDOR_ID)
#error "CortexM4.h and Reg_eSys_SMC.h have different vendor IDs"
#endif
#if ((MCU_CORTEXM4_AR_RELEASE_MAJOR_VERSION_C != REG_ESYS_SMC_AR_RELEASE_MAJOR_VERSION) || \
     (MCU_CORTEXM4_AR_RELEASE_MINOR_VERSION_C != REG_ESYS_SMC_AR_RELEASE_MINOR_VERSION) || \
     (MCU_CORTEXM4_AR_RELEASE_REVISION_VERSION_C != REG_ESYS_SMC_AR_RELEASE_REVISION_VERSION))
#error "AutoSar Version Numbers of Mcu_CortexM4.c and Reg_eSys_SMC.h are different"
#endif
#if ((MCU_CORTEXM4_SW_MAJOR_VERSION_C != REG_ESYS_SMC_SW_MAJOR_VERSION) || \
     (MCU_CORTEXM4_SW_MINOR_VERSION_C != REG_ESYS_SMC_SW_MINOR_VERSION) || \
     (MCU_CORTEXM4_SW_PATCH_VERSION_C != REG_ESYS_SMC_SW_PATCH_VERSION))
#error "Software Version Numbers of Mcu_CortexM4.c and Reg_eSys_SMC.h are different"
#endif

/* Check if current file and StdRegMacros header file are of the same Autosar version */
#ifndef DISABLE_MCAL_INTERMODULE_ASR_CHECK
    #if ((MCU_CORTEXM4_AR_RELEASE_MAJOR_VERSION_C != STDREGMACROS_AR_RELEASE_MAJOR_VERSION) || \
         (MCU_CORTEXM4_AR_RELEASE_MINOR_VERSION_C != STDREGMACROS_AR_RELEASE_MINOR_VERSION) \
        )
        #error "AutoSar Version Numbers of Mcu_CortexM4.c and StdRegMacros.h are different"
    #endif
#endif
/*==================================================================================================
*                                 GLOBAL VARIABLE DECLARATIONS
==================================================================================================*/

/*==================================================================================================
*                                             ENUMS                                                  
==================================================================================================*/


/*==================================================================================================
*                                           CONSTANTS
==================================================================================================*/

/*==================================================================================================
*                                       DEFINES AND MACROS
==================================================================================================*/

/*==================================================================================================
*                                 STRUCTURES AND OTHER TYPEDEFS
==================================================================================================*/


/*==================================================================================================
*                                     LOCAL FUNCTION 
==================================================================================================*/
#define MCU_START_SEC_CODE
/**
* @violates @ref Mcu_CortexM4_c_REF_1 MISRA 2004 Required Rule 19.15, Repeated include file
*/
#include "Mcu_MemMap.h"

#if (MCU_PERFORM_RESET_API == STD_ON)
 /**
* @brief        The function initiates a system reset request to reset the SoC.
* @details      The function initiates a system reset request to reset the SoC
*
* @param[in]    none
*
* @return void
*
*/
FUNC(void, MCU_CODE) Mcu_CM4_SystemReset(void)
{

    ASM_KEYWORD(" dsb");               /* All memory accesses have to be completed before reset */
    /** @violates @ref Mcu_CortexM4_c_REF_4 Required Rule 11.1, Conversion from integer to pointer */
    /** @violates @ref Mcu_CortexM4_c_REF_5 The cast is used to access memory mapped registers.*/
    REG_WRITE32( CM4_AIRCR_BASEADDR, (uint32)(CM4_AIRCR_VECTKEY(0x5FAU) | (REG_READ32(CM4_AIRCR_BASEADDR) & CM4_AIRCR_PRIGROUP_MASK) | CM4_AIRCR_SYSRESETREQ_MASK ));
    ASM_KEYWORD(" dsb");               /* All memory accesses have to be completed */

}

#endif


 /**
* @brief        The function initiates a system reset request to reset the SoC.
* @details      The function initiates a system reset request to reset the SoC
*
* @param[in]    none
*
* @return void
* @violates @ref Mcu_CortexM4_c_REF_6 Violates MISRA 2004 Required Rule 8.10, global declaration of function
*/
FUNC(void, MCU_CODE) Mcu_CM4_EnableDeepSleep(void)
{
    /** @violates @ref Mcu_CortexM4_c_REF_4 Required Rule 11.1, Conversion from integer to pointer */
    /** @violates @ref Mcu_CortexM4_c_REF_5 The cast is used to access memory mapped registers.*/
    REG_RMW32( CM4_SCR_BASEADDR, CM4_SCR_SLEEPDEEP_MASK32, CM4_SCR_SLEEPDEEP_U32);

}

 /**
* @brief        The function initiates a system reset request to reset the SoC.
* @details      The function initiates a system reset request to reset the SoC
*
* @param[in]    none
*
* @return void
* @violates @ref Mcu_CortexM4_c_REF_6 Violates MISRA 2004 Required Rule 8.10, global declaration of function
*/
FUNC(void, MCU_CODE) Mcu_CM4_DisableDeepSleep(void)
{
    /** @violates @ref Mcu_CortexM4_c_REF_4 Required Rule 11.1, Conversion from integer to pointer */
    /** @violates @ref Mcu_CortexM4_c_REF_5 The cast is used to access memory mapped registers.*/
    REG_RMW32( CM4_SCR_BASEADDR, CM4_SCR_SLEEPDEEP_MASK32, (uint32)0U);

}

#ifdef MCU_SLEEPONEXIT_SUPPORT
 /**
* @brief        The function disable SLEEPONEXIT bit.
* @details      The function disable SLEEPONEXIT bit.
*
* @param[in]    none
*
* @return void
* @violates @ref Mcu_CortexM4_c_REF_6 Violates MISRA 2004 Required Rule 8.10, global declaration of function
*/
FUNC(void, MCU_CODE) Mcu_CM4_DisableSleepOnExit(void)
{
    /** @violates @ref Mcu_CortexM4_c_REF_4 Required Rule 11.1, Conversion from integer to pointer */
    /** @violates @ref Mcu_CortexM4_c_REF_5 The cast is used to access memory mapped registers.*/
    REG_RMW32( CM4_SCR_BASEADDR, CM4_SCR_SLEEPONEXIT_MASK32, CM4_SCR_SLEEPONEXIT_DIS_U32);
}
#endif

#ifdef MCU_SLEEPONEXIT_SUPPORT
 /**
* @brief        The function enable SLEEPONEXIT bit.
* @details      The function enable SLEEPONEXIT bit.
*
* @param[in]    none
*
* @return void
* @violates @ref Mcu_CortexM4_c_REF_6 Violates MISRA 2004 Required Rule 8.10, global declaration of function
*/
FUNC(void, MCU_CODE) Mcu_CM4_EnableSleepOnExit(void)
{
    /** @violates @ref Mcu_CortexM4_c_REF_4 Required Rule 11.1, Conversion from integer to pointer */
    /** @violates @ref Mcu_CortexM4_c_REF_5 The cast is used to access memory mapped registers.*/
    REG_RMW32( CM4_SCR_BASEADDR, CM4_SCR_SLEEPONEXIT_MASK32, CM4_SCR_SLEEPONEXIT_ENA_U32);
}
#endif

#define MCU_STOP_SEC_CODE
/**
* @violates @ref Mcu_CortexM4_c_REF_1 MISRA 2004 Required Rule 19.15, Repeated include file
* @violates @ref Mcu_CortexM4_c_REF_2 MISRA 2004 Advisory Rule 19.1, only preprocessor
* statements and comments before '#include'
*/
#include "Mcu_MemMap.h"

#ifdef __cplusplus
}
#endif



/** @} */
