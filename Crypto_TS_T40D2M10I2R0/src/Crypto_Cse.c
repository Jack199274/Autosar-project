/**
*   @file    Crypto_Cse.c
*
*   @version 1.0.2
*   @brief   AUTOSAR Crypto - Cryptographic Services Engine (CSE) functions
*   @details Contains functions for accessing CSE from the Crypto driver perspective
*
*   @addtogroup  Ccrypto
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
* @section Crypto_Cse_c_REF_1
*          Violates MISRA 2004 Advisory Rule 19.1, #include statements in a file should only be preceded 
*          by other preprocessor directives or comments. AUTOSAR imposes the specification of the sections 
*          in which certain parts of the driver must be placed.
*
*
* @section Crypto_Cse_c_REF_3
*          Violates MISRA 2004 Required Rule 19.15, Precautions shall be taken in order to
*          prevent the contents of a header file being included twice. All header files are
*          protected against multiple inclusions.
*
* @section Crypto_Cse_c_REF_4
*          Violates MISRA 2004 Required Rule 8.10, could be made static The respective code could not be made 
*          static because of layers architecture design of the driver.
*
* @section Crypto_Cse_c_REF_5
*          Violates MISRA 2004 Required Rule 17.4, Array indexing shall be the only allowed form of pointer 
*          arithmetic. 
*          The violation occurs because the variables are defined as per Crypto Driver API specifications.
*
* @section Crypto_Cse_c_REF_6
*           Violates MISRA 2004 Required Rule 11.1, cast from unsigned long to pointer.
*           This violation is generated because conversions must not be performed between a pointer 
*           to a function and any type other than an integral type. The cast can't be avoided as it is 
*           used to access memory mapped registers.
*
* @section Crypto_Cse_c_REF_7
*           Violates MISRA 2004 Advisory Rule 11.3, A cast should not be performed between a pointer type and an 
*           integral type. The cast can't be avoided as it is used to access memory mapped registers.
*
* @section Crypto_Cse_c_REF_8
*           Violates MISRA 2004 Required Rule 10.1 , The value of an expression of integer type shall not be implicitly
*           converted to a different underlying type if: 
*               a) it is not aconversion to a wider integer type of the same signedness, 
*               b) the expression is complex,
*               c) the expression is not constant and is a function argument,
*               d) the expression is not constant and is a return expression.
*
** @section Crypto_Cse_c_REF_9
*           Violates MISRA 2004 Advisory Rule 12.6 , The operands of logical operators (&&, || and !) should be
*           effectively Boolean. Expressions that are effectively Boolean
*           should not be used as operands to operators other than (&&, ||, !, =, ==, != and ?:).
*
* @section Crypto_Cse_c_REF_10
*           Violates MISRA 2004 Required Rule 1.4, Identifier clash.
*           This violation is due to the requirement that request to have a file version check.
*
* @section Crypto_Cse_c_REF_11
*           Violates MISRA 2004 Required Rule 5.1, External identifiers shall be distinct.
*           The used compilers use more than 31 chars for identifiers.
*/


/*==================================================================================================
*                                        INCLUDE FILES
* 1) system and project includes
* 2) needed interfaces from external units
* 3) internal and external interfaces from this unit
==================================================================================================*/
/**
* @file           Crypto_Cse.c    
*/

#include "Crypto_CseTypes.h"
#include "Crypto_Cse.h"
#include "Crypto_Cfg.h"
#include "Reg_eSys_Cse.h"
#include "StdRegMacros.h"
#include "CryIf_Cbk.h"
#include "Crypto_Ipw.h"
#include "SchM_Crypto.h"

/*==================================================================================================
*                                       SOURCE FILE VERSION INFORMATION
==================================================================================================*/
/**
* @file           Crypto_Ipw.c
*/
#define CRYPTO_CSE_VENDOR_ID_C                     43
/**
* @violates @ref Crypto_Cse_c_REF_10 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_Cse_c_REF_11 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_CSE_AR_RELEASE_MAJOR_VERSION_C      4
/**
* @violates @ref Crypto_Cse_c_REF_10 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_Cse_c_REF_11 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_CSE_AR_RELEASE_MINOR_VERSION_C      3
/**
* @violates @ref Crypto_Cse_c_REF_10 Violates MISRA 2004 Required Rule 1.4,  Identifier clash
*/
/**
* @violates @ref Crypto_Cse_c_REF_11 Violates MISRA 2012 Required Rule 5.1, External identifiers shall be distinct.
*/
#define CRYPTO_CSE_AR_RELEASE_REVISION_VERSION_C   1
#define CRYPTO_CSE_SW_MAJOR_VERSION_C              1
#define CRYPTO_CSE_SW_MINOR_VERSION_C              0
#define CRYPTO_CSE_SW_PATCH_VERSION_C              2
/*==================================================================================================
*                                      FILE VERSION CHECKS
==================================================================================================*/

/* Check if Crypto cse source file and Crypto Cse header file are of the same vendor */
#if (CRYPTO_CSE_VENDOR_ID_C != CRYPTO_CSE_H_VENDOR_ID)
#error "Crypto_Cse.c and Crypto_Cse.h have different vendor ids"
#endif

/* Check if Crypto cse source file and Crypto Cse header file are of the same Autosar version */
#if ((CRYPTO_CSE_AR_RELEASE_MAJOR_VERSION_C != CRYPTO_CSE_H_AR_RELEASE_MAJOR_VERSION) || \
     (CRYPTO_CSE_AR_RELEASE_MINOR_VERSION_C != CRYPTO_CSE_H_AR_RELEASE_MINOR_VERSION) || \
     (CRYPTO_CSE_AR_RELEASE_REVISION_VERSION_C != CRYPTO_CSE_H_AR_RELEASE_REVISION_VERSION) \
    )
#error "AutoSar Version Numbers of Crypto_Cse.c and Crypto_Cse.h are different"
#endif

/* Check if Crypto cse source file and Crypto Cse header file are of the same Software version */
#if ((CRYPTO_CSE_SW_MAJOR_VERSION_C != CRYPTO_CSE_H_SW_MAJOR_VERSION) || \
     (CRYPTO_CSE_SW_MINOR_VERSION_C != CRYPTO_CSE_H_SW_MINOR_VERSION) || \
     (CRYPTO_CSE_SW_PATCH_VERSION_C != CRYPTO_CSE_H_SW_PATCH_VERSION) \
    )
#error "Software Version Numbers of Crypto_Cse.c and Crypto_Cse.h are different"
#endif

/* Check if Crypto cse source file and Crypto CseTypes header file are of the same vendor */
#if (CRYPTO_CSE_VENDOR_ID_C != CRYPTO_CSETYPES_H_VENDOR_ID)
#error "Crypto_Cse.c and Crypto_CseTypes.h have different vendor ids"
#endif

/* Check if Crypto cse source file and Crypto CseTypes header file are of the same Autosar version */
#if ((CRYPTO_CSE_AR_RELEASE_MAJOR_VERSION_C != CRYPTO_CSETYPES_H_AR_RELEASE_MAJOR_VERSION) || \
     (CRYPTO_CSE_AR_RELEASE_MINOR_VERSION_C != CRYPTO_CSETYPES_H_AR_RELEASE_MINOR_VERSION) || \
     (CRYPTO_CSE_AR_RELEASE_REVISION_VERSION_C != CRYPTO_CSETYPES_H_AR_RELEASE_REVISION_VERSION) \
    )
#error "AutoSar Version Numbers of Crypto_Cse.c and Crypto_CseTypes.h are different"
#endif

/* Check if Crypto cse source file and Crypto CseTypes header file are of the same Software version */
#if ((CRYPTO_CSE_SW_MAJOR_VERSION_C != CRYPTO_CSETYPES_H_SW_MAJOR_VERSION) || \
     (CRYPTO_CSE_SW_MINOR_VERSION_C != CRYPTO_CSETYPES_H_SW_MINOR_VERSION) || \
     (CRYPTO_CSE_SW_PATCH_VERSION_C != CRYPTO_CSETYPES_H_SW_PATCH_VERSION) \
    )
#error "Software Version Numbers of Crypto_Cse.c and Crypto_CseTypes.h are different"
#endif

/* Check if Crypto cse source file and Crypto Cfg header file are of the same vendor */
#if (CRYPTO_CSE_VENDOR_ID_C != CRYPTO_VENDOR_ID_CFG)
#error "Crypto_Cse.c and Crypto_Cfg.h have different vendor ids"
#endif

/* Check if Crypto cse source file and Crypto Cfg header file are of the same Autosar version */
#if ((CRYPTO_CSE_AR_RELEASE_MAJOR_VERSION_C != CRYPTO_AR_RELEASE_MAJOR_VERSION_CFG) || \
     (CRYPTO_CSE_AR_RELEASE_MINOR_VERSION_C != CRYPTO_AR_RELEASE_MINOR_VERSION_CFG) || \
     (CRYPTO_CSE_AR_RELEASE_REVISION_VERSION_C != CRYPTO_AR_RELEASE_REVISION_VERSION_CFG) \
    )
#error "AutoSar Version Numbers of Crypto_Cse.c and Crypto_Cfg.h are different"
#endif

/* Check if Crypto cse source file and Crypto Cfg header file are of the same Software version */
#if ((CRYPTO_CSE_SW_MAJOR_VERSION_C != CRYPTO_SW_MAJOR_VERSION_CFG) || \
     (CRYPTO_CSE_SW_MINOR_VERSION_C != CRYPTO_SW_MINOR_VERSION_CFG) || \
     (CRYPTO_CSE_SW_PATCH_VERSION_C != CRYPTO_SW_PATCH_VERSION_CFG) \
    )
#error "Software Version Numbers of Crypto_Cse.c and Crypto_Cfg.h are different"
#endif

/* Check if Crypto cse source file and Reg_eSys_Cse header file are of the same vendor */
#if (CRYPTO_CSE_VENDOR_ID_C != REG_ESYS_CSE_VENDOR_ID)
#error "Crypto_Cse.c and Reg_eSys_Cse.h have different vendor ids"
#endif

/* Check if Crypto cse source file and Reg_eSys_Cse header file are of the same Autosar version */
#if ((CRYPTO_CSE_AR_RELEASE_MAJOR_VERSION_C != REG_ESYS_CSE_AR_RELEASE_MAJOR_VERSION) || \
     (CRYPTO_CSE_AR_RELEASE_MINOR_VERSION_C != REG_ESYS_CSE_AR_RELEASE_MINOR_VERSION) || \
     (CRYPTO_CSE_AR_RELEASE_REVISION_VERSION_C != REG_ESYS_CSE_AR_RELEASE_REVISION_VERSION) \
    )
#error "AutoSar Version Numbers of Crypto_Cse.c and Reg_eSys_Cse.h are different"
#endif

/* Check if Crypto cse source file and Reg_eSys_Cse header file are of the same Software version */
#if ((CRYPTO_CSE_SW_MAJOR_VERSION_C != REG_ESYS_CSE_SW_MAJOR_VERSION) || \
     (CRYPTO_CSE_SW_MINOR_VERSION_C != REG_ESYS_CSE_SW_MINOR_VERSION) || \
     (CRYPTO_CSE_SW_PATCH_VERSION_C != REG_ESYS_CSE_SW_PATCH_VERSION) \
    )
#error "Software Version Numbers of Crypto_Cse.c and Reg_eSys_Cse.h are different"
#endif

/* Check if Crypto cse source file and StdRegMacros header file are of the same vendor */
#if (CRYPTO_CSE_VENDOR_ID_C != STDREGMACROS_VENDOR_ID)
#error "Crypto_Cse.c and StdRegMacros.h have different vendor ids"
#endif

/* Check if Crypto cse source file and StdRegMacros header file are of the same Autosar version */
#if ((CRYPTO_CSE_AR_RELEASE_MAJOR_VERSION_C != STDREGMACROS_AR_RELEASE_MAJOR_VERSION) || \
     (CRYPTO_CSE_AR_RELEASE_MINOR_VERSION_C != STDREGMACROS_AR_RELEASE_MINOR_VERSION) || \
     (CRYPTO_CSE_AR_RELEASE_REVISION_VERSION_C != STDREGMACROS_AR_RELEASE_REVISION_VERSION) \
    )
#error "AutoSar Version Numbers of Crypto_Cse.c and StdRegMacros.h are different"
#endif

/* Check if Crypto cse source file and StdRegMacros header file are of the same Software version */
#if ((CRYPTO_CSE_SW_MAJOR_VERSION_C != STDREGMACROS_SW_MAJOR_VERSION) || \
     (CRYPTO_CSE_SW_MINOR_VERSION_C != STDREGMACROS_SW_MINOR_VERSION) || \
     (CRYPTO_CSE_SW_PATCH_VERSION_C != STDREGMACROS_SW_PATCH_VERSION) \
    )
#error "Software Version Numbers of Crypto_Cse.c and StdRegMacros.h are different"
#endif

/* Check if Crypto cse source file and CryIf_Cbk header file are of the same vendor */
#if (CRYPTO_CSE_VENDOR_ID_C != CRYIF_CBK_VENDOR_ID)
#error "Crypto_Cse.c and CryIf_Cbk.h have different vendor ids"
#endif

/* Check if Crypto cse source file and CryIf_Cbk header file are of the same Autosar version */
#if ((CRYPTO_CSE_AR_RELEASE_MAJOR_VERSION_C != CRYIF_CBK_AR_RELEASE_MAJOR_VERSION) || \
     (CRYPTO_CSE_AR_RELEASE_MINOR_VERSION_C != CRYIF_CBK_AR_RELEASE_MINOR_VERSION) || \
     (CRYPTO_CSE_AR_RELEASE_REVISION_VERSION_C != CRYIF_CBK_AR_RELEASE_REVISION_VERSION) \
    )
#error "AutoSar Version Numbers of Crypto_Cse.c and CryIf_Cbk.h are different"
#endif

/* Check if Crypto cse source file and CryIf_Cbk header file are of the same Software version */
#if ((CRYPTO_CSE_SW_MAJOR_VERSION_C != CRYIF_CBK_SW_MAJOR_VERSION) || \
     (CRYPTO_CSE_SW_MINOR_VERSION_C != CRYIF_CBK_SW_MINOR_VERSION) || \
     (CRYPTO_CSE_SW_PATCH_VERSION_C != CRYIF_CBK_SW_PATCH_VERSION) \
    )
#error "Software Version Numbers of Crypto_Cse.c and CryIf_Cbk.h are different"
#endif
/*==================================================================================================
*                          LOCAL TYPEDEFS (STRUCTURES, UNIONS, ENUMS)
==================================================================================================*/

/*==================================================================================================
*                                       LOCAL MACROS
==================================================================================================*/
/* Represents the maximum number of bytes accepted for data to be encrypted/decrypted (MAX = 65 535 (pages) * 16 (bytes per page) = 1048560) */
#define CRYPTO_MAXU32LENGTH_U32                         ((uint32)1048560U)
/* Represents the number of CRYPTO_CSE_PRAM pages available for data (excluding the first page, used for command header) */
#define CRYPTO_ALL_AVAILABLE_PRAM_PAGES_U16             ((uint16)7U)
/* Represents the number of CRYPTO_CSE_PRAM pages available for data in CBC for the first iteration 
(excluding the first page, used for command header and the second page used for IV) */
#define CRYPTO_AVAILABLE_PRAM_PAGES_FOR_CBC_U16         ((uint16)6U)
/* Represents the number of bytes in CRYPTO_CSE_PRAM available for data (excluding the
first page, used for command header) */
#define CRYPTO_DATA_BYTES_AVAILABLE_U8                  ((uint8)112U)
/* Represents the number of bytes in CRYPTO_CSE_PRAM available for data in CBC for the first iteration 
(excluding the first page and second page, used for command header and IV) */
#define CRYPTO_DATA_BYTES_AVAILABLE_CBC_U8              ((uint8)96U)
/* Represents one page of PRAM */
#define CRYPTO_ONE_PAGE_U16                             ((uint16)1U)
/* Represents the size  of a CRYPTO_CSE_PRAM page in bytes */
#define CRYPTO_BYTES_ONE_PAGE_U8                        ((uint8)16U)
/* Represents the size of a CRYPTO_CSE_PRAM page in bits */
#define CRYPTO_BITS_ONE_PAGE_U32                        ((uint32)128U)                  
/* Represents the size in bytes of the UID */
#define CRYPTO_UID_SIZE_IN_BYTES_U8                     ((uint8)15U)
/* Represents the correct verification status for the verify MAC functions - VERIFICATION_STATUS = (0 ~= ( MACcalc - MACref )) */
#define CRYPTO_CORRECT_VERIFICATION_STATUS              ((uint16)0x0000U)

/* Represents the size in pages of the M1 entry (used for key management) */
#define CRYPTO_M1_SIZE_IN_PAGES_U16                     ((uint16)1U)
/* Represents the size in pages of the M2 entry (used for key management) */
#define CRYPTO_M2_SIZE_IN_PAGES_U16                     ((uint16)2U)
/* Represents the size in pages of the M3 entry (used for key management) */
#define CRYPTO_M3_SIZE_IN_PAGES_U16                     ((uint16)1U)
/* Represents the size in pages of the M4 entry (used for key management) */
#define CRYPTO_M4_SIZE_IN_PAGES_U16                     ((uint16)2U)
/* Represents the size in pages of the M5 entry (used for key management) */
#define CRYPTO_M5_SIZE_IN_PAGES_U16                     ((uint16)1U)

/* Represents the size of a word (4 bytes) */
#define CRYPTO_WORD_LEN_U8                              ((uint8)4U)
/* Represents the position of the last byte in a word */
#define CRYPTO_LAST_BYTE_IN_A_WORD_U8                   ((uint8)3U)
/* Represents the position of the second byte in a word */
#define CRYPTO_SECOND_BYTE_IN_A_WORD_U32                ((uint32)1U)
/* Represents the position of the third byte in a word */
#define CRYPTO_THIRD_BYTE_IN_A_WORD_U32                 ((uint32)2U)
/* Represents the position of the second byte in a word */
#define CRYPTO_FOURTH_BYTE_IN_A_WORD_U32                ((uint32)3U)
/* Mask for word's least significat byte */
#define CRYPTO_WORD_LSB_MASK_U32                        ((uint32)0x000000FFU)

/* Represents the maximum remainder when a number is divided by 8 */
#define CRYPTO_MAX_REMAINDER_DIV_8_U32                  ((uint32)7U)
/* Represents the maximum remainder when a number is divided by 8 */
#define CRYPTO_MAX_REMAINDER_DIV_128_U8                 ((uint8)127U)
/* Represents the exponent of 2 power 7 = 128 (used for shifting operations) */
#define CRYPTO_BITS_ONE_PAGE_EXPONENT_U8                ((uint8)7U)
/* Represents the exponent of 2 power 4 = 16 (used for shifting operations) */
#define CRYPTO_BYTES_ONE_PAGE_EXPONENT_U8               ((uint8)4U)
/* Represents the exponent of 2 power 3 = 8 (used for shifting operations) */
#define CRYPTO_BITS_ONE_BYTE_EXPONENT_U8                ((uint8)3U)

/* Represents the number of bits on which the shifting is done */
#define CRYPTO_SHIFT_24_BIT_POSITIONS_U8                ((uint8)24U)
#define CRYPTO_SHIFT_16_BIT_POSITIONS_U8                ((uint8)16U)
#define CRYPTO_SHIFT_8_BIT_POSITIONS_U8                 ((uint8)8U)


/*==================================================================================================
*                                      LOCAL CONSTANTS
==================================================================================================*/


/*==================================================================================================
*                                      LOCAL VARIABLES
==================================================================================================*/
#define CRYPTO_START_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"


/**
* @brief          This variable holds the state of the driver.
* @details        This variable holds the state of the driver. After reset is UNINIT.
*                 CRYPTO_CSE_UNINIT = The CRYPTO CSE controller is not initialized. All registers belonging to the CRYPTO CSE are in reset state.
*
*/

static VAR(Crypto_Cse_InitStatusType, CRYPTO_VAR) Crypto_Cse_eDriverStatus = CRYPTO_CSE_UNINIT;

#define CRYPTO_STOP_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

#define CRYPTO_START_SEC_VAR_NO_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

static VAR(Crypto_Cse_InitStateType, AUTOMATIC) Crypto_Cse_InitState;

#define CRYPTO_STOP_SEC_VAR_NO_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

#define CRYPTO_START_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

static VAR(boolean, CRYPTO_VAR) Crypto_bCseFirstCall = (boolean)TRUE;
static VAR(boolean, CRYPTO_VAR) Crypto_bIsAsyncFunc = (boolean)FALSE;
static VAR(Crypto_Cse_StateType, CRYPTO_VAR) Crypto_Cse_eState = CRYPTO_CSE_IDLE;

#define CRYPTO_STOP_SEC_VAR_INIT_UNSPECIFIED
/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"
/*==================================================================================================
*                                      GLOBAL CONSTANTS
==================================================================================================*/

/*==================================================================================================
*                                      GLOBAL VARIABLES
==================================================================================================*/

/*==================================================================================================
*                                   LOCAL FUNCTION PROTOTYPES
==================================================================================================*/
#define CRYPTO_START_SEC_CODE

/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

/**
* @brief        Reads the MAC status    
* @details      This function reads the MAC status after succesfully running the command VerifyMac (pointer or buffer method)
*
* @param[in]    pStatus              A pointer to a memory location where the verification status will be copied to
* @param[in]    eResponse            The response received after triggering the command VerifyMac
* @param[out]   none                                 
*
* @return       none  
*                                               
*                   
* @pre          The verify MAC function should be triggered first
*/
static FUNC(void, CRYPTO_CODE) Crypto_Cse_ReadMacStatus (P2VAR(Crypto_VerifyResultType, AUTOMATIC, CRYPTO_APPL_DATA) pStatus, VAR(Crypto_Cse_ErrorCodeType, AUTOMATIC) eResponse);

/**
* @brief        Populates and triggers a particular command      
* @details      This function populates and triggers a command (given by cmd) using the CRYPTO_CSE_FUNC_FORMAT_COPY format.
*
* @param[in]    eCmd                The command to be triggered
* @param[in]    bIsFirstCmdCall     Call sequence
* @param[in]    eKeyID              Key ID
* @param[out]   none                             
*
* @return       eOutResponse        Response returned by CSE 
*                                           
*                   
* @pre          Driver must be initialized.
*
* @note         It should be used only for functions needing CRYPTO_CSE_FUNC_FORMAT_COPY as format
*/
LOCAL_INLINE FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_PopulateCommandHeader ( VAR(Crypto_Cse_CmdType, AUTOMATIC) eCmd,  VAR(boolean, AUTOMATIC) bIsFirstCmdCall, VAR(Crypto_Cse_KeyIdType, AUTOMATIC) eKeyId );

/**
* @brief        Writes the mac reference pointer to PRAM      
* @details      This function writes the mac reference pointer to PRAM for the function Cse_VerifyMac
*
* @param[in]    u32PagesToWrite       Number of pages of data that are still needed to be written
* @param[in]    u8PageIdx             Page index number 
* @param[in]    pMacRefPtr            Mac reference pointer
* @param[out]   none                              
*
* @return       bRefMacWritten        Boolean value to indicate if the MacReferencePointer has been written to PRAM  
*                                           
*                   
* @pre          Driver must be initialized.
*
*/
LOCAL_INLINE FUNC(boolean, CRYPTO_CODE) Crypto_Cse_WriteMacRefPointer (VAR(uint32, AUTOMATIC) u32PagesToWrite, VAR(uint8, AUTOMATIC) u8PageIdx, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) pMacRefPtr);
 

/**
* @brief        Performs AES-128 decryption and encryption in ECB mode.     
* @details      This function performs the AES-128 decryption and encryption in ECB mode of the input data buffer.
*               It operates under the assumption that the input data length is a multiple of 16 bytes.
*
* @param[in]    none               
* @param[out]   none       
*                                   
*
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_CseStartEnDeEcb(void);
 
/**
* @brief        The CCIE bit controls interrupt generation when an FTFC command completes.
* @details      This function enable or disable the CCIE bit.
*
* @param[in]    enable  
* @param[out]   none  
*
* @return       none 
*               
*                
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*   
*   
*/
LOCAL_INLINE FUNC (void, CRYPTO_CODE) Crypto_CseEnableInterrupt(VAR(boolean, AUTOMATIC) enable);
 
/**
* @brief        Performs AES-128 decryption and encryption in ECB mode.     
* @details      This function performs the AES-128 decryption and encryption in ECB mode of the input data buffer.
*               It operates under the assumption that the input data length is a multiple of 16 bytes.
*
* @param[in]    none               
* @param[out]   none       
*                                   
*
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_CseContinueEncDecECBCmd(void);

/**
* @brief        Initialized keyID, in_Data, Num_Pages, out_Data and command.      
* @details      This function initialized keyID, in_Data, Num_Pages, out_Data and command for command execution.
*
* @param[in]    keyId                  Key ID
* @param[in]    in_Data                Pointer to the input data buffer to execute the command 
* @param[in]    Num_Pages              Number of bytes of input data message
* @param[in]    Cse_Cmd                Cse command
* @param[out]   out_Data               Pointer to the output data buffer
*
* @return       none  
*                                           
*                   
* @pre          Driver must be initialized.
*
* @note         
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Cse_Init_state(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) in_Data,
                                      VAR(uint32, AUTOMATIC) Num_Pages, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) out_Data, 
                                      VAR(Crypto_Cse_CmdType, AUTOMATIC) Cse_Cmd
                                      );
                                      
 /**
* @brief        Performs AES-128 decryption and encryption in CBC mode.     
* @details      This function performs the AES-128 decryption and encryption in CBC mode of the input data buffer.
*               It operates under the assumption that the input data length is a multiple of 16 bytes.
*
* @param[in]    none               
* @param[out]   none       
*                                   
*
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_CseStartEnDeCbc(void);

/**
* @brief        Performs AES-128 decryption and encryption in CBC mode.     
* @details      This function performs the AES-128 decryption and encryption in CBC mode of the input data buffer.
*               It operates under the assumption that the input data length is a multiple of 16 bytes.
*
* @param[in]    none               
* @param[out]   none       
*                                   
*
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_CseContinueEncDecCBCCmd(void);

 /**
* @brief        Calculates the MAC of a given message using CMAC with AES-128.     
* @details      This function calculates the MAC of a given message based on CMAC with the 128-bit Advanced Encryption Standard. 
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    none  
* @param[out]   none  
*
* @return       none 
*               
*                
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*   
*   
*/
LOCAL_INLINE FUNC (void, CRYPTO_CODE) Crypto_CseStartGenMacCmd(void);

/**
* @brief        Calculates the MAC of a given message using CMAC with AES-128.     
* @details      This function calculates the MAC of a given message based on CMAC with the 128-bit Advanced Encryption Standard. 
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    none  
* @param[out]   none  
*
* @return       none 
*               
*                
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*   
*   
*/
LOCAL_INLINE FUNC (void, CRYPTO_CODE) Crypto_CseContinueGenMacCmd(void);

/**
* @brief        Calculates the MAC of a given message using CMAC with AES-128.     
* @details      This function verifies the MAC of of a given message based on CMAC with the 128-bit Advanced Encryption Standard.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes. 
*
* @param[in]    none
* @param[out]   none
*
* @return       none           
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
LOCAL_INLINE FUNC (void, CRYPTO_CODE) Crypto_CseStartVerMacCmd(void);

/**
* @brief        Calculates the MAC of a given message using CMAC with AES-128.     
* @details      This function verifies the MAC of of a given message based on CMAC with the 128-bit Advanced Encryption Standard.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes. 
*
* @param[in]    none
* @param[out]   none
*
* @return       none           
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
LOCAL_INLINE FUNC (void, CRYPTO_CODE) Crypto_CseContinueVerMacCmd(void);

#define CRYPTO_STOP_SEC_CODE

/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

#define CRYPTO_START_SEC_RAMCODE

/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"
/**
* @brief        Copies data from a buffer to PRAM     
* @details      This function copies the (noPages * 16) bytes from a buffer to a particular 
                location from PRAM.
*
* @param[in]    aText                  A buffer from where the data will be copied
* @param[in]    u32Location            The start of a page from PRAM
* @param[in]    u16NoPages             Number of pages to be copied (max 7)
* @param[out]   none                                 
*
* @return       none  
*                                               
*                   
* @pre          Driver must be initialized.
*
*
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_Cse_WritePagesToPRAM (CONST (uint8, AUTOMATIC) aText[], VAR(uint32, AUTOMATIC) u32Location, VAR(uint16, AUTOMATIC) u16NoPages);

/**
* @brief        Copies data from PRAM to a buffer     
* @details      This function copies the (u16NoPages * 16) bytes from a location in PRAM to a buffer
*
* @param[in]    aText                  A buffer where the data will be copied to
* @param[in]    u32Location            The start of a page from PRAM
* @param[in]    u16NoPages             Number of pages to be copied (max 7)
* @param[out]   none                                 
*
* @return       none  
*                                            
*                   
* @pre          Driver must be initialized.
*
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_Cse_ReadPagesFromPRAM (VAR(uint8, AUTOMATIC) aText[], VAR(uint32, AUTOMATIC) u32Location, VAR(uint16, AUTOMATIC) u16NoPages);


/**
* @brief        Populates the command header      
* @details      This function populates bytes 0 - 3 of the command header from PAGE0 of PRAM, waits for the CRYPTO_CSE_FCSESTAT_BSY flag
*
* @param[in]    eCmd                     FuncID
* @param[in]    eFuncFormat              Function format
* @param[in]    eCallSeq                 Call sequence
* @param[in]    eKeyID                   Key ID
* @param[out]   none               
*
* @return       Crypto_ErrorType  Error Code after command execution. Output parameter is valid if 
*               the error code is CRYPTO_CSE_ERC_NO_ERROR.    
*                                              
*                   
* @pre          Driver must be initialized; all the other required fields of PRAM for the particular command must be populated.
*
*/
LOCAL_INLINE FUNC (Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_SendCommand ( VAR(Crypto_Cse_CmdType, AUTOMATIC) eCmd, VAR(Crypto_Cse_FuncFormatType, AUTOMATIC) eFuncFormat,
                                                                        VAR(Crypto_Cse_CallSequenceType, AUTOMATIC) eCallSeq, VAR(Crypto_Cse_KeyIdType, AUTOMATIC) eKeyID
                                                                       );

/**
* @brief        Clears the error flags      
* @details      This function clears ACCERR and FPVIOL flags before entering any CSE operation
*
* @param[in]    none
* @param[out]   none                                 
*
* @return       none  
*                                              
*                   
* @pre          none
*
*/                              
LOCAL_INLINE FUNC (void, CRYPTO_CODE) Crypto_Cse_ClearErrorFlags (void);  

/**
* @brief        Wait command complete
* @details      This function wait a command.
* @param[in]    none
* @param[out]   none
* @return       Cse_ErrorCodeType  
*/
LOCAL_INLINE FUNC (Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_WaitCommandComplete(void);                        

#define CRYPTO_STOP_SEC_RAMCODE

/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

/*==================================================================================================
*                                      LOCAL FUNCTIONS
==================================================================================================*/

#define CRYPTO_START_SEC_CODE

/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

/**
* @brief        Populates and triggers a particular command      
* @details      This function populates and triggers a command (given by cmd) using the CRYPTO_CSE_FUNC_FORMAT_COPY format.
*
* @param[in]    eCmd                The command to be triggered
* @param[in]    bIsFirstCmdCall     Call sequence
* @param[in]    eKeyID              Key ID
* @param[out]   none                              
*
* @return       eOutResponse        Response returned by CSE  
*                                           
*                   
* @pre          Driver must be initialized.
*
* @note         It should be used only for functions needing CRYPTO_CSE_FUNC_FORMAT_COPY as format
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_PopulateCommandHeader (VAR(Crypto_Cse_CmdType, AUTOMATIC) eCmd,  VAR(boolean, AUTOMATIC) bIsFirstCmdCall, VAR(Crypto_Cse_KeyIdType, AUTOMATIC) eKeyId)
{
    VAR(Crypto_Cse_ErrorCodeType, AUTOMATIC) eOutResponse = CRYPTO_CSE_ERC_GENERAL_ERROR;

    if (Crypto_Cse_eState != CRYPTO_CSE_IDLE)
    {
        if ( (boolean)TRUE == bIsFirstCmdCall )
        {
            /* write command header to CRYPTO_CSE_PRAM, wait for the completion of the command, read and process error code */
            eOutResponse = Crypto_Cse_SendCommand(eCmd, CRYPTO_CSE_FUNC_FORMAT_COPY, CRYPTO_CSE_CALL_SEQ_FIRST, eKeyId);
        }
        else
        {
            /* write CallSeq field (== CALL_SEQ_SEQENT) to CRYPTO_CSE_PRAM command header */
            eOutResponse = Crypto_Cse_SendCommand(eCmd, CRYPTO_CSE_FUNC_FORMAT_COPY, CRYPTO_CSE_CALL_SEQ_SEQUENT, eKeyId);
        }
    }
    else
    {
        eOutResponse = CRYPTO_CSE_ERC_CANCELED;
    }
    
    return eOutResponse;
}


/**
* @brief        Writes the mac reference pointer to PRAM      
* @details      This function writes the mac reference pointer to PRAM for the function Cse_VerifyMac
*
* @param[in]    u32PagesToWrite       Number of pages of data that are still needed to be written
* @param[in]    u8PageIdx             Page index number 
* @param[in]    pMacRefPtr            Mac reference pointer
* @param[out]   none                              
*
* @return       bRefMacWritten     Boolean value to indicate if the MacReferencePointer has been written to PRAM  
*                                           
*                   
* @pre          Driver must be initialized.
*
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(boolean, CRYPTO_CODE) Crypto_Cse_WriteMacRefPointer (VAR(uint32, AUTOMATIC) u32PagesToWrite, VAR(uint8, AUTOMATIC) u8PageIdx, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) pMacRefPtr)
{
    VAR(boolean, AUTOMATIC) bRefMacWritten = (boolean)FALSE;
   
    if ( ( 0U == u32PagesToWrite ) && ( CRYPTO_ALL_AVAILABLE_PRAM_PAGES_U16 != u8PageIdx ) ) 
    {
        Crypto_Cse_WritePagesToPRAM (pMacRefPtr, CRYPTO_PRAM_PAGE1_ADDR32 + ((uint32)CRYPTO_BYTES_ONE_PAGE_U8 * u8PageIdx), CRYPTO_ONE_PAGE_U16);             
        bRefMacWritten = (boolean)TRUE;
    }
    
    return bRefMacWritten;
}

#define CRYPTO_STOP_SEC_CODE
/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"
#define CRYPTO_START_SEC_RAMCODE
/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"
/**
* @brief        Copies data from a buffer to PRAM     
* @details      This function copies the (u16NoPages * 16) bytes from a buffer to a particular 
                location from PRAM.
*
* @param[in]    aText                  A buffer from where the data will be copied
* @param[in]    u32Location            The start of a page from PRAM
* @param[in]    u16NoPages             Number of pages to be copied (max 7)
* @param[out]   none                                 
*
* @return       none  
*                                               
*                   
* @pre          Driver must be initialized.
*
*
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_Cse_WritePagesToPRAM (CONST (uint8, AUTOMATIC) aText[], VAR(uint32, AUTOMATIC) u32Location, VAR(uint16, AUTOMATIC) u16NoPages)
{
    VAR(uint8, AUTOMATIC) u8PageIdx = 0U;
    VAR(uint8, AUTOMATIC) u8WordIdx = 0U;
    VAR(uint32, AUTOMATIC) u32Value = 0U;
    VAR(uint32, AUTOMATIC) u32IndexLocation = 0U;
    
    /* copy max 7 pages of text from textPtr to CRYPTO_CSE_PRAM, reversing endianess - application - little endian, hardware - big endian */     
    for ( u8PageIdx = 0U; u8PageIdx < u16NoPages; u8PageIdx++ )
    {
        /* 16 bytes per page */
        u32IndexLocation = ((uint32)u8PageIdx << CRYPTO_BYTES_ONE_PAGE_EXPONENT_U8);
        for ( u8WordIdx = 0U; CRYPTO_BYTES_ONE_PAGE_U8 > u8WordIdx; u8WordIdx = u8WordIdx + CRYPTO_WORD_LEN_U8 )
        {
            u32Value = ((uint32)((aText[u32IndexLocation])) << CRYPTO_SHIFT_24_BIT_POSITIONS_U8) + \
                       ((uint32)((aText[u32IndexLocation + CRYPTO_SECOND_BYTE_IN_A_WORD_U32])) << CRYPTO_SHIFT_16_BIT_POSITIONS_U8) + \
                       ((uint32)((aText[u32IndexLocation + CRYPTO_THIRD_BYTE_IN_A_WORD_U32])) << CRYPTO_SHIFT_8_BIT_POSITIONS_U8) + \
                       (uint32)((aText[u32IndexLocation + CRYPTO_FOURTH_BYTE_IN_A_WORD_U32]));
            /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
            /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
            REG_WRITE32((u32Location + u32IndexLocation), u32Value);
            u32IndexLocation = u32IndexLocation + (uint32)CRYPTO_WORD_LEN_U8;
        }
    }
}


/**
* @brief        Copies data from PRAM to a buffer     
* @details      This function copies the (u16NoPages * 16) bytes from a location in PRAM to a buffer
*
* @param[in]    aText                  A buffer where the data will be copied to
* @param[in]    u32Location            The start of a page from PRAM
* @param[in]    u16NoPages             Number of pages to be copied (max 7)
* @param[out]   none                                 
*
* @return       none  
*                                           
*                   
* @pre          Driver must be initialized.
*
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_Cse_ReadPagesFromPRAM (VAR(uint8, AUTOMATIC) aText[], VAR(uint32, AUTOMATIC) u32Location, VAR(uint16, AUTOMATIC) u16NoPages)
{   
    VAR(uint8, AUTOMATIC) u8PageIdx = 0U;
    VAR(uint8, AUTOMATIC) u8WordIdx = 0U;
    VAR(uint32, AUTOMATIC) u32PRAMLocation = 0U;
    VAR(uint32, AUTOMATIC) u32Index = 0U;
    VAR(uint32, AUTOMATIC) u32CurrentWord = 0U;
    
    /* copy pages (max 7) from CRYPTO_CSE_PRAM to textPtr, reversing endianess */
    for ( u8PageIdx = 0U; u8PageIdx < u16NoPages; u8PageIdx++ )
    {
        for ( u8WordIdx = 0U; CRYPTO_BYTES_ONE_PAGE_U8 > u8WordIdx ; u8WordIdx = u8WordIdx + CRYPTO_WORD_LEN_U8 )
        {
            /* Compute the memory location of the word */
            u32PRAMLocation = u32Location + ((uint32)u8PageIdx << CRYPTO_BYTES_ONE_PAGE_EXPONENT_U8) + (uint32)u8WordIdx;
            /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/
            /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
            u32CurrentWord = REG_READ32(u32PRAMLocation);            
            /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
            /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
            aText[u32Index + CRYPTO_FOURTH_BYTE_IN_A_WORD_U32] = (uint8)(u32CurrentWord & CRYPTO_PRAM_WORD_FOURTH_BYTE_MASK_U32);
            /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
            /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
            aText[u32Index + CRYPTO_THIRD_BYTE_IN_A_WORD_U32] = (uint8)((u32CurrentWord & CRYPTO_PRAM_WORD_THIRD_BYTE_MASK_U32) >> CRYPTO_SHIFT_8_BIT_POSITIONS_U8);
            /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
            /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
            aText[u32Index + CRYPTO_SECOND_BYTE_IN_A_WORD_U32] = (uint8)((u32CurrentWord & CRYPTO_PRAM_WORD_SECOND_BYTE_MASK_U32) >> CRYPTO_SHIFT_16_BIT_POSITIONS_U8);
            /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
            /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
            aText[u32Index] = (uint8)((u32CurrentWord & CRYPTO_PRAM_WORD_FIRST_BYTE_MASK_U32) >> CRYPTO_SHIFT_24_BIT_POSITIONS_U8);
            u32Index = u32Index + (uint32)CRYPTO_WORD_LEN_U8;
        }
    }
}


/**
* @brief        Populates the command header;  waits for the CRYPTO_CSE_FCSESTAT_BSY flag    
* @details      This function populates bytes 0 - 3 of the command header from PAGE0 of PRAM, waits for the FLASH_FCSESTAT_BSY flag
*
* @param[in]    eCmd                     FuncID
* @param[in]    eFuncFormat              Function format
* @param[in]    eCallSeq                 Call sequence
* @param[in]    eKeyID                   Key ID
* @param[out]   none                 
*
* @return       Crypto_ErrorType  Error Code after command execution. Output parameter is valid if 
*               the error code is CRYPTO_CSE_ERC_NO_ERROR.     
*                                              
*                   
* @pre          Driver must be initialized; all the other required fields of PRAM for the particular command must be populated.
*
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC (Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_SendCommand ( VAR(Crypto_Cse_CmdType, AUTOMATIC) eCmd, VAR(Crypto_Cse_FuncFormatType, AUTOMATIC) eFuncFormat,
                                                                        VAR(Crypto_Cse_CallSequenceType, AUTOMATIC) eCallSeq, VAR(Crypto_Cse_KeyIdType, AUTOMATIC) eKeyID
                                                                       )
{
    VAR(Crypto_CseCommandWordType, AUTOMATIC) u32CommandHeader;   
    VAR(Crypto_Cse_ErrorCodeType, AUTOMATIC) eOutResponse = CRYPTO_CSE_ERC_GENERAL_ERROR;
    
    if (Crypto_Cse_eState != CRYPTO_CSE_IDLE)
    {
        /* for the first iteration, all the fields are populated */
        if ( CRYPTO_CSE_CALL_SEQ_FIRST == eCallSeq )
        {
            u32CommandHeader = (((Crypto_CseCommandWordType)(eKeyID) << CRYPTO_PRAM_HDR_KEYID_U32) | ((Crypto_CseCommandWordType)(eCallSeq) << CRYPTO_PRAM_HDR_SEQ_U32) \
                            | ((Crypto_CseCommandWordType)(eFuncFormat) << CRYPTO_PRAM_HDR_FORMAT_U32) | ((Crypto_CseCommandWordType)(eCmd) << CRYPTO_PRAM_HDR_CMD_U32) 
                                );
            /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
            /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
            REG_WRITE32(CRYPTO_PRAM_HDR_ADDR32, u32CommandHeader); 
        }
        /* for the second iteration, only the Call Seq field is changed inside PRAM */
        else
        {
            /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
            /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
            REG_RMW32(CRYPTO_PRAM_HDR_ADDR32, CRYPTO_PRAM_HDR_SEQ_MASK_U32, (uint32)((uint8)CRYPTO_CSE_CALL_SEQ_SEQUENT) << CRYPTO_WORD_CALL_SEQ_SHIFT_U8);
        }
        eOutResponse = CRYPTO_CSE_ERC_NO_ERROR;
    }
    else
    {
        eOutResponse = CRYPTO_CSE_ERC_CANCELED;
    }
    return eOutResponse;
}

/**
* @brief        Wait command complete
* @details      This function wait a command.
* @param[in]    none
* @param[out]   none
* @return       Cse_ErrorCodeType  
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC (Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_WaitCommandComplete(void)
{   
    VAR(uint32, AUTOMATIC) u32TimeoutCount = (uint32)CRYPTO_TIMEOUT_DURATION;
    VAR(Crypto_Cse_ErrorCodeType, AUTOMATIC) eOutResponse = CRYPTO_CSE_ERC_GENERAL_ERROR;
    /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
    /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/  
    while  ( ( CRYPTO_COMMAND_IN_PROGRESS_U8 == ( REG_BIT_GET8(CRYPTO_FCSESTAT_ADDR32, CRYPTO_FCSESTAT_BSY_U8 ) ) ) && ( 0U < u32TimeoutCount ) && (Crypto_Cse_eState != CRYPTO_CSE_IDLE) ) 
    { 
        --u32TimeoutCount;
    }
    /* if the timeout did not elapse and the command has finished */
    /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
    /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
    if ( CRYPTO_NO_COMMAND_IN_PROGRESS_U8 == REG_BIT_GET8(CRYPTO_FCSESTAT_ADDR32, CRYPTO_FCSESTAT_BSY_U8) )
    {
        /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
        /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
        if (0U == REG_BIT_GET8(CRYPTO_FSTAT_ADDR32, CRYPTO_FSTAT_RDCOLERR_U8 | CRYPTO_FSTAT_ACCERR_U8 | CRYPTO_FSTAT_FPVIOL_U8 | CRYPTO_FSTAT_MGSTAT0_U8))
        {
            /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
            /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
            eOutResponse = (Crypto_Cse_ErrorCodeType)((uint16)((CRYPTO_PRAM_ERROR_MASK_U32 & ((uint32)REG_READ32(CRYPTO_PRAM_PAGE0_WORD1_ADDR32))) >> CRYPTO_WORD_ERR_SHIFT_U8));
        }
        else
        {
            /* clear ACCERR and FPVIOL flags  */
            Crypto_Cse_ClearErrorFlags();
        }
    }
    
    return eOutResponse;    
}


/**
* @brief        Clears the error flags      
* @details      This function clears ACCERR and FPVIOL flags before entering any operation
*
* @param[in]    none
* @param[out]   none                                 
*
* @return       none  
*                                              
*                   
* @pre          none
*
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC (void, CRYPTO_CODE) Crypto_Cse_ClearErrorFlags (void)   
{
    /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
    /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
    REG_WRITE8(CRYPTO_FSTAT_ADDR32,CRYPTO_FSTAT_ACCERR_W1C | CRYPTO_FSTAT_FPVIOL_W1C);
}


/**
* @brief        Reads the MAC status    
* @details      This function reads the MAC status after succesfully running the command VerifyMac (pointer or buffer method)
*
* @param[in]    pStatus              A pointer to a memory location where the verification status will be copied to
* @param[in]    eResponse            The response received after triggering the command VerifyMac
* @param[out]   none                                 
*
* @return       none  
*                                               
*                   
* @pre          The verify MAC function should be triggered first
*/



#define CRYPTO_STOP_SEC_RAMCODE
/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"
/*==================================================================================================
*                                       GLOBAL FUNCTIONS
==================================================================================================*/
#define CRYPTO_START_SEC_CODE
/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"
/**
* Check status of HW.
**/
FUNC(boolean, CRYPTO_CODE) Crypto_Cse_IsBusy(void)
{
    VAR(boolean, AUTOMATIC) eOutResponse = (boolean)TRUE;
    VAR(uint8, AUTOMATIC) u8Fcnfg = 0U;
    VAR(uint8, AUTOMATIC) u8Fstat = 0U;
    
    /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
    /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
    u8Fcnfg = REG_BIT_GET8(CRYPTO_FCNFG_ADDR32, CRYPTO_FCNFG_EEERDY_U8);
    /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
    /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
    u8Fstat = REG_BIT_GET8(CRYPTO_FSTAT_ADDR32, CRYPTO_FSTAT_CCIF_U8);
    
    if ( ( CRYPTO_CCIF_NO_COMMAND_IN_PROGRESS_U8 == u8Fstat ) && ( CRYPTO_FCNFG_EEERDY_U8 == u8Fcnfg ) && ((Crypto_Cse_StateType)CRYPTO_CSE_IDLE == Crypto_Cse_eState) )
    {
        eOutResponse = (boolean)FALSE;
    }
    
    return eOutResponse;
}

/**
* @brief          Interrupt service routine to process the Cse Cmd interrupt
* @details        This function:
*                 - check executing command 
*                 - calls the function handler
*
* @return void
*
* @api
* @implements     Crypto_Cse_FTFCProcessInterrupt_Activity
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
FUNC(void, CRYPTO_CODE) Crypto_Cse_FTFCProcessInterrupt (void)
{
    VAR(uint8, AUTOMATIC) u8Fcnfg = 0x00U;
    /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
    /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
    Crypto_Cse_InitState.eOutResponse = (Crypto_Cse_ErrorCodeType)((uint16)((CRYPTO_PRAM_ERROR_MASK_U32 & ((uint32)REG_READ32(CRYPTO_PRAM_PAGE0_WORD1_ADDR32))) >> CRYPTO_WORD_ERR_SHIFT_U8));
    /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
    /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
    u8Fcnfg = REG_READ8(CRYPTO_FCNFG_ADDR32);
    /*Check HW was initiated or not, and Interrupt is enabled or not*/
    if(     (CRYPTO_CSE_INIT == Crypto_Cse_eDriverStatus) &&
            (CRYPTO_FCNFG_ENABLE_CCIE_U8 == (u8Fcnfg & CRYPTO_FCNFG_ENABLE_CCIE_U8) )
       )
    {
        if ((Crypto_Cse_InitState.Cmd == CRYPTO_CSE_CMD_ENC_ECB) || (Crypto_Cse_InitState.Cmd == CRYPTO_CSE_CMD_DEC_ECB))
        {
            Crypto_CseContinueEncDecECBCmd();
        }
        else if ((Crypto_Cse_InitState.Cmd == CRYPTO_CSE_CMD_ENC_CBC) || (Crypto_Cse_InitState.Cmd == CRYPTO_CSE_CMD_DEC_CBC))
        {
            Crypto_CseContinueEncDecCBCCmd();
        }
        else if (Crypto_Cse_InitState.Cmd == CRYPTO_CSE_CMD_GENERATE_MAC)
        {
            Crypto_CseContinueGenMacCmd(); 
        }
        else if (Crypto_Cse_InitState.Cmd == CRYPTO_CSE_CMD_VERIFY_MAC)
        {
            Crypto_CseContinueVerMacCmd();
        }
        else
        {
            /* do nothing */
        }
    }
    else
    {
        /* do nothing */
    }
}

/**
* @brief        Performs AES-128 encryption in ECB mode.     
* @details      This function performs the AES-128 encryption in ECB mode of the input plaintext buffer.
*               It operates under the assumption that the plaintext length is a multiple of 16 bytes.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    keyId               KeyID used to perform the cryptographic operation
* @param[in]    plainTextPtr        Pointer to the plain text buffer to be encrypted
* @param[in]    plainTextLength     Number of bytes of plain text message to be encrypted; should be smalled than 1048560 bytes
* @param[out]   cipherTextPtr       Pointer to the cipher text buffer. The buffer shall have the same 
*                                   size as the plain text buffer.
*
* @return       Cse_ErrorCodeType  Error Code after command execution. Output parameter is valid if 
*                                   the error code is CRYPTO_CSE_ERC_NO_ERROR.            
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_EcbEncrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) plainTextPtr,
                                                    VAR(uint32, AUTOMATIC) plainTextLength, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) cipherTextPtr
                                                   )
{
    VAR(uint16, AUTOMATIC) u16PagesToWrite = (uint16)(plainTextLength >> CRYPTO_BYTES_ONE_PAGE_EXPONENT_U8); /* 2 bytes are allocated for PAGE_LENGTH inside PRAM_PAGE0 */

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    Crypto_Cse_ClearErrorFlags();
    /*Initiation the value for the command Cse*/
    if (Crypto_bCseFirstCall)
    {
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        Cse_Init_state(keyId, plainTextPtr, u16PagesToWrite, cipherTextPtr, CRYPTO_CSE_CMD_ENC_ECB);
    }
    Crypto_CseStartEnDeEcb();
    /** @violates @ref Crypto_Cse_c_REF_9 Violates MISRA 2004 Advisory Rule 12.6, The operands of logical operators (&&, || and !) should be effectively Boolean.*/
    while ( !Crypto_bCseFirstCall ) 
    {
        Crypto_CseContinueEncDecECBCmd();
    }
    
    return Crypto_Cse_InitState.eOutResponse;
}

/**
* @brief        Performs AES-128 encryption in ECB mode.     
* @details      This function performs the AES-128 encryption in ECB mode of the input plaintext buffer.
*               It operates under the assumption that the plaintext length is a multiple of 16 bytes.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    keyId               KeyID used to perform the cryptographic operation
* @param[in]    plainTextPtr        Pointer to the plain text buffer to be encrypted
* @param[in]    plainTextLength     Number of bytes of plain text message to be encrypted; should be smalled than 1048560 bytes
* @param[out]   cipherTextPtr       Pointer to the cipher text buffer. The buffer shall have the same 
*                                   size as the plain text buffer.
*
* @return       Cse_ErrorCodeType  Error Code after command execution. Output parameter is valid if 
*                                   the error code is CRYPTO_CSE_ERC_NO_ERROR.            
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_EcbAsyncEncrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) plainTextPtr,
                                                    VAR(uint32, AUTOMATIC) plainTextLength, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) cipherTextPtr
                                                   )
{
    VAR(uint16, AUTOMATIC) u16PagesToWrite = (uint16)(plainTextLength >> CRYPTO_BYTES_ONE_PAGE_EXPONENT_U8); /* 2 bytes are allocated for PAGE_LENGTH inside PRAM_PAGE0 */

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    Crypto_Cse_ClearErrorFlags();
    /*Initiation the value for the command Cse*/
    if (Crypto_bCseFirstCall)
    {
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        Cse_Init_state(keyId, plainTextPtr, u16PagesToWrite, cipherTextPtr, CRYPTO_CSE_CMD_ENC_ECB);
        Crypto_bIsAsyncFunc = (boolean)TRUE;
    }
    Crypto_CseStartEnDeEcb();
    Crypto_CseEnableInterrupt((boolean)TRUE);
    
    return Crypto_Cse_InitState.eOutResponse;
}

/**
* @brief        Performs AES-128 decryption in ECB mode.     
* @details      This function performs the AES-128 decryption in ECB mode of the input ciphertext buffer.
*               It operates under the assumption that the ciphertext length is a multiple of 16 bytes.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    keyId               KeyID used to perform the cryptographic operation
* @param[in]    cipherTextPtr       Pointer to the cipher text buffer
* @param[in]    cipherTextLength    Number of bytes of cipher text message to be decrypted;  should be smalled than 1048560 bytes
* @param[out]   plainTextPtr        Pointer to the plain text buffer. The buffer shall have the same 
*                                   size as the cipher text buffer.
*
* @return       Cse_ErrorCodeType  Error Code after command execution. Output parameter is valid if 
*                                   the error code is CRYPTO_CSE_ERC_NO_ERROR.            
*
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*                   
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_EcbAsyncDecrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) cipherTextPtr,
                                                    VAR(uint32, AUTOMATIC) cipherTextLength, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) plainTextPtr
                                                   )
{
    VAR(uint16, AUTOMATIC) u16PagesToWrite = (uint16)(cipherTextLength >> CRYPTO_BYTES_ONE_PAGE_EXPONENT_U8); /* 2 bytes are allocated for PAGE_LENGTH inside PRAM_PAGE0  */

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    Crypto_Cse_ClearErrorFlags();
    if (Crypto_bCseFirstCall)
    {
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        Cse_Init_state(keyId, cipherTextPtr, u16PagesToWrite, plainTextPtr, CRYPTO_CSE_CMD_DEC_ECB);
        Crypto_bIsAsyncFunc = (boolean)TRUE;
    }
   
    /*start decrypt ECB*/
    Crypto_CseStartEnDeEcb();
    Crypto_CseEnableInterrupt((boolean)TRUE);
    
    return (Crypto_Cse_InitState.eOutResponse);
}

/**
* @brief        Performs AES-128 decryption in ECB mode.     
* @details      This function performs the AES-128 decryption in ECB mode of the input ciphertext buffer.
*               It operates under the assumption that the ciphertext length is a multiple of 16 bytes.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    keyId               KeyID used to perform the cryptographic operation
* @param[in]    cipherTextPtr       Pointer to the cipher text buffer
* @param[in]    cipherTextLength    Number of bytes of cipher text message to be decrypted;  should be smalled than 1048560 bytes
* @param[out]   plainTextPtr        Pointer to the plain text buffer. The buffer shall have the same 
*                                   size as the cipher text buffer.
*
* @return       Cse_ErrorCodeType  Error Code after command execution. Output parameter is valid if 
*                                   the error code is CRYPTO_CSE_ERC_NO_ERROR.            
*
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*                   
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_EcbDecrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) cipherTextPtr,
                                                    VAR(uint32, AUTOMATIC) cipherTextLength, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) plainTextPtr
                                                   )
{
    VAR(uint16, AUTOMATIC) u16PagesToWrite = (uint16)(cipherTextLength >> CRYPTO_BYTES_ONE_PAGE_EXPONENT_U8); 

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    /* clear ACCERR and FPVIOL flags before entering any operation */
    Crypto_Cse_ClearErrorFlags();
    /*Initiation the value for the command Cse*/
    if (Crypto_bCseFirstCall)
    {
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        Cse_Init_state(keyId, cipherTextPtr, u16PagesToWrite, plainTextPtr, CRYPTO_CSE_CMD_DEC_ECB);
    }
    
    Crypto_CseStartEnDeEcb();
    /** @violates @ref Crypto_Cse_c_REF_9 Violates MISRA 2004 Advisory Rule 12.6, The operands of logical operators (&&, || and !) should be effectively Boolean.*/
    while ( !Crypto_bCseFirstCall ) 
    {
        Crypto_CseContinueEncDecECBCmd();
    }
    
    return Crypto_Cse_InitState.eOutResponse;
}

/**
* @brief        Performs AES-128 encryption in CBC mode.     
* @details      This function performs the AES-128 encryption in CBC mode of the input plaintext buffer.
*               It operates under the assumption that the plaintext length is a multiple of 16 bytes.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    keyId               KeyID used to perform the cryptographic operation
* @param[in]    plainTextPtr        Pointer to the plain text buffer
* @param[in]    plainTextLength     Number of bytes of plain text message to be encrypted;  should be smalled than 1048560 bytes
* @param[in]    ivPtr               Pointer to the initialization vector buffer
* @param[out]   cipherTextPtr       Pointer to the cipher text buffer. The buffer shall have the same 
*                                   size as the plain text buffer.
*
* @return       Cse_ErrorCodeType  Error Code after command execution. Output parameter is valid if 
*                                   the error code is CRYPTO_CSE_ERC_NO_ERROR.            
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_CbcEncrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) plainTextPtr,
                                                    VAR(uint32, AUTOMATIC) plainTextLength, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) ivPtr,
                                                    P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) cipherTextPtr
                                                   )
{
    VAR(uint16, AUTOMATIC) u16PagesToWrite = (uint16)(plainTextLength >> CRYPTO_BYTES_ONE_PAGE_EXPONENT_U8); /* 2 bytes are allocated for PAGE_LENGTH inside PRAM_PAGE0 */

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    /* clear ACCERR and FPVIOL flags before entering any operation */
    Crypto_Cse_ClearErrorFlags();
    /* copy u16PagesToWrite, iv (one page) and max 6 pages of plaintext to CRYPTO_CSE_PRAM */
    if (Crypto_bCseFirstCall)
    {
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        Cse_Init_state(keyId, plainTextPtr, u16PagesToWrite, cipherTextPtr, CRYPTO_CSE_CMD_ENC_CBC);
        Crypto_Cse_InitState.u16MaxPages = CRYPTO_AVAILABLE_PRAM_PAGES_FOR_CBC_U16;
        Crypto_Cse_InitState.u32Location = CRYPTO_PRAM_PAGE2_ADDR32;/* For the first iteration, input and output are passed starting with PAGE2  */
        Crypto_Cse_InitState.SecondaryInput = ivPtr;
    }
    Crypto_CseStartEnDeCbc();
    /** @violates @ref Crypto_Cse_c_REF_9 Violates MISRA 2004 Advisory Rule 12.6, The operands of logical operators (&&, || and !) should be effectively Boolean.*/
    while ( !Crypto_bCseFirstCall ) 
    {
        Crypto_CseContinueEncDecCBCCmd();
    }
    
    return (Crypto_Cse_InitState.eOutResponse);
}

/**
* @brief        Performs AES-128 encryption in CBC mode.     
* @details      This function performs the AES-128 encryption in CBC mode of the input plaintext buffer.
*               It operates under the assumption that the plaintext length is a multiple of 16 bytes.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    keyId               KeyID used to perform the cryptographic operation
* @param[in]    plainTextPtr        Pointer to the plain text buffer
* @param[in]    plainTextLength     Number of bytes of plain text message to be encrypted;  should be smalled than 1048560 bytes
* @param[in]    ivPtr               Pointer to the initialization vector buffer
* @param[out]   cipherTextPtr       Pointer to the cipher text buffer. The buffer shall have the same 
*                                   size as the plain text buffer.
*
* @return       Cse_ErrorCodeType  Error Code after command execution. Output parameter is valid if 
*                                   the error code is CRYPTO_CSE_ERC_NO_ERROR.            
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_CbcAsyncEncrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) plainTextPtr,
                                                    VAR(uint32, AUTOMATIC) plainTextLength, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) ivPtr,
                                                    P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) cipherTextPtr
                                                   )
{
    VAR(uint16, AUTOMATIC) u16PagesToWrite = (uint16)(plainTextLength >> CRYPTO_BYTES_ONE_PAGE_EXPONENT_U8); /* 2 bytes are allocated for PAGE_LENGTH inside PRAM_PAGE0 */

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    Crypto_Cse_ClearErrorFlags();

    if (Crypto_bCseFirstCall)
    {
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        Cse_Init_state(keyId, plainTextPtr, u16PagesToWrite, cipherTextPtr, CRYPTO_CSE_CMD_ENC_CBC);
        Crypto_Cse_InitState.u16MaxPages = CRYPTO_AVAILABLE_PRAM_PAGES_FOR_CBC_U16;
        Crypto_Cse_InitState.u32Location = CRYPTO_PRAM_PAGE2_ADDR32;/* For the first iteration, input and output are passed starting with PAGE2  */
        Crypto_Cse_InitState.SecondaryInput = ivPtr;
        Crypto_bIsAsyncFunc = (boolean)TRUE;
    }

    /*start encrypt CBC*/
    Crypto_CseStartEnDeCbc();
    Crypto_CseEnableInterrupt((boolean)TRUE);
        
    return (Crypto_Cse_InitState.eOutResponse);
}

/**
* @brief        Performs AES-128 decryption in CBC mode.     
* @details      This function performs the AES-128 decryption in CBC mode of the input ciphertext buffer.
*               It operates under the assumption that the ciphertext length is a multiple of 16 bytes.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    keyId               KeyID used to perform the cryptographic operation
* @param[in]    cipherTextPtr       Pointer to the cipher text buffer
* @param[in]    cipherTextLength    Number of bytes of cipher text message to be decrypted;  should be smalled than 1048560 bytes
* @param[in]    ivPtr               Pointer to the initialization vector buffer
* @param[out]   plainTextPtr        Pointer to the plain text buffer. The buffer shall have the same 
*                                   size as the cipher text buffer.
*
* @return       Cse_ErrorCodeType  Error Code after command execution. Output parameter is valid if 
*                                   the error code is CRYPTO_CSE_ERC_NO_ERROR.            
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_CbcDecrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) cipherTextPtr,
                                                    VAR(uint32, AUTOMATIC) cipherTextLength, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) ivPtr,
                                                    P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) plainTextPtr
                                                   )
{
    VAR(uint16, AUTOMATIC) u16PagesToWrite = (uint16)(cipherTextLength >> CRYPTO_BYTES_ONE_PAGE_EXPONENT_U8); /* Inside PRAM_PAGE0 2 bytes are allocated for PAGE_LENGTH */

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    Crypto_Cse_ClearErrorFlags();
    /* copy u16PagesToWrite, iv and max 6 pages of ciphertext to CRYPTO_CSE_PRAM */
    if (Crypto_bCseFirstCall)
    {
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        Cse_Init_state(keyId, cipherTextPtr, u16PagesToWrite, plainTextPtr, CRYPTO_CSE_CMD_DEC_CBC);
        Crypto_Cse_InitState.u16MaxPages = CRYPTO_AVAILABLE_PRAM_PAGES_FOR_CBC_U16;
        Crypto_Cse_InitState.u32Location = CRYPTO_PRAM_PAGE2_ADDR32;/* For the first iteration, input and output are passed starting with PAGE2  */
        Crypto_Cse_InitState.SecondaryInput = ivPtr;
    }
    Crypto_CseStartEnDeCbc();
    /** @violates @ref Crypto_Cse_c_REF_9 Violates MISRA 2004 Advisory Rule 12.6, The operands of logical operators (&&, || and !) should be effectively Boolean.*/
    while ( !Crypto_bCseFirstCall ) 
    {
        Crypto_CseContinueEncDecCBCCmd();
    }
    
    return Crypto_Cse_InitState.eOutResponse;
}

/**
* @brief        Performs AES-128 decryption in CBC mode.     
* @details      This function performs the AES-128 decryption in CBC mode of the input ciphertext buffer.
*               It operates under the assumption that the ciphertext length is a multiple of 16 bytes.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    keyId               KeyID used to perform the cryptographic operation
* @param[in]    cipherTextPtr       Pointer to the cipher text buffer
* @param[in]    cipherTextLength    Number of bytes of cipher text message to be decrypted;  should be smalled than 1048560 bytes
* @param[in]    ivPtr               Pointer to the initialization vector buffer
* @param[out]   plainTextPtr        Pointer to the plain text buffer. The buffer shall have the same 
*                                   size as the cipher text buffer.
*
* @return       Cse_ErrorCodeType  Error Code after command execution. Output parameter is valid if 
*                                   the error code is CRYPTO_CSE_ERC_NO_ERROR.            
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_CbcAsyncDecrypt(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) cipherTextPtr,
                                                    VAR(uint32, AUTOMATIC) cipherTextLength, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) ivPtr,
                                                    P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) plainTextPtr
                                                   )
{
    VAR(uint16, AUTOMATIC) u16PagesToWrite = (uint16)(cipherTextLength >> CRYPTO_BYTES_ONE_PAGE_EXPONENT_U8); /* Inside PRAM_PAGE0 2 bytes are allocated for PAGE_LENGTH */

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

        if (Crypto_bCseFirstCall)
        {
            /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
            Cse_Init_state(keyId, cipherTextPtr, u16PagesToWrite, plainTextPtr, CRYPTO_CSE_CMD_DEC_CBC);
            Crypto_Cse_InitState.u16MaxPages = CRYPTO_AVAILABLE_PRAM_PAGES_FOR_CBC_U16;
            Crypto_Cse_InitState.u32Location = CRYPTO_PRAM_PAGE2_ADDR32;
            Crypto_Cse_InitState.SecondaryInput = ivPtr;
            Crypto_bIsAsyncFunc = (boolean)TRUE;
        }
        
        /* clear ACCERR and FPVIOL flags before entering any operation */
        Crypto_Cse_ClearErrorFlags();
        /*start decrypt CBC*/
        Crypto_CseStartEnDeCbc();
        Crypto_CseEnableInterrupt((boolean)TRUE);
    
    return (Crypto_Cse_InitState.eOutResponse);
}

 /**
* @brief        Performs AES-128 decryption and encryption in CBC mode.     
* @details      This function performs the AES-128 decryption and encryption in CBC mode of the input data buffer.
*               It operates under the assumption that the input data length is a multiple of 16 bytes.
*
* @param[in]    none               
* @param[out]   none       
*                                   
*
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_CseStartEnDeCbc(void)
{

    if (Crypto_bCseFirstCall)
    {
        /* copy (Crypto_Cse_InitState.num_pages) to CRYPTO_CSE_PRAM */
        /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
        /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        REG_WRITE32(CRYPTO_PRAM_PAGE0_LENGTH_SLOT_ADDR16, Crypto_Cse_InitState.num_pages);
        Crypto_Cse_WritePagesToPRAM(Crypto_Cse_InitState.SecondaryInput, CRYPTO_PRAM_PAGE1_ADDR32, CRYPTO_ONE_PAGE_U16);
    }
    
    /** @violates @ref Crypto_Cse_c_REF_5 Array indexing shall be the only allowed form of pointer arithmetic. */
    Crypto_Cse_InitState.outputdata += (((uint32)(Crypto_Cse_InitState.page_written)) << CRYPTO_BYTES_ONE_PAGE_EXPONENT_U8);
    /* copy max plaintext pages to CRYPTO_CSE_PRAM (6 for first iteration, 7 for the second iteration) */
    if ( (Crypto_Cse_InitState.u16MaxPages) < (Crypto_Cse_InitState.num_pages) )
    {
        Crypto_Cse_WritePagesToPRAM(Crypto_Cse_InitState.inputdata, Crypto_Cse_InitState.u32Location, Crypto_Cse_InitState.u16MaxPages);
        Crypto_Cse_InitState.num_pages = Crypto_Cse_InitState.num_pages - Crypto_Cse_InitState.u16MaxPages;
        Crypto_Cse_InitState.page_written = Crypto_Cse_InitState.u16MaxPages;
        /* plainTextPtr is increased only if there are more pages to read from the input buffer */
        /** @violates @ref Crypto_Cse_c_REF_5 Array indexing shall be the only allowed form of pointer arithmetic.*/
        Crypto_Cse_InitState.inputdata += (((uint32)(Crypto_Cse_InitState.page_written)) << CRYPTO_BYTES_ONE_PAGE_EXPONENT_U8);
    }
    else
    {
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        Crypto_Cse_WritePagesToPRAM(Crypto_Cse_InitState.inputdata, Crypto_Cse_InitState.u32Location, Crypto_Cse_InitState.num_pages);
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        Crypto_Cse_InitState.page_written = Crypto_Cse_InitState.num_pages;
        Crypto_Cse_InitState.num_pages = 0U;
    }

    /* write command header to CRYPTO_CSE_PRAM, wait for the completion of the command, read and process error code */
    Crypto_Cse_InitState.eOutResponse = Crypto_Cse_PopulateCommandHeader (Crypto_Cse_InitState.Cmd, Crypto_bCseFirstCall, Crypto_Cse_InitState.keyId);
    Crypto_bCseFirstCall = (boolean)FALSE;
    /** @violates @ref Crypto_Cse_c_REF_9 Violates MISRA 2004 Advisory Rule 12.6, The operands of logical operators (&&, || and !) should be effectively Boolean.*/
    if (!Crypto_bIsAsyncFunc)
    {
        Crypto_Cse_InitState.eOutResponse = Crypto_Cse_WaitCommandComplete();
    }
}

/**
* @brief        Performs AES-128 decryption and encryption in CBC mode.     
* @details      This function performs the AES-128 decryption and encryption in CBC mode of the input data buffer.
*               It operates under the assumption that the input data length is a multiple of 16 bytes.
*
* @param[in]    none               
* @param[out]   none       
*                                   
*
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_CseContinueEncDecCBCCmd(void)
{
    if(CRYPTO_CSE_IDLE == Crypto_Cse_eState)
    {
        Crypto_Cse_InitState.eOutResponse = CRYPTO_CSE_ERC_CANCELED;
    }

    if (CRYPTO_CSE_ERC_NO_ERROR == Crypto_Cse_InitState.eOutResponse)
    {
        /* move pages of ciphertext from CRYPTO_CSE_PRAM to output */
        Crypto_Cse_ReadPagesFromPRAM(Crypto_Cse_InitState.outputdata, Crypto_Cse_InitState.u32Location, Crypto_Cse_InitState.page_written);
        Crypto_Cse_InitState.u32Location = CRYPTO_PRAM_PAGE1_ADDR32;
        Crypto_Cse_InitState.u16MaxPages = CRYPTO_ALL_AVAILABLE_PRAM_PAGES_U16;
        if (0U < (Crypto_Cse_InitState.num_pages))
        {
            Crypto_CseStartEnDeCbc();
        }
        else
        {
            Crypto_Cse_eState = CRYPTO_CSE_IDLE;
            if(Crypto_bIsAsyncFunc)
            {
                Crypto_CseEnableInterrupt((boolean)FALSE);
                Crypto_Ipw_CallBackNotification(Crypto_Cse_InitState.eOutResponse);
                Crypto_bIsAsyncFunc = (boolean) FALSE;
            }
            Crypto_bCseFirstCall = (boolean)TRUE;
        }
    }
    else
    {
        Crypto_Cse_eState = CRYPTO_CSE_IDLE;
        if(Crypto_bIsAsyncFunc)
        {
            Crypto_CseEnableInterrupt((boolean)FALSE);
            Crypto_Ipw_CallBackNotification(Crypto_Cse_InitState.eOutResponse);
            Crypto_bIsAsyncFunc = (boolean) FALSE;
        }
        Crypto_bCseFirstCall = (boolean)TRUE;
    }
}

/**
* @brief        Performs AES-128 decryption and encryption in ECB mode.     
* @details      This function performs the AES-128 decryption and encryption in ECB mode of the input data buffer.
*               It operates under the assumption that the input data length is a multiple of 16 bytes.
*
* @param[in]    none               
* @param[out]   none       
*                                   
*
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_CseStartEnDeEcb(void)
{
    
    if (Crypto_bCseFirstCall)
    {
        /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
        /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        REG_WRITE32(CRYPTO_PRAM_PAGE0_LENGTH_SLOT_ADDR16, Crypto_Cse_InitState.num_pages);
    }
    /** @violates @ref Crypto_Cse_c_REF_5 Array indexing shall be the only allowed form of pointer arithmetic. */
    Crypto_Cse_InitState.outputdata += (((uint32)(Crypto_Cse_InitState.page_written)) << CRYPTO_BYTES_ONE_PAGE_EXPONENT_U8);
    if ( CRYPTO_ALL_AVAILABLE_PRAM_PAGES_U16 < (Crypto_Cse_InitState.num_pages) )
    {
        Crypto_Cse_WritePagesToPRAM(Crypto_Cse_InitState.inputdata, CRYPTO_PRAM_PAGE1_ADDR32, CRYPTO_ALL_AVAILABLE_PRAM_PAGES_U16);
        Crypto_Cse_InitState.page_written = CRYPTO_ALL_AVAILABLE_PRAM_PAGES_U16;
        Crypto_Cse_InitState.num_pages = Crypto_Cse_InitState.num_pages - Crypto_Cse_InitState.page_written;
        /** @violates @ref Crypto_Cse_c_REF_5 Array indexing shall be the only allowed form of pointer arithmetic. */
        Crypto_Cse_InitState.inputdata += CRYPTO_DATA_BYTES_AVAILABLE_U8;
    }
    else
    {
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        Crypto_Cse_WritePagesToPRAM(Crypto_Cse_InitState.inputdata, CRYPTO_PRAM_PAGE1_ADDR32, Crypto_Cse_InitState.num_pages);
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        Crypto_Cse_InitState.page_written = Crypto_Cse_InitState.num_pages;
        Crypto_Cse_InitState.num_pages = 0U;
    }
    Crypto_Cse_InitState.eOutResponse = Crypto_Cse_PopulateCommandHeader (Crypto_Cse_InitState.Cmd, Crypto_bCseFirstCall, Crypto_Cse_InitState.keyId);
    /** @violates @ref Crypto_Cse_c_REF_9 Violates MISRA 2004 Advisory Rule 12.6, The operands of logical operators (&&, || and !) should be effectively Boolean.*/
    if (!Crypto_bIsAsyncFunc)
    {
        Crypto_Cse_InitState.eOutResponse = Crypto_Cse_WaitCommandComplete();
    }
    Crypto_bCseFirstCall = (boolean)FALSE;

}

/**
* @brief        Performs AES-128 decryption and encryption in ECB mode.     
* @details      This function performs the AES-128 decryption and encryption in ECB mode of the input data buffer.
*               It operates under the assumption that the input data length is a multiple of 16 bytes.
*
* @param[in]    none               
* @param[out]   none       
*                                   
*
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_CseContinueEncDecECBCmd(void)
{
    if(CRYPTO_CSE_IDLE == Crypto_Cse_eState)
    {
        Crypto_Cse_InitState.eOutResponse = CRYPTO_CSE_ERC_CANCELED;
    }
    if (CRYPTO_CSE_ERC_NO_ERROR == Crypto_Cse_InitState.eOutResponse)
    {
        /* move pages of ciphertext from CRYPTO_CSE_PRAM to output */
        Crypto_Cse_ReadPagesFromPRAM(Crypto_Cse_InitState.outputdata, CRYPTO_PRAM_PAGE1_ADDR32, Crypto_Cse_InitState.page_written);
        if (0U < (Crypto_Cse_InitState.num_pages))
        {
            Crypto_CseStartEnDeEcb();
        }
        else
        {
            Crypto_Cse_eState = CRYPTO_CSE_IDLE;
            if(Crypto_bIsAsyncFunc)
            {
                Crypto_CseEnableInterrupt((boolean)FALSE);
                Crypto_Ipw_CallBackNotification(Crypto_Cse_InitState.eOutResponse);
                Crypto_bIsAsyncFunc = (boolean) FALSE;
            }
            Crypto_bCseFirstCall = (boolean)TRUE;
        }
    }
    else
    {
        Crypto_Cse_eState = CRYPTO_CSE_IDLE;
        if(Crypto_bIsAsyncFunc)
        {
            Crypto_CseEnableInterrupt((boolean)FALSE);
            Crypto_Ipw_CallBackNotification(Crypto_Cse_InitState.eOutResponse);
            Crypto_bIsAsyncFunc = (boolean) FALSE;
        }
        Crypto_bIsAsyncFunc = (boolean) FALSE;
    }
}

/**
* @brief        The CCIE bit controls interrupt generation when an FTFC command completes.
* @details      This function enable or disable the CCIE bit.
*
* @param[in]    enable  
* @param[out]   none  
*
* @return       none 
*               
*                
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*   
*   
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Crypto_CseEnableInterrupt(VAR(boolean, AUTOMATIC) enable)
{
    if(enable)
    {
        /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
        /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
        REG_WRITE8(CRYPTO_FCNFG_ADDR32, CRYPTO_FCNFG_ENABLE_CCIE_U8);
    }
    else
    {
        /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
        /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
        REG_WRITE8(CRYPTO_FCNFG_ADDR32, CRYPTO_FCNFG_DISABLE_CCIE_U8);
    }
}

/**
* @brief        Initialized keyID, in_Data, Num_Pages, out_Data and command.      
* @details      This function initialized keyID, in_Data, Num_Pages, out_Data and command for command execution.
*
* @param[in]    keyId                  Key ID
* @param[in]    in_Data                Pointer to the input data buffer to execute the command 
* @param[in]    Num_Pages              Number of bytes of input data message
* @param[in]    Cse_Cmd                Cse command
* @param[out]   out_Data               Pointer to the output data buffer
*
* @return       none  
*                                           
*                   
* @pre          Driver must be initialized.
*
* @note         
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC(void, CRYPTO_CODE) Cse_Init_state(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) in_Data,
                                      VAR(uint32, AUTOMATIC) Num_Pages, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) out_Data, 
                                      VAR(Crypto_Cse_CmdType, AUTOMATIC) Cse_Cmd
                                      )
{
    Crypto_Cse_InitState.keyId = keyId;
    Crypto_Cse_InitState.inputdata = in_Data;
    Crypto_Cse_InitState.outputdata = out_Data;
    Crypto_Cse_InitState.num_pages = Num_Pages;
    Crypto_Cse_InitState.Cmd = Cse_Cmd;
    Crypto_Cse_InitState.page_written=0U;
    Crypto_Cse_InitState.eOutResponse = CRYPTO_CSE_ERC_GENERAL_ERROR;
}

/**
* @brief        Reads the MAC status    
* @details      This function reads the MAC status after succesfully running the command VerifyMac (pointer or buffer method)
*
* @param[in]    pStatus              A pointer to a memory location where the verification status will be copied to
* @param[in]    eResponse            The response received after triggering the command VerifyMac
* @param[out]   none                                 
*
* @return       none  
*                                               
*                   
* @pre          The verify MAC function should be triggered first
*/
static FUNC(void, CRYPTO_CODE) Crypto_Cse_ReadMacStatus (P2VAR(Crypto_VerifyResultType, AUTOMATIC, CRYPTO_APPL_DATA) pStatus, VAR(Crypto_Cse_ErrorCodeType, AUTOMATIC) eResponse)
{
    VAR(uint16, AUTOMATIC) u16ReadStatus = 0U;
    VAR(uint32, AUTOMATIC) u32ReadWord;
    
    if ( CRYPTO_CSE_ERC_NO_ERROR == eResponse)
    {
        /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
        /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
        u32ReadWord = REG_READ32(CRYPTO_PRAM_PAGE1_WORD1_ADDR32);
        u16ReadStatus = (uint16)(u32ReadWord >> CRYPTO_WORD_VER_STATUS_SHIFT_U8);
        
        if ( CRYPTO_CORRECT_VERIFICATION_STATUS == u16ReadStatus )
        {            
            *pStatus = CRYPTO_E_VER_OK; 
        }
        else 
        {
            *pStatus = CRYPTO_E_VER_NOT_OK;
        }
    }
    /*
    else
    {
        do nothing, as u16ReadStatus is already false
    }
    */
}

/**
* @brief        Calculates the MAC of a given message using CMAC with AES-128.     
* @details      This function calculates the MAC of a given message based on CMAC with the 128-bit Advanced Encryption Standard. 
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    keyId               KeyID used to perform the cryptographic operation
* @param[in]    dataPtr             Pointer to the message buffer
* @param[in]    dataLength          Number of bits of message on which CMAC is to be computed
* @param[out]   macPtr              Pointer to the 128-bit buffer containing the result of the CMAC generation
*
* @return       Cse_ErrorCodeType  Error Code after command execution. Output parameter is valid if 
*                                   the error code is CRYPTO_CSE_ERC_NO_ERROR.            
*                
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_MacGenerate(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) dataPtr,
                                                           VAR(uint32, AUTOMATIC) dataLength, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) macPtr
                                                           )
{
    VAR(uint32, AUTOMATIC) Length_bits = dataLength << CRYPTO_LAST_BYTE_IN_A_WORD_U8;
    VAR(uint32, AUTOMATIC) u32PagesToWrite = (Length_bits + (uint32)CRYPTO_MAX_REMAINDER_DIV_128_U8) >> CRYPTO_BITS_ONE_PAGE_EXPONENT_U8;

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    /* clear ACCERR and FPVIOL flags before entering any operation */
    Crypto_Cse_ClearErrorFlags();
    /* copy dataLength to CRYPTO_CSE_PRAM */
    if (Crypto_bCseFirstCall)
    {
        Cse_Init_state(keyId, dataPtr, u32PagesToWrite, macPtr, CRYPTO_CSE_CMD_GENERATE_MAC);
        Crypto_Cse_InitState.dataLength = Length_bits;
        Crypto_Cse_InitState.u32MaxBytes = 0U;
    }
    
    Crypto_CseStartGenMacCmd();
    /** @violates @ref Crypto_Cse_c_REF_9 Violates MISRA 2004 Advisory Rule 12.6, The operands of logical operators (&&, || and !) should be effectively Boolean.*/
    while ( !Crypto_bCseFirstCall ) 
    {
        Crypto_CseContinueGenMacCmd();
    }
    
    return (Crypto_Cse_InitState.eOutResponse);
}

/**
* @brief        Calculates the MAC of a given message using CMAC with AES-128.     
* @details      This function calculates the MAC of a given message based on CMAC with the 128-bit Advanced Encryption Standard. 
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    keyId               KeyID used to perform the cryptographic operation
* @param[in]    dataPtr             Pointer to the message buffer
* @param[in]    dataLength          Number of bits of message on which CMAC is to be computed
* @param[out]   macPtr              Pointer to the 128-bit buffer containing the result of the CMAC generation
*
* @return       Cse_ErrorCodeType  Error Code after command execution. Output parameter is valid if 
*                                   the error code is CRYPTO_CSE_ERC_NO_ERROR.            
*                
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_MacAsyncGenerate(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) dataPtr,
                                                     VAR(uint32, AUTOMATIC) dataLength, P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) macPtr
                                                    )
{
    VAR(uint32, AUTOMATIC) Length_bits = dataLength << CRYPTO_LAST_BYTE_IN_A_WORD_U8;
    VAR(uint32, AUTOMATIC) u32PagesToWrite = (Length_bits + (uint32)CRYPTO_MAX_REMAINDER_DIV_128_U8) >> CRYPTO_BITS_ONE_PAGE_EXPONENT_U8;

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    if (Crypto_bCseFirstCall)
    {
        Cse_Init_state(keyId, dataPtr, u32PagesToWrite, macPtr, CRYPTO_CSE_CMD_GENERATE_MAC);
        Crypto_Cse_InitState.dataLength = Length_bits;
        Crypto_Cse_InitState.u32MaxBytes = 0U;
        Crypto_bIsAsyncFunc = (boolean)TRUE;
    }
    
    /* clear ACCERR and FPVIOL flags before entering any operation */
    Crypto_Cse_ClearErrorFlags();
    /*start generate MAC*/
    Crypto_CseStartGenMacCmd();
    Crypto_CseEnableInterrupt((boolean)TRUE);
    
    return (Crypto_Cse_InitState.eOutResponse);
}

 /**
* @brief        Calculates the MAC of a given message using CMAC with AES-128.     
* @details      This function calculates the MAC of a given message based on CMAC with the 128-bit Advanced Encryption Standard. 
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    none  
* @param[out]   none  
*
* @return       none 
*               
*                
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*   
*   
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC (void, CRYPTO_CODE) Crypto_CseStartGenMacCmd(void)
{
    if (Crypto_bCseFirstCall)
    {
        /* copy dataLength to CRYPTO_CSE_PRAM */
        /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
        /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
        REG_WRITE32(CRYPTO_PRAM_PAGE0_LENGTH_SLOT_ADDR16, Crypto_Cse_InitState.dataLength);    
    }
    if (CRYPTO_ALL_AVAILABLE_PRAM_PAGES_U16 < Crypto_Cse_InitState.num_pages)
    {
        Crypto_Cse_WritePagesToPRAM (Crypto_Cse_InitState.inputdata, CRYPTO_PRAM_PAGE1_ADDR32, CRYPTO_ALL_AVAILABLE_PRAM_PAGES_U16);
        Crypto_Cse_InitState.num_pages = Crypto_Cse_InitState.num_pages - CRYPTO_ALL_AVAILABLE_PRAM_PAGES_U16;
    }
    else
    {
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        Crypto_Cse_WritePagesToPRAM (Crypto_Cse_InitState.inputdata, CRYPTO_PRAM_PAGE1_ADDR32, Crypto_Cse_InitState.num_pages);
        Crypto_Cse_InitState.num_pages = 0U;
    }
    Crypto_Cse_InitState.eOutResponse = Crypto_Cse_PopulateCommandHeader (Crypto_Cse_InitState.Cmd, Crypto_bCseFirstCall, Crypto_Cse_InitState.keyId);
    /** @violates @ref Crypto_Cse_c_REF_9 Violates MISRA 2004 Advisory Rule 12.6, The operands of logical operators (&&, || and !) should be effectively Boolean.*/
    if (!Crypto_bIsAsyncFunc)
    {
        Crypto_Cse_InitState.eOutResponse = Crypto_Cse_WaitCommandComplete();
    }
    Crypto_bCseFirstCall = (boolean)FALSE;
    
}

/**
* @brief        Calculates the MAC of a given message using CMAC with AES-128.     
* @details      This function calculates the MAC of a given message based on CMAC with the 128-bit Advanced Encryption Standard. 
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    none  
* @param[out]   none  
*
* @return       none 
*               
*                
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*   
*   
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC (void, CRYPTO_CODE) Crypto_CseContinueGenMacCmd(void)
{
    if(CRYPTO_CSE_IDLE == Crypto_Cse_eState)
    {
        Crypto_Cse_InitState.eOutResponse = CRYPTO_CSE_ERC_CANCELED;
    }
    if (CRYPTO_CSE_ERC_NO_ERROR == Crypto_Cse_InitState.eOutResponse)
    {
        if (0U < (Crypto_Cse_InitState.num_pages))
        {
            Crypto_CseStartGenMacCmd();
        }
        else
        {
            Crypto_Cse_ReadPagesFromPRAM(Crypto_Cse_InitState.outputdata, CRYPTO_PRAM_PAGE2_ADDR32, CRYPTO_ONE_PAGE_U16);
            Crypto_Cse_eState = CRYPTO_CSE_IDLE;
            if(Crypto_bIsAsyncFunc)
            {
                Crypto_CseEnableInterrupt((boolean)FALSE);
                Crypto_Ipw_CallBackNotification(Crypto_Cse_InitState.eOutResponse);
                Crypto_bIsAsyncFunc = (boolean) FALSE;
            }
            Crypto_bCseFirstCall = (boolean)TRUE;
        }
    }
    else
    {
        Crypto_Cse_eState = CRYPTO_CSE_IDLE;
        if(Crypto_bIsAsyncFunc)
        {
            Crypto_CseEnableInterrupt((boolean)FALSE);
            Crypto_Ipw_CallBackNotification(Crypto_Cse_InitState.eOutResponse);
            Crypto_bIsAsyncFunc = (boolean) FALSE;
        }
        Crypto_bCseFirstCall = (boolean)TRUE;
    }
}

/**
* @brief        Calculates the MAC of a given message using CMAC with AES-128.     
* @details      This function verifies the MAC of of a given message based on CMAC with the 128-bit Advanced Encryption Standard.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes. 
*
* @param[in]    keyId               KeyID used to perform the cryptographic operation
* @param[in]    dataPtr             Pointer to the message buffer
* @param[in]    dataLength          Number of bits of message on which CMAC is to be computed
* @param[in]    macLength           Number of bits of the CMAC to be compared. A macLength value of zero indicates that 
*                                   all 128-bits are to be compared.
* @param[in]    macRefPtr           Pointer to the buffer containing the CMAC to be verified.
* @param[out]   status              Status of the MAC verification command (true: verification operation passed; false: verification
*                                   operation failed)
*
* @return       Crypto_ErrorType  Error Code after command execution. Output parameter is valid if 
*                                   the error code is CRYPTO_CSE_ERC_NO_ERROR.            
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/

FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_MacVerify(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) dataPtr,
                                                   VAR(uint32, AUTOMATIC) dataLength, VAR(uint32, AUTOMATIC) macLength,
                                                   P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) macRefPtr, P2VAR(Crypto_VerifyResultType, AUTOMATIC, CRYPTO_APPL_DATA) verifyPtr
                                                  )
{
    VAR(uint32, AUTOMATIC) Length_bits = dataLength << CRYPTO_LAST_BYTE_IN_A_WORD_U8;
    VAR(uint32, AUTOMATIC) u32PagesToWrite = (Length_bits + (uint32)CRYPTO_MAX_REMAINDER_DIV_128_U8) >> CRYPTO_BITS_ONE_PAGE_EXPONENT_U8;

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    /* clear ACCERR and FPVIOL flags before entering any operation */
    Crypto_Cse_ClearErrorFlags();
    
    if (Crypto_bCseFirstCall)
    {
        Cse_Init_state(keyId, dataPtr, u32PagesToWrite, NULL_PTR, CRYPTO_CSE_CMD_VERIFY_MAC);
        Crypto_Cse_InitState.verifyPtr = verifyPtr;
        Crypto_Cse_InitState.dataLength = Length_bits;
        Crypto_Cse_InitState.macLength = macLength;
        Crypto_Cse_InitState.SecondaryInput = macRefPtr;
        Crypto_Cse_InitState.bRefMacWritten = (boolean) FALSE;
    }   

    Crypto_CseStartVerMacCmd();
    /** @violates @ref Crypto_Cse_c_REF_9 Violates MISRA 2004 Advisory Rule 12.6, The operands of logical operators (&&, || and !) should be effectively Boolean.*/
    while ( !Crypto_bCseFirstCall ) 
    {
        Crypto_CseContinueVerMacCmd();
    }
    
    return Crypto_Cse_InitState.eOutResponse;
}

/**
* @brief        Calculates the MAC of a given message using CMAC with AES-128.     
* @details      This function verifies the MAC of of a given message based on CMAC with the 128-bit Advanced Encryption Standard.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes. 
*
* @param[in]    keyId               KeyID used to perform the cryptographic operation
* @param[in]    dataPtr             Pointer to the message buffer
* @param[in]    dataLength          Number of bits of message on which CMAC is to be computed
* @param[in]    macLength           Number of bits of the CMAC to be compared. A macLength value of zero indicates that 
*                                   all 128-bits are to be compared.
* @param[in]    macRefPtr           Pointer to the buffer containing the CMAC to be verified.
* @param[out]   status              Status of the MAC verification command (true: verification operation passed; false: verification
*                                   operation failed)
*
* @return       Crypto_ErrorType  Error Code after command execution. Output parameter is valid if 
*                                   the error code is CRYPTO_CSE_ERC_NO_ERROR.            
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_MacAsyncVerify(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) dataPtr,
                                                   VAR(uint32, AUTOMATIC) dataLength, VAR(uint32, AUTOMATIC) macLength,
                                                   P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) macRefPtr, P2VAR(Crypto_VerifyResultType, AUTOMATIC, CRYPTO_APPL_DATA) verifyPtr
                                                  )
{
    VAR(uint32, AUTOMATIC) Length_bits = dataLength << CRYPTO_LAST_BYTE_IN_A_WORD_U8;
    VAR(uint32, AUTOMATIC) u32PagesToWrite = (Length_bits + (uint32)CRYPTO_MAX_REMAINDER_DIV_128_U8) >> CRYPTO_BITS_ONE_PAGE_EXPONENT_U8;

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    /* clear ACCERR and FPVIOL flags before entering any operation */
    Crypto_Cse_ClearErrorFlags();
    
    if (Crypto_bCseFirstCall)
    {
        Cse_Init_state(keyId, dataPtr, u32PagesToWrite, NULL_PTR, CRYPTO_CSE_CMD_VERIFY_MAC);
        Crypto_Cse_InitState.verifyPtr = verifyPtr;
        Crypto_Cse_InitState.dataLength = Length_bits;
        Crypto_Cse_InitState.macLength = macLength;
        Crypto_Cse_InitState.SecondaryInput = macRefPtr;
        Crypto_Cse_InitState.bRefMacWritten = (boolean) FALSE;
        Crypto_bIsAsyncFunc = (boolean)TRUE;
    }   

    Crypto_CseStartVerMacCmd();
    
    Crypto_CseEnableInterrupt((boolean)TRUE);
    
    return Crypto_Cse_InitState.eOutResponse;
}

/**
* @brief        Calculates the MAC of a given message using CMAC with AES-128.     
* @details      This function verifies the MAC of of a given message based on CMAC with the 128-bit Advanced Encryption Standard.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes. 
*
* @param[in]    none
* @param[out]   none
*
* @return       none           
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC (void, CRYPTO_CODE) Crypto_CseStartVerMacCmd(void)
{
    VAR(uint8, AUTOMATIC) u8PageIdx = 0U;
    
    if (Crypto_bCseFirstCall)
    {
        /* copy dataLength to CRYPTO_CSE_PRAM */
        /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
        /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
        REG_WRITE32(CRYPTO_PRAM_PAGE0_LENGTH_SLOT_ADDR16, Crypto_Cse_InitState.dataLength);    
        /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
        /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
        REG_RMW32(CRYPTO_PRAM_PAGE0_WORD2_ADDR32, CRYPTO_PRAM_MAC_LENGTH_MASK_U32, (uint32)Crypto_Cse_InitState.macLength << CRYPTO_WORD_MAC_LEN_SHIFT_U8);
    }
    if (CRYPTO_ALL_AVAILABLE_PRAM_PAGES_U16 < Crypto_Cse_InitState.num_pages)
    {
        Crypto_Cse_WritePagesToPRAM (Crypto_Cse_InitState.inputdata, CRYPTO_PRAM_PAGE1_ADDR32, CRYPTO_ALL_AVAILABLE_PRAM_PAGES_U16);
        Crypto_Cse_InitState.num_pages = Crypto_Cse_InitState.num_pages - CRYPTO_ALL_AVAILABLE_PRAM_PAGES_U16;
    }
    else
    {
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        Crypto_Cse_WritePagesToPRAM (Crypto_Cse_InitState.inputdata, CRYPTO_PRAM_PAGE1_ADDR32, Crypto_Cse_InitState.num_pages);
        /** @violates @ref Crypto_Cse_c_REF_8 Violates MISRA 2004 Required Rule 10.1, the value of an expression of integer is converted to a different underlying type */
        u8PageIdx = Crypto_Cse_InitState.num_pages;
        Crypto_Cse_InitState.num_pages = 0U;
    }
    Crypto_Cse_InitState.bRefMacWritten = Crypto_Cse_WriteMacRefPointer (Crypto_Cse_InitState.num_pages, u8PageIdx, Crypto_Cse_InitState.SecondaryInput);
    Crypto_Cse_InitState.eOutResponse = Crypto_Cse_PopulateCommandHeader (Crypto_Cse_InitState.Cmd, Crypto_bCseFirstCall, Crypto_Cse_InitState.keyId);
    /** @violates @ref Crypto_Cse_c_REF_9 Violates MISRA 2004 Advisory Rule 12.6, The operands of logical operators (&&, || and !) should be effectively Boolean.*/
    if (!Crypto_bIsAsyncFunc)
    {
        Crypto_Cse_InitState.eOutResponse = Crypto_Cse_WaitCommandComplete();
    }
    Crypto_bCseFirstCall = (boolean)FALSE;
    
}

/**
* @brief        Calculates the MAC of a given message using CMAC with AES-128.     
* @details      This function verifies the MAC of of a given message based on CMAC with the 128-bit Advanced Encryption Standard.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes. 
*
* @param[in]    none
* @param[out]   none
*
* @return       none           
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
/**
* @violates @ref Crypto_Cse_c_REF_4 Violates MISRA 2004 Required Rule 8.10 could be made static
*/
LOCAL_INLINE FUNC (void, CRYPTO_CODE) Crypto_CseContinueVerMacCmd(void)
{
    if(CRYPTO_CSE_IDLE == Crypto_Cse_eState)
    {
        Crypto_Cse_InitState.eOutResponse = CRYPTO_CSE_ERC_CANCELED;
    }
    if (CRYPTO_CSE_ERC_NO_ERROR == Crypto_Cse_InitState.eOutResponse)
    {
        if ((0U < (Crypto_Cse_InitState.num_pages))&&((boolean)FALSE == Crypto_Cse_InitState.bRefMacWritten))
        {
            Crypto_CseStartVerMacCmd();
        }
        else
        {
            Crypto_Cse_ReadMacStatus(Crypto_Cse_InitState.verifyPtr,CRYPTO_CSE_ERC_NO_ERROR);
            Crypto_Cse_eState = CRYPTO_CSE_IDLE;
            if(Crypto_bIsAsyncFunc)
            {
                Crypto_CseEnableInterrupt((boolean)FALSE);
                Crypto_Ipw_CallBackNotification(Crypto_Cse_InitState.eOutResponse);
                Crypto_bIsAsyncFunc = (boolean) FALSE;
            }
            Crypto_bCseFirstCall = (boolean)TRUE;
        }
    }
    else
    {
        Crypto_Cse_eState = CRYPTO_CSE_IDLE;
        if(Crypto_bIsAsyncFunc)
        {
            Crypto_CseEnableInterrupt((boolean)FALSE);
            Crypto_Ipw_CallBackNotification(Crypto_Cse_InitState.eOutResponse);
            Crypto_bIsAsyncFunc = (boolean) FALSE;
        }
        Crypto_bCseFirstCall = (boolean)TRUE;
    }
}

/**
* @brief        Updates an internal key per the SHE specification.     
* @details      The function updates an internal key per the SHE specification.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes. 
*
* @param[in]    keyId               The ID of the key to be updated.
* @param[in]    keyM1Ptr            Pointer to the 128-bit M1 message containing the UID, Key ID and Authentication Key ID.
* @param[in]    keyM2Ptr            Pointer to the 256-bit M2 message containing the new security flags, counter value and 
*                                   the key value, all encrypted using a derived key generated from the Authentication Key.
* @param[in]    keyM3Ptr            Pointer to the 128-bit M3 message containing a MAC generated over messages M1 and M2.
* @param[out]   keyM4Ptr            Pointer to a 256-bit buffer where the computed M4 verification message is stored.
* @param[out]   keyM5Ptr            Pointer to a 128-bit buffer where the computed M5 verification message is stored.
*
* @return       Crypto_ErrorType  Error Code after command execution. Output parameters are valid if 
*                                   the error code is CRYPTO_CSE_ERC_NO_ERROR.            
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_LoadKey(VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) keyM1Ptr,
                                                 P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) keyM2Ptr, P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) keyM3Ptr
                                                )                                              
{
    VAR(Crypto_Cse_ErrorCodeType, AUTOMATIC) eOutResponse = CRYPTO_CSE_ERC_GENERAL_ERROR;

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    /* clear ACCERR and FPVIOL flags before entering any operation */
    Crypto_Cse_ClearErrorFlags();
    /* write keyM1Ptr, keyM2Ptr, keyM3Ptr to CRYPTO_CSE_PRAM */
    Crypto_Cse_WritePagesToPRAM(keyM1Ptr, CRYPTO_PRAM_PAGE1_ADDR32, CRYPTO_M1_SIZE_IN_PAGES_U16);
    Crypto_Cse_WritePagesToPRAM(keyM2Ptr, CRYPTO_PRAM_PAGE2_ADDR32, CRYPTO_M2_SIZE_IN_PAGES_U16);
    Crypto_Cse_WritePagesToPRAM(keyM3Ptr, CRYPTO_PRAM_PAGE4_ADDR32, CRYPTO_M3_SIZE_IN_PAGES_U16);
    
    /* write command header to CRYPTO_CSE_PRAM,  wait for the completion of the command, read and process error code */
    eOutResponse = Crypto_Cse_SendCommand(CRYPTO_CSE_CMD_LOAD_KEY, CRYPTO_CSE_FUNC_FORMAT_COPY, CRYPTO_CSE_CALL_SEQ_FIRST, keyId);
    eOutResponse = Crypto_Cse_WaitCommandComplete();

    Crypto_Cse_eState = CRYPTO_CSE_IDLE;

    return eOutResponse;
}

/**
* @brief        Updates the RAM key memory slot with a 128-bit plaintext.     
* @details      The function updates the RAM key memory slot with a 128-bit plaintext. The key is loaded without the 
*               encryption and verification of the key, i.e. the key is handed over in plaintext.
*               A plain key can only be loaded into the RAM_KEY slot.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    keyPtr              Pointer to the 128-bit buffer containing the key that needs to be copied in RAM_KEY slot.
* @param[out]   none
*
* @return       Crypto_ErrorType  Error Code after command execution.           
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_PlainKey(P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) keyPtr)
{
    VAR(Crypto_Cse_ErrorCodeType, AUTOMATIC) eOutResponse = CRYPTO_CSE_ERC_GENERAL_ERROR;

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    /* clear ACCERR and FPVIOL flags before entering any operation */
    Crypto_Cse_ClearErrorFlags();
    /* write keyPtr content to CRYPTO_CSE_PRAM */
    Crypto_Cse_WritePagesToPRAM(keyPtr, CRYPTO_PRAM_PAGE1_ADDR32, CRYPTO_ONE_PAGE_U16);        
    /* write command header to CRYPTO_CSE_PRAM,  wait for the completion of the command, read and process error code */
    eOutResponse = Crypto_Cse_SendCommand(CRYPTO_CSE_CMD_LOAD_PLAIN_KEY, CRYPTO_CSE_FUNC_FORMAT_COPY, CRYPTO_CSE_CALL_SEQ_FIRST, CRYPTO_CSE_RAM_KEY);
    eOutResponse = Crypto_Cse_WaitCommandComplete();

    Crypto_Cse_eState = CRYPTO_CSE_IDLE;

    return eOutResponse;
}

/**
* @brief        Exports the RAM_KEY into a format protected by SECRET_KEY.    
* @details      The function exports the RAM_KEY into a format protected by SECRET_KEY. Only keys loaded with the 
*               CMD_LOAD_PLAIN_KEY command may be exported. The output messages are compatible with the messages used for LOAD_KEY.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    keyId               The ID of the key to be updated.
* @param[in]    keyM1Ptr            Pointer to a 128-bit buffer where the M1 parameter is to be exported
* @param[in]    keyM2Ptr            Pointer to a 256-bit buffer where the M2 parameter is to be exported
* @param[in]    keyM3Ptr             Pointer to a 128-bit buffer where the M3 parameter is to be exported
* @param[out]   keyM4Ptr            Pointer to a 256-bit buffer where the M4 parameter is to be exported
* @param[out]   keyM5Ptr            Pointer to a 128-bit buffer where the M5 parameter is to be exported
*
* @return       Cse_ErrorCodeType  Error Code after command execution. Output parameters are valid if 
*                                   the error code is CRYPTO_CSE_ERC_NO_ERROR.            
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_ExportRamKey(P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) keyPtr)
{
    VAR(Crypto_Cse_ErrorCodeType, AUTOMATIC) eOutResponse = CRYPTO_CSE_ERC_GENERAL_ERROR;

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    /* clear ACCERR and FPVIOL flags before entering any operation */
    Crypto_Cse_ClearErrorFlags();
    /* write command header to CRYPTO_CSE_PRAM,  wait for the completion of the command, read and process error code */
    eOutResponse = Crypto_Cse_SendCommand(CRYPTO_CSE_CMD_EXPORT_RAM_KEY, CRYPTO_CSE_FUNC_FORMAT_COPY, CRYPTO_CSE_CALL_SEQ_FIRST, CRYPTO_CSE_RAM_KEY);
    eOutResponse = Crypto_Cse_WaitCommandComplete();
    /* move contents of CRYPTO_CSE_PRAM to keyM1Ptr ... keyM5Ptr */
    /** @violates @ref Crypto_Cse_c_REF_5 Array indexing shall be the only allowed form of pointer arithmetic. */
    Crypto_Cse_ReadPagesFromPRAM (keyPtr + CRYPTO_CSE_KE_SHE_M1_OFFSET, CRYPTO_PRAM_PAGE1_ADDR32, CRYPTO_M1_SIZE_IN_PAGES_U16);
    /** @violates @ref Crypto_Cse_c_REF_5 Array indexing shall be the only allowed form of pointer arithmetic. */
    Crypto_Cse_ReadPagesFromPRAM (keyPtr + CRYPTO_CSE_KE_SHE_M2_OFFSET, CRYPTO_PRAM_PAGE2_ADDR32, CRYPTO_M2_SIZE_IN_PAGES_U16);
    /** @violates @ref Crypto_Cse_c_REF_5 Array indexing shall be the only allowed form of pointer arithmetic. */
    Crypto_Cse_ReadPagesFromPRAM (keyPtr + CRYPTO_CSE_KE_SHE_M2_OFFSET, CRYPTO_PRAM_PAGE4_ADDR32, CRYPTO_M3_SIZE_IN_PAGES_U16);

    Crypto_Cse_eState = CRYPTO_CSE_IDLE;

    return eOutResponse;
}

/**
* @brief        Initializes the seed and derives a key for the PRNG.
* @details      This function initializes the seed and derives a key for the PRNG. 
*               The function must be called before CMD_RND after every power cycle or reset. 
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    none
* @param[out]   none
*
* @return       Crypto_ErrorType  Error Code after command execution. The error code CRYPTO_CSE_ERC_NO_ERROR 
*                                   specifies that the command will execute.           
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_InitRng( void )
{  
    VAR(Crypto_Cse_ErrorCodeType, AUTOMATIC) eOutResponse = CRYPTO_CSE_ERC_GENERAL_ERROR;

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    Crypto_Cse_ClearErrorFlags();
    /* write command header to CRYPTO_CSE_PRAM - only the first byte of the command header (keyID) is considered;  
       wait for the completion of the command, read and process error code */
    eOutResponse = Crypto_Cse_SendCommand(CRYPTO_CSE_CMD_INIT_RNG, CRYPTO_CSE_FUNC_FORMAT_COPY, CRYPTO_CSE_CALL_SEQ_FIRST, CRYPTO_CSE_SECRET_KEY);
    eOutResponse = Crypto_Cse_WaitCommandComplete();

    Crypto_Cse_eState = CRYPTO_CSE_IDLE;

    return eOutResponse;
}

/**
* @brief        Extends the seed of the PRNG by compressing the former seed value and the supplied entropy into a new seed.
* @details      This function extends the seed of the PRNG by compressing the former seed value and the supplied 
*               entropy into a new seed which will be used to generate the following random numbers. The random number 
*               generator has to be initialized by Cse_InitRng() before the seed can be extended. 
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    entropyPtr          Pointer to a 128-bit buffer containing the entropy
* @param[out]   none
*
* @return       Crypto_ErrorType  Error Code after command execution. The error code CRYPTO_CSE_ERC_NO_ERROR 
*                                   specifies that the command will execute.           
*                   
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_ExtendPrngSeed(P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) entropyPtr)
{
    VAR(Crypto_Cse_ErrorCodeType, AUTOMATIC) eOutResponse = CRYPTO_CSE_ERC_GENERAL_ERROR;

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    /* clear ACCERR and FPVIOL flags before entering any operation */
    Crypto_Cse_ClearErrorFlags();
    /* write entropy data to CRYPTO_CSE_PRAM */
    Crypto_Cse_WritePagesToPRAM(entropyPtr, CRYPTO_PRAM_PAGE1_ADDR32, CRYPTO_ONE_PAGE_U16);
    /* write command header to CRYPTO_CSE_PRAM,  wait for the completion of the command, read and process error code */
    eOutResponse = Crypto_Cse_SendCommand(CRYPTO_CSE_CMD_EXTEND_SEED, CRYPTO_CSE_FUNC_FORMAT_COPY, CRYPTO_CSE_CALL_SEQ_FIRST, CRYPTO_CSE_SECRET_KEY);
    eOutResponse = Crypto_Cse_WaitCommandComplete();

    Crypto_Cse_eState = CRYPTO_CSE_IDLE;

    return eOutResponse;
}

/**
* @brief        Generates a vector of 128 random bits.
* @details      The function returns a vector of 128 random bits. The random number generator has to be 
*               initialized by Cse_InitRng() before random numbers can be supplied.
*               This function does not work for VLRP (Very Low Power) and HSRUN (High Speed Run) modes.
*
* @param[in]    none
* @param[out]   rndPtr              Pointer to a 128-bit buffer where the generated random number is to be stored
*
* @return       Crypto_ErrorType  Error Code after command execution. Output parameter is valid if the error 
*                                   code is CRYPTO_CSE_NO_ERROR.           
*
* @pre          Driver must be initialized (FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1).
*
*                   
*/
FUNC(Crypto_Cse_ErrorCodeType, CRYPTO_CODE) Crypto_Cse_GenerateRnd(P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) rndPtr)
{
    VAR(Crypto_Cse_ErrorCodeType, AUTOMATIC) eOutResponse = CRYPTO_CSE_ERC_GENERAL_ERROR;

    Crypto_Cse_eState = CRYPTO_CSE_BUSY;

    Crypto_Cse_ClearErrorFlags();
    /* write command header to CRYPTO_CSE_PRAM; wait for the completion of the command, read and process error code */
    eOutResponse = Crypto_Cse_SendCommand(CRYPTO_CSE_CMD_RND, CRYPTO_CSE_FUNC_FORMAT_COPY, CRYPTO_CSE_CALL_SEQ_FIRST, CRYPTO_CSE_SECRET_KEY); 
    eOutResponse = Crypto_Cse_WaitCommandComplete();
    /* read the content of rndPtr from PRAM */
    Crypto_Cse_ReadPagesFromPRAM (rndPtr, CRYPTO_PRAM_PAGE1_ADDR32, CRYPTO_ONE_PAGE_U16);

    Crypto_Cse_eState = CRYPTO_CSE_IDLE;

    return eOutResponse;
}
/**
* Cancel a job, is processing.
**/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Cse_Cancel(void)
{
    VAR (Std_ReturnType, AUTOMATIC) eStatus = (Std_ReturnType)E_NOT_OK;
    /* Enter critical section  */
    SchM_Enter_Crypto_CRYPTO_EXCLUSIVE_AREA_03();
     if(CRYPTO_CSE_BUSY == Crypto_Cse_eState)
     {
        Crypto_Cse_eState = CRYPTO_CSE_IDLE;
        eStatus = (Std_ReturnType)E_OK;
     }
    /* Exit critical section */
    SchM_Exit_Crypto_CRYPTO_EXCLUSIVE_AREA_03();
     return eStatus;
}
/**
* @brief           Check HW is initialized or not. 
* @param[in]       none
* @param[out]      none 
* @returns         status
*
*/
FUNC(Std_ReturnType, CRYPTO_CODE) Crypto_Cse_CheckHwInit(void)
{
    VAR(uint8, AUTOMATIC) u8FlashStatus = 0x00U;
    VAR (Std_ReturnType, AUTOMATIC) eStatus = (Std_ReturnType)E_NOT_OK;
     /* Once the device is configured successfully for CSEc operation, the FCNFG register fields are set to the following:
     FCNFG[RAMRDY] == 0 and FCNFG[EEERDY] == 1, check if it properly partitioned */
    /** @violates @ref Crypto_Cse_c_REF_6 MISRA 2004 Rule 11.1, Cast from unsigned long to pointer*/ 
    /** @violates @ref Crypto_Cse_c_REF_7 MISRA 2004 Rule 11.3, Cast from unsigned long to pointer*/
    u8FlashStatus = REG_READ8(CRYPTO_FCNFG_ADDR32);
    
    if ( ( CRYPTO_RAMRDY_NOT_CONFIGURED == ( u8FlashStatus & CRYPTO_FCNFG_RAMRDY_U8 ) ) && ( CRYPTO_EEERDY_CONFIGURED == ( u8FlashStatus & CRYPTO_FCNFG_EEERDY_U8 ) ) )
    {
        eStatus = (Std_ReturnType)E_OK;
        Crypto_Cse_eDriverStatus = CRYPTO_CSE_INIT;
    }
    return eStatus;
}

#define CRYPTO_STOP_SEC_CODE
/**
* @violates @ref Crypto_Cse_c_REF_3 Violates MISRA 2004 Required Rule 19.15, #include preceded by non preproc directives.
* @violates @ref Crypto_Cse_c_REF_1 Violates MISRA 2004 Advisory Rule 19.1, Repeated include file MemMap.h.
*/
#include "Crypto_MemMap.h"

#ifdef __cplusplus
}
#endif

/** @} */
