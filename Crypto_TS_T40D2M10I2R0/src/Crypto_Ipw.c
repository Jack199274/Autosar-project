/**
*   @file    Crypto_Hsm.c
*   @version 1.0.2
*
*   @brief   AUTOSAR Crypto - Separation source layer of high-low level drivers.
*   @details Source interface between common and low level driver.
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
extern "C"{
#endif
/**
* @page misra_violations MISRA-C:2004 violations
*
* @section Crypto_Ipw_c_REF_1
*          Violates MISRA 2004 Advisory Rule 19.1, #include statements in a file should only be preceded 
*          by other preprocessor directives or comments. AUTOSAR imposes the specification of the sections 
*          in which certain parts of the driver must be placed.
*
* @section Crypto_Ipw_c_REF_2
*          Violates MISRA 2004 Required Rule 19.15, Precautions shall be taken in order to
*          prevent the contents of a header file being included twice. All header files are
*          protected against multiple inclusions.
*
* @section Crypto_Ipw_c_REF_3
*          Violates MISRA 2004 Required Rule 8.10, could be made static The respective code could not be made 
*          static because of layers architecture design of the driver.
*
* @section Crypto_Ipw_c_REF_4
*          Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer 
*          arithmetic. 
*          The violation occurs because the variables are defined as per Csec Driver API specifications.
*
* @section Crypto_Ipw_c_REF_5
*           Violates MISRA 2004 Required Rule 10.1 , The value of an expression of integer type shall not be implicitly
*           converted to a different underlying type if: 
*               a) it is not aconversion to a wider integer type of the same signedness, 
*               b) the expression is complex,
*               c) the expression is not constant and is a function argument,
*               d) the expression is not constant and is a return expression.
*
* @section Crypto_Ipw_c_REF_6
*           Violates MISRA 2004 Advisory Rule 12.6 , The operands of logical operators (&&, || and !) should be
*           effectively Boolean. Expressions that are effectively Boolean
*           should not be used as operands to operators other than (&&, ||, !, =, ==, != and ?:).
*
* @section Crypto_Ipw_c_REF_7
*           Violates MISRA 2004 Required Rule 14.7, Return statement before end of function.
*           Return from function as soon as the read/write/erase/operation finished
*
* @section Crypto_Ipw_c_REF_8
*           Violates MISRA 2004 Advisory Rule 11.4,  A cast should not be performed between a pointer
*           to object type and a different pointer to object type
*           Due to casting between a pointer and unsigned long, caused by the enforced Autosar API prototypes and
*           used for optimizing the memory access.
*
* @section Crypto_Ipw_c_REF_9
*           Violates MISRA 2004 Required Rule 1.4, Identifier clash.
*           This violation is due to the requirement that request to have a file version check.
*
* @section Crypto_Ipw_c_REF_10
*           Violates MISRA 2004 Required Rule 5.1, External identifiers shall be distinct.
*           The used compilers use more than 31 chars for identifiers.
*
*/
/*==================================================================================================
*                                        INCLUDE FILES
* 1) system and project includes
* 2) needed interfaces from external units
* 3) internal and external interfaces from this unit
==================================================================================================*/
/**
* @file           Crypto_Ipw.c    
*/
#include "Crypto_Cfg.h"
#include "Crypto.h"
#include "Crypto_Ipw.h"
#include "Crypto_Types.h"
#include "Crypto_Cse.h"
#include "Crypto_CseTypes.h"
#include "Csm_Types.h"
#include "CryIf_Cbk.h"

/*==================================================================================================
*                                      SOURCE FILE VERSION INFORMATION 
==================================================================================================*/

/**
* @file           Crypto_Ipw.c
*/
#define CRYPTO_IPW_VENDOR_ID_C                     43
/**
* @violates @ref Crypto_Ipw_c_REF_9 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_Ipw_c_REF_10 Violates MISRA 2004 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_IPW_AR_RELEASE_MAJOR_VERSION_C      4
/**
* @violates @ref Crypto_Ipw_c_REF_9 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_Ipw_c_REF_10 Violates MISRA 2004 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_IPW_AR_RELEASE_MINOR_VERSION_C      3
/**
* @violates @ref Crypto_Ipw_c_REF_9 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_Ipw_c_REF_10 Violates MISRA 2004 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_IPW_AR_RELEASE_REVISION_VERSION_C   1
#define CRYPTO_IPW_SW_MAJOR_VERSION_C              1
#define CRYPTO_IPW_SW_MINOR_VERSION_C              0
#define CRYPTO_IPW_SW_PATCH_VERSION_C              2
/*==================================================================================================
*                                      FILE VERSION CHECKS
==================================================================================================*/

/* Check if Crypto IPW source file and Crypto header file are of the same vendor */
#if (CRYPTO_IPW_VENDOR_ID_C != CRYPTO_VENDOR_ID)
#error "Crypto_Ipw.c and Crypto.h have different vendor ids"
#endif

/* Check if Crypto IPW source file and Crypto header file are of the same Autosar version */
#if ((CRYPTO_IPW_AR_RELEASE_MAJOR_VERSION_C != CRYPTO_AR_RELEASE_MAJOR_VERSION) || \
     (CRYPTO_IPW_AR_RELEASE_MINOR_VERSION_C != CRYPTO_AR_RELEASE_MINOR_VERSION) || \
     (CRYPTO_IPW_AR_RELEASE_REVISION_VERSION_C != CRYPTO_AR_RELEASE_REVISION_VERSION) \
    )
#error "AutoSar Version Numbers of Crypto_Ipw.c and Crypto.h are different"
#endif

/* Check if Crypto IPW source file and Crypto header file are of the same Software version */
#if ((CRYPTO_IPW_SW_MAJOR_VERSION_C != CRYPTO_SW_MAJOR_VERSION) || \
     (CRYPTO_IPW_SW_MINOR_VERSION_C != CRYPTO_SW_MINOR_VERSION) || \
     (CRYPTO_IPW_SW_PATCH_VERSION_C != CRYPTO_SW_PATCH_VERSION) \
    )
#error "Software Version Numbers of Crypto_Ipw.c and Crypto.h are different"
#endif



/* Check if Crypto IPW source file and Crypto types header file are of the same vendor */
#if (CRYPTO_IPW_VENDOR_ID_C != CRYPTO_VENDOR_ID_TYPES)
#error "Crypto_Ipw.c and Crypto_Types.h have different vendor ids"
#endif

/* Check if Crypto IPW source file and Crypto types header file are of the same Autosar version */
#if ((CRYPTO_IPW_AR_RELEASE_MAJOR_VERSION_C != CRYPTO_AR_RELEASE_MAJOR_VERSION_TYPES) || \
     (CRYPTO_IPW_AR_RELEASE_MINOR_VERSION_C != CRYPTO_AR_RELEASE_MINOR_VERSION_TYPES) || \
     (CRYPTO_IPW_AR_RELEASE_REVISION_VERSION_C != CRYPTO_AR_RELEASE_REVISION_VERSION_TYPES) \
    )
#error "AutoSar Version Numbers of Crypto_Ipw.c and Crypto_Types.h are different"
#endif

/* Check if Crypto IPW source file and Crypto types header file are of the same Software version */
#if ((CRYPTO_IPW_SW_MAJOR_VERSION_C != CRYPTO_SW_MAJOR_VERSION_TYPES) || \
     (CRYPTO_IPW_SW_MINOR_VERSION_C != CRYPTO_SW_MINOR_VERSION_TYPES) || \
     (CRYPTO_IPW_SW_PATCH_VERSION_C != CRYPTO_SW_PATCH_VERSION_TYPES) \
    )
#error "Software Version Numbers of Crypto_Ipw.c and Crypto_Types.h are different"
#endif

/* Check if Crypto IPW source file and CryIf Callback header file are of the same vendor */
#if (CRYPTO_IPW_VENDOR_ID_C != CRYIF_CBK_VENDOR_ID)
#error "Crypto_Ipw.c and CryIf_Cbk.h have different vendor ids"
#endif

/* Check if Crypto IPW source file and CryIf Callback header file are of the same Autosar version */
#if ((CRYPTO_IPW_AR_RELEASE_MAJOR_VERSION_C != CRYIF_CBK_AR_RELEASE_MAJOR_VERSION) || \
     (CRYPTO_IPW_AR_RELEASE_MINOR_VERSION_C != CRYIF_CBK_AR_RELEASE_MINOR_VERSION) || \
     (CRYPTO_IPW_AR_RELEASE_REVISION_VERSION_C != CRYIF_CBK_AR_RELEASE_REVISION_VERSION) \
    )
#error "AutoSar Version Numbers of Crypto_Ipw.c and CryIf_Cbk.h are different"
#endif

/* Check if Crypto IPW source file and CryIf Callback header file are of the same Software version */
#if ((CRYPTO_IPW_SW_MAJOR_VERSION_C != CRYIF_CBK_SW_MAJOR_VERSION) || \
     (CRYPTO_IPW_SW_MINOR_VERSION_C != CRYIF_CBK_SW_MINOR_VERSION) || \
     (CRYPTO_IPW_SW_PATCH_VERSION_C != CRYIF_CBK_SW_PATCH_VERSION) \
    )
#error "Software Version Numbers of Crypto_Ipw.c and CryIf_Cbk.h are different"
#endif

/* Check if Crypto IPW source file and Crypto IPW header file are of the same vendor */
#if (CRYPTO_IPW_VENDOR_ID_C != CRYPTO_VENDOR_ID_IPW_H)
#error "Crypto_Ipw.c and Crypto_Ipw.h have different vendor ids"
#endif

/* Check if Crypto IPW source file and Crypto IPW header file are of the same Autosar version */
#if ((CRYPTO_IPW_AR_RELEASE_MAJOR_VERSION_C != CRYPTO_AR_RELEASE_MAJOR_VERSION_IPW_H) || \
     (CRYPTO_IPW_AR_RELEASE_MINOR_VERSION_C != CRYPTO_AR_RELEASE_MINOR_VERSION_IPW_H) || \
     (CRYPTO_IPW_AR_RELEASE_REVISION_VERSION_C != CRYPTO_AR_RELEASE_REVISION_VERSION_IPW_H) \
    )
#error "AutoSar Version Numbers of Crypto_Ipw.c and Crypto_Ipw.h are different"
#endif

/* Check if Crypto IPW source file and Crypto IPW header file are of the same Software version */
#if ((CRYPTO_IPW_SW_MAJOR_VERSION_C != CRYPTO_SW_MAJOR_VERSION_IPW_H) || \
     (CRYPTO_IPW_SW_MINOR_VERSION_C != CRYPTO_SW_MINOR_VERSION_IPW_H) || \
     (CRYPTO_IPW_SW_PATCH_VERSION_C != CRYPTO_SW_PATCH_VERSION_IPW_H) \
    )
#error "Software Version Numbers of Crypto_Ipw.c and Crypto_Ipw.h are different"
#endif

/* Check if Crypto IPW source file and Crypto Cse header file are of the same vendor */
#if (CRYPTO_IPW_VENDOR_ID_C != CRYPTO_CSE_H_VENDOR_ID)
#error "Crypto_Ipw.c and Crypto_Cse.h have different vendor ids"
#endif

/* Check if Crypto IPW source file and Crypto Cse header file are of the same Autosar version */
#if ((CRYPTO_IPW_AR_RELEASE_MAJOR_VERSION_C != CRYPTO_CSE_H_AR_RELEASE_MAJOR_VERSION) || \
     (CRYPTO_IPW_AR_RELEASE_MINOR_VERSION_C != CRYPTO_CSE_H_AR_RELEASE_MINOR_VERSION) || \
     (CRYPTO_IPW_AR_RELEASE_REVISION_VERSION_C != CRYPTO_CSE_H_AR_RELEASE_REVISION_VERSION) \
    )
#error "AutoSar Version Numbers of Crypto_Ipw.c and Crypto_Cse.h are different"
#endif

/* Check if Crypto IPW source file and Crypto Cse header file are of the same Software version */
#if ((CRYPTO_IPW_SW_MAJOR_VERSION_C != CRYPTO_CSE_H_SW_MAJOR_VERSION) || \
     (CRYPTO_IPW_SW_MINOR_VERSION_C != CRYPTO_CSE_H_SW_MINOR_VERSION) || \
     (CRYPTO_IPW_SW_PATCH_VERSION_C != CRYPTO_CSE_H_SW_PATCH_VERSION) \
    )
#error "Software Version Numbers of Crypto_Ipw.c and Crypto_Cse.h are different"
#endif

/* Check if Crypto IPW source file and Crypto CseTypes header file are of the same vendor */
#if (CRYPTO_IPW_VENDOR_ID_C != CRYPTO_CSETYPES_H_VENDOR_ID)
#error "Crypto_Ipw.c and Crypto_CseTypes.h have different vendor ids"
#endif

/* Check if Crypto IPW source file and Crypto CseTypes header file are of the same Autosar version */
#if ((CRYPTO_IPW_AR_RELEASE_MAJOR_VERSION_C != CRYPTO_CSETYPES_H_AR_RELEASE_MAJOR_VERSION) || \
     (CRYPTO_IPW_AR_RELEASE_MINOR_VERSION_C != CRYPTO_CSETYPES_H_AR_RELEASE_MINOR_VERSION) || \
     (CRYPTO_IPW_AR_RELEASE_REVISION_VERSION_C != CRYPTO_CSETYPES_H_AR_RELEASE_REVISION_VERSION) \
    )
#error "AutoSar Version Numbers of Crypto_Ipw.c and Crypto_CseTypes.h are different"
#endif

/* Check if Crypto IPW source file and Crypto CseTypes header file are of the same Software version */
#if ((CRYPTO_IPW_SW_MAJOR_VERSION_C != CRYPTO_CSETYPES_H_SW_MAJOR_VERSION) || \
     (CRYPTO_IPW_SW_MINOR_VERSION_C != CRYPTO_CSETYPES_H_SW_MINOR_VERSION) || \
     (CRYPTO_IPW_SW_PATCH_VERSION_C != CRYPTO_CSETYPES_H_SW_PATCH_VERSION) \
    )
#error "Software Version Numbers of Crypto_Ipw.c and Crypto_CseTypes.h are different"
#endif

/* Check if Crypto IPW source file and CSM Types header file are of the same vendor */
#if (CRYPTO_IPW_VENDOR_ID_C != CSM_VENDOR_ID_TYPES)
#error "Crypto_Ipw.c and Csm_Types.h have different vendor ids"
#endif

/* Check if Crypto IPW source file and CSM Types header file are of the same Autosar version */
#if ((CRYPTO_IPW_AR_RELEASE_MAJOR_VERSION_C != CSM_AR_RELEASE_MAJOR_VERSION_TYPES) || \
     (CRYPTO_IPW_AR_RELEASE_MINOR_VERSION_C != CSM_AR_RELEASE_MINOR_VERSION_TYPES) || \
     (CRYPTO_IPW_AR_RELEASE_REVISION_VERSION_C != CSM_AR_RELEASE_REVISION_VERSION_TYPES) \
    )
#error "AutoSar Version Numbers of Crypto_Ipw.c and Csm_Types.h are different"
#endif

/* Check if Crypto IPW source file and CSM Types header file are of the same Software version */
#if ((CRYPTO_IPW_SW_MAJOR_VERSION_C != CSM_SW_MAJOR_VERSION_TYPES) || \
     (CRYPTO_IPW_SW_MINOR_VERSION_C != CSM_SW_MINOR_VERSION_TYPES) || \
     (CRYPTO_IPW_SW_PATCH_VERSION_C != CSM_SW_PATCH_VERSION_TYPES) \
    )
#error "Software Version Numbers of Crypto_Ipw.c and Csm_Types.h are different"
#endif

/*==================================================================================================
*                                       DEFINES AND MACROS
==================================================================================================*/
/* Value used to mark the end of a job queue */
#define CRYPTO_JOB_QUEUE_NONE_U32               ((uint32)0xFFFFFFFFU)

/*==================================================================================================
*                                      GLOBAL VARIABLES
==================================================================================================*/
#define CRYPTO_START_SEC_VAR_NO_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_Ipw_c_REF_2 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Ipw_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"
/* Variable storing the pointer to the job that is currently processing */
static P2CONST (Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) Crypto_pJobInProgress;

/*Current Job State*/
static VAR (Crypto_JobStateType, CRYPTO_VAR) Crypto_eCurrentJobState;

#define CRYPTO_STOP_SEC_VAR_NO_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_Ipw_c_REF_2 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Ipw_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

/*==================================================================================================
*                                   LOCAL FUNCTION PROTOTYPES
==================================================================================================*/
#define CRYPTO_START_SEC_CODE
/**
* @violates @ref Crypto_Ipw_c_REF_2 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Ipw_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

/**
* @brief           Initialize the CDO job queues
* @details         Each CDO has 2 queues, one with free elements, the second containing jobs sorted by priority. 
*                  For each of the CDO queues, only the first element (head) is stored, as each queue element has a reference to the next one.
*                  This function initializes the queues heads and chains the elements in the free jobs queues
*
* @param[in]       void
* @returns         void
*
* @api
*
* @pre            
*                   
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_Ipw_InitJobQueues(void);

/**
* @brief           Adds a job in the jobs queue
* @details         Adds a job in the jobs queue, if at least one element is found in the queue of free jobs. The job is inserted in the queue
*                  based on its priority
*
* @param[in]       u32ObjectIdIdx: identifier of the Crypto Driver Object to be used for queuing the job
* @param[in]       pJob:        pointer to the job to be queued
* @returns         boolean
*                   TRUE  - job has been queued
*                   FALSE - job could not be queued
*
* @api
*
* @pre            
*                   
*/
LOCAL_INLINE FUNC(boolean, CRYPTO_CODE) Crypto_Ipw_QueueJob
(
    VAR(uint32, AUTOMATIC) u32ObjectIdx,
    P2CONST(Crypto_JobType, AUTOMATIC,  CRYPTO_APPL_CONST) pJob
);

/**
* @brief           Dequeues the first job in the queue
* @details         Removes the first queued job (head) and adds it in the queue of free jobs
*
* @param[in]       u32ObjectIdIdx: identifier of the Crypto Driver Object to be used for dequeuing the job
* @returns         void
*
* @api
*
* @pre            Assumes that at least one element exists in the queued jobs
*                   
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_Ipw_DequeueHeadJob
(
    VAR(uint32, AUTOMATIC) u32ObjectIdIdx
);

/**
* @brief           Dequeues from the list of queued jobs the first found job with the given jobId
* @details         Searches the queued jobs for a job with a given jobId and if found, removes it
*
* @param[in]       u32ObjectIdIdx: identifier of the Crypto Driver Object to be used for dequeuing the job
* @param[in]       pJobInfo:       pointer to jobInfo structure containing the jobId to search for
* @returns         Std_ReturnType
*
* @api
*
* @pre            
*                   
*/
LOCAL_INLINE FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_DequeueJob
(
    VAR(uint32, AUTOMATIC) u32ObjectIdIdx,
    P2CONST(Crypto_JobInfoType, AUTOMATIC, CRYPTO_APPL_CONST) pJobInfo
);

/**
* @brief           Fills the MAC generate descriptor
* @details         Configures the Cse Mac generate descriptor
*
* @param[in]       pJob: pointer to the job
* @param[out]      none 
* @returns         Std_ReturnType
*                   E_OK: correct configuration of parameters
*                   E_NOT_OK: incorrect configuration of parameters: keyId not existent, IV(if needed)
* @api
*
* @pre            
*                   
*/
LOCAL_INLINE FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Ipw_MacGenerate ( P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob);

/**
* @brief           Fills the MAC Verify descriptor
* @details         Configures the Cse Mac Verify descriptor
*
* @param[in]       pJob: pointer to the job
* @param[out]      none 
* @returns         Std_ReturnType
*                   E_OK: correct configuration of parameters
*                   E_NOT_OK: incorrect configuration of parameters: keyId not existent
* @api
*
* @pre            
*                   
*/
LOCAL_INLINE FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Ipw_MacVerify ( P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob);

/**
* @brief           Fills the AES encrypt descriptor
* @details         Configures the AES encrypt descriptor
*
* @param[in]       pJob: pointer to the job
* @param[out]      none 
* @returns         Std_ReturnType
*                   E_OK: correct configuration of parameters
*                   E_NOT_OK: incorrect configuration of parameters: keyId not existent
* @api
*
* @pre            
*                   
*/
LOCAL_INLINE FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Ipw_Encrypt ( P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob);

/**
* @brief           Fills the AES dencrypt descriptor
* @details         Configures the AES dencrypt descriptor
*
* @param[in]       pJob: pointer to the job
* @param[out]      none 
* @returns         Std_ReturnType
*                   E_OK: correct configuration of parameters
*                   E_NOT_OK: incorrect configuration of parameters: keyId not existent
* @api
*
* @pre            
*                   
*/
LOCAL_INLINE FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Ipw_Decrypt ( P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob);

/**
* @brief           Fills the AES random descriptor
* @details         Configures the AES random descriptor
*
* @param[in]       pJob: pointer to the job
* @param[out]      none 
* @returns         Std_ReturnType
*                   E_OK: correct configuration of parameters
*                   E_NOT_OK: incorrect configuration of parameters: keyId not existent
* @api
*
* @pre            
*                   
*/
LOCAL_INLINE FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Ipw_Random ( P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob);

/**
* @brief           Verify the return of the HW.
* @details         Verify the return of the HW to match with error code of Crypto driver.
*
* @param[in]       u32Message: the return of HW
* @param[out]      none 
* @returns         Std_ReturnType
*                   E_OK: correct configuration of parameters
*                   E_NOT_OK: incorrect configuration of parameters: keyId not existent
* @api
*
* @pre            
*                   
*/
LOCAL_INLINE FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_VerifyCseResponse ( VAR (Crypto_Cse_ErrorCodeType, AUTOMATIC) u32Message );

/*==================================================================================================
*                                       LOCAL FUNCTIONS
==================================================================================================*/

/**
* @brief           Initialize the CDO job queues
* @details         Each CDO has 2 queues, one with free elements, the second containing jobs sorted by priority. 
*                  For each of the CDO queues, only the first element (head) is stored, as each queue element has a reference to the next one.
*                  This function initializes the queues heads and chains the elements in the free jobs queues
*
* @param[in]       void
* @returns         void
*
* @api
*
* @pre            
*                   
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_Ipw_InitJobQueues(void)
{
    VAR(uint32, AUTOMATIC) u32ObjectIdIdx;
    VAR(uint32, AUTOMATIC) u32IdxQueueElement;

    for ( u32ObjectIdIdx = 0U; u32ObjectIdIdx < (uint32)CRYPTO_NUMBER_OF_DRIVER_OBJECTS; u32ObjectIdIdx++ )
    {
        /* Initialize the head of queued jobs stating that no job is queued */
        Crypto_aObjectList[u32ObjectIdIdx]->u32HeadOfQueuedJobs = CRYPTO_JOB_QUEUE_NONE_U32;

        if(0U == Crypto_aObjectList[u32ObjectIdIdx]->u32CryptoQueueSize)
        {
            /* If CDO queue size is zero, mark the queue of free jobs as being empty. */
            Crypto_aObjectList[u32ObjectIdIdx]->u32HeadOfFreeJobs = CRYPTO_JOB_QUEUE_NONE_U32;
        }
        else
        {
            /* Initialize the CDO queue of free jobs by chaining all queue job elements */
            Crypto_aObjectList[u32ObjectIdIdx]->u32HeadOfFreeJobs = 0U;
            for (u32IdxQueueElement = 0U; u32IdxQueueElement < (Crypto_aObjectList[u32ObjectIdIdx]->u32CryptoQueueSize - 1U); u32IdxQueueElement++)
            {
                /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                Crypto_aObjectList[u32ObjectIdIdx]->pQueuedJobs[u32IdxQueueElement].u32Next = u32IdxQueueElement + 1U;
            }
            /* Mark the last in the queue as pointing to no other next queue element */
            /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
            Crypto_aObjectList[u32ObjectIdIdx]->pQueuedJobs[u32IdxQueueElement].u32Next = CRYPTO_JOB_QUEUE_NONE_U32;
        }
    }
}

/**
* @brief           Adds a job in the jobs queue
* @details         Each CDO has 2 queues, one with free elements, the second containing jobs sorted by priority. 
*                  For each of the CDO queues, only the first element (head) is stored, as each queue element has a reference to the next one.
*                  This function initializes the queues heads and chains the elements in the free jobs queues
*
* @param[in]       u32ObjectIdx: identifier of the Crypto Driver Object to be used for queuing the job
* @param[in]       pJob:        pointer to the job to be queued
* @returns         boolean
*                   TRUE  - job has been queued
*                   FALSE - job could not be queued
*
* @api
*
* @pre            
*                   
*/
LOCAL_INLINE FUNC(boolean, CRYPTO_CODE) Crypto_Ipw_QueueJob
(
    VAR(uint32, AUTOMATIC) u32ObjectIdx,
    P2CONST(Crypto_JobType, AUTOMATIC,  CRYPTO_APPL_CONST) pJob
)
{
    P2VAR(uint32,  AUTOMATIC, CRYPTO_APPL_DATA) pQueueSearch = &(Crypto_aObjectList[u32ObjectIdx]->u32HeadOfQueuedJobs);
    VAR  (boolean, AUTOMATIC                  ) bJobQueued   = (boolean)FALSE;
    VAR  (boolean, AUTOMATIC                  ) bJobDuplicated   = (boolean)FALSE;
    P2CONST(Crypto_JobType, AUTOMATIC,  CRYPTO_APPL_CONST) pJobDuplicated;
    VAR  (uint32,  AUTOMATIC                  ) u32IdxQueueElementJob;
    VAR  (uint32,  AUTOMATIC                  ) u32TempIdxQueueElement;

    /* Check if there is at least one element in the free jobs queue */
    if (CRYPTO_JOB_QUEUE_NONE_U32 != Crypto_aObjectList[u32ObjectIdx]->u32HeadOfFreeJobs)
    {
        /* Enter critical section  */
        SchM_Enter_Crypto_CRYPTO_EXCLUSIVE_AREA_00();
        /*If there is a job has same id with new job, dequeues this job*/
        while (((boolean)FALSE == bJobDuplicated) && (CRYPTO_JOB_QUEUE_NONE_U32 != *pQueueSearch))
        {
            /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
            if (pJob->jobInfo->jobId == Crypto_aObjectList[u32ObjectIdx]->pQueuedJobs[*pQueueSearch].pJob->jobInfo->jobId)
            {
                /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                pJobDuplicated = Crypto_aObjectList[u32ObjectIdx]->pQueuedJobs[*pQueueSearch].pJob;
                (void)Crypto_Ipw_DequeueJob(u32ObjectIdx,pJobDuplicated->jobInfo);
                bJobDuplicated = (boolean)TRUE;
            }
            /* Advance to the next element in the queue */
            /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
            pQueueSearch = &(Crypto_aObjectList[u32ObjectIdx]->pQueuedJobs[*pQueueSearch].u32Next);
        }
        pQueueSearch = &(Crypto_aObjectList[u32ObjectIdx]->u32HeadOfQueuedJobs);
        /* Take the first element from the queue of free jobs */
        u32IdxQueueElementJob = Crypto_aObjectList[u32ObjectIdx]->u32HeadOfFreeJobs;
        /* Set new value for head of free jobs queue as the next element in the queue */
        /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
        Crypto_aObjectList[u32ObjectIdx]->u32HeadOfFreeJobs = Crypto_aObjectList[u32ObjectIdx]->pQueuedJobs[u32IdxQueueElementJob].u32Next;
        /* Put the element taken from free jobs queue in the job queue, in the right position based on priority */
        while (((boolean)FALSE == bJobQueued) && (CRYPTO_JOB_QUEUE_NONE_U32 != *pQueueSearch))
        {
            /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
            if (pJob->jobInfo->jobPriority > Crypto_aObjectList[u32ObjectIdx]->pQueuedJobs[*pQueueSearch].pJob->jobInfo->jobPriority)
            {
                /* Save address of list element we are inserting the new job in front of */
                u32TempIdxQueueElement = *pQueueSearch;
                /* Need to insert the element here */
                *pQueueSearch = u32IdxQueueElementJob;
                /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                Crypto_aObjectList[u32ObjectIdx]->pQueuedJobs[u32IdxQueueElementJob].u32Next = u32TempIdxQueueElement;
                /* Mark the job as queued */
                bJobQueued = (boolean)TRUE;
            }
            /* Advance to the next element in the queue */
            /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
            pQueueSearch = &(Crypto_aObjectList[u32ObjectIdx]->pQueuedJobs[*pQueueSearch].u32Next);
        }
        /* If we looped through all elements containing queued jobs and did not find a place where to put the new element, add it at the end */
        if ((boolean)FALSE == bJobQueued)
        {
            *pQueueSearch = u32IdxQueueElementJob;
            /* Mark the new added queue element as being the last one in the queue */
            /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
            Crypto_aObjectList[u32ObjectIdx]->pQueuedJobs[u32IdxQueueElementJob].u32Next = CRYPTO_JOB_QUEUE_NONE_U32;
        }
        /* Exit critical section */
        SchM_Exit_Crypto_CRYPTO_EXCLUSIVE_AREA_00();
        /* Copy the job into the free queue element found */
        /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
        Crypto_aObjectList[u32ObjectIdx]->pQueuedJobs[u32IdxQueueElementJob].pJob = pJob;
        /* Mark the job as queued */
        bJobQueued = (boolean)TRUE;
    }
    return bJobQueued;
}

/**
* @brief           Dequeues the first job in the queue
* @details         Removes the first queued job (head) and adds it in the queue of free jobs
*
* @param[in]       u32ObjectIdIdx: identifier of the Crypto Driver Object to be used for dequeuing the job
* @returns         void
*
* @api
*
* @pre            Assumes that at least one element exists in the queued jobs
*                   
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_Ipw_DequeueHeadJob
(
    VAR(uint32, AUTOMATIC) u32ObjectIdIdx
)
{
    VAR(uint32, AUTOMATIC) u32HeadOfQueuedJobs;
    VAR(uint32, AUTOMATIC) u32HeadOfFreeJobs;
    
    /* Enter critical section  */
    SchM_Enter_Crypto_CRYPTO_EXCLUSIVE_AREA_01();
    
    u32HeadOfQueuedJobs = Crypto_aObjectList[u32ObjectIdIdx]->u32HeadOfQueuedJobs;
    u32HeadOfFreeJobs   = Crypto_aObjectList[u32ObjectIdIdx]->u32HeadOfFreeJobs;
    
    /* Move head of queued jobs to the next element in the queue */
    /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
    Crypto_aObjectList[u32ObjectIdIdx]->u32HeadOfQueuedJobs = Crypto_aObjectList[u32ObjectIdIdx]->pQueuedJobs[u32HeadOfQueuedJobs].u32Next;

    /* Add the removed head of queued jobs as being the head of queue of free jobs */
    Crypto_aObjectList[u32ObjectIdIdx]->u32HeadOfFreeJobs                        = u32HeadOfQueuedJobs;
    /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
    Crypto_aObjectList[u32ObjectIdIdx]->pQueuedJobs[u32HeadOfQueuedJobs].u32Next = u32HeadOfFreeJobs;
    
    /* Exit critical section */
    SchM_Exit_Crypto_CRYPTO_EXCLUSIVE_AREA_01();
}


/**
* @brief           Dequeues from the list of queued jobs the first found job with the given jobId
* @details         Searches the queued jobs for a job with a given jobId and if found, removes it
*
* @param[in]       u32ObjectIdIdx: identifier of the Crypto Driver Object to be used for dequeuing the job
* @param[in]       pJobInfo:       pointer to jobInfo structure containing the jobId to search for
* @returns         Std_ReturnType
*
* @api
*
* @pre            
*                   
*/
LOCAL_INLINE FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_DequeueJob
(
    VAR(uint32, AUTOMATIC) u32ObjectIdIdx,
    P2CONST(Crypto_JobInfoType, AUTOMATIC, CRYPTO_APPL_CONST) pJobInfo
)
{
    VAR  (Std_ReturnType, AUTOMATIC                  ) RetVal = (Std_ReturnType)E_NOT_OK;
    P2VAR(uint32,         AUTOMATIC, CRYPTO_APPL_DATA) pQueueSearch;
    VAR  (uint32,         AUTOMATIC                  ) u32TempIdxQueueElement1;
    VAR  (uint32,         AUTOMATIC                  ) u32TempIdxQueueElement2;

    /* Check if there is at least one element in the list of queued jobs */
    if (CRYPTO_JOB_QUEUE_NONE_U32 != Crypto_aObjectList[u32ObjectIdIdx]->u32HeadOfQueuedJobs)
    {
        pQueueSearch = &(Crypto_aObjectList[u32ObjectIdIdx]->u32HeadOfQueuedJobs);
        /* Loop through entire list of queued jobs */
        while (CRYPTO_JOB_QUEUE_NONE_U32 != *pQueueSearch)
        {
            /* Check if the current looped job from the list of queued jobs has same jobId with the one received as parameter */
            /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
            if (pJobInfo->jobId == Crypto_aObjectList[u32ObjectIdIdx]->pQueuedJobs[*pQueueSearch].pJob->jobInfo->jobId)
            {
                /* Enter critical section  */
                SchM_Enter_Crypto_CRYPTO_EXCLUSIVE_AREA_02();

                /* Store temporary the value of the address of the element in array Crypto_aObjectList[u32ObjectIdIdx]->pQueuedJobs[] pointed by pQueueSearch */
                u32TempIdxQueueElement1 = *pQueueSearch;

                /* Found a job matching the same jobId. Remove it from the list of queued jobs */
                /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                *pQueueSearch = Crypto_aObjectList[u32ObjectIdIdx]->pQueuedJobs[*pQueueSearch].u32Next;

                /* Add the removed element in in the list of free jobs */
                u32TempIdxQueueElement2 = Crypto_aObjectList[u32ObjectIdIdx]->u32HeadOfFreeJobs;
                Crypto_aObjectList[u32ObjectIdIdx]->u32HeadOfFreeJobs = u32TempIdxQueueElement1;
                /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
                Crypto_aObjectList[u32ObjectIdIdx]->pQueuedJobs[u32TempIdxQueueElement1].u32Next = u32TempIdxQueueElement2;

                /* Exit critical section */
                SchM_Exit_Crypto_CRYPTO_EXCLUSIVE_AREA_02();
                
                RetVal = (Std_ReturnType)E_OK;
                break;
            }
            /* Advance to the next element in the list of queued jobs, searching for the job to dequeue */
            /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
            pQueueSearch = &(Crypto_aObjectList[u32ObjectIdIdx]->pQueuedJobs[*pQueueSearch].u32Next);
        }
    }
    
    return RetVal;
}

/**
* @brief           Fills the MAC generate descriptor
* @details         Configures the Cse Mac generate descriptor
*
* @param[in]       pJob: pointer to the job
* @param[out]      none 
* @returns         Std_ReturnType
*                   E_OK: correct configuration of parameters
*                   E_NOT_OK: incorrect configuration of parameters: keyId not existent, IV(if needed)
* @api
*
* @pre            
*                   
*/
/**
* @violates @ref Crypto_Ipw_c_REF_3 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Ipw_MacGenerate ( P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob)
{
    VAR (Crypto_Cse_ErrorCodeType, AUTOMATIC) eStatus       = (Crypto_Cse_ErrorCodeType) CRYPTO_CSE_ERC_GENERAL_ERROR;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey = {(Std_ReturnType)E_NOT_OK, 0U};
    VAR (Crypto_VerifyKeyElementType, AUTOMATIC) sVerifyKeyElement = {(Std_ReturnType)E_NOT_OK, 0U};
    
    if ( *pJob->PrimitiveInputOutput.outputLengthPtr >= pJob->jobPrimitiveInfo->primitiveInfo->resultLength )
    {      
        /* Fill the outputLengthPtr with the size of MAC. If job->jobPrimitiveInfo->primitiveInfo->service is set to CRYPTO_HASH or CRYPTO_MACGENERATE, the parameter job->jobPrimitiveInfo->primitiveInfo->resultLength is required.*/
        *pJob->PrimitiveInputOutput.outputLengthPtr = pJob->jobPrimitiveInfo->primitiveInfo->resultLength;
        sVerifyKey = Crypto_Ipw_VerifyKeyId (pJob->cryptoKeyId);
        if ( (Std_ReturnType)E_OK == sVerifyKey.eFound ) 
        {  
            sVerifyKeyElement = Crypto_Ipw_VerifyKeyElementId ( sVerifyKey.u32Counter, 5U );
            
            if (( (Std_ReturnType)E_OK  == sVerifyKeyElement.eFound ))
            {      
                if (CRYPTO_PROCESSING_ASYNC == pJob->jobPrimitiveInfo->processingType)
                {
                    eStatus = Crypto_Cse_MacAsyncGenerate ( (Crypto_Cse_KeyIdType)pJob->cryptoKeyId,pJob->PrimitiveInputOutput.inputPtr, pJob->PrimitiveInputOutput.inputLength, pJob->PrimitiveInputOutput.outputPtr );
                }
                else
                {
                    eStatus = Crypto_Cse_MacGenerate ( (Crypto_Cse_KeyIdType)pJob->cryptoKeyId,pJob->PrimitiveInputOutput.inputPtr, pJob->PrimitiveInputOutput.inputLength, pJob->PrimitiveInputOutput.outputPtr );
                }
            }
        }
        else
        {
            Crypto_eCurrentJobState = CRYPTO_JOBSTATE_IDLE;
        }
    }
    else
    {
        eStatus = CRYPTO_CSE_ERC_SMALL_BUFFER;
        Crypto_eCurrentJobState = CRYPTO_JOBSTATE_IDLE;
    }
    
    return eStatus;
}

/**
* @brief           Fills the MAC Verify descriptor
* @details         Configures the Cse Mac Verify descriptor
*
* @param[in]       pJob: pointer to the job
* @param[out]      none 
* @returns         Std_ReturnType
*                   E_OK: correct configuration of parameters
*                   E_NOT_OK: incorrect configuration of parameters: keyId not existent
* @api
*
* @pre            
*                   
*/
/**
* @violates @ref Crypto_Ipw_c_REF_3 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Ipw_MacVerify ( P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob)
{
    VAR (Crypto_Cse_ErrorCodeType, AUTOMATIC) eStatus       = (Crypto_Cse_ErrorCodeType) CRYPTO_CSE_ERC_GENERAL_ERROR;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey = {(Std_ReturnType)E_NOT_OK, 0U};
    VAR (Crypto_VerifyKeyElementType, AUTOMATIC) sVerifyKeyElement = {(Std_ReturnType)E_NOT_OK, 0U};
    
    sVerifyKey = Crypto_Ipw_VerifyKeyId (pJob->cryptoKeyId);
    if ( (Std_ReturnType)E_OK == sVerifyKey.eFound ) 
    {  
        sVerifyKeyElement = Crypto_Ipw_VerifyKeyElementId ( sVerifyKey.u32Counter, 5U );
        
        if (( (Std_ReturnType)E_OK  == sVerifyKeyElement.eFound ))
        {
            if (CRYPTO_PROCESSING_ASYNC == pJob->jobPrimitiveInfo->processingType)    
            {
                eStatus = Crypto_Cse_MacAsyncVerify ( (Crypto_Cse_KeyIdType)pJob->cryptoKeyId, pJob->PrimitiveInputOutput.inputPtr, pJob->PrimitiveInputOutput.inputLength, \
                                                 pJob->PrimitiveInputOutput.secondaryInputLength, pJob->PrimitiveInputOutput.secondaryInputPtr, pJob->PrimitiveInputOutput.verifyPtr);
            }
            else
            {
                eStatus = Crypto_Cse_MacVerify ( (Crypto_Cse_KeyIdType)pJob->cryptoKeyId, pJob->PrimitiveInputOutput.inputPtr, pJob->PrimitiveInputOutput.inputLength, \
                                                 pJob->PrimitiveInputOutput.secondaryInputLength, pJob->PrimitiveInputOutput.secondaryInputPtr,pJob->PrimitiveInputOutput.verifyPtr);
            }
        }
        else
        {
            Crypto_eCurrentJobState = CRYPTO_JOBSTATE_IDLE;
        }

    }
    else
    {
        Crypto_eCurrentJobState = CRYPTO_JOBSTATE_IDLE;
    }
    
    return eStatus;
}

/**
* @brief           Fills the AES encrypt descriptor
* @details         Configures the AES encrypt descriptor
*
* @param[in]       pJob: pointer to the job
* @param[out]      none 
* @returns         Std_ReturnType
*                   E_OK: correct configuration of parameters
*                   E_NOT_OK: incorrect configuration of parameters: keyId not existent
* @api
*
* @pre            
*                   
*/
/**
* @violates @ref Crypto_Ipw_c_REF_3 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Ipw_Encrypt ( P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob)
{
    VAR (Crypto_Cse_ErrorCodeType, AUTOMATIC) eStatus       = (Crypto_Cse_ErrorCodeType) CRYPTO_CSE_ERC_GENERAL_ERROR;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey = {(Std_ReturnType)E_NOT_OK, 0U};
    VAR (Crypto_VerifyKeyElementType, AUTOMATIC) sVerifyKeyElement = {(Std_ReturnType)E_NOT_OK, 0U};
    
    sVerifyKey = Crypto_Ipw_VerifyKeyId (pJob->cryptoKeyId);
    if ( (Std_ReturnType)E_OK == sVerifyKey.eFound ) 
    {  
        sVerifyKeyElement = Crypto_Ipw_VerifyKeyElementId ( sVerifyKey.u32Counter, 5U );
    }
    
    if ( *pJob->PrimitiveInputOutput.outputLengthPtr >= pJob->PrimitiveInputOutput.inputLength)
    {
        *pJob->PrimitiveInputOutput.outputLengthPtr = pJob->PrimitiveInputOutput.inputLength;
        
        switch (pJob->jobPrimitiveInfo->primitiveInfo->algorithm.mode)
        {
            case CRYPTO_ALGOMODE_ECB:
            {
                if (CRYPTO_PROCESSING_ASYNC == pJob->jobPrimitiveInfo->processingType)
                {
                    eStatus = Crypto_Cse_EcbAsyncEncrypt((Crypto_Cse_KeyIdType)pJob->cryptoKeyId, pJob->PrimitiveInputOutput.inputPtr,
                                                        pJob->PrimitiveInputOutput.inputLength,pJob->PrimitiveInputOutput.outputPtr);
                }
                else
                {
                    eStatus = Crypto_Cse_EcbEncrypt((Crypto_Cse_KeyIdType)pJob->cryptoKeyId, pJob->PrimitiveInputOutput.inputPtr,
                                                        pJob->PrimitiveInputOutput.inputLength,pJob->PrimitiveInputOutput.outputPtr);
                }
            } break;
            case CRYPTO_ALGOMODE_CBC:
            {
                if ( ( (Std_ReturnType)E_OK  == sVerifyKeyElement.eFound ) )
                {
                    if (CRYPTO_PROCESSING_ASYNC == pJob->jobPrimitiveInfo->processingType)
                    {
                        eStatus = Crypto_Cse_CbcAsyncEncrypt((Crypto_Cse_KeyIdType)pJob->cryptoKeyId, pJob->PrimitiveInputOutput.inputPtr,
                                                            pJob->PrimitiveInputOutput.inputLength,Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->pCryptoElementArray,pJob->PrimitiveInputOutput.outputPtr);
                    }
                    else
                    {
                        eStatus = Crypto_Cse_CbcEncrypt((Crypto_Cse_KeyIdType)pJob->cryptoKeyId, pJob->PrimitiveInputOutput.inputPtr,
                                                            pJob->PrimitiveInputOutput.inputLength,Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->pCryptoElementArray,pJob->PrimitiveInputOutput.outputPtr);
                    }
                }
                else
                {
                    Crypto_eCurrentJobState = CRYPTO_JOBSTATE_IDLE;
                }
            }break;
            default :
            {
                /*do nothing*/
            }
        }
    }
    else
    {
        eStatus = CRYPTO_CSE_ERC_SMALL_BUFFER;
        Crypto_eCurrentJobState = CRYPTO_JOBSTATE_IDLE;
    }
    
    return eStatus;
}

/**
* @brief           Fills the AES dencrypt descriptor
* @details         Configures the AES dencrypt descriptor
*
* @param[in]       pJob: pointer to the job
* @param[out]      none 
* @returns         Std_ReturnType
*                   E_OK: correct configuration of parameters
*                   E_NOT_OK: incorrect configuration of parameters: keyId not existent
* @api
*
* @pre            
*                   
*/
/**
* @violates @ref Crypto_Ipw_c_REF_3 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Ipw_Decrypt ( P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob)
{
    VAR (Crypto_Cse_ErrorCodeType, AUTOMATIC) eStatus       = (Crypto_Cse_ErrorCodeType) CRYPTO_CSE_ERC_GENERAL_ERROR;
    VAR (Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey = {(Std_ReturnType)E_NOT_OK, 0U};
    VAR (Crypto_VerifyKeyElementType, AUTOMATIC) sVerifyKeyElement = {(Std_ReturnType)E_NOT_OK, 0U};
    
    sVerifyKey = Crypto_Ipw_VerifyKeyId (pJob->cryptoKeyId);
    if ( (Std_ReturnType)E_OK == sVerifyKey.eFound ) 
    {  
        sVerifyKeyElement = Crypto_Ipw_VerifyKeyElementId ( sVerifyKey.u32Counter, 5U );
    }
    
    if ( *pJob->PrimitiveInputOutput.outputLengthPtr >= pJob->PrimitiveInputOutput.inputLength)
    {
        *pJob->PrimitiveInputOutput.outputLengthPtr = pJob->PrimitiveInputOutput.inputLength;
        switch (pJob->jobPrimitiveInfo->primitiveInfo->algorithm.mode)
        {
            case CRYPTO_ALGOMODE_ECB:
            {
                if (CRYPTO_PROCESSING_ASYNC == pJob->jobPrimitiveInfo->processingType)
                {
                    eStatus = Crypto_Cse_EcbAsyncDecrypt((Crypto_Cse_KeyIdType)pJob->cryptoKeyId, pJob->PrimitiveInputOutput.inputPtr,
                                                        pJob->PrimitiveInputOutput.inputLength,pJob->PrimitiveInputOutput.outputPtr);
                }
                else
                {
                    eStatus = Crypto_Cse_EcbDecrypt((Crypto_Cse_KeyIdType)pJob->cryptoKeyId, pJob->PrimitiveInputOutput.inputPtr,
                                                        pJob->PrimitiveInputOutput.inputLength,pJob->PrimitiveInputOutput.outputPtr);
                }
            } break;
            case CRYPTO_ALGOMODE_CBC:
            {
                if ( ( (Std_ReturnType)E_OK  == sVerifyKeyElement.eFound ) )
                {
                    if (CRYPTO_PROCESSING_ASYNC == pJob->jobPrimitiveInfo->processingType)
                    {
                        eStatus = Crypto_Cse_CbcAsyncDecrypt((Crypto_Cse_KeyIdType)pJob->cryptoKeyId, pJob->PrimitiveInputOutput.inputPtr,
                                                        pJob->PrimitiveInputOutput.inputLength,Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->pCryptoElementArray,pJob->PrimitiveInputOutput.outputPtr);
                    }
                    else
                    {
                        eStatus = Crypto_Cse_CbcDecrypt((Crypto_Cse_KeyIdType)pJob->cryptoKeyId, pJob->PrimitiveInputOutput.inputPtr,
                                                        pJob->PrimitiveInputOutput.inputLength,Crypto_aKeyElementList[sVerifyKeyElement.u32Counter]->pCryptoElementArray,pJob->PrimitiveInputOutput.outputPtr);
                    }
                }
                else
                {
                    Crypto_eCurrentJobState = CRYPTO_JOBSTATE_IDLE;
                }
            } break;
            default :
            {
                /*do nothing*/
            }
        }
    }
    else
    {
        eStatus = CRYPTO_CSE_ERC_SMALL_BUFFER;
        Crypto_eCurrentJobState = CRYPTO_JOBSTATE_IDLE;
    }
    
    return eStatus;
}

/**
* @brief           Verify the return of the HW.
* @details         Verify the return of the HW to match with error code of Crypto driver.
*
* @param[in]       u32Message: the return of HW
* @param[out]      none 
* @returns         Std_ReturnType
*                   E_OK: correct configuration of parameters
*                   E_NOT_OK: incorrect configuration of parameters: keyId not existent
* @api
*
* @pre            
*                   
*/
/**
* @violates @ref Crypto_Ipw_c_REF_3 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC (Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_VerifyCseResponse ( VAR (Crypto_Cse_ErrorCodeType, AUTOMATIC) u32Message )
{
    VAR (Crypto_Cse_ErrorCodeType, AUTOMATIC) eStatus = (Crypto_Cse_ErrorCodeType) u32Message;
    VAR (Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_NOT_OK;
    
    switch (eStatus)
    {
        /* HSM command successfully executed with no error. */
        case CRYPTO_CSE_ERC_NO_ERROR:
        {
            eOutResponse = (Std_ReturnType)E_OK;
        } break;  
        case CRYPTO_CSE_ERC_SEQUENCE_ERROR: /* Command issued before the SHE_DEBUG_CHAL command */ 
        case CRYPTO_CSE_ERC_KEY_EMPTY: /* Specified key slot is empty */ 
        case CRYPTO_CSE_ERC_NO_SECURE_BOOT: /* 1. SECURE_BOOT issued when secure boot is disabled or the BOOT_MAC_KEY slot is empty; 2. BOOT_FAIL or BOOT_OK issued */ 
        case CRYPTO_CSE_ERC_KEY_UPDATE_ERROR:  /* RND, EXTEND_SEED or DEBUG_CHAL command issued before the INIT_RNG command */
        case CRYPTO_CSE_ERC_RNG_SEED:  /* DEBUG_AUTH command issued with invalid MAC value. */
        case CRYPTO_CSE_ERC_NO_DEBUGGING: 
        case CRYPTO_CSE_ERC_MEMORY_FAILURE: /* An internal memory error was encountered while executing the command */
        case CRYPTO_CSE_ERC_GENERAL_ERROR: 
        {
            eOutResponse = (Std_ReturnType)E_NOT_OK;
        } break;
        case CRYPTO_CSE_ERC_SMALL_BUFFER: 
        {
            eOutResponse = (Std_ReturnType)CRYPTO_E_SMALL_BUFFER;
        } break;
        /* The service request failed because read access was denied */        
        case CRYPTO_CSE_ERC_KEY_WRITE_PROTECTED:
        {
            eOutResponse = (Std_ReturnType)CRYPTO_E_KEY_WRITE_FAIL;
        } break;  
        /* This error code is returned if a key is locked due to failed boot measurement or an active debugger. */        
        case CRYPTO_CSE_ERC_KEY_NOT_AVAILABLE:
        {
            eOutResponse = (Std_ReturnType)CRYPTO_E_KEY_NOT_AVAILABLE;
        } break;
        /* Specified key slot is either not valid or not available due to a key usage flags restrictions. */        
        case CRYPTO_CSE_ERC_KEY_INVALID:
        {
            eOutResponse = (Std_ReturnType)CRYPTO_E_KEY_NOT_VALID;
        } break;
        /* HSM request issued when the HSM is in busy state (on that HSM Host) . */        
        case CRYPTO_CSE_ERC_BUSY:
        {
            eOutResponse = (Std_ReturnType)CRYPTO_E_BUSY;
        } break;
        case CRYPTO_CSE_ERC_CANCELED:
        {
            eOutResponse = (Std_ReturnType)CRYPTO_E_JOB_CANCELED;
        } break;
        default:
        {
            /* Should not get here */
            eOutResponse = (Std_ReturnType)E_NOT_OK;
        } break;
    }
    
    return eOutResponse;
}

/**
* @brief           Fills the AES random descriptor
* @details         Configures the AES random descriptor
*
* @param[in]       pJob: pointer to the job
* @param[out]      none 
* @returns         Std_ReturnType
*                   E_OK: correct configuration of parameters
*                   E_NOT_OK: incorrect configuration of parameters: keyId not existent
* @api
*
* @pre            
*                   
*/
/**
* @violates @ref Crypto_Ipw_c_REF_3 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Ipw_Random ( P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob)
{   
    VAR (Crypto_Cse_ErrorCodeType, AUTOMATIC) eStatus = (Crypto_Cse_ErrorCodeType) CRYPTO_CSE_ERC_GENERAL_ERROR;  
    
    eStatus = Crypto_Cse_InitRng();
    if (CRYPTO_CSE_ERC_NO_ERROR == eStatus)
    {
        eStatus = Crypto_Cse_GenerateRnd (pJob->PrimitiveInputOutput.outputPtr);
    }

    return eStatus;
}

/**
* @brief           Processes a job.
* @details         Tries to initiate a request to CSE to process a job.
*
* @param[inout]    pJob              Pointer to the job to be processed.
*
* @return          Result of the operation.
*                   Std_ReturnType
* @api
*
* @pre            Driver must be initialized.
*
*/
LOCAL_INLINE FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_ProcessOperation
(
    P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob
)
{
    VAR(Crypto_Cse_ErrorCodeType, AUTOMATIC) eOutResponse = CRYPTO_CSE_ERC_GENERAL_ERROR;
    VAR(Std_ReturnType, AUTOMATIC) RetVal      = (Std_ReturnType)E_NOT_OK;
    VAR(boolean,        AUTOMATIC) bHwIsBusy = Crypto_Cse_IsBusy();

    /* Check if CSE is not busy processing a request */
    if((CRYPTO_JOBSTATE_IDLE == Crypto_eCurrentJobState) && ((boolean)FALSE == bHwIsBusy))
    {
        /* Copy the pointer to the job into Crypto_pJobInProgress, as the job can be asynchronous */
        Crypto_pJobInProgress = pJob;
        /* Mark the current command sent to CSE as being a job process request */
        Crypto_eCurrentJobState = CRYPTO_JOBSTATE_ACTIVE;
        
        switch (pJob->jobPrimitiveInfo->primitiveInfo->service)
        {
            case CRYPTO_MACGENERATE:
            {
                eOutResponse = Crypto_Ipw_MacGenerate (pJob);
            } break;
            case CRYPTO_MACVERIFY:
            {
                eOutResponse = Crypto_Ipw_MacVerify (pJob);
            } break;
            case CRYPTO_ENCRYPT:
            {
                eOutResponse = Crypto_Ipw_Encrypt (pJob);
            } break;
            case CRYPTO_DECRYPT:
            {
                eOutResponse = Crypto_Ipw_Decrypt (pJob);
            } break;
            case CRYPTO_RANDOMGENERATE:
            {
                eOutResponse = Crypto_Ipw_Random (pJob);
            } break;
            default:
            {
                /*Do nothing*/
            } break;
        }
        
        RetVal = Crypto_Ipw_VerifyCseResponse (eOutResponse);
        
        if(CRYPTO_PROCESSING_SYNC == pJob->jobPrimitiveInfo->processingType)
        {
            Crypto_eCurrentJobState = CRYPTO_JOBSTATE_IDLE;
        }
    }
    else 
    {
        /* No free Cse channel was found */
        RetVal = (Std_ReturnType)CRYPTO_E_BUSY;
    }
    return RetVal;
}
/*==================================================================================================
*                                       GLOBAL FUNCTIONS
==================================================================================================*/
/**
* @brief           Check HW is initialized or not. 
*                  Initialize the job queues.
*                  Set state to IDLE.
* @param[in]       none
* @param[out]      none 
* @returns         status
*
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_Init (void)
{
    VAR (Std_ReturnType, AUTOMATIC) eStatus = (Std_ReturnType)E_NOT_OK;

    eStatus = Crypto_Cse_CheckHwInit();

    if((Std_ReturnType)E_OK == eStatus)
    {
        Crypto_Ipw_InitJobQueues();
        Crypto_eCurrentJobState = CRYPTO_JOBSTATE_IDLE;
    }

    return eStatus;
}

/**
* @brief           Processes a job.
* @details         Tries to initiate a request to CSE to process a job. If CSE is busy and the job is async, it queues it.
*
* @param[in]       u32ObjectIdx    Ientifier of the Crypto Driver Object to be used for processing the job.
* @param[in]       pJob              Pointer to the job to be processed.
*
* @return          Result of the operation.
*                   Std_ReturnType
* @api
*
* @pre            Driver must be initialized.
*
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_ProcessJob
(
    VAR  (uint32, AUTOMATIC) u32ObjectIdx,
    P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob
)
{
    VAR (Std_ReturnType, AUTOMATIC) RetVal;

    if(CRYPTO_OPERATIONMODE_SINGLECALL == pJob->PrimitiveInputOutput.mode)
    {
        /*If Job is async and queue is empty, Job must be executed if current state is idle*/
        if(
            ( CRYPTO_PROCESSING_ASYNC == pJob->jobPrimitiveInfo->processingType ) && \
            ( CRYPTO_JOB_QUEUE_NONE_U32 != Crypto_aObjectList[u32ObjectIdx]->u32HeadOfQueuedJobs )
          )
        {
            /* Try to queue the job */
            if((boolean)TRUE == Crypto_Ipw_QueueJob(u32ObjectIdx, pJob))
            {
                /* Set return value to E_OK, as the async job has been queued successfully for later processing */
                RetVal = (Std_ReturnType)E_OK;
            }
            else
            {
                /* Job could not be queued as the CDO queue is full */
                RetVal = (Std_ReturnType)CRYPTO_E_QUEUE_FULL;
            }
        }
        else
        {
            /* Try to send the job for processing to CSE */
            RetVal = Crypto_Ipw_ProcessOperation(pJob);
            /* If there was no channel available to process the request, check the type of the request (sync or async) */
            if((Std_ReturnType)CRYPTO_E_BUSY == RetVal)
            {
                if  (
                       ( CRYPTO_PROCESSING_ASYNC == pJob->jobPrimitiveInfo->processingType ) && \
                       ( 0U != Crypto_aObjectList[u32ObjectIdx]->u32CryptoQueueSize )
                    )
                {
                    /* Check if the async job has the same jobId with the currently processed job (req SWS_Crypto_00121), and if yes, bypass it from queuing */
                    if(pJob->jobInfo->jobId == Crypto_pJobInProgress->jobInfo->jobId)
                    {
                         RetVal = (Std_ReturnType)E_NOT_OK;
                    }
                    else
                    {
                        /* Try to queue the job */
                        if((boolean)TRUE == Crypto_Ipw_QueueJob(u32ObjectIdx, pJob))
                        {
                            /* Set return value to E_OK, as the async job has been queued successfully for later processing */
                            RetVal = (Std_ReturnType)E_OK;
                        }
                        else
                        {
                            /* Job could not be queued as the CDO queue is full */
                            RetVal = (Std_ReturnType)CRYPTO_E_QUEUE_FULL;
                        }
                    }
                }
            }
        }
        
    }
    else
    {
        RetVal = (Std_ReturnType)E_NOT_OK;
    }
    return RetVal;
}

/**
* Verify the key ID matched with the configuration.
**/
FUNC(Crypto_VerifyKeyType, CRYPTO_CODE) Crypto_Ipw_VerifyKeyId (VAR(uint32, AUTOMATIC) u32keyId)
{
    VAR(Crypto_VerifyKeyType, AUTOMATIC) sVerifyKey = {(Std_ReturnType)E_NOT_OK, 0U};
    VAR(uint32, AUTOMATIC) u32Counter = 0U;
    
    sVerifyKey.eFound = (Std_ReturnType)E_NOT_OK;
    for ( u32Counter = 0U; ( ( u32Counter < CRYPTO_NUMBER_OF_KEYS ) &&  ( (Std_ReturnType)E_NOT_OK == sVerifyKey.eFound ) ); u32Counter++ )
    {
        if ( u32keyId == Crypto_aKeyList[u32Counter]->u32CryptoKeyId ) 
        {
            sVerifyKey.eFound = (Std_ReturnType)E_OK;
            sVerifyKey.u32Counter = u32Counter;
        }
    }
   
    return sVerifyKey;  
}

/**
* Verify the key element ID matched with the configuration.
**/
FUNC(Crypto_VerifyKeyElementType, CRYPTO_CODE) Crypto_Ipw_VerifyKeyElementId ( VAR(uint32, AUTOMATIC) u32KeyIndex, VAR(uint32, AUTOMATIC) u32keyElementId )
{
    VAR(Crypto_VerifyKeyElementType, AUTOMATIC) sVerifyKeyElement;
    
    VAR(uint32, AUTOMATIC) u32Counter = 0U;
    sVerifyKeyElement.eFound = (Std_ReturnType)E_NOT_OK;
    
    for ( u32Counter = 0U; ( ( u32Counter < Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32NoCryptoKeyElements ) && ( (Std_ReturnType)E_NOT_OK == sVerifyKeyElement.eFound ) ); u32Counter++ )
    {
        /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
        if ( u32keyElementId == Crypto_aKeyElementList[Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter]]->u32CryptoKeyElementId )
        {
            sVerifyKeyElement.eFound = (Std_ReturnType)E_OK;
            /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
            sVerifyKeyElement.u32Counter = Crypto_aKeyList[u32KeyIndex]->pCryptoKeyElementList->u32CryptoKeyElements[u32Counter];
        }
    }
     
    return sVerifyKeyElement;
}

/**
* send a request load Key in HW.
**/
FUNC (Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_LoadKey(VAR(uint32, AUTOMATIC) cryptoKeyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) pKeyPtr, VAR(uint32, AUTOMATIC) u32KeyLength)
{
    VAR (Crypto_Cse_ErrorCodeType, AUTOMATIC) eStatus = (Crypto_Cse_ErrorCodeType) CRYPTO_CSE_ERC_GENERAL_ERROR;  
    VAR (Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_NOT_OK;
    
    if((boolean)FALSE == Crypto_Cse_IsBusy())
    {
        if (cryptoKeyId == (uint32)CRYPTO_CSE_RAM_KEY)
        {
            /*Work around: use load plain key to test other functions*/
            eStatus = Crypto_Cse_PlainKey(pKeyPtr);
        }
        else
        {
            /* Load key to memory*/
            /** @violates @ref Crypto_Ipw_c_REF_5 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
            /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
            eStatus = Crypto_Cse_LoadKey((Crypto_Cse_KeyIdType)cryptoKeyId, pKeyPtr + CRYPTO_CSE_KE_SHE_M1_OFFSET, pKeyPtr + CRYPTO_CSE_KE_SHE_M2_OFFSET, pKeyPtr + CRYPTO_CSE_KE_SHE_M3_OFFSET);
        }
        
    }
    else
    {
        eStatus = (Crypto_Cse_ErrorCodeType) CRYPTO_CSE_ERC_BUSY;
    }
    
    eOutResponse = Crypto_Ipw_VerifyCseResponse (eStatus);
    
    (void)u32KeyLength;
    return eOutResponse;
}

/**
* Cancel a Job in process or job in queue.
**/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_CancelJob (VAR(uint32, AUTOMATIC) u32ObjectIdx, P2CONST(Crypto_JobInfoType, AUTOMATIC, CRYPTO_APPL_CONST) pJob)
{
    VAR (Std_ReturnType, AUTOMATIC) RetVal = (Std_ReturnType)E_NOT_OK;

    if( (CRYPTO_JOBSTATE_ACTIVE == Crypto_eCurrentJobState) && 
        (pJob->jobId == Crypto_pJobInProgress->jobInfo->jobId)  )
    {
        RetVal = Crypto_Cse_Cancel();

        if((Std_ReturnType) E_OK == RetVal)
        {
            RetVal = (Std_ReturnType)CRYPTO_E_JOB_CANCELED;
        }
    }
    else
    {
        /* Check the job queue of the CDO pointed by u32ObjectIdIdx to see if a job with the same jobId can be found */
        RetVal = Crypto_Ipw_DequeueJob(u32ObjectIdx, pJob);
    }

    return RetVal;
}

/**
* Send a request load entropy.
**/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_ExtendPrngSeed (P2CONST (uint8, AUTOMATIC, CRYPTO_APPL_CONST) entropy)
{
    VAR (Crypto_Cse_ErrorCodeType, AUTOMATIC) eStatus = (Crypto_Cse_ErrorCodeType) CRYPTO_CSE_ERC_GENERAL_ERROR; 
    VAR (Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_NOT_OK;

    if((boolean)FALSE == Crypto_Cse_IsBusy())
    {
        eStatus = Crypto_Cse_ExtendPrngSeed (entropy);
        eOutResponse = Crypto_Ipw_VerifyCseResponse (eStatus);
    }
    else
    {
        eOutResponse = CRYPTO_E_BUSY;
    }

    return eOutResponse;
}

/**
* Generate a Key and load it in RAM_KEY.
**/
/**
* @violates @ref Crypto_Ipw_c_REF_3 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_GenerateKeysRandom (VAR(uint32, AUTOMATIC) KeyId)
{
    VAR (Crypto_Cse_ErrorCodeType, AUTOMATIC) eStatus = (Crypto_Cse_ErrorCodeType) CRYPTO_CSE_ERC_GENERAL_ERROR; 
    VAR (Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_NOT_OK;
    static VAR(uint8, AUTOMATIC) rndPtr[CRYPTO_LENGTH_OF_ARRAY_16] = {(uint8)0}; 
    
    if((boolean)FALSE == Crypto_Cse_IsBusy())
    {
        if (KeyId == (uint32)CRYPTO_CSE_RAM_KEY)
        {
            eStatus = Crypto_Cse_InitRng();
            if (CRYPTO_CSE_ERC_NO_ERROR == eStatus)
            {
                eStatus = Crypto_Cse_GenerateRnd(rndPtr);
                if (CRYPTO_CSE_ERC_NO_ERROR == eStatus)
                {
                    eStatus = Crypto_Cse_PlainKey(rndPtr);
                }
            }
        }
    }
    else
    {
        eStatus = (Crypto_Cse_ErrorCodeType) CRYPTO_CSE_ERC_BUSY;
    }
    
    eOutResponse = Crypto_Ipw_VerifyCseResponse (eStatus);

    return eOutResponse;
}

/**
* Export RAM_KEY from RAM.
**/
/**
* @violates @ref Crypto_Ipw_c_REF_3 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Ipw_ExportRamKey (VAR(uint32, AUTOMATIC) cryptoKeyId, P2VAR(uint32, AUTOMATIC, CRYPTO_APPL_DATA) resultLengthPtr, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) resultPtr)
{
    VAR (Crypto_Cse_ErrorCodeType, AUTOMATIC) eStatus = (Crypto_Cse_ErrorCodeType) CRYPTO_CSE_ERC_GENERAL_ERROR; 
    VAR (Std_ReturnType, AUTOMATIC) eOutResponse = (Std_ReturnType)E_NOT_OK;
    
    if((boolean)FALSE == Crypto_Cse_IsBusy())
    {
        if (cryptoKeyId == (uint32)CRYPTO_CSE_RAM_KEY)
        {
            eStatus = Crypto_Cse_ExportRamKey(resultPtr);
        }
    }
    else
    {
        eStatus = (Crypto_Cse_ErrorCodeType) CRYPTO_CSE_ERC_BUSY;
    }
    
    eOutResponse = Crypto_Ipw_VerifyCseResponse (eStatus);

    (void)resultLengthPtr;
    
    return eOutResponse;
}

/**
* @brief           Main function
* @details         Main function - check for async jobs, then send jobs from the queue
*
* @param[in]       none
* @param[inout]    none
* @param[out]      none
* @returns         void
*
* @api
*
* @pre            
*                   
*/
FUNC(void, CRYPTO_CODE) Crypto_Ipw_MainFunction (void)
{
    P2CONST(Crypto_JobType, AUTOMATIC, CRYPTO_APPL_CONST) pJob;
    VAR(Std_ReturnType, AUTOMATIC) RetVal;
    VAR(uint32,AUTOMATIC) u32ObjectIdx = 0U;
    VAR(uint32,AUTOMATIC) u32HeadOfQueuedJobs;

    for (u32ObjectIdx = 0U; u32ObjectIdx < CRYPTO_NUMBER_OF_DRIVER_OBJECTS; ++u32ObjectIdx)
    {
        if(CRYPTO_JOB_QUEUE_NONE_U32 != Crypto_aObjectList[u32ObjectIdx]->u32HeadOfQueuedJobs)
        {
            break;
        }
    }
        u32HeadOfQueuedJobs = Crypto_aObjectList[u32ObjectIdx]->u32HeadOfQueuedJobs;
        /* Take the first job in the queue. The queue is already ordered by priority so the first job in queue has the highest priority */
        /** @violates @ref Crypto_Ipw_c_REF_4 Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer*/
        pJob = Crypto_aObjectList[u32ObjectIdx]->pQueuedJobs[u32HeadOfQueuedJobs].pJob;
        /* Try to send the job to CSE for processing */
        RetVal = Crypto_Ipw_ProcessOperation(pJob);

        if((Std_ReturnType)CRYPTO_E_BUSY != RetVal)
        {
            /* If return value is not CRYPTO_E_BUSY, it means that a free channel was found and the request was send to CSE
               Take the first queued job and put it back in the free jobs queue */
            Crypto_Ipw_DequeueHeadJob(u32ObjectIdx);
        }
}

/**
* @brief           CallBack Notification Function
* @details         CallBack Notification Function- Checks status and notify to the upper layer
*
* @param[in]       none
* @param[inout]    none
* @param[out]      none
* @returns         void
*
* @api
*
* @pre            
*                   
*/
FUNC(void, CRYPTO_CODE) Crypto_Ipw_CallBackNotification (VAR (Crypto_Cse_ErrorCodeType, AUTOMATIC) eOutResponse)
{
    VAR(Std_ReturnType, AUTOMATIC) RetVal      = (Std_ReturnType)E_NOT_OK;

    RetVal = Crypto_Ipw_VerifyCseResponse (eOutResponse);

    CryIf_CallbackNotification(Crypto_pJobInProgress, RetVal);

    Crypto_eCurrentJobState = CRYPTO_JOBSTATE_IDLE;
}
#define CRYPTO_STOP_SEC_CODE
/**
* @violates @ref Crypto_Ipw_c_REF_2 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Ipw_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"
#ifdef __cplusplus
}
#endif

/** @} */
