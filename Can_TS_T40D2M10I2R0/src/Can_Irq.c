/**
*   @file    Can_Irq.c
*   @implements Can_Irq.c_Artifact
*   @version 1.0.2
*
*   @brief   AUTOSAR Can - module interface
*   @details Interrupt routines for Can driver.
*
*   @addtogroup CAN_DRIVER
*   @{
*/
/*==================================================================================================
*   Project              : AUTOSAR 4.3 MCAL
*   Platform             : ARM
*   Peripheral           : FLEXCAN
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
extern "C"{
#endif

/**
* @page misra_violations MISRA-C:2004 violations
*
* @section [global]
* Violates MISRA 2004 Required Rule 5.1, Identifiers (internal and external) shall not rely
* on the significance of more than 31 characters. The used compilers use more than 31 chars for
* identifiers.
*
* @section [global]
* Violates MISRA 2004 Required Rule 1.4, The compiler/linker shall be checked to ensure that 31 character
* signifiance and case sensitivity are supported for external identifiers.
* The used compilers use more than 31 chars for identifiers.
*
* @section Can_Irq_c_REF_1
* Violates MISRA 2004 Advisory Rule 19.1, #include preceded by non preproc directives.
* This violation is not fixed since the inclusion of MemMap.h is as per Autosar requirement MEMMAP003.
*
* @section Can_Irq_c_REF_2
* Violates MISRA 2004 Required Rule 19.15, Repeated include file MemMap.h
* There are different kinds of execution code sections.
*
* @section Can_Irq_c_REF_4
* Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used
* This violation is due to the structure of the types used.
*
* @section Can_Irq_c_REF_5
* Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer.
* This macro compute the address of any register by using the hardware ofsset of the controller. The address calculated as an unsigned int
* is passed to  a macro for initializing the pointer with that address. (ex: see REG_WRITE32 macro).
*
* @section Can_Irq_c_REF_6
* Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed between a pointer type and an integral type.
*
* @section Can_Irq_c_REF_9
* Violates MISRA 2004 Advisory Rule 12.1, Use of mixed mode arithmetic
* This violation is due to the macro CAN_BIT_ASSIGN and no explicit cast operation used for the parameters passed
* to the macro. The care is taken for the parameters sent as inputs to the macro and hence unintended truncation of values
* would not result.
*
* @section Can_Irq_c_REF_10
* Violates MISRA 2004 Required Rule 8.10, external ... could be made static
* The respective code could not be made static because of layers architecture design of the driver.
*
* @section Can_Irq_c_REF_11
* Violates MISRA 2004 Required Rule 10.1 , The value of an expression of integer type shall not be implicitly
* converted to a different underlying type if: 
*    a) it is not aconversion to a wider integer type of the same signedness, 
*    b) the expression is complex,
*    c) the expression is not constant and is a function argument,
*    d) the expression is not constant and is a return expression.
*
*
*/

/*
(CAN035) The module Can_Irq.c contains the implementation of interrupt frames.The implementation of the interrupt service routine shall be in Can.c
*/

/*==================================================================================================
*                                        INCLUDE FILES
* 1) system and project includes
* 2) needed interfaces from external units
* 3) internal and external interfaces from this unit
==================================================================================================*/
/**
* @file           Can_Irq.c
*/
#include "Can.h"
#include "Can_IPW.h"
#include "CanIf_Cbk.h"
#include "Mcal.h"

/*==================================================================================================
*                              SOURCE FILE VERSION INFORMATION
==================================================================================================*/
/* The integration of incompatible files shall be avoided. */
#define CAN_VENDOR_ID_IRQ_C                      43
#define CAN_MODULE_ID_IRQ_C                      80
#define CAN_AR_RELEASE_MAJOR_VERSION_IRQ_C       4
#define CAN_AR_RELEASE_MINOR_VERSION_IRQ_C       3
#define CAN_AR_RELEASE_REVISION_VERSION_IRQ_C    1
#define CAN_SW_MAJOR_VERSION_IRQ_C               1
#define CAN_SW_MINOR_VERSION_IRQ_C               0
#define CAN_SW_PATCH_VERSION_IRQ_C               2


/*==================================================================================================
*                                     FILE VERSION CHECKS
==================================================================================================*/
/* Check if current file and CAN header file are of the same vendor */
#if (CAN_VENDOR_ID_IRQ_C != CAN_VENDOR_ID)
    #error "Can_Irq.c and Can.h have different vendor ids"
#endif
/* Check if current file and CAN header file are of the same module */
#if (CAN_MODULE_ID_IRQ_C != CAN_MODULE_ID)
    #error "Can_Irq.c and Can.h have different module ids"
#endif
/* Check if current file and CAN header file are of the same Autosar version */
#if ((CAN_AR_RELEASE_MAJOR_VERSION_IRQ_C    != CAN_AR_RELEASE_MAJOR_VERSION) || \
     (CAN_AR_RELEASE_MINOR_VERSION_IRQ_C    != CAN_AR_RELEASE_MINOR_VERSION) || \
     (CAN_AR_RELEASE_REVISION_VERSION_IRQ_C != CAN_AR_RELEASE_REVISION_VERSION))
    #error "AutoSar Version Numbers of Can_Irq.c and Can.h are different"
#endif
/* Check if current file and CAN header file are of the same Software version */
#if ((CAN_SW_MAJOR_VERSION_IRQ_C != CAN_SW_MAJOR_VERSION) || \
     (CAN_SW_MINOR_VERSION_IRQ_C != CAN_SW_MINOR_VERSION) || \
     (CAN_SW_PATCH_VERSION_IRQ_C != CAN_SW_PATCH_VERSION))
    #error "Software Version Numbers of Can_Irq.c and Can.h are different"
#endif


/* Check if current file and CAN_IPW header file are of the same vendor */
#if (CAN_VENDOR_ID_IRQ_C != CAN_IPW_VENDOR_ID_H)
    #error "Can_Irq.c and Can_IPW.h have different vendor ids"
#endif
/* Check if current file and CAN header file are of the same module */
#if (CAN_MODULE_ID_IRQ_C != CAN_IPW_MODULE_ID_H)
    #error "Can_Irq.c and Can_IPW.h have different module ids"
#endif
/* Check if current file and CAN_IPW header file are of the same Autosar version */
#if ((CAN_AR_RELEASE_MAJOR_VERSION_IRQ_C    != CAN_IPW_AR_RELEASE_MAJOR_VERSION_H) || \
     (CAN_AR_RELEASE_MINOR_VERSION_IRQ_C    != CAN_IPW_AR_RELEASE_MINOR_VERSION_H) || \
     (CAN_AR_RELEASE_REVISION_VERSION_IRQ_C != CAN_IPW_AR_RELEASE_REVISION_VERSION_H))
    #error "AutoSar Version Numbers of Can_Irq.c and Can_IPW.h are different"
#endif
/* Check if current file and CAN_IPW header file are of the same Software version */
#if ((CAN_SW_MAJOR_VERSION_IRQ_C != CAN_IPW_SW_MAJOR_VERSION_H) || \
     (CAN_SW_MINOR_VERSION_IRQ_C != CAN_IPW_SW_MINOR_VERSION_H) || \
     (CAN_SW_PATCH_VERSION_IRQ_C != CAN_IPW_SW_PATCH_VERSION_H))
    #error "Software Version Numbers of Can_Irq.c and Can_IPW.h are different"
#endif

#ifndef DISABLE_MCAL_INTERMODULE_ASR_CHECK
    /* Check if current file and CANIF_CBK header file are of the same version */
    #if ((CAN_AR_RELEASE_MAJOR_VERSION_IRQ_C != CANIF_CBK_AR_RELEASE_MAJOR_VERSION) || \
         (CAN_AR_RELEASE_MINOR_VERSION_IRQ_C != CANIF_CBK_AR_RELEASE_MINOR_VERSION))
        #error "AutoSar Version Numbers of Can_Irq.c and CanIf_Cbk.h are different"
    #endif
    /* Check if current file and Mcal.h header file are of the same version */
    #if ((CAN_AR_RELEASE_MAJOR_VERSION_IRQ_C != MCAL_AR_RELEASE_MAJOR_VERSION) || \
         (CAN_AR_RELEASE_MINOR_VERSION_IRQ_C != MCAL_AR_RELEASE_MINOR_VERSION))
        #error "AutoSar Version Numbers of Can_Irq.c and Mcal.h are different"
    #endif
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

/*==================================================================================================
*                                   LOCAL FUNCTION PROTOTYPES
==================================================================================================*/
#define CAN_START_SEC_CODE
/* @violates @ref Can_Irq_c_REF_1 MISRA 2004 Rule 19.1, #include preceded by non preproc directives. */
/* @violates @ref Can_Irq_c_REF_2 MISRA 2004 Rule 19.15, Repeated include file MemMap.h  */
#include "Can_MemMap.h"

#if (CAN_TX_RX_INTR_SUPPORTED == STD_ON)
static FUNC(void, CAN_CODE) Can_FlexCan_Mb
(
    CONST(uint8, AUTOMATIC) u8ctrId,
    CONST(uint8, AUTOMATIC) u8ctrOffset,
    CONST(uint8, AUTOMATIC) u8IdMin,
    CONST(uint8, AUTOMATIC) u8IdMax
);
#endif

#if (CAN_BUSOFFINT_SUPPORTED == STD_ON)
static FUNC(void, CAN_CODE) Can_FlexCan_BusOff
(
    CONST(uint8, AUTOMATIC) u8ctrId,
    CONST(uint8, AUTOMATIC) u8ctrOffset
);
#endif

#if (CAN_ERROR_NOTIFICATION_ENABLE == STD_ON)
static FUNC(void, CAN_CODE) Can_FlexCan_Err
(
    CONST(uint8, AUTOMATIC) u8ctrId,
    CONST(uint8, AUTOMATIC) u8ctrOffset
);
#endif
/*==================================================================================================
*                                       LOCAL FUNCTIONS
==================================================================================================*/
#if (CAN_TX_RX_INTR_SUPPORTED == STD_ON)
/**
* @brief          Process Tx/Rx/Fifo Message Buffer Interrupt.
* @details        Process Tx/Rx/Fifo Message Buffer Interrupt.
*
* @remarks
* @implements     Can_Isr_X_Activity
*
*/
static FUNC(void, CAN_CODE) Can_FlexCan_Mb
(
    CONST(uint8, AUTOMATIC) u8ctrId,
    CONST(uint8, AUTOMATIC) u8ctrOffset,
    CONST(uint8, AUTOMATIC) u8IdMin,
    CONST(uint8, AUTOMATIC) u8IdMax
)
{
    VAR(uint8, AUTOMATIC)  u8RegCount = 0U;
    VAR(uint32, AUTOMATIC)   can_status = 0U;
    if ( CAN_CS_STARTED != Can_ControllerStatuses[u8ctrId].ControllerState )
    {
        do
        {
            /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
            /* @violates @ref Can_Irq_c_REF_5  Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer. */
            /* @violates @ref Can_Irq_c_REF_6 Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed */
            can_status = REG_READ32(Can_IflagImask[u8RegCount][u8ctrOffset].u32CanIflag);
            /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
            /* @violates @ref Can_Irq_c_REF_5  Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer. */
            /* @violates @ref Can_Irq_c_REF_6 Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed */
            REG_WRITE32(Can_IflagImask[u8RegCount][u8ctrOffset].u32CanIflag, can_status);
            u8RegCount++;
        }
        while(u8RegCount < (uint8)((uint8)CAN_MAXMB_SUPPORTED >> FLEXCAN_MB_SHIFT5BIT_U8));
    }
    else
    {
        /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
        if (((uint32)0U != (CAN_CONTROLLERCONFIG_TXINT_EN_U32 & (Can_pCurrentConfig->ControlerDescriptors[u8ctrId].u32Options))))
        {
            Can_IPW_ProcessTx(u8ctrId, u8IdMin, u8IdMax);
        }
        /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
        if (((uint32)0U != (CAN_CONTROLLERCONFIG_RXINT_EN_U32 & (Can_pCurrentConfig->ControlerDescriptors[u8ctrId].u32Options))))
        {
            Can_IPW_ProcessRx(u8ctrId, u8IdMin, u8IdMax);
        }
    }
    EXIT_INTERRUPT();
}
#endif

#if (CAN_BUSOFFINT_SUPPORTED == STD_ON)
/**
* @brief          Interrupt routine for BusOff.
* @details        Interrupt routine for BusOff.
* @remarks
* @implements     Can_Isr_X_Activity
*/
static FUNC(void, CAN_CODE) Can_FlexCan_BusOff
(
    CONST(uint8, AUTOMATIC) u8ctrId,
    CONST(uint8, AUTOMATIC) u8ctrOffset
)
{
    VAR(uint32, AUTOMATIC) can_status = 0U;
    VAR(uint32, AUTOMATIC) can_mask = 0U;
    if ( CAN_CS_STARTED != Can_ControllerStatuses[u8ctrId].ControllerState )
    {
        /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
        /* @violates @ref Can_Irq_c_REF_5  Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer. */
        /* @violates @ref Can_Irq_c_REF_6 Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed */
        REG_WRITE32( FLEXCAN_ESR(u8ctrOffset), (uint32)(FLEXCAN_ESR_BOFFINT_U32 & FLEXCAN_ESR_CONFIG_MASK_U32));
    }
    else
    {
        /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
        /* @violates @ref Can_Irq_c_REF_5  Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer. */
        /* @violates @ref Can_Irq_c_REF_6 Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed */
        can_mask = (uint32)REG_READ32( FLEXCAN_CTRL(u8ctrOffset)) & FLEXCAN_CTRL_BOFFMSK_U32;
        /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
        /* @violates @ref Can_Irq_c_REF_5  Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer. */
        /* @violates @ref Can_Irq_c_REF_6 Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed */
        can_status = ((uint32)REG_READ32( FLEXCAN_ESR(u8ctrOffset)) & FLEXCAN_ESR_BOFFINT_U32);
        if (0U != can_status)
        {
            if(0U != can_mask)
            {
                /* Process BusOff condition for controller ID of FlexCAN FC */
                /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
                /* @violates @ref Can_Irq_c_REF_11 Violates MISRA 2004 Required Rule 10.1 , Prohibited Implicit Conversion: Non-constant argument to function, Implicit conversion of integer to smaller type, Violation due to workaround implemented in User Mode */
                if ((Std_ReturnType)E_OK == (Std_ReturnType)Can_IPW_SetControllerMode(u8ctrId,  &(Can_pCurrentConfig->ControlerDescriptors[u8ctrId]), CAN_CS_STOPPED,(boolean)FALSE) )
                {
                    Can_IPW_ProcessBusOff(u8ctrId);
                    CanIf_ControllerBusOff(u8ctrId);
                }
            }
            else
            {
                /* Clear the ESR[BOFF_INT] bus off interrupt flag (w1c). */
                /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
                /* @violates @ref Can_Irq_c_REF_5  Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer. */
                /* @violates @ref Can_Irq_c_REF_6 Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed */
                REG_WRITE32( FLEXCAN_ESR(u8ctrOffset), (FLEXCAN_ESR_BOFFINT_U32 & FLEXCAN_ESR_CONFIG_MASK_U32));
            }
        }
    }
#if (CAN_UNIFIED_INTERRUPTS == STD_OFF)
    EXIT_INTERRUPT();
#endif
}
#endif /* CAN_BUSOFFINT_SUPPORTED = STD_ON */
/*==================================================================================================*/

#if (CAN_ERROR_NOTIFICATION_ENABLE == STD_ON)
    /**
    * @brief          Interrupt routine for Error.
    * @details        Interrupt routine for Error.
    * @remarks        FC - Can hardware channel: A, B, C, D, E, F, G, H
    * @implements     Can_Isr_X_Activity
    */
static FUNC(void, CAN_CODE) Can_FlexCan_Err
(
    CONST(uint8, AUTOMATIC) u8ctrId,
    CONST(uint8, AUTOMATIC) u8ctrOffset
)
{
    VAR(uint32, AUTOMATIC) u32ErrFlag = 0U;
    VAR(uint32, AUTOMATIC) u32ErrMask = 0U;
    if ( CAN_CS_STARTED != Can_ControllerStatuses[u8ctrId].ControllerState )
    {
        /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
        /* @violates @ref Can_Irq_c_REF_5  Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer. */
        /* @violates @ref Can_Irq_c_REF_6 Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed */
        REG_WRITE32( FLEXCAN_ESR(u8ctrOffset), (FLEXCAN_ESR_ERRINT_U32 & FLEXCAN_ESR_CONFIG_MASK_U32));
#if (CAN_FD_MODE_ENABLE == STD_ON)
        if ((((uint32)1U << u8ctrOffset) & CAN_FD_CONTROLLER_SUPPORTED) != 0U)
        {
            /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
            /* @violates @ref Can_Irq_c_REF_5  Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer. */
            /* @violates @ref Can_Irq_c_REF_6 Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed */
            REG_WRITE32( FLEXCAN_ESR(u8ctrOffset), (FLEXCAN_ESR_ERRINT_FAST_U32 & FLEXCAN_ESR_CONFIG_MASK_U32));
        }
#endif
    }
    else
    {
#if (CAN_FD_MODE_ENABLE == STD_ON)
        if ((((uint32)1U << u8ctrOffset) & CAN_FD_CONTROLLER_SUPPORTED) != 0U)
        {
            /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
            /* @violates @ref Can_Irq_c_REF_5  Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer. */
            /* @violates @ref Can_Irq_c_REF_6 Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed */
            u32ErrMask = ((REG_READ32( FLEXCAN_CTRL2(u8ctrOffset)) & FLEXCAN_FD_CTRL2_ERRMSK_FAST_U32) >> (11U));
            /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
            /* @violates @ref Can_Irq_c_REF_5  Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer. */
            /* @violates @ref Can_Irq_c_REF_6 Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed */
            u32ErrFlag = (REG_READ32( FLEXCAN_ESR(u8ctrOffset)) & FLEXCAN_ESR_ERRINT_FAST_U32);
            if ((uint32)0U != (u32ErrMask & u32ErrFlag))
            {
                /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
                if ( NULL_PTR != CanStatic_pCurrentConfig->StaticControlerDescriptors[u8ctrId].Can_ErrorFDNotification)
                {
                    /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
                    CanStatic_pCurrentConfig->StaticControlerDescriptors[u8ctrId].Can_ErrorFDNotification();
                }
            }
        }
#endif
        /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
        /* @violates @ref Can_Irq_c_REF_5  Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer. */
        /* @violates @ref Can_Irq_c_REF_6 Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed */
        u32ErrMask |= (((uint32)REG_READ32( FLEXCAN_CTRL(u8ctrOffset)) & FLEXCAN_CTRL_ERRMSK_U32) >> (13U));
        /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
        /* @violates @ref Can_Irq_c_REF_5  Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer. */
        /* @violates @ref Can_Irq_c_REF_6 Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed */
        u32ErrFlag |= ((uint32)REG_READ32( FLEXCAN_ESR(u8ctrOffset)) & FLEXCAN_ESR_ERRINT_U32);

        if ((uint32)0U != (u32ErrMask & u32ErrFlag))
        {
            /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
            if ( NULL_PTR != CanStatic_pCurrentConfig->StaticControlerDescriptors[u8ctrId].Can_ErrorNotification)
            {
                /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
                CanStatic_pCurrentConfig->StaticControlerDescriptors[u8ctrId].Can_ErrorNotification();
            }
        }
        /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
        /* @violates @ref Can_Irq_c_REF_5  Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer. */
        /* @violates @ref Can_Irq_c_REF_6 Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed */
        REG_WRITE32( FLEXCAN_ESR(u8ctrOffset), (FLEXCAN_ESR_ERRINT_U32 & FLEXCAN_ESR_CONFIG_MASK_U32));
#if (CAN_FD_MODE_ENABLE == STD_ON)
        if ((((uint32)1U << u8ctrOffset) & CAN_FD_CONTROLLER_SUPPORTED) != 0U)
        {
            /* @violates @ref Can_Irq_c_REF_4 Violates MISRA 2004 Required Rule 17.4, pointer arithmetic other than array indexing used */
            /* @violates @ref Can_Irq_c_REF_5  Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer. */
            /* @violates @ref Can_Irq_c_REF_6 Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed */
            REG_WRITE32( FLEXCAN_ESR(u8ctrOffset), (FLEXCAN_ESR_ERRINT_FAST_U32 & FLEXCAN_ESR_CONFIG_MASK_U32));
        }
#endif
    }
#if (CAN_UNIFIED_INTERRUPTS == STD_OFF)
    EXIT_INTERRUPT();
#endif
}
#endif

/*==================================================================================================
*                                       GLOBAL FUNCTIONS
==================================================================================================*/

/*================================================================================================*/
/*
   (CAN033) The Can module shall implement the interrupt service routines for all CAN Hardware Unit
   interrupts that are needed. The Can module shall disable all unused interrupts in the CAN controller.
   The Can module shall reset the interrupt flag at the end of the ISR (if not done automatically by
   hardware). The Can module shall not set the configuration (i.e. priority) of the vector table entry.
*/
/**
* @brief          CAN controller A interrupts
* @details        CAN controller A interrupts
*
*
*/
/* CAN controller A interrupts */
#ifdef CAN_FCA_INDEX
#if (CAN_UNIFIED_INTERRUPTS == STD_ON) /*  Support interrupt for  derivatives which support UNIFIED_INTERRUPTS */
    #if ((CAN_A_ERROR_NOTIFICATION_ENABLE == STD_ON) || (CAN_A_BUSOFFINT_SUPPORTED == STD_ON) || (CAN_PUBLIC_ICOM_SUPPORT == STD_ON))
        ISR(Can_ISR_NVIC_ID_10_FCA_SP);
    #endif
    #if ((CAN_A_TXINT_SUPPORTED == STD_ON) && (CAN_A_RXINT_SUPPORTED == STD_ON))
        ISR(Can_ISR_NVIC_ID_11_FCA_SP);
    #endif
#else
    #if (CAN_A_ERROR_NOTIFICATION_ENABLE == STD_ON)
        ISR(Can_IsrFCA_ERR);
    #endif
    #if (CAN_A_BUSOFFINT_SUPPORTED == STD_ON)
        ISR(Can_IsrFCA_BO);
    #endif /* (CAN_A_BUSOFFINT_SUPPORTED == STD_ON) */
    #if (CAN_PUBLIC_ICOM_SUPPORT==STD_ON)
        ISR(Can_IsrFCA_PN);
    #endif/* (CAN_PUBLIC_ICOM_SUPPORT==STD_OFF) */
    #if ((CAN_A_RXINT_SUPPORTED == STD_ON) || (CAN_A_TXINT_SUPPORTED == STD_ON))
        #if (CAN_ISROPTCODESIZE == STD_ON)
            ISR(Can_IsrFCA_UNI);
        #else /* (CAN_ISROPTCODESIZE == STD_OFF) */
            #if ((CAN_A_FIFO_EN == STD_ON) && (CAN_A_RXINT_SUPPORTED == STD_ON))
                ISR(Can_IsrFCA_RxFifoEventsMbMix);
            #else
                ISR(Can_IsrFCA_MB_00_15);
            #endif /* (CAN_A_FIFO_EN == STD_OFF) */
                ISR(Can_IsrFCA_MB_16_31);
                ISR(Can_IsrFCA_MB_32_47);
                ISR(Can_IsrFCA_MB_48_63);
        #endif /* (CAN_ISROPTCODESIZE == STD_OFF) */
    #endif
#endif /*CAN_UNIFIED_INTERRUPTS == STD_ON */
#endif /* CAN_FCA_INDEX */
/**
* @brief          CAN controller B interrupts
* @details        CAN controller B interrupts
*
*
*/
/* CAN controller B interrupts */
#ifdef CAN_FCB_INDEX
    #if (CAN_B_ERROR_NOTIFICATION_ENABLE == STD_ON)
    ISR(Can_IsrFCB_ERR);
    #endif
    
    #if (CAN_B_BUSOFFINT_SUPPORTED == STD_ON)
        ISR(Can_IsrFCB_BO);
    #endif /* (CAN_B_BUSOFFINT_SUPPORTED == STD_ON) */

    #if ((CAN_B_TXINT_SUPPORTED == STD_ON) || (CAN_B_RXINT_SUPPORTED == STD_ON))
        #if (CAN_ISROPTCODESIZE == STD_ON)
            ISR(Can_IsrFCB_UNI);
        #else /* (CAN_ISROPTCODESIZE == STD_OFF) */
            #if ((CAN_B_FIFO_EN == STD_ON) && (CAN_B_RXINT_SUPPORTED == STD_ON))
                ISR(Can_IsrFCB_RxFifoEventsMbMix);
            #else
                ISR(Can_IsrFCB_MB_00_15);
            #endif /* (CAN_B_FIFO_EN == STD_OFF) */
                ISR(Can_IsrFCB_MB_16_31);
                ISR(Can_IsrFCB_MB_32_47);
                ISR(Can_IsrFCB_MB_48_63);
        #endif /* (CAN_ISROPTCODESIZE == STD_OFF) */
    #endif
#endif /* CAN_FCB_INDEX */

/**
* @brief          CAN controller C interrupts
* @details        CAN controller C interrupts
**/
/* CAN controller C interrupts */
#ifdef CAN_FCC_INDEX
  #if (CAN_C_ERROR_NOTIFICATION_ENABLE == STD_ON)
    ISR(Can_IsrFCC_ERR);
  #endif
    #if (CAN_C_BUSOFFINT_SUPPORTED == STD_ON)
        ISR(Can_IsrFCC_BO);
    #endif /* (CAN_C_BUSOFFINT_SUPPORTED == STD_ON) */

    #if ((CAN_C_TXINT_SUPPORTED == STD_ON) || (CAN_C_RXINT_SUPPORTED == STD_ON))
        #if (CAN_ISROPTCODESIZE == STD_ON)
            ISR(Can_IsrFCC_UNI);
        #else /* (CAN_ISROPTCODESIZE == STD_OFF) */
            #if ((CAN_C_FIFO_EN == STD_ON) && (CAN_C_RXINT_SUPPORTED == STD_ON))
                ISR(Can_IsrFCC_RxFifoEventsMbMix);
            #else
                ISR(Can_IsrFCC_MB_00_15);
            #endif /* (CAN_C_FIFO_EN == STD_OFF) */
                ISR(Can_IsrFCC_MB_16_31);
        #endif /* (CAN_ISROPTCODESIZE == STD_OFF) */
    #endif
#endif /* CAN_FCC_INDEX */

/*==================================================================================================
    INTERRUPT SERVICE ROUTINES FOR FLEXCAN A
==================================================================================================*/
#ifdef CAN_FCA_INDEX
#if (CAN_UNIFIED_INTERRUPTS == STD_ON) /*  Support interrupt for  derivatives which support UNIFIED_INTERRUPTS */
    #if ((CAN_A_ERROR_NOTIFICATION_ENABLE == STD_ON) || (CAN_A_BUSOFFINT_SUPPORTED == STD_ON) || (CAN_PUBLIC_ICOM_SUPPORT == STD_ON))
        /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
        ISR(Can_ISR_NVIC_ID_10_FCA_SP)
        {
        #if (CAN_PUBLIC_ICOM_SUPPORT == STD_ON)
            Can_IPW_ProcessWakeupPN(CAN_FCA_INDEX);
        #endif
            
        #if (CAN_A_BUSOFFINT_SUPPORTED == STD_ON)
            Can_FlexCan_BusOff(CAN_FCA_INDEX, FLEXCAN_A_OFFSET);
        #endif
        
        #if (CAN_A_ERROR_NOTIFICATION_ENABLE == STD_ON)
            Can_FlexCan_Err(CAN_FCA_INDEX, FLEXCAN_A_OFFSET);
        #endif
            EXIT_INTERRUPT();
        }
    #endif
    #if ((CAN_A_TXINT_SUPPORTED == STD_ON) || (CAN_A_RXINT_SUPPORTED == STD_ON))
        /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
        ISR(Can_ISR_NVIC_ID_11_FCA_SP)
        {
            Can_FlexCan_Mb(CAN_FCA_INDEX, FLEXCAN_A_OFFSET, 0U, CAN_MAXMB_SUPPORTED - 1U);
        }
    #endif
#else
    #if (CAN_A_ERROR_NOTIFICATION_ENABLE == STD_ON)
        /* Error */
        /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
        ISR(Can_IsrFCA_ERR)
        {
            Can_FlexCan_Err(CAN_FCA_INDEX, FLEXCAN_A_OFFSET);
        }
    #endif
    #if (CAN_A_BUSOFFINT_SUPPORTED == STD_ON)
        /* Bus Off */
        /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
        ISR(Can_IsrFCA_BO)
        {
            Can_FlexCan_BusOff(CAN_FCA_INDEX, FLEXCAN_A_OFFSET);
        }
    #endif /* (CAN_A_BUSOFFINT_SUPPORTED == STD_ON) */

    #if (CAN_PUBLIC_ICOM_SUPPORT==STD_ON)
        /* External Wake-up by PNET */
        /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
        ISR(Can_IsrFCA_PN)
        {
            Can_IPW_ProcessWakeupPN(CAN_FCA_INDEX);
            EXIT_INTERRUPT();
        }
    #endif/* (CAN_PUBLIC_ICOM_SUPPORT==STD_OFF) */
    #if ((CAN_A_RXINT_SUPPORTED == STD_ON) || (CAN_A_TXINT_SUPPORTED == STD_ON))
        #if (CAN_ISROPTCODESIZE == STD_ON)
            /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
            ISR(Can_IsrFCA_UNI)
            {
                Can_FlexCan_Mb(CAN_FCA_INDEX, FLEXCAN_A_OFFSET, 0U, CAN_MAXMB_SUPPORTED - 1U);
            }
        #else /* (CAN_ISROPTCODESIZE == STD_OFF) */
            #if (CAN_A_FIFO_EN == STD_OFF)
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCA_MB_00_15)
                {
                    Can_FlexCan_Mb(CAN_FCA_INDEX, FLEXCAN_A_OFFSET, 0U, 15U);
                }
            #elif (CAN_A_RXINT_SUPPORTED == STD_ON)
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCA_RxFifoEventsMbMix)
                {
                    Can_FlexCan_Mb(CAN_FCA_INDEX, FLEXCAN_A_OFFSET, FLEXCAN_FIFOFRAME_INT_INDEX_U8, 15U);
                }
            #else
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCA_MB_00_15)
                {
                    Can_FlexCan_Mb(CAN_FCA_INDEX, FLEXCAN_A_OFFSET, 8U, 15U);
                }
            #endif /* (CAN_A_FIFO_EN == STD_OFF) */
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCA_MB_16_31)
                {
                     Can_FlexCan_Mb(CAN_FCA_INDEX, FLEXCAN_A_OFFSET, 16U, 31U);
                }
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCA_MB_32_47)
                {
                    Can_FlexCan_Mb(CAN_FCA_INDEX, FLEXCAN_A_OFFSET, 32U, 47U);
                }
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCA_MB_48_63)
                {
                    Can_FlexCan_Mb(CAN_FCA_INDEX, FLEXCAN_A_OFFSET, 48U, 63U);
                }
        #endif /* (CAN_ISROPTCODESIZE == STD_OFF) */
    #endif
#endif
#endif /* CAN_FCA_INDEX */

/*==================================================================================================
    INTERRUPT SERVICE ROUTINES FOR FLEXCAN B
==================================================================================================*/
#ifdef CAN_FCB_INDEX
  #if (CAN_B_ERROR_NOTIFICATION_ENABLE == STD_ON)
    /* Error */
    /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
    ISR(Can_IsrFCB_ERR)
    {
        Can_FlexCan_Err(CAN_FCB_INDEX, FLEXCAN_B_OFFSET);
    }
  #endif
    #if (CAN_B_BUSOFFINT_SUPPORTED == STD_ON)
        /* Bus Off */
        /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
        ISR(Can_IsrFCB_BO)
        {
            Can_FlexCan_BusOff(CAN_FCB_INDEX, FLEXCAN_B_OFFSET);
        }
    #endif /* (CAN_B_BUSOFFINT_SUPPORTED == STD_ON) */

    #if ((CAN_B_RXINT_SUPPORTED == STD_ON) || (CAN_B_TXINT_SUPPORTED == STD_ON))
        #if (CAN_ISROPTCODESIZE == STD_ON)
            /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
            ISR(Can_IsrFCB_UNI)
            {
                Can_FlexCan_Mb(CAN_FCB_INDEX, FLEXCAN_B_OFFSET, 0U, CAN_MAXMB_SUPPORTED - 1U);
            }
        #else /* (CAN_ISROPTCODESIZE == STD_OFF) */
            #if (CAN_B_FIFO_EN == STD_OFF)
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCB_MB_00_15)
                {
                    Can_FlexCan_Mb(CAN_FCB_INDEX, FLEXCAN_B_OFFSET, 0U, 15U);
                }
            #elif (CAN_B_RXINT_SUPPORTED == STD_ON)
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCB_RxFifoEventsMbMix)
                {
                    Can_FlexCan_Mb(CAN_FCB_INDEX, FLEXCAN_B_OFFSET, FLEXCAN_FIFOFRAME_INT_INDEX_U8, 15U);
                }
            #else
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCB_MB_00_15)
                {
                    Can_FlexCan_Mb(CAN_FCB_INDEX, FLEXCAN_B_OFFSET, 8U, 15U);
                }
            #endif /* (CAN_B_FIFO_EN == STD_OFF) */
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCB_MB_16_31)
                {
                     Can_FlexCan_Mb(CAN_FCB_INDEX, FLEXCAN_B_OFFSET, 16U, 31U);
                }
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCB_MB_32_47)
                {
                    Can_FlexCan_Mb(CAN_FCB_INDEX, FLEXCAN_B_OFFSET, 32U, 47U);
                }
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCB_MB_48_63)
                {
                    Can_FlexCan_Mb(CAN_FCB_INDEX, FLEXCAN_B_OFFSET, 48U, 63U);
                }
        #endif /* (CAN_ISROPTCODESIZE == STD_OFF) */
    #endif
#endif /* CAN_FCB_INDEX */
/*==================================================================================================
    INTERRUPT SERVICE ROUTINES FOR FLEXCAN C
==================================================================================================*/
#ifdef CAN_FCC_INDEX
  #if (CAN_C_ERROR_NOTIFICATION_ENABLE == STD_ON)
    /* Error */
    /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
    ISR(Can_IsrFCC_ERR)
    {
        Can_FlexCan_Err(CAN_FCC_INDEX, FLEXCAN_C_OFFSET);
    }
  #endif
    #if (CAN_C_BUSOFFINT_SUPPORTED == STD_ON)
        /* Bus Off */
        /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
        ISR(Can_IsrFCC_BO)
        {
            Can_FlexCan_BusOff(CAN_FCC_INDEX, FLEXCAN_C_OFFSET);
        }
    #endif /* (CAN_C_BUSOFFINT_SUPPORTED == STD_ON) */

    #if ((CAN_C_RXINT_SUPPORTED == STD_ON) || (CAN_C_TXINT_SUPPORTED == STD_ON))
        #if (CAN_ISROPTCODESIZE == STD_ON)
            /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
            ISR(Can_IsrFCC_UNI)
            {
                Can_FlexCan_Mb(CAN_FCC_INDEX, FLEXCAN_C_OFFSET, 0U, CAN_MAXMB_SUPPORTED - 1U);
            }
        #else /* (CAN_ISROPTCODESIZE == STD_OFF) */
            #if (CAN_C_FIFO_EN == STD_OFF)
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCC_MB_00_15)
                {
                    Can_FlexCan_Mb(CAN_FCC_INDEX, FLEXCAN_C_OFFSET, 0U, 15U);
                }
            #elif (CAN_C_RXINT_SUPPORTED == STD_ON)
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCC_RxFifoEventsMbMix)
                {
                    Can_FlexCan_Mb(CAN_FCC_INDEX, FLEXCAN_C_OFFSET, FLEXCAN_FIFOFRAME_INT_INDEX_U8, 15U);
                }
            #else
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCC_MB_00_15)
                {
                    Can_FlexCan_Mb(CAN_FCC_INDEX, FLEXCAN_C_OFFSET, 8U, 15U);
                }
            #endif /* (CAN_C_FIFO_EN == STD_OFF) */
                /* @violates @ref Can_Irq_c_REF_10 Violates MISRA 2004 Required Rule 8.10, external ... could be made static */
                ISR(Can_IsrFCC_MB_16_31)
                {
                     Can_FlexCan_Mb(CAN_FCC_INDEX, FLEXCAN_C_OFFSET, 16U, 31U);
                }
        #endif /* (CAN_ISROPTCODESIZE == STD_OFF) */
    #endif
#endif /* CAN_FCC_INDEX */


#define CAN_STOP_SEC_CODE
/* @violates @ref Can_Irq_c_REF_1 MISRA 2004 Rule 19.1, #include preceded by non preproc directives. */
/* @violates @ref Can_Irq_c_REF_2 MISRA 2004 Rule 19.15, Repeated include file MemMap.h  */
#include "Can_MemMap.h"

#ifdef __cplusplus
}
#endif
/** @} */
